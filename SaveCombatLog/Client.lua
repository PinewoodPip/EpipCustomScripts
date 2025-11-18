---------------------------------------------
-- Allows saving combat log messages to files in the `Osiris Data/Epip` folder.
-- Use the console command !savecombatlog to save the combat log to `Osiris Data/Epip/CombatLog.json`.
-- Additionally, `Osiris Data/Epip/CombatLog_<fight index>.json` files will be automatically saved for each combat fought in the session, with the messages of that combat.
---------------------------------------------

local CombatLog = Client.UI.CombatLog

local messages = {} ---@type string[] Messages sent to the combat log.

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Track added messages.
CombatLog.Events.MessageAdded:Subscribe(function (ev)
    table.insert(messages, ev.Message.Message:ToString())

    -- Remove old messages
    if (#messages > CombatLog.MAX_MESSAGES) then
        table.remove(messages, 1)
    end
end)

-- Save combat log messages to file.
Ext.RegisterConsoleCommand("savecombatlog", function (_)
    IO.SaveFile("Epip/CombatLog.json", messages)
end)

Client.UI.StatusConsole.Events.TurnEnded:Subscribe(function (_)
    IO.SaveFile("Epip/CombatLog.json", messages)
end)

local clientWasInCombat = false
local combatCounter = 0
GameState.Events.RunningTick:Subscribe(function ()
    local char = Client.GetCharacter()
    if not char then return end
    local isInCombat = Character.IsInCombat(char)

    -- Clear previous messages when entering combat
    if isInCombat and not clientWasInCombat then
        messages = {}
    elseif not isInCombat and clientWasInCombat then
        -- Save messages when combat ends
        IO.SaveFile(string.format("Epip/CombatLog_%d.json", combatCounter), messages)
        combatCounter = combatCounter + 1
    end

    -- Track in-combat state
    clientWasInCombat = isInCombat
end)