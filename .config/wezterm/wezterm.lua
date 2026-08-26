local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

local config = wezterm.config_builder()

local target = wezterm.target_triple
local is_windows = target:find("windows") ~= nil

local function maximize_after_layout(mux_window)
    wezterm.time.call_after(0.2, function()
        local gui_window = mux_window:gui_window()
        if gui_window then
            gui_window:maximize()
        end
    end)
end

local function terminal_domain_choices()
    local choices = {}

    for _, domain in ipairs(mux.all_domains()) do
        local domain_name = domain:name()
        local is_local = domain_name == "local"
        local is_direct_ssh = domain_name:match("^SSH:") ~= nil
        if domain:is_spawnable() and (is_local or is_direct_ssh) then
            table.insert(choices, {
                id = domain_name,
                label = domain:label(),
            })
        end
    end

    table.sort(choices, function(a, b)
        return a.label < b.label
    end)

    return choices
end

local select_terminal_tab = wezterm.action_callback(function(window, pane)
    window:perform_action(
        act.InputSelector {
            title = "New terminal tab",
            description = "Select the local terminal or an SSH host",
            fuzzy = true,
            choices = terminal_domain_choices(),
            action = wezterm.action_callback(function(inner_window, inner_pane, domain_name)
                if domain_name then
                    inner_window:perform_action(
                        act.SpawnTab { DomainName = domain_name },
                        inner_pane
                    )
                end
            end),
        },
        pane
    )
end)

local function pane_is_running_tmux(pane)
    local user_vars = pane:get_user_vars()
    if user_vars.TMUX_ACTIVE == "1" then
        return true
    end

    -- Process inspection is only available for local panes. Remote panes use
    -- the TMUX_ACTIVE signal emitted by the server-side tmux configuration.
    local process_name = pane:get_foreground_process_name()
    return process_name == "tmux"
        or (process_name and process_name:match("[/\\]tmux$") ~= nil)
end

local activate_wezterm_leader = act.ActivateKeyTable {
    name = "wezterm_leader",
    one_shot = true,
    timeout_milliseconds = 2000,
}

local function tmux_passthrough_or(wezterm_action, key, mods)
    return wezterm.action_callback(function(window, pane)
        if pane_is_running_tmux(pane) then
            window:perform_action(act.SendKey { key = key, mods = mods }, pane)
        else
            window:perform_action(wezterm_action, pane)
        end
    end)
end

wezterm.on("gui-startup", function(command)
    local _, _, mux_window = mux.spawn_window(command or {})
    maximize_after_layout(mux_window)
end)

config.automatically_reload_config = true
config.window_decorations = "RESIZE"
config.color_scheme = "Nord (Gogh)"
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 12.5
config.background = {
    {
        source = {
            File = wezterm.config_dir .. "/bg-dark-loner.jpeg",
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

-- Direct SSH domains end with the GUI; no remote WezTerm mux server is used.
config.ssh_domains = wezterm.default_ssh_domains()
for _, domain in ipairs(config.ssh_domains) do
    domain.assume_shell = "Posix"
end

if is_windows then
    local wsl_domains = wezterm.default_wsl_domains()
    config.wsl_domains = wsl_domains

    if #wsl_domains > 0 then
        local preferred_domain = wsl_domains[1].name
        for _, domain in ipairs(wsl_domains) do
            if domain.name == "WSL:Ubuntu" then
                preferred_domain = domain.name
                break
            end
        end
        config.default_domain = preferred_domain
    end
end

config.enable_tab_bar = true

config.keys = {
    -- Shell-style word movement on macOS.
    { key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
    { key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },

    -- Keep lowercase Ctrl-b free for tmux; uppercase Ctrl-B opens WezTerm's key table.
    { key = "b", mods = "CTRL|SHIFT", action = activate_wezterm_leader },

    -- Navigate WezTerm panes locally, but pass these keys through to tmux.
    {
        key = "h",
        mods = "ALT",
        action = tmux_passthrough_or(act.ActivatePaneDirection("Left"), "h", "ALT"),
    },
    {
        key = "j",
        mods = "ALT",
        action = tmux_passthrough_or(act.ActivatePaneDirection("Down"), "j", "ALT"),
    },
    {
        key = "k",
        mods = "ALT",
        action = tmux_passthrough_or(act.ActivatePaneDirection("Up"), "k", "ALT"),
    },
    {
        key = "l",
        mods = "ALT",
        action = tmux_passthrough_or(act.ActivatePaneDirection("Right"), "l", "ALT"),
    },
}

config.key_tables = {
    wezterm_leader = {
        -- Core tmux bindings. These affect WezTerm only; tmux remains unchanged.
        { key = "c", action = act.SpawnTab("CurrentPaneDomain") },
        { key = "%", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
        { key = '"', action = act.SplitVertical { domain = "CurrentPaneDomain" } },
        { key = "d", action = act.DetachDomain("CurrentPaneDomain") },
        { key = "T", action = select_terminal_tab },
        { key = "z", action = act.TogglePaneZoomState },
        { key = "x", action = act.CloseCurrentPane { confirm = true } },
        { key = "[", action = act.ActivateCopyMode },
    },
}

return config
