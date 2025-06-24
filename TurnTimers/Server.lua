
---@class Features.TurnTimers
local TurnTimers = Epip.GetFeature("Features.TurnTimers")

---------------------------------------------
-- METHODS
---------------------------------------------

---Returns the time allowed per turn for a character.
---@param char EsvCharacter
---@return integer
function TurnTimers.GetTurnTime(char)
    local isSummon = Character.IsSummon(char)
    return isSummon and TurnTimers.SUMMON_TURN_TIME or TurnTimers.TURN_TIME
end

---Returns whether char is a summon owned by a player.
---@param char Character
---@return boolean
local function IsPlayerSummon(char)
    local owner = Character.Get(char.OwnerCharacterHandle)
    return owner and Character.IsSummon(char) and Character.IsPlayer(owner)
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Refresh timers when player turns begin or they enter combat.
Osiris.RegisterSymbolListener("ObjectTurnStarted", 1, "after", function (entityGUID)
    local char = Character.Get(entityGUID)
    if char and (Character.IsPlayer(char) or IsPlayerSummon(char)) then
        local turnTime = TurnTimers.GetTurnTime(char)
        TurnTimers:SetUserVariable(char, TurnTimers.USERVAR_TURN_TIME, turnTime)
    end
end)
Osiris.RegisterSymbolListener("ObjectEnteredCombat", 2, "after", function (entityGUID, _)
    local char = Character.Get(entityGUID)
    if char and (Character.IsPlayer(char) or IsPlayerSummon(char)) then
        TurnTimers:SetUserVariable(char, TurnTimers.USERVAR_COMBAT_TIME, TurnTimers.COMBAT_TIME)
    end
end)

-- Update player timers each tick.
GameState.Events.Tick:Subscribe(function (ev)
    local combats = Ext.Combat.GetTurnManager().Combats
    for combatID,_ in pairs(combats) do
        local combat = Combat.GetCombat(combatID)
        local turnOrder = combat:GetCurrentTurnOrder()
        if not turnOrder[1] then goto continue end -- Do nothing if this combat is not yet initialized (character unsheathing weapons)

        -- Tick timers for the active character if they're a player
        local combatant = Combat.GetActiveCombatant(combatID)
        if combatant and Entity.IsCharacter(combatant) and Character.IsPlayer(combatant) then
            local char = combatant
            local dt = ev.DeltaTime / 1000
            local turnTime = TurnTimers:GetUserVariable(char, TurnTimers.USERVAR_TURN_TIME)
            local combatTime = TurnTimers:GetUserVariable(char, TurnTimers.USERVAR_COMBAT_TIME)

            -- Tick timers
            if not Character.IsSummon(char) then -- Per-combat timer is not applied to summons.
                combatTime = combatTime - dt
            end
            turnTime = turnTime - dt

            -- Clamp turn timer to combat timer to avoid awkwardly displaying more turn time than combat time left
            turnTime = math.min(turnTime, combatTime)

            -- Kill the character once their time has run out
            if combatTime < 0 then
                Net.Broadcast(TurnTimers.NETMSG_CHARACTER_TIME_OUT, {
                    CharacterNetID = char.NetID,
                })
                Osiris.CharacterDie(char, false, 'Pierce', NULLGUID)
                combatTime = TurnTimers.COMBAT_TIME
            elseif turnTime < 0 then
                Net.Broadcast(TurnTimers.NETMSG_TURN_TIME_OUT, {
                    CharacterNetID = char.NetID,
                })
                turnTime = TurnTimers.GetTurnTime(char)
            end

            -- Sync timers to clients
            TurnTimers:SetUserVariable(char, TurnTimers.USERVAR_COMBAT_TIME, combatTime)
            TurnTimers:SetUserVariable(char, TurnTimers.USERVAR_TURN_TIME, turnTime)
        end
        ::continue::
    end
end, {EnabledFunctor = GameState.IsInRunningSession})