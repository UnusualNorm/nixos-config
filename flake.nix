{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    nix-citizen.url = "github:LovingMelody/nix-citizen";
  };
  outputs = inputs@{ home-manager, nixpkgs, self, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem { modules = [ ./nixos.nix ]; specialArgs = { inherit inputs; }; };
      norman = nixpkgs.lib.nixosSystem { modules = [ ./norman.nix ]; specialArgs = { inherit inputs; }; };
      normette = nixpkgs.lib.nixosSystem { modules = [ ./normette.nix ]; specialArgs = { inherit inputs; }; };
    };
  };
}
