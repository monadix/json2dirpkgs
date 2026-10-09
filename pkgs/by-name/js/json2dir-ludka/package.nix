{
  lib,
  stdenv,
  j2dSources,
  gnumake,
  python3,
  llvmPackages_23,
}:
let
  pname = "json2dir-ludka";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-d45ea9a";
  src = j2dSources.json2dir-ludka;
  nativeBuildInputs = [
    gnumake
    python3
    llvmPackages_23.clang
  ];
  dontConfigure = true;
  buildPhase = "make PYTHON=${python3}/bin/python3 CLANG=${llvmPackages_23.clang}/bin/clang";
  installPhase = ''install -Dm755 build/json2dir "$out/bin/json2dir-ludka"'';
  meta = {
    description = "Ludka trade language implementation compiled through LLVM IR";
    homepage = "https://github.com/TheMaxMur/json2dir-ludka";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
