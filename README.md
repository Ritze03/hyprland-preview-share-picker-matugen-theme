# Hyprland Preview Share Picker - Matugen Theme

A theme for [hyprland-preview-share-picker](https://github.com/WhySoBad/hyprland-preview-share-picker) that dynamically synchronizes your UI with your system colors using **Matugen**.

This theme is specifically designed to match the color scheme of [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell).

## Previews

![Blue Preview](https://raw.githubusercontent.com/Ritze03/hyprland-preview-share-picker-matugen-theme/refs/heads/main/preview/blue.png)
![Teal Preview](https://raw.githubusercontent.com/Ritze03/hyprland-preview-share-picker-matugen-theme/refs/heads/main/preview/teal.png)
![Green Preview](https://raw.githubusercontent.com/Ritze03/hyprland-preview-share-picker-matugen-theme/refs/heads/main/preview/green.png)
![Purple Preview](https://raw.githubusercontent.com/Ritze03/hyprland-preview-share-picker-matugen-theme/refs/heads/main/preview/purple.png)

---

## How it works

This theme utilizes a specific "behavior chain" to bypass common compatibility issues between Matugen variables and GTK CSS. Here is the automated workflow:

1. **Matugen** detects your wallpaper and generates a new color palette.
2. It populates `generated-colors.css` using a provided template.
3. A **post-hook script** (`generate-style-css.sh`) automatically bakes those raw hex codes into the final `style.css`.
4. The picker displays your updated theme colors instantly.

## Installation

### Prerequisites

Whether you choose the automated or manual path, ensure you have the following installed:

* **matugen**: For color palette generation.
* **hyprland-preview-share-picker**: The actual picker binary.
* **xdg-desktop-portal-hyprland**: The necessary backend for screencopy.

### Automated (Recommended)

The included install script handles dependency checks, file placement, and Matugen hook integration. It is designed with safety in mind and will **never** overwrite or modify your existing configurations without explicit confirmation at every step.

```bash
git clone https://github.com/Ritze03/hyprland-preview-share-picker-matugen-theme.git
cd hyprland-preview-share-picker-matugen-theme
chmod +x install.sh
./install.sh
```

### Manual

If you prefer to configure your system yourself, follow these steps:

**1. Share Picker Config**  
Move all files from `config_hyprland-preview-share-picker/` to `~/.config/hyprland-preview-share-picker/`.  
*Note: You must run `chmod +x ~/.config/hyprland-preview-share-picker/generate-style-css.sh`.*

**2. Hyprland Portal (`~/.config/hypr/xdph.conf`)**  
Point your portal to the custom picker binary:

```ini
screencopy {
    custom_picker_binary = hyprland-preview-share-picker
    allow_token_by_default = true
}
```

**3. Matugen Configuration (`~/.config/matugen/config.toml`)**  
Add the following template logic to your Matugen config to enable the automated color updates:

```toml
[templates.hyprland-preview-share-picker]
input_path = "~/.config/hyprland-preview-share-picker/template-colors.css"
output_path = "~/.config/hyprland-preview-share-picker/generated-colors.css"
post_hook = "~/.config/hyprland-preview-share-picker/generate-style-css.sh"
```

## Important Note

After installation, you must restart your system (or restart the `xdg-desktop-portal-hyprland` service) for Hyprland to properly initialize the new picker binary.
