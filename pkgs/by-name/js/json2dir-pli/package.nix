{
  stdenv,
  lib,
  binutils,
  ironspring-pli,
  j2dSources,
}:
let
  pname = "json2dir-pli";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [
    binutils
    ironspring-pli
  ];

  buildPhase = ''
    sh ./build.sh ${ironspring-pli}
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "PL/I implementation of json2dir using Iron Spring PL/I";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
