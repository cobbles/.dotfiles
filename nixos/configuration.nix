# NixOS laptop: full sway desktop.
{ pkgs, inputs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop";
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.tom = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "video"
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock-effects
      swayidle
    ];
  };
  security.pam.services.gtklock = { };
  xdg.portal.wlr.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  # lets prebuilt binaries (e.g. Mason-installed tools) run
  programs.nix-ld.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-mono
    font-awesome
    cantarell-fonts
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      dotfiles = "/home/tom/.local/state/dotfiles"; # points at the checkout, see core.nix
    };
    users.tom.imports = [
      ./core.nix
      ./desktop.nix
    ];
  };

  system.stateVersion = "26.05";
}
