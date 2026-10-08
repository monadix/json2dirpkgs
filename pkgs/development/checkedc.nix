{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  wrapCCWith,
}:
let
  compiler = stdenv.mkDerivation {
    pname = "checkedc-unwrapped";
    version = "12.0.2";
    src = fetchurl {
      url = "https://github.com/checkedc/checkedc-llvm-project/releases/download/CheckedC-Clang-12.0.2/CheckedC-Clang-12.0.2-gnu-ubuntu-22.04.tar.gz";
      hash = "sha256-obXyBZvCzrz3Rj38jFzF6Zgf+V8lJGob+khLp06ivAs=";
    };
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ stdenv.cc.cc.lib ];
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin" "$out/lib"
      cp bin/clang-12 "$out/bin/"
      ln -s clang-12 "$out/bin/clang"
      ln -s clang-12 "$out/bin/clang++"
      cp -a lib/clang "$out/lib/"
      runHook postInstall
    '';
    passthru = {
      isClang = true;
      langC = true;
      langCC = true;
    };
    meta = {
      description = "Checked C extension of Clang";
      homepage = "https://github.com/checkedc/checkedc-llvm-project";
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
