#!/bin/bash

WINDOW_TITLE="rmpc-window"

if swaymsg -t get_tree | grep -q "$WINDOW_TITLE"; then
  swaymsg "[title=\"$WINDOW_TITLE\"] kill"
else
  ghostty --title="$WINDOW_TITLE" -e rmpc
fi
