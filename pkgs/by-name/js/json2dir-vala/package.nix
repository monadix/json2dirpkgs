{
  lib,
  stdenv,
  j2dSources,
  vala,
  glib,
  pkg-config,
}:
let
  pname = "json2dir-vala";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-7102544";
  src = j2dSources."json2dir-vala";
  nativeBuildInputs = [
    vala
    pkg-config
  ];
  buildInputs = [ glib ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    valac --pkg posix -X -w -o "$TMPDIR/out/json2dir" json2dir.vala
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-vala"
  '';
  meta = {
    description = "Vala with GLib and posix.vapi only, one file, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-vala";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
