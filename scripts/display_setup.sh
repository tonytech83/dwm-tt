#!/bin/bash

INTERNAL_DISPLAY="eDP-1"
EXTERNAL_DISPLAY="HDMI-1"

if xrandr | grep "$EXTERNAL_DISPLAY connected"; then
    # If external monitor is connected, use it as the primary display with 75Hz refresh rate
    xrandr --output $INTERNAL_DISPLAY --off --output $EXTERNAL_DISPLAY --mode 3440x1440 --rate 75 --primary
else
    # If external monitor is not connected, use the internal display
    xrandr --output $INTERNAL_DISPLAY --auto --primary --output $EXTERNAL_DISPLAY --off
fi