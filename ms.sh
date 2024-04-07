#!/bin/bash

source ~/.local/share/mpv-over-ssh/settings.sh

handler () {
    while true; do
        if read line; then
            scp "$1:$line" $3
            bash -c "$COMMAND $3" &
        fi
        sleep 0.5
    done
}

prepare () {
    if [ ! -f $(dirname $3) ]; then
        mkdir -p $(dirname $3)
    fi
    ssh $1 "[ ! -e $2 ] && mkfifo $2"
    if [[ ! -e $2 ]]; then
        mkfifo $2
    fi
}

finish () {
    ssh $1 "rm $2"
    rm -rf $(dirname $3)
    rm $2
}

HOST_NAME=$1

prepare $HOST_NAME $FIFO_PATH $LOCAL_FILE

ssh $HOST_NAME "tail -f $FIFO_PATH" > $FIFO_PATH &
SSH_PID=$!

handler $HOST_NAME $FIFO_PATH $LOCAL_FILE < $FIFO_PATH &
HANDLER_PID=$!

ssh $@
kill $SSH_PID $HANDLER_PID
finish $HOST_NAME $FIFO_PATH $LOCAL_FILE $COMMAND
