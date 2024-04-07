#!/bin/bash

# Load settings
source ~/.local/share/mpv-over-ssh/settings.sh

handler () {
    while true; do
        # Read new line
        if read line; then
            # Copy new file
            scp "$1:$line" $3
            # Start mpv
            bash -c "$COMMAND $3" &
        fi
        # Wait a bit to prevent from using CPU too much
        sleep 0.5
    done
}

prepare () {
    # Create temp directory where image/video is saved
    if [ ! -f $(dirname $3) ]; then
        mkdir -p $(dirname $3)
    fi

    # Create remote FIFO
    ssh $1 "[ ! -e $2 ] && mkfifo $2"

    # Create local FIFO
    if [[ ! -e $2 ]]; then
        mkfifo $2
    fi
}

finish () {
    # Delete remote FIFO
    ssh $1 "rm $2"
    # Remove temp directory
    rm -rf $(dirname $3)
    # Delete local FIFO
    rm $2
}

# Store remote SSH hostname
HOST_NAME=$1

# Create FIFOs and temp directory
prepare $HOST_NAME $FIFO_PATH $LOCAL_FILE

# Start reading remote FIFO and redirecting its output to local FIFO
ssh $HOST_NAME "tail -f $FIFO_PATH" > $FIFO_PATH &
SSH_PID=$!

# Start reading local FIFO and processing its output
handler $HOST_NAME $FIFO_PATH $LOCAL_FILE < $FIFO_PATH &
HANDLER_PID=$!

# Start SSH session
ssh $@

# Kill FIFO readers
kill $SSH_PID $HANDLER_PID

# Remove FIFOs and temp directory
finish $HOST_NAME $FIFO_PATH $LOCAL_FILE $COMMAND
