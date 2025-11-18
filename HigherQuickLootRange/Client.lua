---------------------------------------------
-- Expands the search range of Quick Loot
-- and makes it instantly use the max range.
---------------------------------------------

local QuickLoot = Epip.GetFeature("Features.QuickLoot")

QuickLoot.MAX_SEARCH_DISTANCE = 30 -- 30m.

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Change starting search radius to the maximum, disregarding the setting.
QuickLoot.GetBaseSearchRadius = function ()
    return QuickLoot.MAX_SEARCH_DISTANCE
end
