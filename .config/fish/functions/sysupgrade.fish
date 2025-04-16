function sysupgrade
    set start_time (date +%s)

    set_color yellow
    echo
    printf "Yay "
    set_color blue
    echo "󰐱 "
    echo
    set_color normal
    yay -Syu

    set_color yellow
    echo
    printf "Pacman "
    set_color green
    echo "󰮯 "
    echo
    set_color normal
    sudo pacman -Syu
    # command sudo -S pacman -Syu

    set_color yellow
    echo
    echo "Homebrew 🍺"
    echo
    set_color normal
    brew update
    brew upgrade
    brew autoremove

    set_color yellow
    echo
    printf "Flatpak "
    set_color brcyan
    echo " "
    echo
    set_color normal
    flatpak update

    set_color yellow
    echo
    printf "Hyprland "
    set_color blue
    echo " "
    echo
    set_color normal
    hyprpm update

    set_color yellow
    echo
    echo "Fisher 🐠"
    echo
    set_color normal
    fisher update

    set_color yellow
    echo
    echo "Fisher Completions 🐠"
    echo
    set_color normal
    add fish_update_completions

    set_color yellow
    echo
    printf "Zinit "
    set_color green
    echo "󱐋 "
    echo
    set_color normal
    zsh -i -c 'zinit self-update && zinit update'

    set_color yellow
    echo
    echo "Yazi 📁"
    echo
    set_color normal
    ya pack -u

    set_color yellow
    echo
    printf "Yay pkgs ls"
    set_color blue
    echo "󰐱 "
    echo
    set_color normal
    yay -Qq >~/.config/pacman/aur-packages.txt

    set_color yellow
    echo
    printf "Pacman pkgs ls"
    set_color green
    echo "󰮯 "
    echo
    set_color normal
    pacman -Qq | grep -vFf ~/.config/pacman/aur-packages.txt | sort >~/.config/pacman/arch-packages.txt

    set_color yellow
    echo
    printf "Pkgs Man Cache "
    set_color red
    echo " "
    echo
    set_color normal
    yay -Scc

    set_color yellow
    echo
    echo "DeleteOrphans 🧽"
    echo
    set_color normal
    deleteOrphans 2>&1 | while read -l line
        if not string match -q "error: argument '-' specified with empty stdin" -- $line
            echo $line
        end
    end
    set_color green
    echo "Orphaned Dependencies Cleared  "
    set_color normal

    set_color yellow
    echo
    echo "Homebrew 🍺"
    echo
    set_color normal
    pushd ~/.config/brew >/dev/null
    brew bundle dump --force
    brew leaves >leaves.txt
    popd >/dev/null
    set_color green
    echo "Done  "
    set_color normal

    set end_time (date +%s)
    set duration (math $end_time - $start_time)
    set minutes (math --scale=0 "$duration / 60")
    set seconds (math "$duration % 60")

    set_color cyan
    echo
    echo "System Upgraded & Backed Up 👍"
    set_color red
    if test $minutes -eq 0
        echo "Took $seconds sec"
    else
        echo "Took $minutes min $seconds sec"
    end
end
