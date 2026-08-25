# Keep WezTerm's TMUX_ACTIVE pane variable synchronized at each Zsh prompt.
_wezterm_update_tmux_state() {
    if [ -n "${TMUX:-}" ]; then
        "$HOME/.config/wezterm/tmux-state.sh" 1
    else
        "$HOME/.config/wezterm/tmux-state.sh" 0
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook -D precmd _wezterm_update_tmux_state 2>/dev/null
add-zsh-hook precmd _wezterm_update_tmux_state
