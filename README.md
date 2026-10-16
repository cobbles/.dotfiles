# .dotfiles

Configs for zsh, tmux, neovim and a sway desktop. They are plain files under `home/`, symlinked into `~`.

| Machine | OS | Gets | Tools from | Linked by |
|---|---|---|---|---|
| Windows | Ubuntu on WSL | core: zsh, tmux, neovim, CLI tools | apt | stow |
| Anything else | NixOS | core + sway desktop | nix | [home-manager](https://github.com/nix-community/home-manager) |

## Setup

The repo must be cloned to `~/.dotfiles`.

### Ubuntu on WSL

```
git clone https://github.com/cobbles/.dotfiles.git ~/.dotfiles
~/.dotfiles/wsl/install
```

It's safe to re-run, and `dotfiles-switch` runs it after every update.

Install the DroidSansM Nerd Font on Windows and select it in Windows Terminal.

### NixOS

```
git clone https://github.com/cobbles/.dotfiles.git ~/.dotfiles
nixos-generate-config --show-hardware-config > ~/.dotfiles/nixos/hardware-configuration.nix
sudo nixos-rebuild switch --flake ~/.dotfiles/nixos#laptop
```

## Making changes

- **Edit a config:** edit it under `home/`. Configs are symlinked to the checkout, so changes apply immediately.
- **Add a tool:** add it to the apt list in `wsl/install` and to `nixos/core.nix`. Desktop-only tools go in `nixos/desktop.nix`.
- **Add a config:** add it under `home/<tool>/`, add the package to the `stow` line in `wsl/install`, and link it in the same nix file.
- **Apply changes:** run `dotfiles-switch`. It runs `nixos-rebuild` on NixOS and `wsl/install` on WSL.
- **Per-machine settings** (work tokens, aliases): put them in `~/.zshrc.work`. It is sourced if present and never committed.

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

Commit messages need to follow the [Conventional Commits]|(https://www.conventionalcommits.org/en/v1.0.0/) specification

### Tests

CI (`.github/workflows/ci.yml`) runs two jobs:
- `wsl/install` on Ubuntu 26.04, run twice, each followed by `tests/smoke.sh --plugins`;
- `nix flake check ./nixos`, which evaluates the NixOS config.
