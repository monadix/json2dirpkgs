{
  stdenv,
  lib,
  fetchFromGitHub,
  gnumake,
  pngpp,
  libpng,
}:
stdenv.mkDerivation {
  pname = "brainfunk";
  version = "unstable-2026-10-08";
  src = fetchFromGitHub {
    owner = "GReaperEx";
    repo = "Brainfunk";
    rev = "cece326fa0047b6fecc26dbe6d63a79339dac2c0";
    hash = "sha256-oBLzEgHJj2sb2IXX86uZKSSY+MLY84ec9thNCLonZlw=";
  };
  nativeBuildInputs = [ gnumake ];
  buildInputs = [
    pngpp
    libpng
  ];
  dontConfigure = true;
  buildPhase = ''
    runHook preBuild
    make bfk
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 bfk "$out/bin/bfk"
  '';
  meta = {
    description = "Brainfunk interpreter with Brainloller support";
    homepage = "https://github.com/GReaperEx/Brainfunk";
    license = lib.licenses.gpl3Plus;
    mainProgram = "bfk";
    platforms = [ "x86_64-linux" ];
  };
}
