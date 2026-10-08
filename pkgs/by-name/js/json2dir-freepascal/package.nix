{
  lib,
  stdenv,
  j2dSources,
  fpc,
}:
let
  pname = "json2dir-freepascal";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-c74732f";
  src = j2dSources."json2dir-freepascal";
  nativeBuildInputs = [ fpc ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    fpc -O2 -Xs -v0 -FU"$TMPDIR/out" -o"$TMPDIR/out/json2dir" json2dir.pas
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-freepascal"
  '';
  meta = {
    description = "Free Pascal 3.2.2, RTL only (BaseUnix syscalls), hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-freepascal";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
