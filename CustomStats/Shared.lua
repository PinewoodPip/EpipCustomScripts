---------------------------------------------
-- Example script set for a server-driven stat for Epip's "Keywords & Misc." character sheet tab tab.
---------------------------------------------

---@class Features.Examples.CustomStats : Feature
local ExampleCustomStats = {
    USERVAR_SOME_STAT = "Examples.SomeStat",
}
Epip.RegisterFeature("Fafa_Overworld", "Features.Examples.CustomStats", ExampleCustomStats)

-- Uservar for synching stat values from server to client.
ExampleCustomStats:RegisterUserVariable(ExampleCustomStats.USERVAR_SOME_STAT, {
    Persistent = true,
    DefaultValue = 0,
})
