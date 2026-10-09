{
  lib,
  stdenv,
  j2dSources,
  gnumake,
  python3,
  llvmPackages_23,
}:
let
  pname = "json2dir-bimbo";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-f62a869";
  src = j2dSources.json2dir-bimbo;
  nativeBuildInputs = [
    gnumake
    python3
    llvmPackages_23.clang
  ];
  dontConfigure = true;
  buildPhase = "make PYTHON=${python3}/bin/python3 CLANG=${llvmPackages_23.clang}/bin/clang";
  installPhase = ''install -Dm755 build/json2dir "$out/bin/json2dir-bimbo"'';
  meta = {
    description = "Bimbo language implementation compiled through LLVM IR";
    homepage = "https://github.com/TheMaxMur/json2dir-bimbo";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
