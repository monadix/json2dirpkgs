{
  lib,
  stdenv,
  j2dSources,
  gnumake,
  llvmPackages_23,
}:
let
  pname = "json2dir-llvm-IR";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-64616eb";
  src = j2dSources.json2dir-llvm-IR;
  nativeBuildInputs = [
    gnumake
    llvmPackages_23.clang
  ];
  dontConfigure = true;
  buildPhase = "make CLANG=${llvmPackages_23.clang}/bin/clang";
  installPhase = ''install -Dm755 json2dir "$out/bin/json2dir-llvm-IR"'';
  meta = {
    description = "Handwritten textual LLVM IR json2dir implementation";
    homepage = "https://github.com/TheMaxMur/json2dir-llvm-IR";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
