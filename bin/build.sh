#!/usr/bin/env bash
set -eu

ReadMe() {
  cat <<EOF
Pixelated Folders
=================


Website
-------
https://github.com/wavebeem/pixel-folders


Build Date
----------
$date


See LICENSE.txt for license information.


Copyright $year Brian Mock
EOF
}

Main() {
  rm -rf build dist
  mkdir -p build/{mac,windows} dist
  cd build
  for file in ../src/*.png; do
    local name="$(basename "${file%%.png}")"
    printf "  %-30s" "$name"
    for size in 16 32 48 64 128 256; do
      echo -n "."
      convert "$file" -scale "$size" "icon_${size}x${size}.png"
    done
    echo -n "."
    convert *.png icon.ico
    mv icon.ico "windows/$name.ico"
    echo -n "."
    mkdir icon.iconset
    mv *.png icon.iconset
    iconutil --convert icns -o "mac/$name.icns" icon.iconset
    rm -rf icon.iconset *.png
    echo
  done
  local date="$(date -u "+%Y-%m-%d %H:%M:%S UTC")"
  local year="$(date "+%Y")"
  cp ../LICENSE.txt mac
  cp ../LICENSE.txt windows
  ReadMe | tee mac/README.txt windows/README.txt >/dev/null
  cd ../dist
  mv ../build/mac pixel-folders-mac
  mv ../build/windows pixel-folders-windows
  echo
  zip -r pixel-folders-mac.zip pixel-folders-mac
  echo
  zip -r pixel-folders-windows.zip pixel-folders-windows
  rm -rf pixel-folders-{mac,windows}
  cd ..
  rm -rf build
}

Main
