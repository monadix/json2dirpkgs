{
  lib,
  stdenv,
  j2dSources,
  gnat,
}:
let
  pname = "json2dir-ada";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-bdb8c11";
  src = j2dSources."json2dir-ada";
  nativeBuildInputs = [ gnat ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    gnatmake -q -O2 -D "$TMPDIR/out" json2dir.adb -o "$TMPDIR/out/json2dir"
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-ada"
  '';
  meta = {
    description = "Ada (GNAT), standard library only, hand-written JSON parser, POSIX calls via pragma Import";
    homepage = "https://github.com/json2dir-guru/json2dir-ada";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
