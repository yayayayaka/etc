#!/bin/sh

# Return the number of available packages for polybar

case "$(uname -n)" in
	alpine)
		check=$(apk version | wc -l)
		[ "$check" -gt "1" ] && echo " $((check - 1))"
		;;
	archlunix)
		pac=$(checkupdates | wc -l)
		aur=$(auracle outdated | wc -l)

		check=$((pac + aur))
		[ "$check" != "0" ] && echo "$pac  $aur"
		;;
esac

