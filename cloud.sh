#!/bin/bash
while read pair; do
    freq=`echo $pair | awk '{print $2}'`
    word=`echo $pair | awk '{print $1}'`

    cnt=0

    while [[ "$cnt" -le "$freq" ]]; do
        echo -n "$word "
        cnt=$((cnt+1))
    done
done
