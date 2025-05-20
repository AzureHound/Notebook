# Carapace
source ~/.cache/carapace/init.nu

# Theme
source ~/.config/nushell/themes/catppuccin_macchiato.nu

# starship
# mkdir ($nu.data-dir | path join "vendor/autoload")
# starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# alias
alias la = ls -a
alias ll = ls -l
