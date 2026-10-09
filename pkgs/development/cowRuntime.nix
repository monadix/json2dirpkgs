{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "cow-runtime";
  version = "e9503d0";
  src = fetchFromGitHub {
    owner = "BigZaphod";
    repo = "cow";
    rev = "e9503d0663e8814b924554382ddc3368845b68ef";
    hash = "sha256-BZLKNHEUy01O9a3ySi9JwHaDMOey2nDoSmDIibFdTCQ=";
  };
  buildPhase = ''
    runHook preBuild
    $CXX -O2 -DNO_GREETINGS source/cow.cpp -o cow
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 cow "$out/bin/cow"
  '';
  meta = {
    description = "BigZaphod's reference COW interpreter";
    homepage = "https://github.com/BigZaphod/cow";
    license = lib.licenses.publicDomain;
    mainProgram = "cow";
    platforms = [ "x86_64-linux" ];
  };
}
