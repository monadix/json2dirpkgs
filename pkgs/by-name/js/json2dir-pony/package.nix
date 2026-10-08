{
  lib,
  stdenv,
  j2dSources,
  ponyc,
}:
let
  pname = "json2dir-pony";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-6c1f553";
  src = j2dSources."json2dir-pony";
  nativeBuildInputs = [ ponyc ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    ponyc -o "$TMPDIR/out" -b json2dir .
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-pony"
  '';
  meta = {
    description = "Pony with its standard library and a hand-written JSON parser, one file";
    homepage = "https://github.com/json2dir-guru/json2dir-pony";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
