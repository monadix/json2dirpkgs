{
  lib,
  stdenv,
  j2dSources,
  agda,
  gnumake,
  haskellPackages,
}:
let
  pname = "json2dir-agda";
  ghcEnv = haskellPackages.ghcWithPackages (p: [ p.ieee754 ]);
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-8d57b92";
  src = j2dSources.json2dir-agda;
  nativeBuildInputs = [
    agda
    ghcEnv
    gnumake
  ];
  dontConfigure = true;
  buildPhase = "make AGDA=${agda}/bin/agda";
  installPhase = ''install -Dm755 json2dir "$out/bin/json2dir-agda"'';
  meta = {
    description = "Agda implementation of json2dir compiled through GHC";
    homepage = "https://github.com/TheMaxMur/json2dir-agda";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
