#!/bin/bash

M_ZIP_FILE="$1"
M_FILENAME_NO_EXT="${M_ZIP_FILE%.zip}"

unzip "$M_ZIP_FILE" -d "$HOME/Music"
mv "$M_FILENAME_NO_EXT" "$HOME/Music/albums/"

rm -rf "$M_ZIP_FILE"
