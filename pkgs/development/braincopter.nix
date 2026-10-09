{
  stdenv,
  lib,
  fetchzip,
}:
stdenv.mkDerivation {
  pname = "braincopter";
  version = "1.0";
  src = fetchzip {
    url = "https://lodev.org/esolangs/braincopter/braincopter.zip";
    hash = "sha256-8SXrhcc0fCeRd2H+QjRLQI1w7H/TzfdaFX2vDbdVNLM=";
  };
  buildPhase = ''
    runHook preBuild
    $CXX -O2 -o braincopter main.cpp lodepng.cpp
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 braincopter "$out/bin/braincopter"
  '';
  meta = {
    description = "Braincopter interpreter";
    homepage = "https://lodev.org/esolangs/braincopter/";
    license = lib.licenses.mit;
    mainProgram = "braincopter";
    platforms = [ "x86_64-linux" ];
  };
}
