#!/usr/bin/env bash
# Thanks https://github.com/JaKooLit ! #
# Script for waybar layout or configs

set -euo pipefail
IFS=$'\n\t'

# Define directories
waybar_themes="$HOME/.config/waybar/themes"
waybar_config="$HOME/.config/waybar/config"

waybar_colors="$HOME/.config/waybar/colors"
waybar_style="$HOME/.config/waybar/style.css"

rofi_config="$HOME/.config/hypr/assets/themes/items_list.rasi"
#rofi_config="$HOME/.config/rofi/themes/waybar-layout.rasi"

# Function to display menu options
layouts() {
    options=()
    while IFS= read -r file; do
        options+=("$(basename "$file")")
    done < <(find "$waybar_themes" -maxdepth 1 -type f -exec basename {} \; | sort)

    printf '%s\n' "${options[@]}"
}

# Function to display menu options
colors() {
    options=()
    while IFS= read -r file; do
        if [ -f "$waybar_colors/$file" ]; then
            options+=("$(basename "$file" .css)")
        fi
    done < <(find "$waybar_colors" -maxdepth 1 -type f -name '*.css' -exec basename {} \; | sort)
    
    printf '%s\n' "${options[@]}"
}

# Apply selected configuration
apply_config() {
    ln -s -f "$waybar_themes/$1" "$waybar_config"
    echo "$waybar_themes/$1" "$waybar_config"
    restart_waybar_if_needed
}

# Apply selected style
apply_style() {
    ln -sf "$waybar_colors/$1.css" "$waybar_style"
    echo "$waybar_colors/$1.css" "$waybar_style"
    restart_waybar_if_needed
}

# Restart Waybar
restart_waybar_if_needed() {
    if pgrep -x "waybar" >/dev/null; then
        pkill waybar
        sleep 0.1  # Delay for Waybar to completely terminate
    fi
    waybar > /dev/null 2>&1 &
    # ./refresh.sh &
}

# Main function
layout_chooser() {
    choice=$(layouts | rofi -dmenu -theme-str 'entry {placeholder: "Select a Waybar Layout";}' -config "$rofi_config")

    if [[ -z "$choice" ]]; then
        echo "No option selected. Exiting."
        exit 0
    fi

    case $choice in
        "no panel")
            pgrep -x "waybar" && pkill waybar || true
            ;;
        *)
            apply_config "$choice"
            ;;
    esac
}

colors_chooser() {
    choice=$(colors | rofi -dmenu -theme-str 'entry {placeholder: "Select a Waybar Style";}' -config "$rofi_config")

    if [[ -z "$choice" ]]; then
        echo "No option selected. Exiting."
        exit 0
    fi

    apply_style "$choice"
}

main() {
    case $1 in
        "--layout")
            layout_chooser
        ;;
        "--colors")
            colors_chooser
        ;;
        *)
            echo "Invalid option. Exiting."
            exit 1
        ;;
    esac
}

# Kill Rofi if already running before execution
# if pgrep -x "rofi" >/dev/null; then
#     pkill rofi
#     exit 0
# fi

main $@
