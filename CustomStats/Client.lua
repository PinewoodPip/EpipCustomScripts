---------------------------------------------
-- Example of adding a stat to Epip's "Keywords & Misc" tab.
---------------------------------------------

local CustomStats = Epip.GetFeature("Feature_CustomStats")
local ExampleCustomStats = Epip.GetFeature("Fafa_Overworld", "Features.Examples.CustomStats")

---------------------------------------------
-- STATS
---------------------------------------------

CustomStats.RegisterStat("EXAMPLE_SomeStat", {
    Name = "Test stat",
    Description = "Test description",
    Tooltip = {
        {
            Type = "ItemName",
            Label = "My Stat",
        },
        {
            Type = "ItemDescription",
            Label = "Description tooltip goes here",
        },
    },
    Footnote = "A footnote",
    Suffix = "%", -- Displayed after the value
    -- Boolean = true, -- If `true`, the stat will show no value. Use for binary stats ("acquired" or "not acquired")
    -- MaxCharges = 3, -- If specified, this stat will display as "{Value}/{Value of MaxCharges stat}"
    -- Prefix = "", -- Displayed before the value
    -- DefaultValue = 0,
})

---------------------------------------------
-- CATEGORIES
-- A category groups up stats, and a stat must be in some category for it to show.
---------------------------------------------

---@type Feature_CustomStats_Category
local category = {
    Header = Text.Format("———— Examples ————", {Size = 21}),
    Name = "Example Stat",
    Behaviour = "GreyOut", -- Stats that are default value will appear greyed out in the tab. If you set this to "Hidden" instead, they hide (and the category disappears if the character has no stats of the category)
    Stats = {
        "EXAMPLE_SomeStat",
    },
}
CustomStats.RegisterCategory("Examples", category, 1) -- Insert before all other categories.

---------------------------------------------
-- STAT CALCULATIONS
---------------------------------------------

-- This hook is thrown when a stat is to be displayed.
CustomStats.Hooks.GetStatValue:Subscribe(function (ev)
    if ev.Stat.ID == "EXAMPLE_SomeStat" then
        local value = ExampleCustomStats:GetUserVariable(ev.Character, ExampleCustomStats.USERVAR_SOME_STAT)
        ev.Value = value
    end
end)