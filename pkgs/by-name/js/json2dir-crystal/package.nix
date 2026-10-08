{
  lib,
  stdenv,
  j2dSources,
  crystal,
}:
let
  pname = "json2dir-crystal";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-534bc4e";
  src = j2dSources."json2dir-crystal";
  nativeBuildInputs = [ crystal ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    crystal build --release --no-color -o "$TMPDIR/out/json2dir" json2dir.cr
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-crystal"
  '';
  meta = {
    description = "Crystal, one file, standard library only, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-crystal";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
