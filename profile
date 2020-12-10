#!/bin/sh
# login code for bourne-like shells
hostname="$(uname -n)"; export HOSTNAME="$hostname"
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.run/$HOSTNAME}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export PATH=$XDG_CONFIG_HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$PATH
export ENV=$XDG_CONFIG_HOME/shellrc
export NO_AT_BRIDGE=1 # Suppress useless Gnome warnings
export VISUAL
mkdir -p "$XDG_RUNTIME_DIR" "$HOME/.cache"
umask 027

# Define preferred order of editors
for VISUAL in vim nano vi; do
	hash "$VISUAL" >/dev/null 2>&1 && break
done
# pass(1) relies on EDITOR variable
export EDITOR="$VISUAL"

# OS specific configuration
if [ "$(uname)" = "Linux" ]; then
	for dev in /sys/class/net/*; do
		[ -d "/sys/class/net/$dev/wireless" ] && export WIRELESS_IF=$dev
	done
elif [ "$(uname)" = "OpenBSD" ]; then
	export LC_CTYPE="en_US.UTF-8"
fi

[ -f "$XDG_CONFIG_HOME"/profile.local ] && . "$XDG_CONFIG_HOME"/profile.local
[ -n "$BASH_VERSION" ] && . "$ENV"
[ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && exec startx

