#!/usr/bin/bash

#kitty -o initial_window_width=1300 -o initial_window_height=100 cava & disown 
hyprctl dispatch moveactive 0 325 && hyprctl dispatch pin && cava
