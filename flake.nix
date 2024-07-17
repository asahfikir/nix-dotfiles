{
  description = "AsahFikir NixOS Flake Configuration based on forked ZaneyOS";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-24.05";
    };
    stylix.url = "github:danth/stylix";
    # home-manager = {
    #   url = "github:nix-community/home-manager;
    #   inputs.nixpkgs.follow = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in {
      # System wide configuration
      nixosConfigurations = {
        # configuration for DLLPTP hostname
        DLLPTP = lib.nixosSystem {
          specialArgs = { inherit inputs system; };
          system = "${system}";
          # use the configuration from the configuration we copied from /etc/nixos
          modules = [ ./configuration.nix inputs.stylix.nixosModules.stylix ];
        };
      };
      
  
      # Home Manager Configuration;
      # homeConfigurations."fikri" = home-manager.lib.homeManagerConfiguration {
      #   inherit pkgs;

      #   modules = [ ./home.nix ];
      # };
    };
}
