# .dotfiles

## Setup

1. Connect to wifi: https://wiki.archlinux.org/title/Iwd

2. Run archinstall

```
archinstall --config https://raw.githubusercontent.com/cobbles/.dotfiles/main/archinstall/user_configuration.json
```

3. Run post install setup script

```
sudo -u tom
cd ~/
git clone https://github.com/cobbles/.dotfiles.git
cd .dotfiles
./setup
```
