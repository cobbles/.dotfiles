# .dotfiles

Configs for zsh, tmux, neovim and a sway desktop. They are plain files under `home/`, symlinked into `~`.

| Machine | OS | Gets | Tools from | Linked by |
|---|---|---|---|---|
| Laptop / desktop | NixOS | core + sway desktop | nix | [home-manager](https://github.com/nix-community/home-manager) |
| Windows | Ubuntu on WSL | core: zsh, tmux, neovim, CLI tools | apt | stow |

## New machine

Follow one of the guides below, then [Finish up](#finish-up).

### NixOS

Uses the **minimal ISO**. One command wipes the disk and installs this repo's config.

**1. Set up the BIOS**

Turn off **Secure Boot** and make sure it boots in **UEFI** mode. Then boot the ISO.

**2. Connect to the internet**

Ethernet or phone USB tethering works without setup. For Wi-Fi:

```
nmtui
```

Choose **Activate a connection**, pick your network and enter the password.

**3. Find the disk**

```
lsblk -d -o NAME,SIZE,MODEL
```

Pick the internal drive by its size and model, usually `nvme0n1` or `sda`. Ignore the USB stick you booted from. Note the name for the next step.

**4. Run the installer**

```
curl -fsSL https://raw.githubusercontent.com/cobbles/.dotfiles/main/nixos/install | sudo bash
```

It asks:

- **which machine**: `laptop` or `desktop`
- **which disk**: the name from step 3, e.g. `nvme0n1`
- to type `yes`, because it **erases the whole disk**

Then it installs, which takes a while, and asks you to set a password for `tom`.

**5. Reboot**

```
reboot
```

Remove the USB stick when the screen goes blank.

**6. Log in**

ly shows a login screen. Pick **sway**, then log in as `tom`.

`Super+Enter` opens a terminal. Run `nmtui` again to connect to Wi-Fi.

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

**1. Set up SSH for GitHub and GitLab**

The repo was cloned over HTTPS, so you can't push yet.

```
ssh-keygen -t ed25519
```

Copy the public key to the clipboard:

```
clip-copy < ~/.ssh/id_ed25519.pub
```

Paste it into both sites:

- GitHub: [github.com/settings/keys](https://github.com/settings/keys)
- GitLab: [gitlab.com/-/user_settings/ssh_keys](https://gitlab.com/-/user_settings/ssh_keys)

Check they work:

```
ssh -T git@github.com
```

```
ssh -T git@gitlab.com
```

Switch the repo to SSH:

```
git -C ~/personal/.dotfiles remote set-url origin git@github.com:cobbles/.dotfiles.git
```

**2. NixOS only: commit the hardware config**

The installer wrote this machine's hardware config into the repo. Use `laptop` or `desktop`:

```
cd ~/personal/.dotfiles
git add nixos/hosts/laptop/hardware-configuration.nix
git commit -m "chore: add laptop hardware config"
git push
```

**3. Add per-machine settings**

Put work tokens and aliases in `~/.zshrc.work`. It's sourced if present and never committed.

**4. Install neovim plugins**

Run `nvim` once. It installs its plugins on first launch.

**5. Check everything works**

On WSL, first run `sudo apt-get install bats`. On NixOS, use `nix-shell -p bats`.

```
cd ~/personal/.dotfiles && bats tests/smoke.bats
```

## Making changes

- **Edit a config:** edit it under `home/`. Configs are symlinked to the checkout, so changes apply immediately.
- **Add a tool:** add it to the apt list in `wsl/install` and to `nixos/core.nix`. Desktop-only tools go in `nixos/desktop.nix`.
- **Add a config:** add it under `home/<tool>/`, add the package to the `stow` line in `wsl/install`, and link it in the same nix file.
- **Apply changes:** run `dotfiles-switch`. It runs `nixos-rebuild` on NixOS and `wsl/install` on WSL.
- **Add a NixOS machine:** add `nixos/hosts/<name>/hardware-configuration.nix` (copy a placeholder) and add the name to the list in `nixos/flake.nix`. Machine-specific settings can go in that file.
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

CI also runs:

- `tests/install.bats`: the NixOS installer, with the disk tools faked out
- `tests/nixos.bats`: each NixOS machine's config builds (needs nix)
