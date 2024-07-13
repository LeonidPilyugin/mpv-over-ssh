# mpv-over-ssh
Execute mpv on local machine with files on remote from SSH session

# Problem
When using Linux virtual console and connected to remote machine you cannot use mpv, because it is impossible to forward framebuffer device.

# Solution
This repo provides two scripts: `ms.sh` and `ow.sh`. `ms.sh` wraps SSH session and creates a channel to pass files and show them in mpv. `ow.sh` is used on remote machine to select file to show.

# Installation
To install, execute
```
git clone https://github.com/LeonidPilyugin/mpv-over-ssh
bash install.sh
```

To uninstall
```
bash uninstall.sh
```

You need to install scripts both on SSH server and client machines.

Maybe you'll need to add `~/.local/bin` to your `PATH` variable.

# Usage
Execute `ms.sh` instead of `ssh`. SSH config should be configured to connect by remote machine alias:
```
ms.sh remote_machine
```

> [!IMPORTANT]
> This script should be executed in Linux virtual console (TTY), not in terminal emulator! Also there should be mpv installed and framebuffer enabled

To show image in mpv, inside `ms.sh` session
```
ow.sh path/to/image/or/video/file
```
This will copy file via scp and show it in mpv.

To close mpv, press `q` button on keyboard.

# Settings
Settings are stored in `~/.local/share/mpv-over-ssh/settings.sh`
