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
    yay -Qeq >~/.config/pacman/pkgs.txt
    yay -Scc

    set_color yellow
    echo
    printf "Pacman "
    set_color green
    echo "󰮯 "
    echo
    set_color normal
    # sudo pacman -Syu
    deleteOrphans

    set_color yellow
    echo
    echo "Homebrew 🍺"
    echo
    set_color normal
    brew update
    brew upgrade
    brew autoremove
    brew bundle dump --force --file=~/.config/brew/Brewfile

    set_color yellow
    echo
    printf "Flatpak "
    set_color brcyan
    echo " "
    echo
    set_color normal
    flatpak update
    flatpak uninstall --unused
    flatpak list --columns=application >~/.config/flatpak/flatpaks.txt

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
    fish_update_completions

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
