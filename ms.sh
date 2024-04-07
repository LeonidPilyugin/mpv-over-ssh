#!/bin/bash

source ~/.local/share/mpv-over-ssh/settings.sh

handler () {
    while true; do
        if read line; then
            echo got line $line
            if [ line == "quit" ]; then
                pkill mpv
            else
                scp "$1:$line" $3
                bash "$4 $3" &
            fi
        fi
    done
}

prepare () {
    mkdir -p $(dirname $3)
    ssh $1 "rm $2; mkfifo $2"
}

finish () {
    ssh $1 "rm $2"
    rm -rf $(dirname $3)
    kill $5
}

run () {
    ssh $1 "tail -f $2" | handler $@
}


HOST_NAME=$1

prepare $HOST_NAME $FIFO_PATH $LOCAL_FILE
run $HOST_NAME $FIFO_PATH $LOCAL_FILE $COMMAND &
RUN_PID=$!
ssh $@
finish $HOST_NAME $FIFO_PATH $LOCAL_FILE $COMMAND $RUN_PID
