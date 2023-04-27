#!/bin/bash

sig=0
files_moved=0

function crane2 {
	files_in_buffer=$(ls -A buffer)
    # if buffer is not empty
    if [ $(ls -A buffer | wc -l) -gt 0 ]; then
        for file in $files_in_buffer; do
            mv -v "buffer/$file" dir2/
            ((files_moved++))
        done
    else
        break
    fi
    sleep 1
}

# if USR2 is received, assign sig=1
trap sig=1 USR2

while true; do
    # if sig == 1 and buffer isn't empty - start crane2
    if [ $sig -eq 1 ] && [ "$(ls -A buffer | wc -l)" -gt 0 ]; then
        crane2
    fi

    # if sig ==1 and buffer is empty - return number of files moved and finish
    if [ $sig -eq 1 ] && [ "$(ls -A buffer | wc -l)" -eq 0 ]; then
        echo "Crane 2 finished working, it moved: $files_moved files"
        exit $files_moved
    fi
done

exit $files_moved