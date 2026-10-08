{
  lib,
  fetchzip,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "whitespacers";
  version = "1.3.0";
  src = fetchzip {
    url = "https://static.crates.io/crates/whitespacers/whitespacers-1.3.0.crate";
    extension = "tar.gz";
    hash = "sha256-48EvAV89cfwxV9+55dTIhpeEJWvjdwDHfvGq91i1EKA=";
  };

  cargoHash = "sha256-cL8EES08stpAjnwboa8CP7ahDOT0OiX3CV92M73BRu0=";

  meta = {
    description = "Whitespace JIT compiler and command-line interpreter";
    homepage = "https://github.com/CensoredUsername/whitespace-rs";
    license = lib.licenses.mpl20;
    mainProgram = "wsc";
    platforms = [ "x86_64-linux" ];
  };
}
