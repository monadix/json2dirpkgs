{
  lib,
  rustPlatform,
  j2dSources,
}:
let
  pname = "json2dir";
in
rustPlatform.buildRustPackage {
  inherit pname;
  version = "unstable-b2072fb";
  src = j2dSources.json2dir;
  cargoHash = "sha256-EJ4yR/PXRW1dyC3ejjknC7sEJFedV6YRfC7DvFMUBIU=";
  doCheck = false;
  meta = {
    description = "Rust reference implementation of json2dir";
    homepage = "https://github.com/alurm/json2dir";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
