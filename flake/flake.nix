{
  description = "Capsule desktop music player";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} = {
        capsule = pkgs.callPackage ./package.nix { };
        default = self.packages.${system}.capsule;
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/capsule";
      };
    };
}
