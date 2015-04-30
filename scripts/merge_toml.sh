#!/bin/sh

for f in ../content/**/*.md; do
  echo "[$(basename "${f}" '.md')]"
  sed -n -e '1,/^+++/p' "${f}" | sed -e 's/+++//'
done
