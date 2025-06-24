---------------------------------------------
-- Example script for adding custom filters to Quick Loot.
-- This implements a filter for buckets, empty mugs and items with a low base gold value.
---------------------------------------------

local QuickLoot = Epip.GetFeature("Features.QuickLoot")
local UI = QuickLoot.UI

---------------------------------------------
-- SETTINGS
---------------------------------------------

local Settings = {
    ShowJunk = QuickLoot:RegisterSetting("PotentialPizza.ShowJunk", {
        Type = "Boolean",
        Name = "Show random crap",
        Description = "If enabled, buckets and empty mugs will be included.",
        DefaultValue = false,
    })
}
-- Show new settings in the UI
UI.Hooks.GetSettings:Subscribe(function (ev)
    table.insert(ev.Settings, Settings.ShowJunk)
end)

---------------------------------------------
-- FILTERING CONDITIONS
---------------------------------------------

---Returns whether an item is a bucket.
---@param item EclItem
---@return boolean
local function IsBucket(item)
    local templateName = item.RootTemplate.Name -- Prefab name.
    local isBucket = string.find(string.lower(templateName), "bucket") ~= nil -- Case-insensitive search.
    return isBucket
end

---Returns whether an item is an empty mug or cup.
---@param item EclItem
---@return boolean
local function IsEmptyMug(item)
    local statsID = item.StatsId
    return statsID == "CON_Drink_Mug_A_Empty" or statsID == "CON_Drink_Cup_A_Empty"
end

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Apply junk filter.
QuickLoot.Hooks.IsItemFilteredOut:Subscribe(function (ev)
    if Settings.ShowJunk:GetValue() == false then
        ev.FilteredOut = ev.FilteredOut or IsBucket(ev.Item)
        ev.FilteredOut = ev.FilteredOut or IsEmptyMug(ev.Item)

        -- Naive gold filter
        local item = ev.Item
        local stats = item.StatsFromName
        if stats and stats.Value < 20 then
            ev.FilteredOut = true
        end
    end
end)

-- This extra hook is only necessary to ex. allow picking up a container
-- QuickLoot.Hooks.IsGroundItemLootable:Subscribe(function (ev)
--     if Settings.ShowJunk:GetValue() == false then
--         ev.Lootable = ev.Lootable or IsBucket(ev.Item)
--         ev.Lootable = ev.Lootable or IsEmptyMug(ev.Item)
--     end
-- end)
