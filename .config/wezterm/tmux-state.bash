# Keep WezTerm's TMUX_ACTIVE pane variable synchronized at each Bash prompt.
_wezterm_update_tmux_state() {
    if [ -n "${TMUX:-}" ]; then
        "$HOME/.config/wezterm/tmux-state.sh" 1
    else
        "$HOME/.config/wezterm/tmux-state.sh" 0
    fi
}

case ";${PROMPT_COMMAND:-};" in
    *";_wezterm_update_tmux_state;"*) ;;
    *) PROMPT_COMMAND="_wezterm_update_tmux_state${PROMPT_COMMAND:+;$PROMPT_COMMAND}" ;;
esac
