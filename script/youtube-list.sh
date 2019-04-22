#!/bin/sh
format='%(title)s.%(ext)s'

/usr/local/bin/youtube-dl -j --flat-playlist $1 | jq -r '.url' | parallel -j 10 --progress youtube-dl -i -o \'$format\' --

