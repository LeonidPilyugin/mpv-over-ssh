#!/bin/bash

source ~/.local/share/mpv-over-ssh/msettings.sh

echo $(realpath $1) > FIFO_PATH
read line
echo quit > FIFO_PATH
