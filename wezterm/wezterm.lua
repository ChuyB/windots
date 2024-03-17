-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Actions
local act = wezterm.action

-- Initial Position
local inital_x = 140
local inital_y = 50

-- Config table
config = {
  default_prog = { "nu.exe" },
  initial_cols = 130,
  initial_rows = 40,

  window_decorations = "RESIZE",
  window_background_opacity = 0.8,
  tab_bar_at_bottom = false,
  use_fancy_tab_bar = false,
  status_update_interval = 1000,

  font = wezterm.font("CaskaydiaCove Nerd Font"),
  font_rules = {
    {
      intensity = "Bold",
      italic = false,
      font = wezterm.font({ family = "CaskaydiaCove Nerd Font", weight = "Bold" }),
    },
    {
      intensity = "Bold",
      italic = true,
      font = wezterm.font({ family = "CaskaydiaCove Nerd Font", weight = "Bold", italic = true }),
    },
  },
  font_size = 13.0,

  scrollback_lines = 3000,
  default_workspace = "main",

  -- Keys
  leader = { key = "b", mods = "CTRL", timeout_miliseconds = 1000 },
  treat_left_ctrlalt_as_altgr = true,
  keys = {
    -- Leader Key
    { key = "b", mods = "LEADER|CTRL",  action = act.SendKey({ key = "b", mods = "CTRL" }) },

    { key = "p", mods = "LEADER|SHIFT", action = act.ActivateCommandPalette },
    { key = "r", mods = "LEADER|SHIFT", action = act.ReloadConfiguration },

    -- Tabs
    { key = "c", mods = "LEADER",       action = act.SpawnTab("CurrentPaneDomain") },
    -- Panes
    { key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    -- Move between panes
    { key = "h", mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
    { key = "j", mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
    { key = "k", mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
    { key = "l", mods = "LEADER",       action = act.ActivatePaneDirection("Right") },
    { key = "q", mods = "LEADER",       action = act.CloseCurrentPane({ confirm = true }) },
    { key = "z", mods = "LEADER",       action = act.TogglePaneZoomState },
    { key = "o", mods = "LEADER",       action = act.RotatePanes("Clockwise") },
    -- Resize panes
    { key = "r", mods = "LEADER",       action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
    -- Move tabs
    { key = "m", mods = "LEADER",       action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
    {
      key = "e",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = wezterm.format({
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Renaming Tab Title...:" },
        }),
        action = wezterm.action_callback(function(window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },

    -- Workspaces
    { key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  },

  key_tables = {
    resize_pane = {
      { key = "h",     action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "j",     action = act.AdjustPaneSize({ "Down", 1 }) },
      { key = "k",     action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "l",     action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "c",     mods = "CTRL",                              action = "PopKeyTable" },
      { key = "Enter", action = "PopKeyTable" },
    },
    move_tab = {
      { key = "h",     action = act.MoveTabRelative(-1) },
      { key = "l",     action = act.MoveTabRelative(1) },
      { key = "c",     mods = "CTRL",                   action = "PopKeyTable" },
      { key = "Enter", action = "PopKeyTable" },
    },
  },

  colors = {
    ansi = {
      "#282C34",
      "#EF596F",
      "#89CA78",
      "#E5C07B",
      "#61AFEF",
      "#D55FDE",
      "#2BBAC5",
      "#ABB2BF",
    },
    brights = {
      "#282C34",
      "#EF596F",
      "#89CA78",
      "#E5C07B",
      "#61AFEF",
      "#D55FDE",
      "#2BBAC5",
      "#ABB2BF",
    },
    background = "#000000",
    cursor_bg = "#FFFFFF",
    cursor_fg = "#181B20",
    cursor_border = "#ABB2BF",
    foreground = "#ABB2BF",
    selection_bg = "#FFFFFF",
    selection_fg = "#ABB2BF",

    tab_bar = {
      background = "rgba(0,0,0,0.8)",
      new_tab = {
        bg_color = "#000000",
        fg_color = "#FFFFFF",
      },
    },
  },
}

-- Move through tabs with numbers
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
end

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
  local edge_background = "rgba(0,0,0,0.8)"
  local title = tab_title(tab)
  local index = tab.tab_index + 1

  local accentColor = "Blue"
  local textIntensity = "Normal"
  local isItalic = true
  if tab.is_active then
    accentColor = "Red"
    textIntensity = "Bold"
    isItalic = false
  end

  -- ensure that the titles fit in the available space,
  -- and that we have room for the edges.
  title = wezterm.truncate_right(title, max_width - 2)

  return {
    { Attribute = { Intensity = textIntensity } },
    { Attribute = { Italic = isItalic } },

    { Background = { Color = edge_background } },
    { Foreground = { AnsiColor = "Black" } },
    { Text = "█" },

    { Background = { AnsiColor = "Black" } },
    { Foreground = { AnsiColor = "White" } },
    { Text = title },

    { Foreground = { AnsiColor = accentColor } },
    { Background = { AnsiColor = "Black" } },
    { Text = " █" },

    { Foreground = { AnsiColor = "Black" } },
    { Background = { AnsiColor = accentColor } },
    { Text = "" .. index },

    { Background = { Color = edge_background } },
    { Foreground = { AnsiColor = accentColor } },
    { Text = "█" },
  }
end)

-- Name of workspace
wezterm.on("update-status", function(window, _)
  -- Workspace name
  local stat = window:active_workspace()
  local color = "Blue"
  if window:leader_is_active() then
    stat = "Leader"
    color = "Red"
  end
  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format({
    { Attribute = { Intensity = "Bold" } },
    { Background = { Color = "rgba(0,0,0,0.8)" } },
    { Foreground = { AnsiColor = "Black" } },
    { Text = " █" },
    { Background = { AnsiColor = "Black" } },
    { Foreground = { AnsiColor = color } },
    { Text = stat },
    { Background = { Color = "rgba(0,0,0,0.8)" } },
    { Foreground = { AnsiColor = "Black" } },
    { Text = "█ " },
  }))
end)

-- Initial position
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():set_position(inital_x, inital_y)
end)

-- NVIM ZenMode
wezterm.on("user-var-changed", function(window, pane, name, value)
  wezterm.log_info("var", name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "ZEN_MODE" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while number_value > 0 do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = true
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config
