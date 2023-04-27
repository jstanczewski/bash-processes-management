#!/bin/bash

files_moved=0
files_in_dir1=$(ls -A dir1)

for file in $files_in_dir1; do
    # check if buffer isn't full
    if [ "$(ls -A buffer | wc -l)" -lt 3 ]; then
        # move the materials to the buffer
        mv -v "dir1/$file" buffer/
        ((files_moved++))
    else
        echo "Crane 1: buffer full"
        break
    fi
    sleep 1
done

echo "Crane 1: job done, it moved: $files_moved files"

exit $files_moved

