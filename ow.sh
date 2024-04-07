#!/bin/bash

source ~/.local/share/mpv-over-ssh/settings.sh

echo $(realpath $1) > $FIFO_PATH
