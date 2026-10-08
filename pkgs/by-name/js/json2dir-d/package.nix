{
  lib,
  stdenv,
  j2dSources,
  dmd,
  removeReferencesTo,
}:
let
  pname = "json2dir-d";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-c1909f7";
  src = j2dSources."json2dir-d";
  nativeBuildInputs = [
    dmd
    removeReferencesTo
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    dmd -O -of="$TMPDIR/out/json2dir" json2dir.d
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-d"
  '';
  preFixup = ''
    remove-references-to -t ${dmd} "$out/bin/json2dir-d"
  '';
  disallowedReferences = [ dmd ];
  meta = {
    description = "D (DMD), one source file, druntime/Phobos only with a hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-d";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
