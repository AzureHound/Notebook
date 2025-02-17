source ~/.config/fish/user_variables.fish
source ~/.config/fish/abbreviations.fish

fish_config theme choose "Catppuccin Macchiato" # Catppuccin Macchiato, Dracula Official

# Fisher
if not type -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source 
end

set sponge_allow_previously_successful false #sponge fish plugin

# Starship Prompt
function starship_transient_prompt_func
  starship module character
end

function starship_transient_rprompt_func
  starship module time
end

atuin init fish | source

# backups
function backup --argument filename
    cp $filename $filename.bak
end

# bat
set -gx BAT_THEME "Catppuccin Macchiato" # base16-256, Catppuccin Macchiato, Dracula

# fish
set -g theme_nerd_fonts yes

# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
starship init fish | source
enable_transience

# yazi
function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# ollama
function ollama-serve
    ollama serve > /dev/null 2>&1 &
end

function ollama-kill
    pkill ollama
end

# zoxide
zoxide init --cmd cd fish | source

# aliasis
alias la='eza -a --icons'
alias ls='eza --icons'
alias ll='eza -a -l --icons'
alias tree='eza -a -T --git-ignore --icons'
alias lta4="eza -lTag --git-ignore --level=4 --icons"
alias histwipe="cliphist wipe"
alias private='fish -P'
alias rg='rg -i'

alias asciiquarium='asciiquarium -t'
alias bonsai='cbonsai --seed 119'
alias colors='~/.local/bin/colorscript -r'
alias clock='tty-clock -DScC6b'
alias emoji='~/.local/bin/emojifzf'
alias lofi='lowfi'
alias preview='kitten icat'
alias words='tt -theme ~/.tt/Catppuccin-Macchiato'
alias matrix="unimatrix -n -c yellow -s 90 -l 'o'"
alias weather='curl "v2.wttr.in/Agartala?F"'

alias branch='git branch --sort=-committerdate | fzf --header "Checkout Recent Branch" --preview "git diff --color=always {1} | delta" --pointer="" | xargs git checkout'
alias commits="~/.local/bin/commits"
alias glog='git log --oneline --graph --all'
alias gen='tgpt -i'
alias ssh="kitten ssh"
alias powertop='sudo powertop'
alias zed='zeditor'

# Keybinds
bind \ce 'emoji'
bind \cf 'fzf'
bind \ct 'tv'

set -g fish_greeting ""
