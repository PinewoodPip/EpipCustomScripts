---------------------------------------------
-- Replaces "You've already learned this skill" message boxes with notifications that do not require manual closing.
---------------------------------------------

local MsgBox = Client.UI.MessageBox
local Notification = Client.UI.Notification

local ALREADY_LEARNT_TSKHANDLE = "he05662b7g4e95g4294gb0bdg599ddf453317" -- "You've already learned [1]."
local resolvedAlreadyLearntTSK = nil ---@type string?

-- Show "You've already learned this skill" messages as a notification instead.
MsgBox:RegisterInvokeListener("showPopup", function (ev, _, message)
    ---@cast message string
    local ui = ev.UI
    local root = ui:GetRoot()

    -- Get the translated string for the "You've already learned X." message
    local alreadyLearntTSK = resolvedAlreadyLearntTSK
    if not alreadyLearntTSK then
        -- Fetch & cache the string
        alreadyLearntTSK = Text.GetTranslatedString(ALREADY_LEARNT_TSKHANDLE, "You've already learned [1].")
        alreadyLearntTSK = Text.ReplaceLarianPlaceholders(alreadyLearntTSK, "") -- Replaces [1] so that the string can be used as a pattern.
    end

    -- Auto-close the message box and show a warning notification instead.
    if message:find(alreadyLearntTSK, nil, true) then
        Timer.StartTickTimer(1, function (_)
            ui:ExternalInterfaceCall("ButtonPressed", root.isOkCancel and 3 or 1, root.currentDevice)
            Notification.ShowWarning(message)
        end)
    end
end, "After")
