#!/bin/bash

LOCKFILE=/tmp/cava.lock

if [ -f "$LOCKFILE" ]; then
  echo "Cava ya está en ejecución"
  exit 1
fi

touch "$LOCKFILE"

# Resto de tu script para ejecutar Cava en Kitty
kitty -o initial_window_width=1300 -o initial_window_height=100 -e ~/.config/hypr/magic/run_cava.sh

# Eliminar el lockfile al finalizar
rm "$LOCKFILE"
