{
  lib,
  stdenv,
  j2dSources,
  dart,
}:
let
  pname = "json2dir-dart";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-cfb36ec";
  src = j2dSources."json2dir-dart";
  nativeBuildInputs = [ dart ];
  dontStrip = true; # Dart AOT executable snapshots break when Nix strips the ELF.
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    dart compile exe bin/json2dir.dart -o "$TMPDIR/out/json2dir"
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-dart"
  '';
  meta = {
    description = "Dart, one file, AOT-compiled with dart compile exe; libc via dart:ffi";
    homepage = "https://github.com/json2dir-guru/json2dir-dart";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
