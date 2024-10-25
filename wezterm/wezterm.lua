local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window {}
  window:gui_window():maximize()
end)

local config = wezterm.config_builder()


local BinaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")

-- print(string.format("Result: %s", BinaryFormat))
if BinaryFormat == "Program" then
  -- print("hello windows here")
  config = {
    default_prog = { "powershell.exe" },
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
          File = "C:/Users/sushr/OneDrive/Pictures/Saved Pictures/bg-dark-loner.jpeg"
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
      key = "B", mods = "CTRL", timeout_milliseconds = 7000,
    },
    keys = {
      {
        key = "U",
        mods = "CTRL",
        action = act.SpawnTab { DomainName = "WSL:Ubuntu", },
      },
      {
        key = "v",
        mods = "LEADER",
        action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
      },
      {
        key = 's',
        mods = "LEADER",
        action = act.SplitVertical { domain = "CurrentPaneDomain" },
      },
      {
        key = "h",
        mods = "ALT",
        action = act.ActivatePaneDirection("Left"),
      },
      {
        key = "j",
        mods = "ALT",
        action = act.ActivatePaneDirection("Down"),
      },
      {
        key = "k",
        mods = "ALT",
        action = act.ActivatePaneDirection("Up"),
      },
      {
        key = "l",
        mods = "ALT",
        action = act.ActivatePaneDirection("Right"),
      },

    },
  }
elseif BinaryFormat == "so" then
  config = {
    default_prog = { "/bin/bash" },
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
          File = "~/.config/nvim/bg-dark-loner.jpeg"
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
  }
elseif BinaryFormat == "dylib" then
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
          File = "/Users/sushr/.config/nvim/bg-dark-loner.jpeg"
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
  }
end

return config
