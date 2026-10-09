{
  lib,
  stdenv,
  j2dSources,
  gnumake,
  z3,
  ocaml-ng,
  fstar-2026-09-27,
}:
let
  pname = "json2dir-F-";
  ocaml = ocaml-ng.ocamlPackages_5_3;
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-1a2afa1";
  src = j2dSources.json2dir-F-;
  nativeBuildInputs = [
    fstar-2026-09-27
    gnumake
    z3
    ocaml.ocaml
    ocaml.findlib
    ocaml.batteries
    ocaml.stdint
    ocaml.zarith
    ocaml.ppx_deriving
    ocaml.ppx_deriving_yojson
  ];
  dontConfigure = true;
  buildPhase = ''
    export FSTAR_HOME=${fstar-2026-09-27}
    export FSTAR=${fstar-2026-09-27}/bin/fstar.exe
    export PATH=${fstar-2026-09-27}/lib/fstar/z3-4.13.3/bin:$PATH
    make
  '';
  installPhase = ''install -Dm755 json2dir "$out/bin/json2dir-F-"'';
  meta = {
    description = "F* implementation of json2dir extracted to native OCaml";
    homepage = "https://github.com/TheMaxMur/json2dir-F-";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
