{
  lib,
  stdenv,
  j2dSources,
  gcc,
}:
let
  pname = "json2dir-c89";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-8159941";
  src = j2dSources."json2dir-c89";
  nativeBuildInputs = [ gcc ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    gcc -std=c89 -pedantic-errors -Wall -Wextra -O2 -o "$TMPDIR/out/json2dir" json2dir.c
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-c89"
  '';
  meta = {
    description = "ANSI C (C89) + POSIX in one file, gcc -std=c89 -pedantic-errors, hand-written UTF-8 check and JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-c89";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
