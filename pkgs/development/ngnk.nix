{
  lib,
  pkgsMusl,
  fetchzip,
}:

pkgsMusl.stdenv.mkDerivation {
  pname = "ngnk";
  version = "0-unstable-2026-10-07-b9eeb91";
  src = fetchzip {
    url = "https://codeberg.org/ngn/k/archive/b9eeb91e0343ef6029f59d55dd98f82667b9bd59.tar.gz";
    hash = "sha256-zoJsQyDfkzGgICRWfdqaqweumfF4R7nYDGSb+ZjWAC8=";
  };

  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    make k CC=cc O=-O3
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 k "$out/bin/k"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    runHook postInstall
  '';

  meta = {
    description = "The ngn/k array programming language interpreter";
    homepage = "https://codeberg.org/ngn/k";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "k";
  };
}
