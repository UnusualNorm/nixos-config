{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    # nix-citizen = {
    #   inputs = {
    #     nix-gaming.follows = "nix-gaming";
    #     nixpkgs.follows = "nixpkgs";
    #   };
    #   url = "github:LovingMelody/nix-citizen";
    # };
    # nix-gaming = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:fufexan/nix-gaming";
    # };
  };
  outputs = inputs@{ home-manager, nixpkgs, self, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem { modules = [ ./nixos.nix ]; specialArgs = { inherit inputs; }; };
      norman = nixpkgs.lib.nixosSystem { modules = [ ./norman.nix ]; specialArgs = { inherit inputs; }; };
      normette = nixpkgs.lib.nixosSystem { modules = [ ./normette.nix ]; specialArgs = { inherit inputs; }; };
    };
  };
}
