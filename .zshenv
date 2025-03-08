#!/bin/zsh
export XDG_CONFIG_HOME="$HOME/.config"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# Source .zshenv
. $ZDOTDIR/.zshenv 2>/dev/null
# [[ -r $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv
