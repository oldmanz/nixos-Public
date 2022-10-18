{
  description = "Zs nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

  };

  outputs = { nixpkgs, home-manager, impermanence,... }@inputs:
    let
      inherit (nixpkgs.lib) nixosSystem;
      inherit (home-manager.lib) homeManagerConfiguration;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
    in {
      nixosConfigurations = {
        Znform = nixosSystem {
          inherit system;
          modules = [ 
	    ./system/configuration.nix 
	    home-manager.nixosModules.home-manager
	    impermanence.nixosModules.impermanence
	  ];
          specialArgs = { 
	    inherit inputs;
	  };
        };
      };
    };
}

