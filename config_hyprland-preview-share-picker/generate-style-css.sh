#!/usr/bin/env bash

# Paths
CONFIG_DIR="$HOME/.config/hyprland-preview-share-picker"
GEN_COLORS="$CONFIG_DIR/generated-colors.css"
TEMPLATE="$CONFIG_DIR/template-style.css"
OUTPUT="$CONFIG_DIR/style.css"

# Check if files exist
if [[ ! -f "$GEN_COLORS" ]] || [[ ! -f "$TEMPLATE" ]]; then
  echo "Error: Required files missing."
  exit 1
fi

# Start with the template content
FINAL_CSS=$(cat "$TEMPLATE")

# Read generated-colors.css line by line
while read -r line; do
  # Match lines like: @define-color name #hex;
  if [[ $line =~ @define-color\ ([a-zA-Z0-9_-]+)\ ([#a-fA-F0-9]+)\; ]]; then
    VAR_NAME="${BASH_REMATCH[1]}"
    COLOR_VAL="${BASH_REMATCH[2]}"

    # Replace %VAR_NAME% with COLOR_VAL
    FINAL_CSS="${FINAL_CSS//%$VAR_NAME%/$COLOR_VAL}"
  fi
done <"$GEN_COLORS"

# Write to the final style.css
echo "$FINAL_CSS" >"$OUTPUT"
