#!/bin/sh

while true; do
  date_info=$(date +'%H:%M | %d-%m-%Y')

  curr=$(brightnessctl get)
  max=$(brightnessctl m)
  brightness=" $((curr * 100 / max))% | "

  battery=$(cat /sys/class/power_supply/BAT0/capacity)
  battery_status=$(cat /sys/class/power_supply/BAT0/status)

  if [ "$battery_status" = "Charging" ]; then
    bat_info="󱐌 $battery% | "
  elif [ "$battery_status" = "Discharging" ]; then
    bat_info=" $battery% | "
  else
    bat_info=""
  fi

  mpc_status=$(mpc status %state%)

  if [ "$mpc_status" = "playing" ]; then
    mpc_volume=$(mpc volume | awk '{print $2}')
    mpc_display=" $mpc_volume | "
  else
    mpc_display=""
  fi

  is_volume_muted_status=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
  vol_val=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '/Volume:/ {print $5}')

  if [ "$is_volume_muted_status" = "yes" ]; then
    volume_display=" | "
  else
    volume_display=" $vol_val | "
  fi

  is_mic_muted_status=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
  if [ "$is_mic_muted_status" = "yes" ]; then
    mic_info=" | "
  else
    mic_info=""
  fi

  power_profile=$(powerprofilesctl get | tr -d '\n')

  if [ "$power_profile" = "balanced" ]; then
    power_profile="󰗑 | "
  elif [ "$power_profile" = "performance" ]; then
    power_profile=" | "
  elif [ "$power_profile" = "power-saver" ]; then
    power_profile=" | "
  else
    $power_profile = ""
  fi

  echo "${bat_info}${mic_info}${mpc_display}${volume_display}${brightness}${power_profile}${date_info}"

  sleep 1
done
