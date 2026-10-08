{
  lib,
  stdenv,
  j2dSources,
  coq,
  rocqPackages,
  ocaml,
}:
let
  pname = "json2dir-rocq";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-ee71269";
  src = j2dSources."json2dir-rocq";
  nativeBuildInputs = [
    coq
    rocqPackages.stdlib
    ocaml
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p out "$TMPDIR/out"
    cd src
    coqc -Q . J2D Json2dir.v
    coqc -Q . J2D Extract.v
    cd ../out
    cp ../src/main.ml .
    ocamlopt -w -a unix.cmxa json2dir_core.mli json2dir_core.ml main.ml -o "$TMPDIR/out/json2dir"
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/${pname}"
  '';
  meta = {
    description = "Rocq 8.15 (Coq): UTF-8, JSON parser and validation proved in Rocq, extracted to OCaml; OCaml driver does I/O only";
    homepage = "https://github.com/json2dir-guru/json2dir-rocq";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
