#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: ./script.sh <LINKS_FILE>"
    exit 1;
fi

DATA_ROOT="data"
LINKS_FILE="$1"

cnt=0
total=`cat "$LINKS_FILE" | wc -l | tr -d ' '`

while read link; do
    FILE_PATH=$DATA_ROOT/$cnt.txt

    if [[ ! -e $FILE_PATH ]]; then
        echo "Processing $cnt/$total link: $link..."
        phantomjs test.js "$link" | tee $FILE_PATH
    else
        echo "Skipping $FILE_PATH as it already exists..."
    fi
    cnt=$((cnt+1));
done < $LINKS_FILE
