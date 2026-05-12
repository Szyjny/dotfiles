#!/bin/bash

WALL_DIR="$HOME/Pictures/wallpapers"

list=$(find "$WALL_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" \) | while read -r path; do
  filename=$(basename "$path")
  name="${filename%.*}"
  echo "img:$path:text:$name"
done)

raw_selection=$(echo "$list" | wofi --show dmenu \
  --prompt "Select wallpaper..." \
  --allow-images \
  -i)

[ -z "$raw_selection" ] && exit 0

selection=$(echo "$raw_selection" | awk -F':text:' '{print $2}')

full_path=$(find "$WALL_DIR" -name "$selection.*" -print -quit)

[ -z "$full_path" ] && exit 1

link_path="$HOME/.local/share/current_wallpaper"
ln -sf "$full_path" "$link_path"

pkill -x swaybg
swaybg -i "$link_path" -m fill &
