{
  lib,
  stdenv,
  j2dSources,
  clang,
}:
let
  pname = "json2dir-c23";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-726ee35";
  src = j2dSources."json2dir-c23";
  nativeBuildInputs = [ clang ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    clang -std=c23 -pedantic-errors -Wall -Wextra -O2 -o "$TMPDIR/out/json2dir" json2dir.c
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-c23"
  '';
  meta = {
    description = "C23 (ISO/IEC 9899:2024) + POSIX in one file, compiled with clang 23 -std=c23, hand-written UTF-8 check and JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-c23";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
