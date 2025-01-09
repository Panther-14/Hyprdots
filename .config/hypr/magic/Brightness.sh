#!/bin/bash

DIR="$HOME/.config/hypr"
RASI="$DIR/assets/themes/applets.rasi"

iDIR="$HOME/.config/hypr/assets/icons"

# Brightness Info
backlight="$(printf "%.0f\n" `echo $(brightnessctl -m | cut -d, -f4) | awk -F '%' '{print $1}'`)"
card="`brightnessctl -m | cut -d, -f1`"

if [[ $backlight -ge 0 ]] && [[ $backlight -le 29 ]]; then
    level="Low"
elif [[ $backlight -ge 30 ]] && [[ $backlight -le 49 ]]; then
    level="Optimal"
elif [[ $backlight -ge 50 ]] && [[ $backlight -le 69 ]]; then
    level="High"
elif [[ $backlight -ge 70 ]] && [[ $backlight -le 100 ]]; then
    level="Peak"
fi
# Theme Elements
prompt="${backlight}%"
mesg="Device: $card, Level: $level"

option_1=""
option_2=""
option_3=""
option_4=""

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "window {width: 550px;}" \
		-theme-str "listview {columns: 4; lines: 1;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${RASI}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Get brightness
get_backlight() {
	echo $(brightnessctl -m | cut -d, -f4)
}

# Get icons
get_icon() {
	current=$(get_backlight | sed 's/%//')
	if   [ "$current" -le "20" ]; then
		icon="$iDIR/brightness-20.png"
	elif [ "$current" -le "40" ]; then
		icon="$iDIR/brightness-40.png"
	elif [ "$current" -le "60" ]; then
		icon="$iDIR/brightness-60.png"
	elif [ "$current" -le "80" ]; then
		icon="$iDIR/brightness-80.png"
	else
		icon="$iDIR/brightness-100.png"
	fi
}

# Notify
notify_user() {
	notify-send -e -h string:x-canonical-private-synchronous:sys-notify-brightness -h int:value:$current -u low -i "$icon" "Brightness : $current%" --app-name="Brightness"
}

# Change brightness
change_backlight() {
	brightnessctl set "$1" && get_icon && notify_user
}

# Execute Command
run_cmd() {
	# Actions
	chosen="$(run_rofi)"
	case ${chosen} in
		$option_1)
			change_backlight "+25%"
		;;
		$option_2)
			change_backlight "60%"
		;;
		$option_3)
			change_backlight "25%-"
		;;
		$option_4)
			change_backlight "30%"
		;;
	esac
}

# Execute accordingly
case "$1" in
	--increase|-I)
		change_backlight "+5%"
	;;
	--decrease|-D)
		change_backlight "5%-"
	;;
	--get)
		get_backlight
	;;
	--rofi|*) run_cmd
	;;
esac

exit 0