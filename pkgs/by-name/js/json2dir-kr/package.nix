{
  lib,
  stdenv,
  j2dSources,
  gcc,
}:
let
  pname = "json2dir-kr";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-8a80456";
  src = j2dSources."json2dir-kr";
  nativeBuildInputs = [ gcc ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    gcc -std=gnu89 -fno-builtin -O2 -o "$TMPDIR/out/json2dir" json2dir.c
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-kr"
  '';
  meta = {
    description = "K&R C (pre-ANSI, 1978 style: old-style definitions, no prototypes/void/const/enum) in one file, built with gcc -std=gnu89, hand-written UTF-8 check and JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-kr";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
