{
  lib,
  stdenv,
  j2dSources,
  ocaml,
}:
let
  pname = "json2dir-ocaml";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-0dfe5d6";
  src = j2dSources."json2dir-ocaml";
  nativeBuildInputs = [ ocaml ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    ocamlopt unix.cmxa json2dir.ml -o "$TMPDIR/out/json2dir"
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-ocaml"
  '';
  meta = {
    description = "OCaml (stdlib + Unix), hand-written JSON parser, native build";
    homepage = "https://github.com/json2dir-guru/json2dir-ocaml";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
