#!/bin/bash
# tmux-split-in-cwd - open a new shell with same cwd as calling pane

SIP=$(tmux display-message -p "#S:#I:#P")
PTY=$(tmux server-info |
        egrep flags=\|bytes |
        awk '/windows/ { s = $2 }
             /references/ { i = $1 }
             /bytes/ { print s i $1 $2 } ' |
        grep "$SIP" |
        cut -d: -f4)
PTS=${PTY#/dev/}
PIDs=$(ps -eao pid,tty | tac | awk '$2 == "'$PTS'" {print $1}')
for i in $PIDs
do
	DIR=$(readlink /proc/$i/cwd)
	[ -n "$DIR" ] && break
done

case "$1" in
  h) tmux splitw -h "cd '$DIR'; $SHELL"
     ;;
  v) tmux splitw -v "cd '$DIR'; $SHELL"
     ;;
  *) tmux neww "cd '$DIR'; $SHELL"
     ;;
esac
