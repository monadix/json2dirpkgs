{
  lib,
  stdenv,
  j2dSources,
  vlang,
}:
let
  pname = "json2dir-v";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-c212b0d";
  src = j2dSources."json2dir-v";
  nativeBuildInputs = [ vlang ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    export HOME="$TMPDIR/task-home"
    mkdir -p "$HOME" "$TMPDIR/out" "$TMPDIR/classes"
    v -prod -o "$TMPDIR/out/json2dir" json2dir.v
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-v"
  '';
  meta = {
    description = "V, one source file, os module plus libc via C interop, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-v";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
