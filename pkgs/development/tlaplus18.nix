{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "tlaplus-tools";
  version = "1.8.0";
  src = fetchurl {
    url = "https://github.com/tlaplus/tlaplus/releases/download/v1.8.0/tla2tools.jar";
    hash = "sha256-e+7A8EgYcypi+hk3MXEamapPESeUmbI2Cn0VbFGep40=";
  };
  dontUnpack = true;
  installPhase = ''
    install -Dm644 "$src" "$out/share/java/tla2tools.jar"
  '';
  meta = {
    description = "TLA+ tools, including TLC";
    homepage = "https://github.com/tlaplus/tlaplus";
    license = lib.licenses.epl20;
    platforms = [ "x86_64-linux" ];
  };
}
