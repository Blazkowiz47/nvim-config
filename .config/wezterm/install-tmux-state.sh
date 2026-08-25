#!/bin/sh
set -eu

source_dir=${1:?"usage: install-tmux-state.sh SOURCE_DIR"}
managed_dir="$HOME/.config/wezterm"
backup_dir="$managed_dir/backups/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$managed_dir" "$backup_dir"

backup_file() {
    file=$1
    if [ -e "$file" ]; then
        cp -p "$file" "$backup_dir/$(basename "$file")"
    fi
}

backup_file "$HOME/.tmux.conf"
backup_file "$HOME/.bashrc"
backup_file "$HOME/.zshrc"
backup_file "$managed_dir/tmux-state.sh"
backup_file "$managed_dir/tmux-state.bash"
backup_file "$managed_dir/tmux-state.zsh"
backup_file "$managed_dir/tmux-state.tmux.conf"

install -m 755 "$source_dir/tmux-state.sh" "$managed_dir/tmux-state.sh"
install -m 644 "$source_dir/tmux-state.bash" "$managed_dir/tmux-state.bash"
install -m 644 "$source_dir/tmux-state.zsh" "$managed_dir/tmux-state.zsh"
install -m 644 "$source_dir/tmux-state.tmux.conf" "$managed_dir/tmux-state.tmux.conf"

append_line() {
    file=$1
    line=$2
    touch "$file"
    if ! grep -Fqx "$line" "$file"; then
        printf '\n%s\n' "$line" >>"$file"
    fi
}

append_line "$HOME/.tmux.conf" 'source-file ~/.config/wezterm/tmux-state.tmux.conf'
append_line "$HOME/.bashrc" '[ -r "$HOME/.config/wezterm/tmux-state.bash" ] && source "$HOME/.config/wezterm/tmux-state.bash"'
if [ -e "$HOME/.zshrc" ]; then
    append_line "$HOME/.zshrc" '[ -r "$HOME/.config/wezterm/tmux-state.zsh" ] && source "$HOME/.config/wezterm/tmux-state.zsh"'
fi

sh -n "$managed_dir/tmux-state.sh"
bash -n "$HOME/.bashrc"
if command -v zsh >/dev/null 2>&1 && [ -e "$HOME/.zshrc" ]; then
    zsh -n "$HOME/.zshrc"
fi

validation_socket="codex-tmux-state-$$"
tmux -L "$validation_socket" -f "$HOME/.tmux.conf" new-session -d
tmux -L "$validation_socket" kill-server

if tmux list-sessions >/dev/null 2>&1; then
    tmux source-file "$HOME/.tmux.conf"
    tmux list-clients -F '#{client_tty}' 2>/dev/null | while IFS= read -r client_tty; do
        "$managed_dir/tmux-state.sh" 1 "$client_tty"
    done
fi

printf 'backup_dir=%s\n' "$backup_dir"
tmux -V
