#!/bin/bash

# bash
cat >> ~/.bash_aliases <<EOF
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias watch-nvidia-smi='watch -n 1 -d -t nvidia-smi'
EOF

# screen
cat >> ~/.screenrc <<EOF
# Prefix Key
escape ^Jj

# set scrollback
defscrollback 1000

# Delete start up screen
startup_message off

# alternate screen
altscreen on

# Enable mouse scroll
termcapinfo xterm* ti@:te@
EOF

# emacs
mkdir -p ~/.emacs.d
cat >> ~/.emacs.d/init.el <<EOF
(setq inhibit-startup-message t)
(setq initial-scratch-message "")

(menu-bar-mode -1)
(tool-bar-mode 0)
EOF
