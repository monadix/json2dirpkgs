{
  lib,
  stdenv,
  j2dSources,
  hare,
}:
let
  pname = "json2dir-hare";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-60add5e";
  src = j2dSources."json2dir-hare";
  nativeBuildInputs = [ hare ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    export HOME="$TMPDIR/task-home"
    mkdir -p "$HOME" "$TMPDIR/out" "$TMPDIR/classes"
    hare build -o "$TMPDIR/out/json2dir" json2dir.ha
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-hare"
  '';
  meta = {
    description = "Hare, one file, standard library only, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-hare";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
