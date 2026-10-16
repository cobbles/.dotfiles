# Sway desktop apps and their configs.
{ config, pkgs, ... }:
let
  link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/${path}";
in
{
  home.packages = with pkgs; [
    alacritty
    rofi
    waybar
    i3status-rust
    swaynotificationcenter
    nwg-displays
    gtklock
    networkmanagerapplet
    playerctl
    pulseaudio # pactl
    pavucontrol
    brightnessctl
    grim
    slurp
    swappy
    wl-clipboard # clip-copy, nvim clipboard
    firefox
    dracula-theme
    papirus-icon-theme
  ];

  home.file = {
    ".alacritty.toml".source = link "alacritty/.alacritty.toml";
    ".gtkrc-2.0".source = link "gtk/.gtkrc-2.0";
  };

  xdg.configFile = {
    "sway".source = link "sway/.config/sway";
    "environment.d/env.conf".source = link "sway/.config/environment.d/env.conf";
    "waybar".source = link "waybar/.config/waybar";
    "rofi".source = link "rofi/.config/rofi";
    "swaync".source = link "swaync/.config/swaync";
    "gtklock".source = link "gtklock/.config/gtklock";
    "i3status-rust".source = link "i3status-rust/.config/i3status-rust";
    "nwg-displays".source = link "nwg-displays/.config/nwg-displays";
    "gtk-3.0/settings.ini".source = link "gtk/.config/gtk-3.0/settings.ini";
  };
}
