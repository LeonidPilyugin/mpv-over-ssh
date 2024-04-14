#!/bin/bash

# Load settings
source ~/.local/share/mpv-over-ssh/settings.sh

# Pass new filename to FIFO
echo $(realpath $1) > $FIFO_PATH
