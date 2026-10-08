{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  ncurses5,
  zlib,
}:
stdenv.mkDerivation {
  pname = "emojicode";
  version = "1.0-beta.2";
  src = fetchurl {
    url = "https://github.com/emojicode/emojicode/releases/download/v1.0-beta.2/Emojicode-1.0-beta.2-Linux-x86_64.tar.gz";
    hash = "sha256-wuSo7BVsGYqA2ETnR85xydNO/VSixfO2oRZHDQy47w8=";
  };
  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [
    stdenv.cc.cc.lib
    ncurses5
    zlib
  ];
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp emojicodec "$out/bin/"
    cp -a include packages "$out/"
    wrapProgram "$out/bin/emojicodec" \
      --set EMOJICODE_PACKAGES_PATH "$out/packages" \
      --prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}
    runHook postInstall
  '';
  meta = {
    description = "Emojicode compiler and standard packages";
    homepage = "https://www.emojicode.org/";
    license = lib.licenses.artistic2;
    platforms = [ "x86_64-linux" ];
    mainProgram = "emojicodec";
  };
}
