local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window {}
  window:gui_window():maximize()
end)

local config = wezterm.config_builder()

config = {
  automatically_reload_config = true,
  enable_tab_bar = false,
  window_close_confirmation = "NeverPrompt",
  window_decorations = "RESIZE",
  color_scheme = "Nord (Gogh)",
  font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
  font_size = 12.5,
  background = {
    {
      source = {
        File = "/home/blazkowiz47/.config/nvim/wezterm/bg-dark-loner.jpeg"
      },
      hsb = {
        hue = 1.0,
        saturation = 1.02,
        brightness = 0.25,

      },
      width = "100%",
      height = "100%",
    },
  },
  leader = {
    key = "b", mods = "ALT", timeout_milliseconds = 700,
  },
  keys = {
    {
      key = "v",
      mods = "LEADER",
      action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
    },
    {
      key = "s",
      mods = "LEADER",
      action = act.SplitVertical { domain = "CurrentPaneDomain" },
    },
    {
      key = "h",
      mods = "SHIFT",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "j",
      mods = "SHIFT",
      action = act.ActivatePaneDirection("Down"),
    },
    {
      key = "k",
      mods = "SHIFT",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "l",
      mods = "SHIFT",
      action = act.ActivatePaneDirection("Right"),
    },

  },
}

return config
