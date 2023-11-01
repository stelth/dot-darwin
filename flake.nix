{
  description = "stelth's darwin system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	nix-darwin = {
	    url = "github:LnL7/nix-darwin";
	    inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }: {
    darwinConfigurations."stelths-MacBook" = nix-darwin.lib.darwinSystem {
      modules = [ ./modules/vim ];
specialArgs = {inherit inputs;};
    };
  };
}
