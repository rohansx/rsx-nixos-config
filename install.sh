#!/usr/bin/env bash

# NixOS Hyprland Dotfiles Installer
# Author: rsx
# Description: Installs dotfiles for NixOS with Hyprland

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║       NixOS Hyprland Dotfiles Installer                   ║"
echo "║       Catppuccin Mocha Theme                              ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Function to backup existing config
backup_config() {
    local target="$1"
    if [ -e "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        echo -e "${YELLOW}Backing up $target to $BACKUP_DIR${NC}"
        cp -r "$target" "$BACKUP_DIR/"
    fi
}

# Function to install config
install_config() {
    local src="$1"
    local dest="$2"

    if [ -d "$src" ]; then
        backup_config "$dest"
        echo -e "${GREEN}Installing $src -> $dest${NC}"
        mkdir -p "$(dirname "$dest")"
        cp -r "$src" "$dest"
    fi
}

echo -e "\n${YELLOW}Step 1: Installing NixOS configuration${NC}"
echo "This will copy configuration.nix to /etc/nixos/"
read -p "Do you want to install NixOS config? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo cp "$DOTFILES_DIR/nixos/configuration.nix" /etc/nixos/configuration.nix
    echo -e "${GREEN}NixOS configuration installed!${NC}"
    echo -e "${YELLOW}Note: You may need to update hardware-configuration.nix manually${NC}"
fi

echo -e "\n${YELLOW}Step 2: Installing Hyprland configuration${NC}"
read -p "Install Hyprland config? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    backup_config "$CONFIG_DIR/hypr"
    mkdir -p "$CONFIG_DIR/hypr"
    cp -r "$DOTFILES_DIR/hypr/"* "$CONFIG_DIR/hypr/"
    echo -e "${GREEN}Hyprland configuration installed!${NC}"
fi

echo -e "\n${YELLOW}Step 3: Installing Waybar configuration${NC}"
read -p "Install Waybar config? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    backup_config "$CONFIG_DIR/waybar"
    mkdir -p "$CONFIG_DIR/waybar"
    cp -r "$DOTFILES_DIR/waybar/"* "$CONFIG_DIR/waybar/"
    echo -e "${GREEN}Waybar configuration installed!${NC}"
fi

echo -e "\n${YELLOW}Step 4: Installing SwayNC configuration${NC}"
read -p "Install SwayNC config? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    backup_config "$CONFIG_DIR/swaync"
    mkdir -p "$CONFIG_DIR/swaync"
    cp -r "$DOTFILES_DIR/swaync/"* "$CONFIG_DIR/swaync/"
    echo -e "${GREEN}SwayNC configuration installed!${NC}"
fi

echo -e "\n${YELLOW}Step 5: Installing Rofi configuration${NC}"
read -p "Install Rofi config? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    backup_config "$CONFIG_DIR/rofi"
    mkdir -p "$CONFIG_DIR/rofi"
    cp -r "$DOTFILES_DIR/rofi/"* "$CONFIG_DIR/rofi/"
    echo -e "${GREEN}Rofi configuration installed!${NC}"
fi

echo -e "\n${GREEN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Installation complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"

if [ -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}Backups saved to: $BACKUP_DIR${NC}"
fi

echo -e "\n${BLUE}Next steps:${NC}"
echo "1. Run 'sudo nixos-rebuild switch' to apply NixOS changes"
echo "2. Log out and log back in to apply Hyprland changes"
echo "3. Restart waybar and swaync for immediate effect:"
echo "   pkill waybar; waybar &"
echo "   pkill swaync; swaync &"
echo ""
