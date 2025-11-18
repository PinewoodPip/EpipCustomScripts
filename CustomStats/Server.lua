---------------------------------------------
-- Example of synchronizing a custom stat for Epip's "Keywords & Misc" tab.
---------------------------------------------

local ExampleCustomStats = Epip.GetFeature("Fafa_Overworld", "Features.Examples.CustomStats")

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Update the stat value on turn start.
Osiris.RegisterSymbolListener("ObjectTurnStarted", 1, "after", function(guid)
    if Osi.ObjectIsCharacter(guid) == 1 and Osi.CharacterIsPlayer(guid) == 1 then
        local char = Character.Get(guid)
        local value = math.random(1, 100)
        -- Osi example
        -- local value = Osi.DB_MyDB:Get(char.MyGuid, nil)[1][2] -- Take 1st tuple, and its 2nd value
        ExampleCustomStats:SetUserVariable(char, ExampleCustomStats.USERVAR_SOME_STAT, value)
    end
end)