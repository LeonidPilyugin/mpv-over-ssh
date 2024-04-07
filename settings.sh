# MPV starting command
COMMAND="mpv --vo=drm --keep-open=yes"

# Path where viewed file is saved
# It is deleted on ms.sh exit
LOCAL_FILE="/tmp/mpv-over-ssh/current"

# FIFO file path
# FIFO file is created both on local and remote machines
# It is deleted on ms.sh exit
FIFO_PATH="$HOME/.local/share/mpv-over-ssh/queue"

