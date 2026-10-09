{
  lib,
  fetchurl,
  wine64Packages,
  symlinkJoin,
}:
let
  version = "6.0.3";
  src = fetchurl {
    url = "https://dl.winehq.org/wine/source/6.0/wine-${version}.tar.xz";
    hash = "sha256-1P1uGflzUOp733+h/CSOvFlRhRb3Y9Di/UxQWqKwzB4=";
  };
  runtime = wine64Packages.minimal.overrideAttrs (old: {
    inherit src version;
    configureFlags = (old.configureFlags or [ ]) ++ [ "--disable-tests" ];
    patches = builtins.filter (
      patch: lib.hasSuffix "cert-path.patch" (builtins.baseNameOf patch)
    ) old.patches;
    env = (old.env or { }) // {
      NIX_CFLAGS_COMPILE = "-std=gnu17";
    };
    meta = old.meta // {
      description = "Headless 64-bit Wine 6.0.3 runtime built with the pinned Nixpkgs Wine builder";
      mainProgram = "wine";
    };
  });
in
symlinkJoin {
  name = runtime.name;
  paths = [ runtime ];
  postBuild = ''
    ln -s wine64 "$out/bin/wine"
  '';
  meta = runtime.meta;
  passthru = runtime.passthru or { };
}
