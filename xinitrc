#!/bin/sh
[ -z "$ENV" ] && . ~/.profile
[ -f "$XDG_CONFIG_HOME"/xprofile.local ] && . "$XDG_CONFIG_HOME"/xprofile.local

# Start ssh agent
if hash ssh-agent >/dev/null 2>&1; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent$DISPLAY.sck"
    rm "$SSH_AUTH_SOCK"
    ssh-agent -d -a "$SSH_AUTH_SOCK" &
    export SSH_AGENT_PID="$!"
fi

# Disable DPMS turning off the screen
xset -dpms
xset s off

# Disable bell
xset b off

# Configure keyboard
setxkbmap us workman -option compose:prsc \
    || setxkbmap us -option compose:prsc

exec i3
