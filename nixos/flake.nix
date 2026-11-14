{
  description = "cobbles dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dracula-zsh = {
      url = "github:dracula/zsh";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      # one config per machine, picked by hostname:
      # sudo nixos-rebuild switch --flake ~/personal/.dotfiles/nixos  (or ~/.dotfiles/nixos)
      # to add a machine, add hosts/<name>/hardware-configuration.nix and its name here
      nixosConfigurations = nixpkgs.lib.genAttrs [ "laptop" "desktop" ] (
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.home-manager
            ./configuration.nix
            ./hosts/${host}/hardware-configuration.nix
            { networking.hostName = host; }
          ];
        }
      );
    };
}
