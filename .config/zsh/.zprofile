# XDG Directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"
export PATH="$HOME/.atuin/bin:$PATH"

# Respect XDG Specification
export CONAN_USER_HOME="$XDG_CONFIG_HOME"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export RIPGREP_CONFIG_PATH="$HOME/.config/rg/.ripgreprc"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export FFMPEG_DATADIR="$XDG_CONFIG_HOME/ffmpeg"
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export WINEPREFIX="$XDG_DATA_HOME/wine"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export W3M_DIR="$XDG_DATA_HOME/w3m"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"

# Path
export PATH="$XDG_BIN_HOME:$XDG_BIN_HOME/color-scripts:$GOPATH/bin:$CARGO_HOME/bin:$XDG_SCRIPT_HOME:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/lib/rustup/bin:/usr/lib/go/bin:$HOME/.dotnet/tools:$XDG_DATA_HOME/nvim:$XDG_DATA_HOME/nvim/mason/bin:$XDG_DATA_HOME/npm/bin:$HOME/.yarn/bin:$XDG_DATA_HOME/pnpm:$PATH"

# History
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"
export SUDO_EDITOR="vim"

# Tools
export BROWSER="firefox"
export LS_COLORS="$(vivid generate catppuccin-macchiato)"

# GPG/LANG
export GPG_TTY="$(tty)"

# FZF
export FZF_DEFAULT_COMMAND="fd"
export fzf_fd_opts="--hidden --color=always"
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --preview '{$fzf_preview_dir_cmd} {2}'"
export fzf_preview_dir_cmd="eza --long --header --icons --all --color=always --group-directories-first --hyperlink"
export FZF_DEFAULT_OPTS="--height=90% --layout=reverse --info=inline --border rounded --pointer='' --margin=1 --padding=1 \
--color=bg+:-1,gutter:-1,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--bind 'ctrl-u:preview-half-page-up' \
--bind 'ctrl-d:preview-half-page-down' \
--bind 'ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)' \
--multi"

# MANPATH
export MANPATH="/usr/share/man:/usr/local/man:/usr/local/share/man"

# NPM
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# PERL
PATH="/home/eyes/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/eyes/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/eyes/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/eyes/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/eyes/perl5"; export PERL_MM_OPT;
export PERL5LIB=/home/eyes/perl5/lib/perl5:$PERL5LIB

# Pipx
eval "$(register-python-argcomplete pipx)"
