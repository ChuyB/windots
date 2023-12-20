-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

--config.default_domain = "WSL:Ubuntu"

config.initial_cols = 100
config.initial_rows = 30
config.color_scheme = "OneHalfDark"
config.font = wezterm.font("CaskaydiaCove Nerd Font", { weight = "DemiBold" })
config.font_size = 14.0
config.default_prog = { "C:\\Program Files\\PowerShell\\7\\pwsh.exe", "--nologo" }
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.keys = {
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ReloadConfiguration,
	},
}

-- MICA --
--config.window_background_opacity = 0
--config.win32_system_backdrop = "Mica"

-- and finally, return the configuration to wezterm
return config
