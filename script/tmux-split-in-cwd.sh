#!/bin/bash
# $File: tmux-split-in-cwd.sh
# $Date: Tue Feb 25 20:43:13 2014 +0800
# $Author: jiakai <jia.kai66@gmail.com>

# tmux-split-in-cwd - open a new shell with same cwd as calling pane

PID=$(tmux  display-message -p '#{pane_pid}')
DIR=$(readlink /proc/$PID/cwd)

case "$1" in
  h) tmux splitw -h "cd '$DIR'; $SHELL"
     ;;
  v) tmux splitw -v "cd '$DIR'; $SHELL"
     ;;
  *) tmux neww "cd '$DIR'; $SHELL"
     ;;
esac

