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
