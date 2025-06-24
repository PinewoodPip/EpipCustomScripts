
local StatusConsole = Client.UI.StatusConsole
local Notification = Client.UI.Notification
local EnemyHealthBar = Client.UI.EnemyHealthBar

---@class Features.TurnTimers
local TurnTimers = Epip.GetFeature("Features.TurnTimers")
local TSK = TurnTimers.TranslatedStrings

TurnTimers.TIME_OUT_SOUND = "UI_Lobby_AssignMember"

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- End turn and show notification when the turn timer runs out.
Net.RegisterListener(TurnTimers.NETMSG_TURN_TIME_OUT, function (payload)
    local char = payload:GetCharacter()
    if char == Client.GetCharacter() then
        StatusConsole:ExternalInterfaceCall("EndButtonPressed")
        Notification.ShowWarning(TSK.Notification_TurnTimeOut:GetString())
    end
end)

-- Show notification when a player character runs out of time.
Net.RegisterListener(TurnTimers.NETMSG_CHARACTER_TIME_OUT, function (payload)
    local char = payload:GetCharacter()
    local name = Character.GetDisplayName(char)
    Notification.ShowWarning(TSK.Notification_CharacterTimeOut:Format(name), nil, TurnTimers.TIME_OUT_SOUND)
end)

-- Display remaining times on the StatusConsole turn toast.
GameState.Events.RunningTick:Subscribe(function (_)
    local root = StatusConsole:GetRoot()
    local turnNotice = root.turnNotice_mc
    local clientChar = Client.GetCharacter()
    local combatID = Combat.GetCombatID(clientChar)
    if not combatID then return end -- Do nothing if the combat ID is not yet initialized.

    local char = Combat.GetActiveCombatant(combatID)
    if not char or not Character.IsPlayer(char) then return end -- Do nothing if it's an enemy turn or the combat is not yet initialized (characters still unsheathing weapons)

    -- Format timer label
    local turnTimeRemaining = TurnTimers:GetUserVariable(char, TurnTimers.USERVAR_TURN_TIME)
    local characterTimeRemaining = TurnTimers:GetUserVariable(char, TurnTimers.USERVAR_COMBAT_TIME)
    local label ---@type string
    if not Character.IsSummon(char) then
        -- Show both turn & combat timer.
        -- String is padded to show the 2 timers on opposite sides of the toast.
        label = Text.Format("%s" .. string.rep(" ", 100) ..  "%s", {
            FormatArgs = {
                Text.FormatTime(turnTimeRemaining),
                Text.FormatTime(characterTimeRemaining),
            },
            Size = 15,
        })
    else
        -- Show only turn timer.
        label = Text.Format("%s" .. string.rep(" ", 105), {
            FormatArgs = {
                Text.FormatTime(turnTimeRemaining),
            },
            Size = 15,
        })
    end

    -- Set timer label
    local timerTxt = turnNotice.timer_txt
    timerTxt.htmlText = label
    timerTxt.width = 1000
    timerTxt.visible = true
    timerTxt.x = -495 -- Reposition the text field a bit (I have no idea how this is positioned in vanilla)
    timerTxt.y = -14
end, {EnabledFunctor = Client.IsInCombat})

-- Display turn timers under the target health bar UI.
EnemyHealthBar.Hooks.GetBottomLabel:Subscribe(function (ev)
    local char = ev.Character
    if not char or not Character.IsPlayer(char) or not Character.IsInCombat(char) then return end

    -- Add timer label
    local combatTimeRemaining = TurnTimers:GetUserVariable(char, TurnTimers.USERVAR_COMBAT_TIME)
    table.insert(ev.Labels, TSK.Label_TimeRemaining:Format(Text.FormatTime(combatTimeRemaining)))
end)