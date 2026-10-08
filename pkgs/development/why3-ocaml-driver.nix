{
  stdenvNoCC,
  fetchzip,
  lib,
}:

let
  source = fetchzip {
    name = "why3-1.5.1-source";
    url = "https://gitlab.inria.fr/why3/why3/-/archive/1.5.1/why3-1.5.1.tar.gz";
    hash = "sha256-b/tNj5F35lb0UdbZSm5ovvb7RJhie874ov3eOLcbojE=";
    stripRoot = true;
  };
in
stdenvNoCC.mkDerivation {
  pname = "why3-ocaml-driver";
  version = "1.5.1";
  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "$out/drivers" "$out/stdlib" "$out/share/licenses/why3-ocaml-driver"
    cp "${source}/drivers/ocaml64.drv" "$out/drivers/"
    cp "${source}/stdlib/null.mlw" "$out/stdlib/"
    cp "${source}/LICENSE" "$out/share/licenses/why3-ocaml-driver/"
    cp "${source}/OCAML-LICENSE" "$out/share/licenses/why3-ocaml-driver/"
  '';
  meta = {
    description = "Why3 1.5.1 OCaml driver and null standard module";
    homepage = "https://why3.lri.fr/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
  };
}
