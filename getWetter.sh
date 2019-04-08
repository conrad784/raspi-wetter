#!/bin/bash

if [ -z "$1" ]; then
    CITY="Heideberg"
else
    CITY=$1
fi

echo "Getting info for $CITY"
wget -q -O /tmp/pic.png wttr.in/$CITY.png
