---------------------------------------------
-- Example script that marks giftbags as incompatible or undesirable to use alongside your mod.
---------------------------------------------

local MODS = Mod.GUIDS
local MOD_GUID = "YOUR_GUID_HERE"

local GiftbagLocker = Epip.GetFeature("Features.GiftBagCompatibilityWarnings")

---@type table<GUID.Mod, TextLib.String>
local INCOMPATIBLE_GIFTBAGS = { -- 
    [MODS.GB_8AP] = "AP costs are modified in such a way that this giftbag results in players having less maximum AP.",
}
---@type table<GUID.Mod, TextLib.String>
local UNDESIRABLE_GIFTBAGS = {
    [MODS.GB_ORGANIZATION] = "A better implementation is already included.",
    [MODS.GB_LEVELUP_ITEMS] = "Items already level up automatically.",
}

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Mark problematic giftbags as incompatible or undesirable.
GiftbagLocker.Hooks.IsIncompatible:Subscribe(function (ev)
    local reason = INCOMPATIBLE_GIFTBAGS[ev.ModGUID]
    if reason then
        ev.IncompatibilityReasons[MOD_GUID] = reason
    end
end)
GiftbagLocker.Hooks.IsUndesirable:Subscribe(function (ev)
    local reason = UNDESIRABLE_GIFTBAGS[ev.ModGUID]
    if reason then
        ev.UndesirabilityReasons[MOD_GUID] = reason
    end
end)
