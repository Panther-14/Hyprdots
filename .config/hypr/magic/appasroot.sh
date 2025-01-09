#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Run Applications as Root
## Modified Panther-14 (Github)

DIR="$HOME/.config/hypr"
RASI="$DIR/assets/themes/applets.rasi"

iDIR="$HOME/.config/hypr/assets/icons"

# Theme Elements
prompt='Applications'
mesg='Run Applications as Root'

list_col='5'
list_row='1'
win_width='670px'

# Options
option_1=""
option_2=""
option_3=""
option_4=""
option_5=""

# Rofi CMD
rofi_cmd() {
    rofi -theme-str "window {width: $win_width;}" \
    -theme-str "listview {columns: $list_col; lines: $list_row;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -theme ${RASI}
}

# Pass variables to rofi dmenu
run_rofi() {
    echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}

# Execute Command
run_cmd() {
    
    polkit_cmd="pkexec env WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
    
    # Actions
    chosen="$(run_rofi)"
    case ${chosen} in
        $option_1)
            ${polkit_cmd} kitty
        ;;
        $option_2)
            ${polkit_cmd} dbus-run-session nemo
        ;;
        $option_3)
            ${polkit_cmd} geany
        ;;
        $option_4)
            ${polkit_cmd} kitty -e ranger
        ;;
        $option_5)
            ${polkit_cmd} kitty -e nvim
        ;;
    esac
}

run_cmd

exit 0