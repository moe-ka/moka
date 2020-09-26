#!/bin/sh
BI="moka.bin"
ISO="moka.iso"

if tmux has-session -t vm 2>/dev/null; then
	echo "vm session already running"
	exit 1
fi

make iso
export DISPLAY="`hostname`:0.0"
EMU_CMD="qemu-system-i386 -s -S -cdrom $ISO"
GDB_CMD="gdb $BI"

tmux start-server
tmux new-session -d -s vm
tmux set-option -g history-limit 10000
tmux new-window -n emu -t vm:2 "$EMU_CMD"
tmux new-window -n gdb -t vm:3 "$GDB_CMD"
tmux select-window -t vm:gdb
tmux set-window-option -g monitor-activity on
exec tmux attach -t vm
