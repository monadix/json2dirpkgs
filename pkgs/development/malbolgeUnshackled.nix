{
  stdenv,
  lib,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "malbolge-unshackled";
  version = "20";
  src = fetchurl {
    url = "https://www.lutter.cc/unshackled/Unshackled-20.c";
    hash = "sha256-i/WE682fvm3aznE/SqraZ2ssThfciFhzJ5aS0zFuyRI=";
  };
  dontUnpack = true;
  buildPhase = ''
    runHook preBuild
    $CC -O2 "$src" -o Unshackled-20
    runHook postBuild
  '';
  installPhase = ''
    install -Dm755 Unshackled-20 "$out/bin/Unshackled-20"
  '';
  meta = {
    description = "Unshackled-20 Malbolge interpreter";
    homepage = "https://www.lutter.cc/unshackled/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "Unshackled-20";
    platforms = [ "x86_64-linux" ];
  };
}
