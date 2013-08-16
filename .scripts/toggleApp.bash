#!/bin/bash

SEARCHED_WINDOW=dolphin
W_ID=$(xdotool search --classname $SEARCHED_WINDOW)
VISIBLE_W_ID=$(xdotool search --onlyvisible --classname $SEARCHED_WINDOW 2>/dev/null)

if [ -z "$W_ID" ]; then
	echo "NO WINDOW FOUNT"
	$SEARCHED_WINDOW
	NEW_W_ID=$(wmctrl -lx | grep -i $SEARCHED_WINDOW | head -n 1 | cut -d ' ' -f1)
	xdotool windowfocus $NEW_W_ID
elif [ -z "$VISIBLE_W_ID" ]; then
	echo "UNMAPPED WINDOW FOUND"
	for wid in $W_ID; do
		if [[ !($(xprop -id $wid WM_WINDOW_ROLE) =~ .*not\ found.* )]]; then
			xdotool windowmap $wid
			xdotool windowfocus $wid
		fi
	done
else
	echo "VISIBLE WINDOW FOUND"
	windowPosition=$(xdotool getwindowgeometry $VISIBLE_W_ID | grep Position | sed "s/^.* \([0-9]*,[0-9]*\).*$/\1/")
	windowX=$(echo $windowPosition | cut -d ',' -f1)
	windowY=$(echo $windowPosition | cut -d ',' -f2)
	echo $windowX $windowY

	xdotool windowunmap --sync $VISIBLE_W_ID
	sleep 0.2s
	xdotool windowmove $VISIBLE_W_ID $windowX $windowY
fi
