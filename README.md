sudo pacman -Rns dolphin dunst htop nano vim wofi wget

mkdir Desktop Developer Documents Downloads Music Pictures Public Templates Videos

sudo pacman -Syu

sudo pacman -S --needed base-devel git
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

```javascript
yay -Scc
```

sudo vim /etc/pacman.conf
sudo vim /boot/loader/loader.conf

rm .bashrc
rm .bash_profile
mv .config .configbak
ln -s ~/Developer/repos/Notebook/.config ~/
ln -s ~/Developer/repos/Notebook/.icons ~/
ln -s ~/Developer/repos/Notebook/.themes ~/
ln -s ~/Developer/repos/Notebook/.tt ~/
ln -s ~/Developer/repos/Notebook/.bash_profile ~/
ln -s ~/Developer/repos/Notebook/.bashrc ~/
ln -s ~/Developer/repos/Notebook/.czrc ~/
ln -s ~/Developer/repos/Notebook/.face.icon ~/
ln -s ~/Developer/repos/Notebook/.gitmux.conf ~/
ln -s ~/Developer/repos/Notebook/.gtkrc-2.0 ~/
ln -s ~/Developer/repos/Notebook/.profile ~/
ln -s ~/Developer/repos/Notebook/.tmux.conf ~/
ln -s ~/Developer/repos/Notebook/.vimrc ~/
ln -s ~/Developer/repos/Notebook/.zshrc ~/

ln -s ~/Developer/repos/nvim ~/.config/
ln -s ~/Developer/repos/Notebook/.local/bin ~/.local/
ln -s ~/Developer/repos/Notebook/.local/share/fonts ~/.local/share/

sudo cp -r JosefinSans /usr/share/fonts/

yay -S ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono ttf-nerd-fonts-symbols-common ttf-font-awesome noto-fonts-cjk noto-fonts-emoji

fc-cache -fv

yay -S cmake cpio less llvm lua gcc fd jq meson python-pip reflector portal-bin

yay -S hypridle hyprlang hyprfreeze hyprlock hyprpicker hyprshot hyprutils hyprwayland-scanner pyprland xdg-desktop-portal-gtk xdg-desktop-portal-wlr qt5ct qt6ct kvantum-qt5

yay -S gnome-keyring polkit-gnome | libsecret

yay -S adb android-file-transfer android-tools ani-cli asciiquarium-transparent-git atuin bat bash-pipes bibata-cursor-theme-bin bluetui bluez brightnessctl btop cava cbonsai cliphist wl-clipboard cowsay ddcutil devify dipc duf eza fastfetch ffmpeg figlet fish flatpak fzf gtk-engine-murrine git-delta github-cli gvfs-smb gitmux tmux glow imagemagick keyb laptop-mode-tools lazygit lazynpm lolcat lowfi neovim nodejs npm nushell nvm oh-my-posh onefetch pacseek playerctl pokemon-colorscripts powertop reflector ripgrep ripgrep-all rofi-emoji rofi-games rofi-wayland speedtest-cli starship syncthing swaync swayosd-git swww television tgpt tldr trash-cli tt tty-clock udiskie ufw unimatrix unzip vim wget wf-recorder yazi yt-dlp zathura-cb zathura-pdf-mupdf zoxide zsh vscodium-bin python-pipx lsd spicetify-cli chess-tui tesseract tesseract-data-eng tint-tetris gallery-dl

yay -S auto-cpufreq baobab easyeffects gnome-firmware helvum iwgtk keepassxc kvantum nautilus nwg-look obsidian openrgb overskride pauvcontrol pika-backup qimgv satty scrcpy thunderbird zathura zen-browser-bin firefox spotify-launcher zed gnome-disk-utility

gh extension install dlvhdr/gh-dash

sudo systemctl enable --now auto-cpufreq.service
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now fstrim.timer
sudo systemctl enable --now iptables.service

sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=$HOME/.icons
flatpak override --user --filesystem=xdg-config/gtk-4.0
sudo flatpak override --filesystem=xdg-config/gtk-4.0

flatpak install flathub com.github.neithern.g4music io.github.flattool.Warehouse com.github.tchx84.Flatseal org.gnome.gitlab.YaLTeR.Identity org.gnome.Calculator io.gitlab.adhami3310.Impression de.haeckerfelix.Fragments org.nickvision.tubeconverter com.github.ADBeveridge.Raider

ya pack -a yazi-rs/flavors:catppuccin-macchiato
ya pack -a yazi-rs/plugins:hide-preview
ya pack -a yazi-rs/plugins:smart-filter
ya pack -a yazi-rs/plugins:full-border
ya pack -a imsi32/yatline-githead
ya pack -a yazi-rs/plugins:git
ya pack -a Lil-Dank/lazygit
ya pack -a Reledia/glow

git clone https://github.com/DreamMaoMao/fg.yazi.git ~/.config/yazi/plugins/fg.yazi
git clone https://github.com/imsi32/yatline.yazi.git ~/.config/yazi/plugins/yatline.yazi
git clone https://github.com/DreamMaoMao/searchjump.yazi.git ~/.config/yazi/plugins/searchjump.yazi

ya pack -i
ya pack -u
ya pack -m

bat cache --build

exec fish

fisher install patrickf1/fzf.fish \
      catppuccin/fish \
      gazorby/fish-abbreviation-tips \
      nickeb96/puffer-fish \
      jorgebucaran/autopair.fish \
      dracula/fish \
      meaningful-ooo/sponge

hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo

npm install -g cz-git commitizen

vscodium --list-extensions > extensions.txt

sudo gpasswd -a $USER input

spicetify update
spicetify backup apply enable-devtools
spicetify
sudo chmod a+wr ~/.local/share/spotify-launcher/install/usr/share/spotify/Apps -R
sudo chmod a+wr ~/.local/share/spotify-launcher/install/usr/share/spotify

curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl disable tailscaled.service

systemctl --user enable --now pipewire pipewire-pulse

