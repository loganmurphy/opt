#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "Usage: ./script.sh <INDEX> <LABEL=Y/N>"
    exit 1
fi

index=$1
label=$2

DATA_ROOT="data"
LABELED_DATA="model/data"

tail -n +2 "$DATA_ROOT/$index.txt" > "$LABELED_DATA/$index-$label.txt"
