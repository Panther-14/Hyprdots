#!/usr/bin/bash

folder="~/Descargas/YouTube"

download_audio(){
  yt-dlp -x \
  --audio-format mp3 \
  --add-metadata \
  --embed-metadata \
  --embed-thumbnail \
  --convert-thumbnails jpg \
  --parse-metadata "%(release_year,upload_date)s:%(meta_date)s" \
  --parse-metadata "%(album,title)s:%(meta_album)s" \
  -o $folder/'%(title)s by %(uploader)s.%(ext)s' \
  $1
}

download_video(){
  yt-dlp \
  -f bv+ba/b \
  --add-metadata \
  --embed-metadata \
  --embed-thumbnail \
  --convert-thumbnails jpg \
  --parse-metadata "%(release_year,upload_date)s:%(meta_date)s" \
  --parse-metadata "%(album,title)s:%(meta_album)s" \
  -o $folder/'%(title)s by %(uploader)s.%(ext)s' \
  $1
}

convert_file(){
  in=$(echo -e "$@")
  out=$in.mp4
  
  ffmpeg -i  "$(echo $in)" -codec copy "$(echo $out)"
}

help_command(){
  echo -e "No hay nada que hacer"
}

case "$1" in
  --audio|-a) download_audio $2
  ;;
  --video|-v) download_video $2
  ;;
  --convert|-c) convert_file $2
  ;;
  --help|-h) help_command
  ;;
  *) echo "No hay nada que hacer"
  ;;
esac

