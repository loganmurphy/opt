#!/bin/bash

DATA_ROOT="data"
LABELED_DATA="model/data"

total=`ls $DATA_ROOT | wc -l | tr -d ' '`
cnt=0
start_cnt=805

for f in $DATA_ROOT/*.txt; do 
    if [[ $cnt -lt $start_cnt ]]; then
        echo "Skipping $cnt < $start_cnt..."
        cnt=$((cnt+1))
        continue
    fi

    echo "Processing $cnt/$total..."
    echo "---------------------"
    cat $f
    echo "---------------------"
    echo "Label? [Y/N]: "
    read user_label

    if [[ "$user_label" == "Y" || "$user_label" == "y" ]]; then
        label=Y
    elif [[ "$user_label" == "N" || "$user_label" == "n" ]]; then
        label=N
    else
        echo "Unrecognized option. SKIPPING."
        label=Z
    fi

    # First clear, then post the status
    clear

    if [[ "$label" != "Z" ]]; then
        echo "OKAY. Copying as $label label."
        tail -n +2 $f > "$LABELED_DATA/$cnt-$label.txt"
    fi
    cnt=$((cnt+1))
done
