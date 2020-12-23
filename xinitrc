#!/bin/sh
[ -z "$ENV" ] && . ~/.profile

# Load drop-ins
for f in "$XDG_CONFIG_HOME"/xinitrc.d/*; do
    [ -e "$f"  ] && . "$f"
done

exec i3
