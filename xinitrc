#!/bin/sh
[ -z "$ENV" ] && . ~/.profile

# Load drop-ins
for f in "$ETC_DIR"/xinitrc.d/*; do
    [ -e "$f"  ] && . "$f"
done

exec i3
