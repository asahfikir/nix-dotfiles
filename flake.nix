{
  description = "AsahFikir NixOS Flake Configuration based on Mysterio77 Starter Template and ZaneyOS";

  inputs = {
    # Nixpkgs
    nixpkgs = {
      url = "nixpkgs/nixos-24.05";
    };

    # Stylix - base16 color
    stylix.url = "github:danth/stylix";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      host = "DLLPTP";
      username = "fikri";
      lib = nixpkgs.lib;
    in {
      # System wide configuration
      nixosConfigurations = {
        # configuration for DLLPTP hostname
        ${host} = lib.nixosSystem {
          specialArgs = { inherit inputs outputs system; };
          system = "x86_64-linux";
          # use the configuration from the configuration we copied from /etc/nixos
          modules = [
            # main configuration
            ./configuration.nix

            # Coloring purposes
            inputs.stylix.nixosModules.stylix
          ];
        };
      };


      # Home Manager Configuration;
      # homeConfigurations."fikri" = home-manager.lib.homeManagerConfiguration {
      #   inherit pkgs;

      #   modules = [ ./home.nix ];
      # };
    };
}
