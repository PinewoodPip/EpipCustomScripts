---------------------------------------------
-- Disable's Epip "Show Fog of War" setting to prevent it from calling the corresponding engine function.
-- This is a workaround for hardware-specific issues with this engine call.
-- Load this as a server script, as the listeners involved are on the server.
---------------------------------------------

local ShroudToggle = Epip.GetFeature("Features.ShroudToggle")

-- Request the feature to be disabled; this will disable the event listeners that call the problematic engine function
ShroudToggle:SetEnabled("CustomScript", false)
