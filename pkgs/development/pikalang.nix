{
  stdenv,
  lib,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "pikalang";
  version = "unstable-2026-10-08";
  src = fetchFromGitHub {
    owner = "Amirreza-Ipchi-Haq";
    repo = "Pikalang";
    rev = "ee784e930a4eca1ec8cc09d115e661fb819ad28e";
    hash = "sha256-TTJmx80xndvx4GqEL04n8Pe0ynXjtkIxMAvboZdnfxQ=";
  };
  buildPhase = ''
    runHook preBuild
    $CC -O2 -o pikalang main.c
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 pikalang "$out/bin/pikalang"
  '';
  meta = {
    description = "Pikalang interpreter";
    homepage = "https://github.com/Amirreza-Ipchi-Haq/Pikalang";
    license = lib.licenses.unlicense;
    mainProgram = "pikalang";
    platforms = [ "x86_64-linux" ];
  };
}
