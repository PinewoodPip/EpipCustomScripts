
---------------------------------------------
-- Raises the mininum & maximum values for Epip's camera zoom settings,
-- and automatically reduces max camera distance when it is your turn in combat.
---------------------------------------------

local StatusConsole = Client.UI.StatusConsole
local Camera = Epip.GetFeature("Feature_CameraZoom")

local maxDistanceSetting = Settings.GetSetting(Camera.SETTINGS_MODULE_ID, "Camera_NormalModeZoomLimit") ---@cast maxDistanceSetting SettingsLib_Setting_ClampedNumber
local minDistanceSetting = Settings.GetSetting(Camera.SETTINGS_MODULE_ID, "NormalModeZoomInLimit") ---@cast maxDistanceSetting SettingsLib_Setting_ClampedNumber

-- Set to whatever limits you desire
maxDistanceSetting.Max = 40
minDistanceSetting.Min, minDistanceSetting.Max = 1, 20

---------------------------------------------
-- EVENT LISTENERS
---------------------------------------------

-- Reduce the max camera zoom level when it is the client player's turn.
StatusConsole:RegisterInvokeListener("setBtnVisible", function (_, buttonID, enabled)
    if buttonID == 1 then -- "End turn" button.
        local switches = Ext.Utils.GetGlobalSwitches()
        switches.CameraSwitchesMode0.MaxCameraDistance = enabled and 20 or maxDistanceSetting.Max -- Lower max camera distance when it's your turn, restore it otherwise.
    end
end)
