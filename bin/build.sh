#!/usr/bin/env bash
set -eu

Main() {
  rm -rf build dist
  mkdir -p build/{mac,windows} dist
  cd build
  for file in ../src/*.png; do
    local name="$(basename "${file%%.png}")"
    printf "  %-30s [" "$name"
    for size in 16 32 48 64 128 256; do
      echo -n "."
      convert "$file" -scale "$size" "icon_${size}x${size}.png"
      mkdir -p "png/$size"
      cp "icon_${size}x${size}.png" "png/${size}/${name}.png"
    done
    echo -n "."
    convert *.png icon.ico
    mv icon.ico "windows/$name.ico"
    echo -n "."
    mkdir icon.iconset
    mv *.png icon.iconset
    iconutil --convert icns -o "mac/$name.icns" icon.iconset
    rm -rf icon.iconset *.png
    echo "]"
  done
  local date="$(date -u "+%Y-%m-%d %H:%M:%S UTC")"
  local year="$(date "+%Y")"
  cp ../LICENSE.txt .
  cat ../src/README-template.txt \
    | sed "s/{year}/$year/g" \
    | sed "s/{date}/$date/g" \
    > README.txt
  echo
  zip -r pixel-folders.zip *
  mv * ../dist
  echo
  cd ..
  rm -rf build
}

Main
