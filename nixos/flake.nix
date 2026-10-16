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
      # sudo nixos-rebuild switch --flake ~/personal/.dotfiles/nixos  (or ~/.dotfiles/nixos)
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.nixosModules.home-manager
          ./configuration.nix
        ];
      };
    };
}
