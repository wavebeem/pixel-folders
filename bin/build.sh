#!/usr/bin/env bash
set -eu

:main() {
  rm -rf build dist
  mkdir -p build/{mac,windows} dist
  cd build
  for file in ../src/*.png; do
    local name date year
    name="$(basename "${file%%.png}")"
    printf "  %-30s [" "$name"
    for size in 16 32 48 64 128 256; do
      echo -n "."
      magick "$file" -scale "$size" -strip "icon_${size}x${size}.png"
      mkdir -p "png/$size"
      cp "icon_${size}x${size}.png" "png/${size}/${name}.png"
    done
    echo -n "."
    magick ./*.png -strip icon.ico
    mv icon.ico "windows/$name.ico"
    echo -n "."
    mkdir icon.iconset
    mv ./*.png icon.iconset
    iconutil --convert icns -o "mac/$name.icns" icon.iconset
    rm -rf icon.iconset ./*.png
    echo "]"
  done
  date="$(date -u "+%Y-%m-%d %H:%M:%S UTC")"
  year="$(date "+%Y")"
  cp ../LICENSE.txt .
  sed \
    -e "s/{YEAR}/$year/g" \
    -e "s/{DATE}/$date/g" \
    ../src/README-template.txt \
    > README.txt
  echo
  zip -r pixel-folders.zip ./*
  mv ./* ../dist
  echo
  cd ..
  rm -rf build
}

:main
