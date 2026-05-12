#!/bin/bash

WINDOW_TITLE="btop-window"

if swaymsg -t get_tree | grep -q "$WINDOW_TITLE"; then
  swaymsg "[title=\"$WINDOW_TITLE\"] kill"
else
  ghostty --title="$WINDOW_TITLE" -e btop
fi
