---------------------------------------------
-- Implements a chess-like timer for player characters.
-- Characters are assigned a per-turn and per-combat timer;
-- if a character's turn timer ends, their turn is forcibly ended.
-- if their combat timer ends, they are killed.
---------------------------------------------

---@class Features.TurnTimers : Feature
local TurnTimers = {
    TURN_TIME = 60, -- Time allowed per turn, in seconds.
    SUMMON_TURN_TIME = 20, -- Time allowed per turn for summons, in seconds.
    COMBAT_TIME = 10 * 60, -- Time allowed per character per combat, in seconds.

    USERVAR_TURN_TIME = "TurnTime",
    USERVAR_COMBAT_TIME = "CombatTime",

    NETMSG_CHARACTER_TIME_OUT = "Features.TurnTimers.NetMsg.CharacterTimeOut",
    NETMSG_TURN_TIME_OUT = "Features.TurnTimers.NetMsg.TurnTimeOut",

    TranslatedStrings = {
        Notification_TurnTimeOut = {
            Handle = "h136e11f2g7ec5g45aag82a0g4ad2061e7fbf",
            Text = "Turn time's up!",
            ContextDescription = [[Notification when a character's turn timer ends.]],
        },
        Notification_CharacterTimeOut = {
            Handle = "h50bc66a9gbc02g4701g970eg08b8c4c539ea",
            Text = "%s has run out of time!",
            ContextDescription = [[Notification when a character's combat timer ends. Param is character name.]],
        },
        Label_TimeRemaining = {
            Handle = "ha90470d9g6b76g4ea6ga84agc31ea26da243",
            Text = "Total Time Remaining: %s",
            ContextDescription = [[Label underneath player target healthbar UI. Param is duration (MM:SS)]],
        },
    }
}
Epip.RegisterFeature("Features.TurnTimers", TurnTimers)

TurnTimers:RegisterUserVariable(TurnTimers.USERVAR_TURN_TIME, {
    Persistent = true,
    DefaultValue = 0,
})
TurnTimers:RegisterUserVariable(TurnTimers.USERVAR_COMBAT_TIME, {
    Persistent = true,
    DefaultValue = 0,
})

---@class Features.TurnTimers.NetMsg.TurnTimeOut : NetLib_Message_Character
---@class Features.TurnTimers.NetMsg.CharacterTimeOut : NetLib_Message_Character