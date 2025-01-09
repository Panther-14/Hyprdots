#!/usr/bin/env bash

## Author  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Quick Links
## Modified Panther-14 (Github)

DIR="$HOME/.config/hypr"
RASI="$DIR/assets/themes/applets.rasi"

iDIR="$HOME/.config/hypr/assets/icons"
BROWSER="`xdg-settings get default-web-browser | awk -F '.' '{print $1}'`"
# Theme Elements
prompt='Quick Links'
mesg="Using '$BROWSER' as web browser"

list_col='6'
list_row='1'

efonts="Hack Mono Nerd Font 28"

# Options
option_1=""
option_2=""
option_3=""
option_4=""
option_5=""
option_6=""

# Rofi CMD
rofi_cmd() {
	rofi -theme-str "listview {columns: $list_col; lines: $list_row;}" \
		-theme-str 'textbox-prompt-colon {str: "";}' \
		-theme-str "element-text {font: \"$efonts\";}" \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		-markup-rows \
		-theme ${RASI}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6" | rofi_cmd
}

# Execute Command
run_cmd() {
	# Actions
	chosen="$(run_rofi)"
	case ${chosen} in
		$option_1)
			xdg-open 'https://www.google.com/'
		;;
		$option_2)
			xdg-open 'https://mail.google.com/'
		;;
		$option_3)
			xdg-open 'https://www.youtube.com/'
		;;
		$option_4)
			xdg-open 'https://www.github.com/'
		;;
		$option_5)
			xdg-open 'https://www.reddit.com/'
		;;
		$option_6)
			xdg-open 'https://www.twitter.com/'
		;;
	esac
}

run_cmd

exit 0