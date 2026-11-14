#!/usr/bin/env bats
# Checks nixos/install with the disk and nix tools stubbed out: bats tests/install.bats

setup() {
    script="$BATS_TEST_DIRNAME/../nixos/install"
    stubs="$BATS_TEST_TMPDIR/bin"
    log="$BATS_TEST_TMPDIR/calls"
    export MNT="$BATS_TEST_TMPDIR/mnt"
    export TTY_IN="$BATS_TEST_TMPDIR/answers"
    export TMPDIR="$BATS_TEST_TMPDIR/tmp"
    mkdir -p "$stubs" "$MNT" "$TMPDIR"

    for cmd in parted udevadm mkfs.fat mkfs.ext4 mount nixos-install nixos-enter; do
        printf '#!/bin/sh\necho "%s $*" >> "%s"\n' "$cmd" "$log" > "$stubs/$cmd"
    done
    # git clone makes a repo with a laptop and a desktop
    cat > "$stubs/git" << EOF
#!/bin/sh
echo "git \$*" >> "$log"
for dest; do :; done
mkdir -p "\$dest/nixos/hosts/laptop" "\$dest/nixos/hosts/desktop"
EOF
    # nixos-generate-config writes a hardware config, like the real one
    cat > "$stubs/nixos-generate-config" << EOF
#!/bin/sh
echo "nixos-generate-config \$*" >> "$log"
mkdir -p "\$2/etc/nixos"
echo generated > "\$2/etc/nixos/hardware-configuration.nix"
EOF
    # lsblk reports whatever TYPE the test sets
    printf '#!/bin/sh\n[ "$1" = -dno ] && echo "${DISK_TYPE:-disk}"\nexit 0\n' > "$stubs/lsblk"
    printf '#!/bin/sh\necho "${FAKE_UID:-0}"\n' > "$stubs/id"
    chmod +x "$stubs"/*
    PATH="$stubs:$PATH"
}

answer() {
    printf '%s\n' "$@" > "$TTY_IN"
}

# everything run after cloning the repo
installed() {
    grep -v '^git ' "$log" || true
}

@test "refuses to run without root" {
    answer laptop /dev/nvme0n1 yes
    FAKE_UID=1000 run bash "$script"
    [ "$status" -eq 1 ]
    [[ $output == *root* ]]
    [ ! -e "$log" ]
}

@test "clones the repo from github" {
    answer laptop /dev/nvme0n1 yes
    run bash "$script"
    [ "$status" -eq 0 ]
    grep -q '^git clone .*https://github.com/cobbles/.dotfiles.git ' "$log"
}

@test "refuses a machine that isn't in nixos/hosts" {
    answer server /dev/nvme0n1 yes
    run bash "$script"
    [ "$status" -eq 1 ]
    [[ $output == *"Unknown machine"* ]]
    [ -z "$(installed)" ]
}

@test "refuses something that isn't a whole disk" {
    answer laptop /dev/nvme0n1p1 yes
    DISK_TYPE=part run bash "$script"
    [ "$status" -eq 1 ]
    [[ $output == *"not a disk"* ]]
    [ -z "$(installed)" ]
}

@test "does nothing unless you type yes" {
    answer laptop /dev/nvme0n1 y
    run bash "$script"
    [ "$status" -eq 1 ]
    [ -z "$(installed)" ]
}

@test "partitions the disk and installs the laptop" {
    answer laptop /dev/nvme0n1 yes
    run bash "$script"
    [ "$status" -eq 0 ]
    expected="parted -s /dev/nvme0n1 -- mklabel gpt mkpart boot fat32 1MB 1GB set 1 esp on mkpart nixos ext4 1GB 100%
udevadm settle
mkfs.fat -F 32 -n boot /dev/disk/by-partlabel/boot
mkfs.ext4 -F -L nixos /dev/disk/by-partlabel/nixos
udevadm settle
mount /dev/disk/by-partlabel/nixos $MNT
mount -o umask=077 /dev/disk/by-partlabel/boot $MNT/boot
nixos-generate-config --root $MNT
nixos-install --root $MNT --flake $MNT/home/tom/personal/.dotfiles/nixos#laptop --no-root-passwd
nixos-enter --root $MNT -c chown -R tom:users /home/tom
nixos-enter --root $MNT -c passwd tom"
    diff <(echo "$expected") <(installed)
}

@test "installs the desktop and accepts a bare disk name" {
    answer desktop nvme0n1 yes
    run bash "$script"
    [ "$status" -eq 0 ]
    installed | grep -q '^parted -s /dev/nvme0n1 '
    installed | grep -q "^nixos-install .*nixos#desktop "
}

@test "puts the repo in tom's home with this machine's hardware config" {
    answer desktop /dev/nvme0n1 yes
    run bash "$script"
    [ "$status" -eq 0 ]
    repo="$MNT/home/tom/personal/.dotfiles"
    [ "$(cat "$repo/nixos/hosts/desktop/hardware-configuration.nix")" = generated ]
    [ ! -e "$repo/nixos/hosts/laptop/hardware-configuration.nix" ]
}

@test "turns on flakes for the install" {
    printf '#!/bin/sh\necho "$NIX_CONFIG" > "%s"\n' "$BATS_TEST_TMPDIR/nix_config" > "$stubs/nixos-install"
    answer laptop /dev/nvme0n1 yes
    run bash "$script"
    [ "$status" -eq 0 ]
    grep -q 'experimental-features = nix-command flakes' "$BATS_TEST_TMPDIR/nix_config"
}
