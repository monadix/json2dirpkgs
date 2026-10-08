{
  lib,
  stdenv,
  j2dSources,
  gcc,
}:
let
  pname = "json2dir-gnuc";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-71ca5fa";
  src = j2dSources."json2dir-gnuc";
  nativeBuildInputs = [ gcc ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    gcc -std=gnu17 -O2 -Wall -o "$TMPDIR/out/json2dir" json2dir.c
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-gnuc"
  '';
  meta = {
    description = "GNU C (gcc -std=gnu17) in one file: nested functions, statement expressions, cleanup attributes, case ranges, computed goto; POSIX *at() calls, hand-written UTF-8 check and JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-gnuc";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
