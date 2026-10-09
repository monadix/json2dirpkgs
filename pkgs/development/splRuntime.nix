{
  stdenv,
  lib,
  fetchFromGitHub,
  bison,
  flex,
  gnumake,
}:
stdenv.mkDerivation {
  pname = "spl-runtime";
  version = "1.2.1";
  src = fetchFromGitHub {
    owner = "krayon";
    repo = "shakespearelang";
    rev = "70f60d8669fb241ff830924c0ed2ea0bc751f444";
    hash = "sha256-Y//Q+n3xH9KEhW+ZAS8Nxqvfnod21sx8KgPhezbHoBM=";
  };
  postPatch = ''
    substituteInPlace include/roman_numbers.metaflex \
      --replace-fail 'ROMAN_HUNDREDS  (c(d|m)|dc{0,3}|c{1,3})' \
        'ROMAN_HUNDREDS  (c(d|m)|dccc|dcc|dc|d|ccc|cc|c)' \
      --replace-fail 'ROMAN_TENS      (x(l|c)|lx{0,3}|x{1,3})' \
        'ROMAN_TENS      (x(l|c)|lxxx|lxx|lx|l|xxx|xx|x)' \
      --replace-fail 'ROMAN_ONES      (i(v|x)|vi{0,3}|i{1,3})' \
        'ROMAN_ONES      (i(v|x)|viii|vii|vi|v|iii|ii|i)'
  '';
  nativeBuildInputs = [
    bison
    flex
    gnumake
  ];
  hardeningDisable = [ "fortify" ];
  buildPhase = ''
    runHook preBuild
    make install
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin" "$out/include" "$out/lib"
    install -m755 spl2c "$out/bin/spl2c"
    install -m644 spl.h "$out/include/spl.h"
    install -m644 libspl.a "$out/lib/libspl.a"
    runHook postInstall
  '';
  meta = {
    description = "SPL 1.2.1 compiler and runtime library";
    homepage = "https://sourceforge.net/projects/shakespearelang/";
    license = lib.licenses.gpl2Plus;
    mainProgram = "spl2c";
    platforms = [ "x86_64-linux" ];
  };
}
