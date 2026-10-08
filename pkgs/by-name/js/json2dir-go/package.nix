{
  lib,
  stdenv,
  j2dSources,
  go_1_27,
}:
let
  pname = "json2dir-go";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-c9d1b6d";
  src = j2dSources."json2dir-go";
  nativeBuildInputs = [ go_1_27 ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    export GOPATH="$TMPDIR/gopath"
    export GOCACHE="$TMPDIR/gocache"
    export GOTOOLCHAIN=local
    mkdir -p "$GOPATH" "$GOCACHE"
    go build -trimpath -o "$TMPDIR/out/json2dir" .
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-go"
  '';
  meta = {
    description = "Go, one file, standard library only, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-go";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
