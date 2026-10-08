{
  lib,
  stdenv,
  j2dSources,
  odin,
  removeReferencesTo,
}:
let
  pname = "json2dir-odin";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-88e9ed6";
  src = j2dSources."json2dir-odin";
  nativeBuildInputs = [
    odin
    removeReferencesTo
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    odin build . -o:speed -source-code-locations:filename -out:"$TMPDIR/out/json2dir"
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-odin"
  '';
  preFixup = ''
    remove-references-to -t ${odin} "$out/bin/json2dir-odin"
  '';
  disallowedReferences = [ odin ];
  meta = {
    description = "Odin, core library only, hand-written JSON parser and raw Linux syscalls";
    homepage = "https://github.com/json2dir-guru/json2dir-odin";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
