local wezterm = require("wezterm")

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
        File = "/Users/sushrutpatwardhan/.config/nvim/bg-dark-loner.jpeg"
      },
      hsb = {
        hue = 1.0,
        saturation = 1.02,
        brightness = 0.25,

      },
      width = "100%",
      height = "100%",
    },
    {
      source = {
        Color = "#282c35",
      },
      width = "100%",
      height = "100%",
      opacity = 0.55,
    },
  },
}

return config
