#!/bin/bash

source ~/.local/share/mpv-over-ssh/settings.sh

handler () {
    while true; do
        if read line; then
            echo got line $line >> /tmp/log.log
            # if [ line == "quit" ]; then
            #     pkill mpv
            # else
            #     scp "$1:$line" $3
            #     bash "$4 $3" &
            # fi
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
echo "jobs: $(jobs -l)"

ssh $HOST_NAME "tail -f $FIFO_PATH" > $FIFO_PATH &
SSH_PID=$!

handler $HOST_NAME $FIFO_PATH $LOCAL_FILE $COMMAND < $FIFO_PATH &
HANDLER_PID=$!

echo "jobs: $(jobs -l)"
read
#ssh $@
kill $SSH_PID $HANDLER_PID
finish $HOST_NAME $FIFO_PATH $LOCAL_FILE $COMMAND
