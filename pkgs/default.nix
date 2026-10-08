{ pkgs }:
let
  inherit (pkgs) lib;
  selection = builtins.fromJSON (builtins.readFile ../data/selection.json);
  sourceFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".json" name) (
    builtins.readDir ../sources
  );
  sourcePins = lib.mapAttrs' (
    file: _:
    lib.nameValuePair (lib.removeSuffix ".json" file) (
      builtins.fromJSON (builtins.readFile (../sources + "/${file}"))
    )
  ) sourceFiles;
  j2dSources = lib.mapAttrs (
    _: spec:
    pkgs.fetchFromGitHub {
      inherit (spec)
        owner
        repo
        rev
        hash
        ;
    }
  ) sourcePins;
  dependencyFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
    builtins.readDir ./development
  );
in
lib.makeScope pkgs.newScope (
  self:
  let
    dependencies = lib.mapAttrs' (
      file: _:
      lib.nameValuePair (lib.removeSuffix ".nix" file) (self.callPackage (./development + "/${file}") { })
    ) dependencyFiles;
    implementations = builtins.listToAttrs (
      map (
        item:
        lib.nameValuePair item.name (
          self.callPackage (./by-name + "/${builtins.substring 0 2 item.name}/${item.name}/package.nix") { }
        )
      ) selection.implementations
    );
  in
  dependencies // implementations // { inherit j2dSources implementations; }
)
