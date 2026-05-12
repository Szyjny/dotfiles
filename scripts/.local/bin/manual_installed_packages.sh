#!/bin/bash

XBPS_CHECK=false
FLATPAK_CHECK=false
VERBOSE=false
ALL_MODE=false

while getopts "xfva" opt; do
  case $opt in
  x) XBPS_CHECK=true ;;
  f) FLATPAK_CHECK=true ;;
  v) VERBOSE=true ;;
  a) ALL_MODE=true ;;
  \?) exit 1 ;;
  esac
done

if [ "$XBPS_CHECK" = false ] && [ "$FLATPAK_CHECK" = false ]; then
  XBPS_CHECK=true
  FLATPAK_CHECK=true
fi

SUM=0

if [ "$XBPS_CHECK" = true ]; then
  if [ "$ALL_MODE" = true ]; then
    XBPS_LIST=$(xbps-query -l | awk '{print $2}')
    TITLE="All Installed Packages"
  else
    XBPS_LIST=$(xbps-query -m)
    TITLE="Manual Packages"
  fi

  XBPS_COUNT=$(echo "$XBPS_LIST" | grep -c '^')
  SUM=$((SUM + XBPS_COUNT))

  if [ "$VERBOSE" = true ]; then
    echo "=====> XBPS $TITLE ($XBPS_COUNT) <====="
    echo "$XBPS_LIST"
  fi
fi

if [ "$FLATPAK_CHECK" = true ]; then
  if command -v flatpak >/dev/null 2>&1; then
    if [ "$ALL_MODE" = true ]; then
      FLAT_LIST=$(flatpak list --all --columns=name,application | awk -F'\t' '{printf "%-30s  ->  %s\n", $1, $2}')
      F_TITLE="All Components (Apps, Runtimes, Extensions)"
    else
      FLAT_LIST=$(flatpak list --app --columns=name,application | awk -F'\t' '{printf "%-30s  ->  %s\n", $1, $2}')
      F_TITLE="Applications"
    fi
    FLAT_COUNT=$(echo "$FLAT_LIST" | grep -c '^')
  else
    FLAT_COUNT=0
    FLAT_LIST=""
  fi

  SUM=$((SUM + FLAT_COUNT))

  if [ "$VERBOSE" = true ]; then
    echo -e "\n=====> Flatpak $F_TITLE ($FLAT_COUNT) <====="
    if [ "$FLAT_COUNT" -gt 0 ]; then
      echo "$FLAT_LIST"
    else
      echo "None"
    fi
  fi
fi

if [ "$VERBOSE" = true ]; then
  echo -e "\nTotal: $SUM"
else
  echo "$SUM"
fi
