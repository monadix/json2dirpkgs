{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "sqrun-hsq";
  version = "unstable-45a539e7";
  src = fetchFromGitHub {
    owner = "8l";
    repo = "hsq";
    rev = "45a539e7b0d01e33213b594edf1563983fc19546";
    hash = "sha256-95ZzJYOO9ibLMFbcJcs29DnqFoWs93qtIY1fCyMy63o=";
  };

  buildPhase = ''
    $CXX -O2 -std=c++11 -o sqrun hsq.cpp
  '';

  installPhase = ''
    install -Dm755 sqrun "$out/bin/sqrun"
  '';

  meta = {
    description = "Higher Subleq compiler and emulator used as the sqrun runtime";
    longDescription = "Built from 8l/hsq revision 45a539e7b0d01e33213b594edf1563983fc19546. The source archive contains no license text or explicit redistribution grant.";
    homepage = "https://mazonka.com/subleq/";
    license = lib.licenses.unfree;
    mainProgram = "sqrun";
    platforms = [ "x86_64-linux" ];
  };
}
