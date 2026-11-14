#!/usr/bin/env bats
# Checks nixos/partition with the disk tools stubbed out: bats tests/partition.bats

setup() {
    script="$BATS_TEST_DIRNAME/../nixos/partition"
    stubs="$BATS_TEST_TMPDIR/bin"
    log="$BATS_TEST_TMPDIR/calls"
    export MNT="$BATS_TEST_TMPDIR/mnt"
    mkdir -p "$stubs"
    for cmd in parted udevadm mkfs.fat mkfs.ext4 mount; do
        printf '#!/bin/sh\necho "%s $*" >> "%s"\n' "$cmd" "$log" > "$stubs/$cmd"
    done
    # nixos-generate-config creates the config dir, like the real one
    printf '#!/bin/sh\necho "nixos-generate-config $*" >> "%s"\nmkdir -p "$2/etc/nixos"\n' "$log" > "$stubs/nixos-generate-config"
    # lsblk reports whatever TYPE the test sets
    printf '#!/bin/sh\n[ "$1" = -dno ] && echo "${DISK_TYPE:-disk}"\nexit 0\n' > "$stubs/lsblk"
    chmod +x "$stubs"/*
    PATH="$stubs:$PATH"
}

@test "shows usage without a disk" {
    run bash "$script"
    [ "$status" -eq 1 ]
    [[ $output == *Usage* ]]
    [ ! -e "$log" ]
}

@test "refuses something that isn't a whole disk" {
    DISK_TYPE=part run bash "$script" /dev/nvme0n1p1 <<< yes
    [ "$status" -eq 1 ]
    [[ $output == *"not a disk"* ]]
    [ ! -e "$log" ]
}

@test "does nothing unless you type yes" {
    run bash "$script" /dev/nvme0n1 <<< y
    [ "$status" -eq 1 ]
    [ ! -e "$log" ]
}

@test "partitions, formats and mounts the disk, then generates the config" {
    run bash "$script" /dev/nvme0n1 <<< yes
    [ "$status" -eq 0 ]
    expected="parted -s /dev/nvme0n1 -- mklabel gpt mkpart boot fat32 1MB 1GB set 1 esp on mkpart nixos ext4 1GB 100%
udevadm settle
mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/boot
mkfs.ext4 -F -L nixos /dev/disk/by-partlabel/nixos
mount /dev/disk/by-label/nixos $MNT
mount -o umask=077 /dev/disk/by-label/boot $MNT/boot
nixos-generate-config --root $MNT"
    diff <(echo "$expected") "$log"
}

@test "writes a base config with tom, wifi, git and flakes" {
    run bash "$script" /dev/nvme0n1 <<< yes
    [ "$status" -eq 0 ]
    config="$MNT/etc/nixos/configuration.nix"
    grep -q './hardware-configuration.nix' "$config"
    grep -q 'boot.loader.systemd-boot.enable = true;' "$config"
    grep -q 'networking.networkmanager.enable = true;' "$config"
    grep -q '"nix-command" "flakes"' "$config"
    grep -q 'users.users.tom' "$config"
    grep -q '"wheel" "networkmanager"' "$config"
    grep -q 'pkgs.git' "$config"
    grep -q 'system.stateVersion = "26.05";' "$config"
}
