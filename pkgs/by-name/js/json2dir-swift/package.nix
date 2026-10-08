{
  lib,
  stdenv,
  j2dSources,
  swift,
}:
let
  pname = "json2dir-swift";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-326c8d6";
  src = j2dSources."json2dir-swift";
  nativeBuildInputs = [ swift ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    export HOME="$TMPDIR/swift-home"
    mkdir -p "$HOME"
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    # Nixpkgs ships only shared Swift runtime libraries; its Swift toolchain
    # has no static resource module tree or libswiftCore.a for -static-stdlib.
    swiftc -O json2dir.swift -o "$TMPDIR/out/json2dir"
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-swift"
  '';
  meta = {
    description = "Swift, one file, standard library + Glibc only (no Foundation), hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-swift";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
