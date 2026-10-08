{
  lib,
  stdenv,
  j2dSources,
  nim,
}:
let
  pname = "json2dir-nim";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-ade9c45";
  src = j2dSources."json2dir-nim";
  nativeBuildInputs = [ nim ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    nim c -d:release --hints:off --nimcache:"$TMPDIR/nimcache" -o:"$TMPDIR/out/json2dir" json2dir.nim
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-nim"
  '';
  meta = {
    description = "Nim, one file, standard library only, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-nim";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
