{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ home-manager, nixpkgs, self, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem { modules = [ ./nixos.nix home-manager.nixosModules.home-manager ]; };
    nixosConfigurations.norman = nixpkgs.lib.nixosSystem { modules = [ ./norman.nix home-manager.nixosModules.home-manager ]; };
    nixosConfigurations.normette = nixpkgs.lib.nixosSystem { modules = [ ./normette.nix home-manager.nixosModules.home-manager ]; };
  };
}
