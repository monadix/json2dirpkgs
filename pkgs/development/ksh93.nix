{
  lib,
  stdenv,
  fetchFromGitHub,
  bash,
  gnumake,
  gcc,
  ncurses,
  zlib,
}:

stdenv.mkDerivation {
  pname = "ksh93u-m";
  version = "1.0.10";
  src = fetchFromGitHub {
    owner = "ksh93";
    repo = "ksh";
    rev = "v1.0.10";
    hash = "sha256-hrXW+PKQ6v0CCKiZ8E3HAEcrt9m4ZO5QfwFT9rCgbxc=";
  };

  nativeBuildInputs = [
    bash
    gnumake
    gcc
  ];
  buildInputs = [
    ncurses
    zlib
  ];
  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    bin/package make SHELL=${bash}/bin/bash
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    bin/package install "$out"
    runHook postInstall
  '';

  meta = {
    description = "KornShell 93u+m";
    homepage = "https://github.com/ksh93/ksh";
    license = lib.licenses.epl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "ksh";
  };
}
