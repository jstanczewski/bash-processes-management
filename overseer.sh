#!/bin/bash

function start_cranes {
    while [ "$(ls -A dir1 | wc -l)" -gt 0 ]; do
        # start crane1.sh in the background
        ./crane1.sh &
        # capture PID of crane1
        crane1_PID=$!
        echo "Crane 1 started by overseer"
        # start crane2.sh in the background
        ./crane2.sh &
        # capture PID of crane2
        crane2_PID=$!
        # wait for crane1 to finish its job
        echo "Waiting for crane 1 to finish"
        wait $crane1_PID
        # show the number of files it moved (exit code of crane1)
        echo "Files moved by crane 1: $?"
        # send USR2 signal to start crane2
        kill -s USR2 $crane2_PID
        echo "Crane 2 started by overseer"
        # wait for crane2 to finish
        echo "Waiting for crane 2 to finish"
        wait $crane2_PID
        # show the number of files it moved (exit code of crane2)
        echo "Files moved by crane 2: $?"
    done
}

function stop_cranes {
    echo "Cranes stopped"
    kill -INT $$
}

# if USR1 is captured - start the process
trap start_cranes USR1
# if SIGINT is captured - stop the process
trap stop_cranes SIGINT

while true; do
    sleep 5
done

exit 0