#!/bin/sh

for f in *.heic; do
    FILENAME="${f%.heic}"
    echo $FILENAME

    tifig -v -p "$FILENAME.heic" "$FILENAME.jpg"

done


