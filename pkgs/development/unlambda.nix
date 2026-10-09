{
  lib,
  stdenv,
  fetchurl,
  ocaml,
}:
stdenv.mkDerivation {
  pname = "unlambda";
  version = "2.0.0";
  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/math-linux/OldFiles/unlambda-2.0.0.tar.gz";
    hash = "sha256-qdvgo5qSiyOM3PWnHlBOODzqSU5MlqedNWbeoUQMEKk=";
  };
  nativeBuildInputs = [ ocaml ];
  buildPhase = ''
    runHook preBuild
    ocamlopt -O3 -o unlambda caml/unlambda.ml
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 unlambda "$out/bin/unlambda"
  '';
  meta = {
    description = "David Madore's official Unlambda 2.0.0 OCaml interpreter";
    homepage = "https://www.madore.org/~david/programs/unlambda/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "unlambda";
    platforms = [ "x86_64-linux" ];
  };
}
