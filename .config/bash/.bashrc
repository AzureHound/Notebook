#!/usr/bin/env bash
BASH_HOME=~/.config/bash

# Source
source $BASH_HOME/.bash_aliases

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
PS1='\[\e[0;36m\]\u\[\e[0;37m\]@\[\e[0;34m\]\h\[\e[0;33m\] \w\[\e[0m\]$(if git rev-parse --is-inside-work-tree &>/dev/null; then echo " \[\e[0;32m\] $(git branch 2>/dev/null | grep "\*" | sed "s/* //")"; fi) \[\e[0m\] '

# Starship
# eval "$(starship init bash)"

# I-beam cursor
echo -ne "\e[5 q"

# Graphics
export LIBVA_DRIVER_NAME=iHD

# Editor
export EDITOR=nvim
export VISUAL="$EDITOR"
export SUDO_EDITOR="vim"

# vivid
export LS_COLORS="$(vivid generate catppuccin-macchiato)"

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# NPM
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# Pipx
eval "$(register-python-argcomplete pipx)"
