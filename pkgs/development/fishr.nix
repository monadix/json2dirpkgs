{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
let
  src = fetchFromGitHub {
    owner = "noirotm";
    repo = "fishr";
    rev = "baded0354b5f22378dd3104b1a145a860614c36b";
    hash = "sha256-6LU4/0oTD7q8NHuWGhhT1eXkIXJBmaM3dBdIMvpOkRQ=";
  };
in
rustPlatform.buildRustPackage {
  pname = "fishr";
  version = "unstable-2026-10-08";
  inherit src;
  cargoLock.lockFile = src + "/Cargo.lock";
  meta = {
    description = "Rust Fish language interpreter";
    homepage = "https://github.com/noirotm/fishr";
    license = lib.licenses.mit;
    mainProgram = "fishr";
    platforms = [ "x86_64-linux" ];
  };
}
