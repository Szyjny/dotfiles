#!/bin/bash

VERBOSE=false
PACKAGE=""

for arg in "$@"; do
  if [ "$arg" == "-v" ]; then
    VERBOSE=true
  else
    PACKAGE="$arg"
  fi
done

if [ -z "$PACKAGE" ]; then
  echo "Usage: $0 [-v] <package_name>"
  exit 1
fi

installed=$(xbps-query -l | awk '{ print $2 }' | xargs xbps-uhelper getpkgname | sort)
if echo "$installed" | grep -qE "$PACKAGE"; then
  echo "Package '$PACKAGE' is already installed."
  exit 0
fi

match_count=$(xbps-query -Rs "$PACKAGE" | wc -l)
if [ "$match_count" -ne 0 ]; then
  if ! xbps-query -Rs "$PACKAGE" | awk '{ print $2 }' | xargs -n1 xbps-uhelper getpkgname 2>/dev/null | grep -qx "$PACKAGE"; then
    echo "Package '$PACKAGE' not found in repositories."
    exit 1
  fi
else
  echo "Package '$PACKAGE' not found in repositories."
  exit 1
fi

full_deps=$(xbps-query -Rx --fulldeptree "$PACKAGE" 2>/dev/null | sort)
if [ -z "$full_deps" ]; then
  echo "0"
  exit 0
fi

missing=$(comm -23 <(echo "$full_deps") <(echo "$installed"))

if [ "$VERBOSE" = true ]; then
  if [ -z "$missing" ]; then
    echo "All dependencies are already installed."
    exit 0
  fi
  echo "Missing dependencies:"
  echo "$missing"
else
  if [ -z "$missing" ]; then
    echo "0"
    exit 0
  fi
  echo "$missing" | wc -l
fi
