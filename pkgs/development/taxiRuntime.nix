{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "taxi-runtime";
  version = "1.7";
  src = fetchFromGitHub {
    owner = "BigZaphod";
    repo = "Taxi";
    rev = "61383585546668901e77287334ab454426e6f148";
    hash = "sha256-QMIBPqWPzWgb+ZpNefaZKdNNNID9bu69cXtrl4eGSUA=";
  };
  buildPhase = ''
    runHook preBuild
    $CXX -O2 -DNO_GREETINGS source/taxi.cpp -o taxi
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 taxi "$out/bin/taxi"
  '';
  meta = {
    description = "BigZaphod's reference Taxi 1.7 interpreter";
    homepage = "https://github.com/BigZaphod/Taxi";
    license = lib.licenses.publicDomain;
    mainProgram = "taxi";
    platforms = [ "x86_64-linux" ];
  };
}
