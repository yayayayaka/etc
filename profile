#!/bin/sh
# login code for bourne-like shells
hostname="$(uname -n)"; export HOSTNAME="$hostname"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-$HOME/.run/$HOSTNAME}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export PATH="$XDG_CONFIG_HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export ENV="$XDG_CONFIG_HOME/shellrc"
export NO_AT_BRIDGE=1 # Suppress useless Gnome warnings
export VISUAL
mkdir -p "$XDG_RUNTIME_DIR" "$HOME/.cache"
umask 027


# load drop-ins
for f in "$XDG_CONFIG_HOME"/profile.d/*; do
    [ -e "$f"  ] && . "$f"
done

[ -n "$BASH_VERSION" ] && . "$ENV"
[ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && exec startx
