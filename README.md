# .dotfiles

## Setup

1. Connect to wifi: https://wiki.archlinux.org/title/Iwd

2. Run archinstall

```
archinstall --config https://raw.githubusercontent.com/cobbles/.dotfiles/main/archinstall/user_configuration.json
```

3. Run post install setup script

```
sudo tom
cd ~/
git clone https://github.com/cobbles/.dotfiles.git
cd .dotfiles
./setup
```

## Development

lefthook is used to run githooks to ensure consistency in formatting etc.

Install dependencies
```
npm install
```

Install lefthook config into githooks
```
lefthook install
```

Commit messages need to follow the [Conventional Commits]|(https://www.conventionalcommits.org/en/v1.0.0/) specification 



