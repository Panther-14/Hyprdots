#!/bin/bash

PIDFILE=/tmp/cava.pid
CAVA_WINDOW_TITLE="cava"

execute_cava(){
  kitty --title "$CAVA_WINDOW_TITLE" -o initial_window_width=1300 -o initial_window_height=100 -e cava &
  echo $! > "$PIDFILE"
}

if [ -f "$PIDFILE" ]; then
  kill "$(cat $PIDFILE)" && rm -f "$PIDFILE"
else
  execute_cava
fi
