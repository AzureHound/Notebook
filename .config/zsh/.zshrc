# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Themes
source $XDG_CONFIG_HOME/zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh

# Plugins
zinit light Aloxaf/fzf-tab
zinit light loiccoyle/zsh-github-copilot
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
# zinit ice depth=1
# zinit light djui/alias-tips
# zinit light jeffreytse/zsh-vi-mode

# Snippets
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit snippet OMZP::direnv
zinit snippet OMZP::man
zinit snippet OMZP::node
zinit snippet OMZP::python
zinit snippet OMZP::sudo
zinit snippet OMZP::uv

# Load completions
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -Uz compinit && compinit
zinit cdreplay -q

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
# zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-flags  '--pointer='\
                          '--color=bg+:-1,gutter:-1,spinner:#f4dbd6,hl:#ed8796' \
                          '--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6' \
                          '--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796' \
                          '--color=selected-bg:#494d64'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -a -1 --show-symlinks --git-ignore --icons --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -a -1 --show-symlinks --git-ignore --icons --color=always $realpath'

# History
HISTFILE=$XDG_CACHE_HOME/zsh/zsh_history
SAVEHIST=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase

# Options
setopt autocd
setopt appendhistory
setopt correct
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_expire_dups_first
setopt hist_verify
setopt no_case_glob no_case_match
setopt globdots
setopt extended_glob
unsetopt prompt_sp

# Filter ZSH Error History
zshaddhistory() {
  local j=1
  while ([[ ${${(z)1}[$j]} == *=* ]]) {
    ((j++))
  }
  whence ${${(z)1}[$j]} >| /dev/null || return 1
}

# I-beam cursor
echo -ne "\e[5 q"

# Exiting vim/neovim cursor
function vim() {
  command vim "$@"
  echo -ne '\e[5 q'
}

function nvim() {
  command nvim "$@"
  echo -ne '\e[5 q'
}

# Init
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/pk10k.json)"
eval "$(atuin init zsh)"
eval "$(tv init zsh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(register-python-argcomplete pipx)"

# FZF
source <(fzf --zsh)

# Color Scripts
# pokemon-colorscripts --no-title -r 1,3,6

# Keybindings
bindkey -e
bindkey '^[|' zsh_gh_copilot_explain
bindkey '^[\' zsh_gh_copilot_suggest
bindkey '^[[B' history-search-forward
bindkey '^[[A' history-search-backward
bindkey '^[w' kill-region

# Man
export MANPAGER="vim -M +MANPAGER -"
# export MANPAGER='nvim +Man!'

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
