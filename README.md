# .dotfiles

Configs for zsh, tmux, neovim and a sway desktop. They are plain files under `home/`, symlinked into `~`.

| Machine | OS | Gets | Tools from | Linked by |
|---|---|---|---|---|
| Laptop | NixOS | core + sway desktop | nix | [home-manager](https://github.com/nix-community/home-manager) |
| Windows | Ubuntu on WSL | core: zsh, tmux, neovim, CLI tools | apt | stow |

## New machine

Follow one of the guides below, then [Finish up](#finish-up).

### NixOS laptop

This uses the **minimal ISO**. First you install a tiny base system, then reboot and switch it to this repo's config.

Before you start, in the BIOS: turn off **Secure Boot** and make sure it boots in **UEFI** mode.

#### Part 1: install the base system (from the ISO)

**1. Become root**

```
sudo -i
```

Everything in Part 1 runs as root.

**2. Connect to the internet**

Ethernet or phone USB tethering works without setup. For Wi-Fi:

```
systemctl start wpa_supplicant
```

```
wpa_cli
```

Inside `wpa_cli`, type these one at a time. Use your Wi-Fi name and password, and keep the quotes:

```
add_network
set_network 0 ssid "WIFI NAME"
set_network 0 psk "WIFI PASSWORD"
enable_network 0
quit
```

Check it works:

```
ping -c 3 nixos.org
```

**3. Find the disk**

```
lsblk
```

Find the laptop's internal drive by its size. It's usually `nvme0n1` or `sda`. Save it, using your drive's name:

```
DISK=/dev/nvme0n1
```

⚠️ The next step **erases the whole disk**.

**4. Partition the disk**

This makes a 1 GB boot partition and uses the rest for NixOS:

```
parted $DISK -- mklabel gpt
```

```
parted $DISK -- mkpart boot fat32 1MB 1GB
```

```
parted $DISK -- set 1 esp on
```

```
parted $DISK -- mkpart nixos ext4 1GB 100%
```

**5. Format the partitions**

```
mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/boot
```

```
mkfs.ext4 -L nixos /dev/disk/by-partlabel/nixos
```

**6. Mount them**

```
mount /dev/disk/by-label/nixos /mnt
```

```
mkdir -p /mnt/boot
```

```
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
```

**7. Generate the hardware config**

```
nixos-generate-config --root /mnt
```

**8. Write a small base config**

Delete the generated config and write a new one:

```
rm /mnt/etc/nixos/configuration.nix
```

```
nano /mnt/etc/nixos/configuration.nix
```

Type this in exactly:

```nix
{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  users.users.tom = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
  environment.systemPackages = [ pkgs.git ];
  system.stateVersion = "26.05";
}
```

Save with `Ctrl+O`, `Enter`, then quit with `Ctrl+X`.

**9. Install**

```
nixos-install
```

When it finishes, it asks for a **root password**.

**10. Set your user's password**

```
nixos-enter --root /mnt -c 'passwd tom'
```

**11. Reboot**

```
reboot
```

Remove the USB stick when the screen goes blank.

#### Part 2: switch to this repo's config

Log in as `tom` at the text console.

**1. Connect to the internet**

If you're on Wi-Fi:

```
nmtui
```

**2. Clone the repo**

```
git clone https://github.com/cobbles/.dotfiles.git ~/personal/.dotfiles
```

**3. Use this machine's hardware config**

Copy it over the placeholder in the repo:

```
cp /etc/nixos/hardware-configuration.nix ~/personal/.dotfiles/nixos/
```

**4. Build the system**

```
sudo nixos-rebuild switch --flake ~/personal/.dotfiles/nixos#laptop
```

This takes a while. From now on, run `dotfiles-switch` to apply changes.

**5. Reboot**

```
sudo reboot
```

**6. Start the desktop**

Log in at the console, then:

```
sway
```

`Super+Enter` opens a terminal.

**7. Commit the hardware config**

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
