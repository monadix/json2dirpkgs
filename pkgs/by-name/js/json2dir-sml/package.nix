{
  lib,
  stdenv,
  j2dSources,
  mlton,
}:
let
  pname = "json2dir-sml";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-12837a8";
  src = j2dSources."json2dir-sml";
  nativeBuildInputs = [ mlton ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    mlton -output "$TMPDIR/out/json2dir" json2dir.sml
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-sml"
  '';
  meta = {
    description = "Standard ML (Basis Library + Posix only), hand-written strict JSON parser, MLton native build";
    homepage = "https://github.com/json2dir-guru/json2dir-sml";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
