#!/bin/bash

file_dir=/mnt/share/scanner
threshold=$((1*24*3600))

curr_timestamp=$(date +"%s")
for f in $file_dir/*; do
    created_timestamp=$(stat -c %W $f)
    delta=$(($curr_timestamp-$created_timestamp))
    if [ $delta -gt $threshold ]; then
        rm $f
    fi
done
