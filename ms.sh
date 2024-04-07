#!/bin/bash

source ~/.local/share/mpv-over-ssh/msettings.sh

handler () {
    while true; do
        if read line; then
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
    mkdir -p $(basename $3)
    ssh $1 "mkfifo $2"
}

finish () {
    ssh $1 "rm -rf $(basename $2)"
    rm -rf $(basename $3)
}

run () {
    ssh $1 "tail -f $2" | handler $@
}


HOST_NAME=$0

prepare $HOST_NAME $FIFO_PATH $LOCAL_FILE
run $HOST_NAME $FIFO_PATH $LOCAL_FILE $COMMAND &
ssh $@
finish $HOST_NAME $FIFO_PATH $LOCAL_FILE $COMMAND 
