# Placeholder: nixos/install replaces this with the real one when installing
# this machine. Commit it afterwards.
{
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
  nixpkgs.hostPlatform = "x86_64-linux";
}
