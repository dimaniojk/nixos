{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };

        overlays = [
          self.overlays.default
        ];
      };
    in
    {
      overlays.default = final: prev: {
        omniroute = final.callPackage ./packages/omniroute.nix { };
        radmin-vpn-linux = final.callPackage ./packages/radmin-vpn-linux.nix { };
      };

      packages.${system} = {
        omniroute = pkgs.omniroute;
        radmin-vpn-linux = pkgs.radmin-vpn-linux;
        default = pkgs.omniroute;
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit self;
        };

        modules = [
          {
            nixpkgs.overlays = [
              self.overlays.default
            ];
          }
          home-manager.nixosModules.home-manager
          ./configuration.nix
        ];
      };
    };
}
