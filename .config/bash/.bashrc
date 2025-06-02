#!/usr/bin/env bash
BASH_HOME=~/.config/bash

# Source
source $BASH_HOME/.bash_aliases

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# Check & update window size values after each command.
shopt -s checkwinsize

# Prompt
PS1='\[\e[0;36m\]\u\[\e[0;37m\]@\[\e[0;34m\]\h\[\e[0;33m\] \w\[\e[0m\]$(if git rev-parse --is-inside-work-tree &>/dev/null; then echo " \[\e[0;32m\] $(git branch 2>/dev/null | grep "\*" | sed "s/* //")"; fi) \[\e[0m\] '

# I-beam cursor
echo -ne "\e[5 q"

# Graphics
export LIBVA_DRIVER_NAME=iHD

# Editor
export EDITOR=nvim
export VISUAL="$EDITOR"
export SUDO_EDITOR="vim"

# Init
eval "$(atuin init bash)"
eval "$(fzf --bash)"
# eval "$(starship init bash)"
eval "$(zoxide init --cmd cd bash)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# FZF
export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore"
export fzf_fd_opts="--hidden --color=always"
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS"
export FZF_DEFAULT_OPTS="--height=100% --info=right --border=rounded --pointer='' --marker='⇒' --margin=1 --padding=1 \
--color=bg+:-1,gutter:-1,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--bind='ctrl-u:preview-half-page-up' \
--bind='ctrl-d:preview-half-page-down' \
--bind='ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)' \
--multi --prompt='󰥨 Search: '"

# GCC
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Man
export MANPAGER="vim -M +MANPAGER -"
# export MANPAGER='nvim +Man!'

# NPM
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# Pipx
eval "$(register-python-argcomplete pipx)"

# UV
eval "$(uv generate-shell-completion bash)"

# Vivid
export LS_COLORS="$(vivid generate catppuccin-macchiato)"

# Yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
