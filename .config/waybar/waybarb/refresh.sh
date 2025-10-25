#!/bin/bash

# Check if waybar is running
if pgrep -x "waybar" > /dev/null; then
    # If running, kill the waybar process
    pkill -x "waybar"
    echo "Waybar stopped."
else
    # If not running, start waybar
    waybar &
    echo "Waybar started."
fi

