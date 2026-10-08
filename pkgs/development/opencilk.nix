{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  wrapCCWith,
  zlib,
  ncurses,
}:
let
  compiler = stdenv.mkDerivation {
    pname = "opencilk-unwrapped";
    version = "2.1.0";
    src = fetchurl {
      url = "https://github.com/OpenCilk/opencilk-project/releases/download/opencilk%2Fv2.1/opencilk-2.1.0-x86_64-linux-gnu-ubuntu-22.04.tar.gz";
      hash = "sha256-gt2dxtVfrKW8NEuT2lI7n4W0HqkB3fP5YhW//qJQGlw=";
    };
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      stdenv.cc.cc.lib
      zlib
      ncurses
    ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin" "$out/lib"
      cp bin/clang-16 "$out/bin/"
      ln -s clang-16 "$out/bin/clang"
      ln -s clang-16 "$out/bin/clang++"
      cp -a lib/clang "$out/lib/"
      runHook postInstall
    '';
    passthru = {
      isClang = true;
      langC = true;
      langCC = true;
    };
    meta = {
      description = "OpenCilk compiler and parallel runtime";
      homepage = "https://www.opencilk.org/";
      license = lib.licenses.WITH lib.licenses.asl20 lib.licenses.llvm-exception;
      platforms = [ "x86_64-linux" ];
    };
  };
in
wrapCCWith {
  cc = compiler;
  isClang = true;
  gccForLibs = stdenv.cc.cc;
}
