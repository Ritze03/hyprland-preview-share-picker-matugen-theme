#!/usr/bin/env bash

# Colors
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# --- Precautions ---
clear
echo -e "${CYAN}Hyprland Preview Share Picker - Matugen Theme Installer${NC}"
echo -e "------------------------------------------------------------"
echo -e "This script will modify or create files in:"
echo -e "1. ~/.config/hypr/xdph.conf"
echo -e "2. ~/.config/matugen/config.toml"
echo -e "3. ~/.config/hyprland-preview-share-picker/"
echo -e "   - config.yaml, generated-colors.css, generate-style-css.sh,"
echo -e "   - style.css, template-colors.css, template-style.css\n"

# Check existence for safety report
EXISTING_FILES=0
[ -f ~/.config/hypr/xdph.conf ] && ((EXISTING_FILES++))
[ -f ~/.config/matugen/config.toml ] && ((EXISTING_FILES++))
[ -d ~/.config/hyprland-preview-share-picker ] && ((EXISTING_FILES++))

if [ $EXISTING_FILES -eq 0 ]; then
  echo -e "${GREEN}Procedure is safe: No existing configurations detected.${NC}"
else
  echo -e "${YELLOW}Notice: $EXISTING_FILES existing configuration(s) detected.${NC}"
fi

echo -e "${RED}This script will not overwrite anything without your confirmation.${NC}"
read -p "Proceed? (y/N): " confirm_start
[[ $confirm_start != "y" ]] && exit 0

# --- Dependencies ---
clear
echo -e "${CYAN}[Checking Dependencies]${NC}"
echo -e "-----------------------\n"

if ! command -v matugen &>/dev/null; then
  echo -e "${YELLOW}Matugen not found.${NC} It is required to generate colors from wallpaper."
  echo "Please install it via your package manager."
  read -p "Install theme files anyway? (y/N): " ignore_matugen
  [[ $ignore_matugen != "y" ]] && exit 0
else
  echo -e "${GREEN}✓ Matugen is installed.${NC}"
fi

if ! command -v hyprland-preview-share-picker &>/dev/null; then
  if [ -f /etc/arch-release ]; then
    echo -e "\n${YELLOW}Picker not found.${NC} Install 'hyprland-preview-share-picker-git' from the AUR."
  else
    echo -e "\n${YELLOW}Picker not found.${NC} Install it from: https://github.com/WhySoBad/hyprland-preview-share-picker"
  fi
  read -p "Press [Enter] once you have installed the picker to continue..."
else
  echo -e "${GREEN}✓ hyprland-preview-share-picker is installed.${NC}"
fi

# --- Hyprland Configuration ---
clear
echo -e "${CYAN}[Hyprland Configuration]${NC}"
echo -e "------------------------\n"
XDPH_PATH="$HOME/.config/hypr/xdph.conf"

if [ ! -f "$XDPH_PATH" ]; then
  echo -e "File ${YELLOW}$XDPH_PATH${NC} does not exist."
  echo -e "Proposed content for new file:\n"
  cat config_hypr/xdph.conf
  echo ""
  read -p "Create this file? (y/N): " create_xdph
  if [ "$create_xdph" == "y" ]; then
    mkdir -p "$(dirname "$XDPH_PATH")"
    cp config_hypr/xdph.conf "$XDPH_PATH"
    echo -e "${GREEN}Created $XDPH_PATH${NC}"
  fi
else
  echo -e "${YELLOW}$XDPH_PATH already exists.${NC}"
  echo -e "Recommended settings (Ensure these are in your file):\n"
  echo -e "screencopy {"
  echo -e "    custom_picker_binary=hyprland-preview-share-picker"
  echo -e "    allow_token_by_default = true"
  echo -e "}\n"
  read -p "Press [Enter] to continue..."
fi

# --- Picker Theme Configuration ---
clear
echo -e "${CYAN}[Picker Theme Configuration]${NC}"
echo -e "----------------------------\n"
PICKER_DIR="$HOME/.config/hyprland-preview-share-picker"

if [ ! -d "$PICKER_DIR" ] || [ ! -f "$PICKER_DIR/config.yaml" ]; then
  [ ! -d "$PICKER_DIR" ] && echo -e "Directory ${YELLOW}$PICKER_DIR${NC} does not exist.\n"
  [ -d "$PICKER_DIR" ] && echo -e "Directory exists, but ${YELLOW}config.yaml${NC} is missing.\n"

  echo "Proposed theme files to be installed:"
  ls config_hyprland-preview-share-picker/
  echo ""
  read -p "Install all theme files to $PICKER_DIR? (y/N): " install_picker
  if [ "$install_picker" == "y" ]; then
    mkdir -p "$PICKER_DIR"
    cp config_hyprland-preview-share-picker/* "$PICKER_DIR/"
    chmod +x "$PICKER_DIR/generate-style-css.sh"
    echo -e "${GREEN}Theme files installed.${NC}"
  fi
else
  echo -e "${YELLOW}$PICKER_DIR/config.yaml already exists.${NC}"
  read -p "Overwrite existing theme configuration? (y/N): " over_picker
  if [ "$over_picker" == "y" ]; then
    cp config_hyprland-preview-share-picker/* "$PICKER_DIR/"
    chmod +x "$PICKER_DIR/generate-style-css.sh"
    echo -e "${GREEN}Theme files updated.${NC}"
  fi
fi

# --- Matugen Configuration ---
clear
echo -e "${CYAN}[Matugen Configuration]${NC}"
echo -e "-----------------------\n"
MAT_DIR="$HOME/.config/matugen"
MAT_FILE="$MAT_DIR/config.toml"

if [ ! -f "$MAT_FILE" ]; then
  echo -e "File ${YELLOW}$MAT_FILE${NC} does not exist."
  echo -e "Proposed content for new file:\n"
  echo -e "[config]\n"
  cat config_matugen/config.toml
  echo ""
  read -p "Create this file? (y/N): " create_mat
  if [ "$create_mat" == "y" ]; then
    mkdir -p "$MAT_DIR"
    echo -e "[config]\n" >"$MAT_FILE"
    cat config_matugen/config.toml >>"$MAT_FILE"
    echo -e "${GREEN}Created $MAT_FILE${NC}"
  fi
else
  echo -e "${YELLOW}$MAT_FILE already exists.${NC}"
  echo -e "Proposed content to append:\n"
  cat config_matugen/config.toml
  echo ""
  read -p "Append these theme hooks to your config? (y/N): " append_mat
  if [ "$append_mat" == "y" ]; then
    echo -e "\n" >>"$MAT_FILE"
    cat config_matugen/config.toml >>"$MAT_FILE"
    echo -e "${GREEN}Matugen configuration updated.${NC}"
  fi
fi

# --- Closing ---
clear
echo -e "${GREEN}Installation complete!${NC}"
echo -e "----------------------\n"
echo -e "${YELLOW}IMPORTANT:${NC} You must restart your system (or restart the xdg-desktop-portal-hyprland service)"
echo -e "for Hyprland to properly use the new picker binary.\n"
echo "Bye bye!"
exit 0
