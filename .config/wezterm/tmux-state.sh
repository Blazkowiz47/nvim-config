#!/bin/sh

# Tell the outer WezTerm pane whether this terminal is currently inside tmux.
state=${1:-0}
case "$state" in
    1) encoded_state="MQ==" ;;
    *) encoded_state="MA==" ;;
esac

emit_state() {
    printf '\033]1337;SetUserVar=TMUX_ACTIVE=%s\007' "$encoded_state"
}

emit_to_all_clients() {
    tmux list-clients -F '#{client_tty}' 2>/dev/null | while IFS= read -r client_tty; do
        if [ -n "$client_tty" ] && [ -w "$client_tty" ]; then
            emit_state >"$client_tty"
        fi
    done
}

# tmux hooks provide the outer client TTY explicitly.
if [ "$#" -ge 2 ]; then
    client_tty=$2
    if [ "$client_tty" = "--all-clients" ]; then
        emit_to_all_clients
    elif [ -n "$client_tty" ] && [ -w "$client_tty" ]; then
        emit_state >"$client_tty"
    fi
    exit 0
fi

# A prompt inside tmux updates every attached client. Outside tmux, emit to
# stdout so a normal shell prompt clears any stale state.
if [ -n "${TMUX:-}" ] && command -v tmux >/dev/null 2>&1; then
    emit_to_all_clients
else
    emit_state
fi
