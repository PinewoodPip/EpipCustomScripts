---------------------------------------------
-- Adds console commands to separately reset a character's attribute, ability, or civil ability points,
-- as well as a command to open the respec mirror.
---------------------------------------------

---@type set<integer> AbilityType enum values, 0-based.
CIVIL_ABILITIES = {
    [22] = true, -- Sneaking
    [23] = true, -- Thievery
    [25] = true, -- Loremaster
    [27] = true, -- Bartering
    [31] = true, -- Persuasion
    [33] = true, -- Luck
}

---------------------------------------------
-- FUNCTIONS
---------------------------------------------

---Resets a character's allocated attribute points.
---@param char EsvCharacter
function RespecAttributes(char)
    local progression = char.PlayerUpgrade.Attributes
    local pointsToRefund = 0

    -- Sum attribute points spent and reset them
    for statID,amount in ipairs(progression) do
        pointsToRefund = pointsToRefund + amount - 10 -- Ignore base amount.
        Osiris.NRD_PlayerSetBaseAttribute(char, Ext.Enums.PlayerUpgradeAttribute[statID - 1].Label, 10)
    end

    -- Refund points
    Osiris.CharacterAddAttributePoint(char, pointsToRefund)
end
---Resets a character's allocated ability points.
---@param char EsvCharacter
---@param abilityType "Abilities"|"Civils"|"All" Which abilities to respec.
function RespecAbilities(char, abilityType)
    local progression = char.PlayerUpgrade.Abilities
    local civilsToRefund = 0
    local abilityPointsToRefund = 0
    local resetAbilities = abilityType == "Abilities" or abilityType == "All"
    local resetCivils = abilityType == "Civils" or abilityType == "All"

    -- Sum ability points spent and reset them
    for abilityID,amount in ipairs(progression) do
        local abilityStringID = Ext.Enums.AbilityType[abilityID - 1].Label
        if CIVIL_ABILITIES[abilityID - 1] and resetCivils then
            civilsToRefund = civilsToRefund + amount
            Osiris.NRD_PlayerSetBaseAbility(char, abilityStringID, 0)
        elseif not CIVIL_ABILITIES[abilityID - 1] and resetAbilities then
            abilityPointsToRefund = abilityPointsToRefund + amount
            Osiris.NRD_PlayerSetBaseAbility(char, abilityStringID, 0)
        end
    end

    -- Refund points
    Osiris.CharacterAddAbilityPoint(char, abilityPointsToRefund)
    Osiris.CharacterAddCivilAbilityPoint(char, civilsToRefund)
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

---Gets the character object from a GUID param,
---defaulting to the host's active character if not provided.
---@param charGUID GUID.Character?
---@return EsvCharacter
local function GetCharacterFromCommandParam(charGUID)
    charGUID = charGUID or Osi.CharacterGetHostCharacter()
    return Character.Get(charGUID)
end

-- Command to respec attributes.
Ext.RegisterConsoleCommand("respecattributes", function (_, charGUID)
    local char = GetCharacterFromCommandParam(charGUID)
    RespecAttributes(char)
end)

-- Command to respec combat & skill abilities.
Ext.RegisterConsoleCommand("respecabilities", function (_, charGUID)
    local char = GetCharacterFromCommandParam(charGUID)
    RespecAbilities(char, "Abilities")
end)

-- Command to respec civil abilities.
Ext.RegisterConsoleCommand("respeccivils", function (_, charGUID)
    local char = GetCharacterFromCommandParam(charGUID)
    RespecAbilities(char, "Civils")
end)

-- Command to enter the respec mirror.
-- Talents cannot be respecced in script due to extender limitations,
-- so this is provided as a workaround.
Ext.RegisterConsoleCommand("respec", function (_, charGUID)
    local char = GetCharacterFromCommandParam(charGUID)
    Osiris.CharacterAddToCharacterCreation(char.MyGuid, 1)
end)
