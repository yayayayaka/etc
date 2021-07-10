#!/bin/sh
# login code for bourne-like shells
hostname="$(uname -n)"; export HOSTNAME="$hostname"

# The location of my dotfilles
export ETC_DIR="$HOME/etc"

# Set default XDG directories
export XDG_RUNTIME_DIR="$HOME/.run/$HOSTNAME"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export ENV="$ETC_DIR/shellrc"

# 
export VISUAL

mkdir -p "$XDG_RUNTIME_DIR" "$HOME/.cache"
umask 027


# load drop-ins
for f in "$ETC_DIR"/profile.d/*; do
    [ -e "$f"  ] && . "$f"
done

[ -n "$BASH_VERSION" ] && . "$ENV"
[ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && exec startx
