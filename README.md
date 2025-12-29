# NixOS Dotfiles

My personal NixOS configuration featuring Hyprland, Waybar, Rofi, and SwayNC with the Catppuccin Mocha theme.

## Overview

This repository contains my complete NixOS setup optimized for:
- **Hyprland** - Wayland compositor with smooth animations
- **NVIDIA** - Proper Wayland support with proprietary drivers
- **Catppuccin Mocha** - Consistent theming across all components

## Components

| Component | Description |
|-----------|-------------|
| **Hyprland** | Tiling Wayland compositor with multiple animation presets |
| **Waybar** | Highly customizable status bar with multiple themes |
| **Rofi** | Application launcher and clipboard manager |
| **SwayNC** | Notification center with theme variants |
| **Greetd + tuigreet** | Minimal TUI display manager |

## Structure

```
.
├── hypr/                    # Hyprland configuration
│   ├── hyprland.conf        # Main config
│   └── conf/                # Modular configs
│       ├── animations/      # Animation presets (smooth, fast, dynamic...)
│       ├── decorations/     # Window decoration variants
│       ├── monitors/        # Monitor resolution configs
│       └── windows/         # Border and gap styles
├── waybar/                  # Waybar status bar
│   ├── modules.json         # Module definitions
│   ├── scripts/             # Custom scripts (caffeine, netspeed)
│   └── themes/              # Theme variants
│       ├── catppuccin/
│       ├── tokyo-night/
│       ├── ml4w-modern/
│       └── ...
├── rofi/                    # Rofi launcher
│   ├── config.rasi          # Main config
│   └── config-*.rasi        # Specialized configs (cliphist, screenshot...)
├── swaync/                  # SwayNC notifications
│   └── themes/              # Theme variants
├── nixos/                   # NixOS system configuration
│   ├── configuration.nix    # Main system config
│   └── hardware-configuration.nix
└── install.sh               # Interactive installer
```

## Installation

### Prerequisites

- NixOS (tested on 25.11)
- NVIDIA GPU (config includes NVIDIA-specific settings)

### Quick Install

```bash
git clone git@github.com:rohansx/rsx-nixos-config.git
cd rsx-nixos-config
chmod +x install.sh
./install.sh
```

The installer will:
1. Backup existing configs to `~/.config-backup-<timestamp>/`
2. Prompt for each component (NixOS, Hyprland, Waybar, SwayNC, Rofi)
3. Copy selected configs to appropriate locations

### Manual Installation

```bash
# NixOS configuration
sudo cp nixos/configuration.nix /etc/nixos/
sudo nixos-rebuild switch

# User configs
cp -r hypr ~/.config/
cp -r waybar ~/.config/
cp -r rofi ~/.config/
cp -r swaync ~/.config/
```

## Key Features

### Hyprland
- Multiple animation presets (smooth, fast, dynamic, classic)
- Window decoration variants (blur, rounded corners, glass effect)
- Monitor configurations for common resolutions
- NVIDIA-optimized environment variables

### Waybar Themes
- **Catppuccin** - Mocha color scheme
- **Tokyo Night** - Dark purple aesthetic
- **ML4W Modern** - Clean minimal look
- **ML4W Glass** - Transparent glassmorphism

### Included Packages

**Development:**
- Neovim, VS Code, Cursor
- Node.js, Python, Go, Rust
- Docker & Docker Compose
- Git, ripgrep, fzf

**Desktop:**
- Firefox, Brave
- Nautilus, Dolphin
- Kitty, Foot terminals

**Utilities:**
- Claude Code, OpenCode (AI coding)
- btop, fastfetch
- wl-clipboard, cliphist

## Keybindings

Default keybindings are in `hypr/conf/keybindings/default.conf`. Common ones:

| Key | Action |
|-----|--------|
| `Super + Return` | Terminal |
| `Super + D` | Rofi launcher |
| `Super + Q` | Close window |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |

## Customization

### Changing Themes

Waybar themes can be switched by symlinking the desired theme:
```bash
ln -sf ~/.config/waybar/themes/catppuccin/style.css ~/.config/waybar/style.css
```

### Monitor Setup

Edit `hypr/conf/monitor.conf` to source the appropriate resolution config:
```
source = ~/.config/hypr/conf/monitors/1920x1080.conf
```

## Credits

- [ML4W Dotfiles](https://github.com/mylinuxforwork/dotfiles) - Inspiration for modular Hyprland config
- [Catppuccin](https://github.com/catppuccin) - Color scheme
- [Hyprland](https://hyprland.org/) - Wayland compositor

## License

MIT
