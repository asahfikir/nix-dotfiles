{
  description = "AsahFikir NixOS Flake Configuration";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-24.05";
    };
  };

  outputs = { self, nixpkgs, ... }: 
    let
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        DLLPTP = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
        };
      };
    };
}
