# .dotfiles

Configs for zsh, tmux, neovim and a sway desktop. They are plain files under `home/`, symlinked into `~`.

| Machine | OS | Gets | Tools from | Linked by |
|---|---|---|---|---|
| Laptop | NixOS | core + sway desktop | nix | [home-manager](https://github.com/nix-community/home-manager) |
| Windows | Ubuntu on WSL | core: zsh, tmux, neovim, CLI tools | apt | stow |

## New machine

Follow one of the guides below, then [Finish up](#finish-up).

### NixOS laptop

**1. Install NixOS**

Boot the NixOS ISO and run the installer.

- Username: `tom` (the config expects it)
- Desktop: **No desktop** (sway comes from this repo)
- Boot: UEFI (the config uses systemd-boot)

Reboot and log in at the text console.

**2. Connect to the internet**

If you're on Wi-Fi:

```
nmtui
```

**3. Get git for this session**

```
nix-shell -p git
```

**4. Clone the repo**

```
git clone https://github.com/cobbles/.dotfiles.git ~/personal/.dotfiles
```

**5. Use this machine's hardware config**

The installer already generated it. Copy it over the placeholder:

```
cp /etc/nixos/hardware-configuration.nix ~/personal/.dotfiles/nixos/
```

**6. Build the system**

Flakes aren't on yet, so turn them on for this one command:

```
sudo env NIX_CONFIG="experimental-features = nix-command flakes" nixos-rebuild switch --flake ~/personal/.dotfiles/nixos#laptop
```

This takes a while. After this, run `dotfiles-switch` to apply changes.

**7. Reboot**

```
sudo reboot
```

**8. Start the desktop**

Log in at the console, then:

```
sway
```

`Super+Enter` opens a terminal.

**9. Commit the hardware config**

```
cd ~/personal/.dotfiles
git add nixos/hardware-configuration.nix
git commit -m "chore: add laptop hardware config"
```

Push it after setting up SSH in [Finish up](#finish-up).

### Ubuntu on WSL

**1. Install WSL**

In PowerShell **as Administrator**:

```
wsl --install -d Ubuntu
```

Reboot Windows. Open **Ubuntu** from the Start menu and create your user.

**2. Clone and install**

In Ubuntu:

```
git clone https://github.com/cobbles/.dotfiles.git ~/personal/.dotfiles
```

```
~/personal/.dotfiles/wsl/install
```

It's safe to re-run, and `dotfiles-switch` runs it after every update.

**3. Install the font**

1. Download **DroidSansMono** from [nerdfonts.com](https://www.nerdfonts.com/font-downloads)
2. Unzip it, select all the `.ttf` files, then right-click and choose **Install**
3. In Windows Terminal, open **Settings → Ubuntu → Appearance → Font face** and pick **DroidSansM Nerd Font**

**4. Open a new terminal**

You're now in zsh.

### Finish up

**1. Set up SSH for GitHub**

The repo was cloned over HTTPS, so you can't push yet.

```
ssh-keygen -t ed25519
```

```
cat ~/.ssh/id_ed25519.pub
```

Add the key at [github.com/settings/keys](https://github.com/settings/keys), then:

```
git -C ~/personal/.dotfiles remote set-url origin git@github.com:cobbles/.dotfiles.git
```

```
ssh -T git@github.com
```

**2. Add per-machine settings**

Put work tokens and aliases in `~/.zshrc.work`. It's sourced if present and never committed.

**3. Install neovim plugins**

Run `nvim` once. It installs its plugins on first launch.

**4. Check everything works**

On WSL, first run `sudo apt-get install bats`. On NixOS, use `nix-shell -p bats`.

```
cd ~/personal/.dotfiles && bats tests/smoke.bats
```

## Making changes

- **Edit a config:** edit it under `home/`. Configs are symlinked to the checkout, so changes apply immediately.
- **Add a tool:** add it to the apt list in `wsl/install` and to `nixos/core.nix`. Desktop-only tools go in `nixos/desktop.nix`.
- **Add a config:** add it under `home/<tool>/`, add the package to the `stow` line in `wsl/install`, and link it in the same nix file.
- **Apply changes:** run `dotfiles-switch`. It runs `nixos-rebuild` on NixOS and `wsl/install` on WSL.
- **Per-machine settings** (work tokens, aliases): put them in `~/.zshrc.work`. It is sourced if present and never committed.

The repo can live at `~/personal/.dotfiles` or `~/.dotfiles`. On WSL any path works.

When the remote has new commits, a new shell offers to pull them and run `dotfiles-switch`.

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

Commit messages need to follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

### Tests

After setting up a machine, run `bats tests/smoke.bats`. See [Finish up](#finish-up) for installing bats.
