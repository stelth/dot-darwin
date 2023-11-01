{
  description = "Stelth's darwin system";

  inputs = {
    # Package sets
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Environment/system management
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Other sources
    comma = {
      url = github:Shopify/comma;
      flake = false;
    };
  };
  outputs = {
    self,
    darwin,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
      nixpkgsConfig = {
      config = { allowUnfree = true; };
      overlays = nixpkgs.lib.attrValues self.overlays;
    };
  in {
    darwinConfigurations = rec {
      Jasons-MacBook-Pro = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          # Main `nix-darwin` config
          ./modules/configuration.nix
          ./modules/brew.nix
          ./modules/nix-path.nix
          home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;
            # `home-manager` config
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jcox = import ./home.nix;
          }
        ];
      };
    };

    overlays = {
      sessionizer = final: prev: {
        sessionizer = final.callPackage ./packages/sessionizer {};
      };
    };
  };
}
