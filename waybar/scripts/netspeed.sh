#!/bin/bash

# Get the active interface
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)

if [ -z "$INTERFACE" ]; then
    echo "No Net"
    exit 0
fi

# File to store previous values
CACHE_FILE="/tmp/netspeed_$INTERFACE"

# Get current bytes
RX=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes 2>/dev/null || echo 0)
TX=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes 2>/dev/null || echo 0)

# Read previous values
if [ -f "$CACHE_FILE" ]; then
    read PREV_RX PREV_TX < "$CACHE_FILE"
else
    PREV_RX=$RX
    PREV_TX=$TX
fi

# Save current values
echo "$RX $TX" > "$CACHE_FILE"

# Calculate speed (bytes per second, assuming 2 second interval)
RX_SPEED=$(( (RX - PREV_RX) / 2 ))
TX_SPEED=$(( (TX - PREV_TX) / 2 ))

# Handle negative values (interface reset)
[ $RX_SPEED -lt 0 ] && RX_SPEED=0
[ $TX_SPEED -lt 0 ] && TX_SPEED=0

# Format function
format_speed() {
    local speed=$1
    if [ $speed -gt 1048576 ]; then
        printf "%.1fM" $(echo "scale=1; $speed/1048576" | bc)
    elif [ $speed -gt 1024 ]; then
        printf "%.0fK" $(echo "scale=0; $speed/1024" | bc)
    else
        printf "%dB" $speed
    fi
}

DOWN=$(format_speed $RX_SPEED)
UP=$(format_speed $TX_SPEED)

echo "↓${DOWN} ↑${UP}"
