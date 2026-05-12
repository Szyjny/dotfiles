#!/bin/bash

list=" Performance
 Balanced
 Power Saver"

selection=$(echo -e "$list" | wofi --show dmenu \
  --prompt "Select Power Profile..." \
  -i)

[ -z "$selection" ] && exit 0

case "$selection" in
*"Performance"*) profile="performance" ;;
*"Balanced"*) profile="balanced" ;;
*"Power Saver"*) profile="power-saver" ;;
*) exit 1 ;;
esac

powerprofilesctl set "$profile"
