#!/usr/bin/env bats
# Checks each NixOS machine's config evaluates (needs nix with flakes): bats tests/nixos.bats

setup() {
    flake="$BATS_TEST_DIRNAME/../nixos"
}

config() {
    nix eval --raw "$flake#nixosConfigurations.$1.config.$2"
}

@test "laptop config builds and is named laptop" {
    run config laptop system.build.toplevel.drvPath
    [ "$status" -eq 0 ]
    [ "$(config laptop networking.hostName)" = laptop ]
}

@test "desktop config builds and is named desktop" {
    run config desktop system.build.toplevel.drvPath
    [ "$status" -eq 0 ]
    [ "$(config desktop networking.hostName)" = desktop ]
}

@test "ly is the login manager" {
    [ "$(nix eval "$flake#nixosConfigurations.laptop.config.services.displayManager.ly.enable")" = true ]
    [ "$(nix eval "$flake#nixosConfigurations.desktop.config.services.displayManager.ly.enable")" = true ]
}

@test "helm and yaml language servers are installed" {
    packages=$(nix eval --json "$flake#nixosConfigurations.laptop.config.home-manager.users.tom.home.packages" --apply 'map (p: p.pname or p.name)')
    [[ $packages == *'"helm-ls"'* ]]
    [[ $packages == *'"yaml-language-server"'* ]]
}

@test "tailscale is enabled" {
    [ "$(nix eval "$flake#nixosConfigurations.laptop.config.services.tailscale.enable")" = true ]
    [ "$(nix eval "$flake#nixosConfigurations.desktop.config.services.tailscale.enable")" = true ]
}

@test "home-manager backs up files it would clobber instead of failing" {
    [ "$(config desktop home-manager.backupFileExtension)" = hm-bak ]
    [ "$(nix eval "$flake#nixosConfigurations.desktop.config.home-manager.overwriteBackup")" = true ]
}

@test "gh is installed and git knows who is committing" {
    packages=$(nix eval --json "$flake#nixosConfigurations.laptop.config.home-manager.users.tom.home.packages" --apply 'map (p: p.pname or p.name)')
    [[ $packages == *'"gh"'* ]]
    [ "$(config laptop home-manager.users.tom.programs.git.settings.user.name)" = "Tom Molloy" ]
    [ "$(config laptop home-manager.users.tom.programs.git.settings.user.email)" = cobbles@molloy.cloud ]
}

@test "herdr sessions can be reached from other machines over tailscale ssh" {
    packages=$(nix eval --json "$flake#nixosConfigurations.laptop.config.home-manager.users.tom.home.packages" --apply 'map (p: p.pname or p.name)')
    [[ $packages == *'"herdr"'* ]]
    [[ $(nix eval --json "$flake#nixosConfigurations.desktop.config.services.tailscale.extraSetFlags") == *'"--ssh"'* ]]
}

@test "mise is installed and activated in zsh" {
    packages=$(nix eval --json "$flake#nixosConfigurations.laptop.config.home-manager.users.tom.home.packages" --apply 'map (p: p.pname or p.name)')
    [[ $packages == *'"mise"'* ]]
    grep -q 'mise activate zsh' "$BATS_TEST_DIRNAME/../home/zsh/.zshrc"
}

@test "jq is installed" {
    packages=$(nix eval --json "$flake#nixosConfigurations.laptop.config.home-manager.users.tom.home.packages" --apply 'map (p: p.pname or p.name)')
    [[ $packages == *'"jq"'* ]]
}
