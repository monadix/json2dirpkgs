{
  stdenv,
  lib,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "arnoldc";
  version = "0.1";
  src = fetchurl {
    url = "https://lhartikk.github.io/ArnoldC.jar";
    hash = "sha256-wmsDQtNS5pg4vH2rZzBUhO2spwIALPeT9h+BfZ3Bwx0=";
  };

  dontUnpack = true;

  installPhase = ''
    install -Dm644 "$src" "$out/share/ArnoldC.jar"
  '';

  meta = {
    description = "Compiler for the ArnoldC language";
    homepage = "https://github.com/lhartikk/ArnoldC";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
