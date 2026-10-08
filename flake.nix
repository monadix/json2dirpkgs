{
  description = "Nixpkgs-style packages for json2dir implementations";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        # These toolchains are required by selected implementations. Their
        # individual licenses still determine whether outputs may be cached.
        config.allowUnfreePredicate =
          package:
          builtins.elem (nixpkgs.lib.getName package) [
            "compcert"
            "bcpl-cintcode"
            "mojo-bin"
            "mojo-runtime-libs"
            "json2dir-mojo"
            "portable-false"
            "ironspring-pli"
            "sqrun-hsq"
          ];
      };
      packages = import ./pkgs { inherit pkgs; };
    in
    {
      packages.${system} = packages.implementations;
      legacyPackages.${system} = packages;
      formatter.${system} = pkgs.nixfmt;
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.python3
          pkgs.dotnet-sdk_10
        ];
      };
    };
}
