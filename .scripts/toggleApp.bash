#!/bin/bash

SEARCHED_WINDOW=$1
COMMAND=${2:-$SEARCHED_WINDOW}
SEARCHED_WINDOW_CLASSNAME=toggleApp$SEARCHED_WINDOW
WINDOW_ID=$(xdotool search --classname $SEARCHED_WINDOW_CLASSNAME)
VISIBLE_WINDOW_ID=$(xdotool search --onlyvisible --classname $SEARCHED_WINDOW_CLASSNAME 2>/dev/null)

if [ -z "$WINDOW_ID" ]; then
	$COMMAND 2>/dev/null &
	pid=$!
	NEW_WINDOW_ID=$(xdotool search --onlyvisible --sync --pid $pid 2>/dev/null)
	xdotool set_window --classname $SEARCHED_WINDOW_CLASSNAME $NEW_WINDOW_ID
	xdotool windowfocus $NEW_WINDOW_ID
elif [ -z "$VISIBLE_WINDOW_ID" ]; then
	xdotool windowmap $WINDOW_ID
	xdotool windowfocus $WINDOW_ID
else
	xdotool windowunmap $VISIBLE_WINDOW_ID
fi
