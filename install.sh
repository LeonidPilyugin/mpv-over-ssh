#!/bin/bash

mkdir -p ~/.local/bin
mkdir -p ~/.local/share/mpv-over-ssh

install -m755 ms.sh ~/.local/bin/
install -m755 ow.sh ~/.local/bin/
install -m755 settings.sh ~/.local/share/mpv-over-ssh/
