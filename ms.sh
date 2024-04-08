#!/bin/bash

# Load settings
source ~/.local/share/mpv-over-ssh/settings.sh

handler () {
    while true; do
        # Read new line
        if read line; then
            # Copy new file
            scp "$1:$line" $LOCAL_FILE
            # Start mpv
            bash -c "$COMMAND $LOCAL_FILE" &
        fi
        # Wait a bit to prevent from using CPU too much
        sleep 0.5
    done
}

prepare () {
    # Create temp directory where image/video is saved
    if [ ! -f $(dirname $LOCAL_FILE) ]; then
        mkdir -p $(dirname $LOCAL_FILE)
    fi

    # Create remote FIFO
    #ssh $1 "[ ! -e $2 ] && mkfifo $2"
    ssh $1 "if [[ ! -e \"~/$FIFO_PATH\" ]]; then mkfifo ~/$FIFO_PATH; fi"

    # Create local FIFO
    if [[ ! -e $HOME/$FIFO_PATH ]]; then
        mkfifo $HOME/$FIFO_PATH
    fi
}

finish () {
    # Delete remote FIFO
    ssh $1 "rm ~/$FIFO_PATH"
    # Remove temp directory
    rm -rf $(dirname $LOCAL_FILE)
    # Delete local FIFO
    rm $HOME/$FIFO_PATH
}

# Store remote SSH hostname
HOST_NAME=$1

# Create FIFOs and temp directory
prepare $HOST_NAME

# Start reading remote FIFO and redirecting its output to local FIFO
ssh $HOST_NAME "tail -f ~/$FIFO_PATH" > $HOME/$FIFO_PATH &
SSH_PID=$!

# Start reading local FIFO and processing its output
handler $HOST_NAME < $FIFO_PATH &
HANDLER_PID=$!

# Start SSH session
ssh $@

# Kill FIFO readers
kill $SSH_PID $HANDLER_PID

# Remove FIFOs and temp directory
finish $HOST_NAME
