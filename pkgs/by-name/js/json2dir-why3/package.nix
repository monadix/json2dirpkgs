{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  why3,
  ocaml-ng,
  why3-ocaml-driver,
  z3,
}:
let
  pname = "json2dir-why3";
  why3WithProvers = why3.withProvers [ z3 ];
  ocamlPackages = ocaml-ng.ocamlPackages_4_14;
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-e8acbac";
  src = j2dSources."json2dir-why3";
  nativeBuildInputs = [
    makeWrapper
    why3WithProvers
    ocamlPackages.ocaml
    ocamlPackages.findlib
  ];
  buildInputs = [ ocamlPackages.zarith ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out"
    why3 prove -a split_vc -P z3 -t 30 -L . json2dir.mlw
    why3 extract -D "${why3-ocaml-driver}/drivers/ocaml64.drv" -L . -L "${why3-ocaml-driver}/stdlib" --recursive json2dir.Json2dir -o "$TMPDIR/out/core.ml"
    cp driver.ml "$TMPDIR/out/driver.ml"
    cd "$TMPDIR/out"
    ocamlfind ocamlopt -package zarith,unix -linkpkg core.ml driver.ml -o json2dir
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/libexec/json2dir"; makeWrapper "$out/libexec/json2dir" "$out/bin/json2dir-why3"
  '';
  meta = {
    description = "json2dir in WhyML (Why3, extracted to OCaml)";
    homepage = "https://github.com/json2dir-guru/json2dir-why3";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
