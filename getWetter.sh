#!/bin/bash

if [ -z "$1" ]; then
    CITY="Heidelberg"
else
    CITY=$1
fi

echo "Getting info for $CITY"
wget -q -O /tmp/pic.png wttr.in/${CITY}_1nq.png
