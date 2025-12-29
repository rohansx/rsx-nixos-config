#!/usr/bin/env bash

# Caffeine script for Waybar
# Prevents system from sleeping/screen dimming when active

CAFFEINE_FILE="/tmp/caffeine_mode"

toggle() {
    if [ -f "$CAFFEINE_FILE" ]; then
        # Disable caffeine
        rm "$CAFFEINE_FILE"
        # Kill any running systemd-inhibit processes we started
        pkill -f "systemd-inhibit.*caffeine" 2>/dev/null
        notify-send "Caffeine" "Disabled - System can sleep now" -i caffeine-cup-empty
    else
        # Enable caffeine
        touch "$CAFFEINE_FILE"
        # Use systemd-inhibit to prevent sleep
        systemd-inhibit --what=idle:sleep:handle-lid-switch \
            --who="Caffeine" \
            --why="User requested to keep system awake" \
            --mode=block \
            sleep infinity &
        notify-send "Caffeine" "Enabled - System will stay awake" -i caffeine-cup-full
    fi
}

status() {
    if [ -f "$CAFFEINE_FILE" ]; then
        echo "󰅶"  # Caffeine ON (cup full)
    else
        echo "󰛊"  # Caffeine OFF (cup empty/sleep)
    fi
}

case "$1" in
    toggle)
        toggle
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: $0 {toggle|status}"
        exit 1
        ;;
esac
