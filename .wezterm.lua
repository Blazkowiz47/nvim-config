local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

wezterm.on("gui-startup", function()
    local _, _, window = mux.spawn_window {}
    window:gui_window():maximize()
end)

local config = wezterm.config_builder()

config = {}

config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.color_scheme = "Nord (Gogh)"
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 12.5
config.leader = {
    key = "B", mods = "CTRL", timeout_milliseconds = 2000,
}

config.keys = {
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
        key = "s",
        mods = "LEADER",
        action = act.SplitVertical { domain = "CurrentPaneDomain" },
    },
    {
        key = "H",
        mods = "ALT",
        action = act.ActivatePaneDirection("Left"),
    },
    {
        key = "J",
        mods = "ALT",
        action = act.ActivatePaneDirection("Down"),
    },
    {
        key = "K",
        mods = "ALT",
        action = act.ActivatePaneDirection("Up"),
    },
    {
        key = "L",
        mods = "ALT",
        action = act.ActivatePaneDirection("Right"),
    },

}

local BinaryFormat = package.cpath:match("%p[\\|/]?%p(%a+)")
print(string.format("Result: %s", BinaryFormat))
if BinaryFormat == "Program" then
    -- print("hello windows here")
    config.default_prog = { "powershell.exe" }
    config.background = {
        {
            source = {
                File = string.format("%s/bg-dark-loner.jpeg", os.getenv('USERPROFILE'))
            },
            hsb = {
                hue = 1.0,
                saturation = 1.02,
                brightness = 0.25,

            },
            width = "100%",
            height = "100%",
        },
    }
    config.enable_tab_bar = true
elseif BinaryFormat == "so" then
    config.background = {
        {
            source = {
                File = string.format("%s/.config/wezterm/bg-dark-loner.jpeg", os.getenv('HOME'))
            },
            hsb = {
                hue = 1.0,
                saturation = 1.02,
                brightness = 0.25,

            },
            width = "100%",
            height = "100%",
        },
    }
    config.enable_tab_bar = false
end

return config
