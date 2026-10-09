{
  lib,
  stdenv,
  j2dSources,
  ats2,
  gnumake,
  gcc,
}:
let
  pname = "json2dir-ats";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-ef3ee2f";
  src = j2dSources.json2dir-ats;
  nativeBuildInputs = [
    ats2
    gnumake
    gcc
  ];
  dontConfigure = true;
  buildPhase = ''
    export PATSHOME=${ats2}/lib/ats2-postiats-0.4.2
    export PATH=${ats2}/bin:$PATH
    make PATSCC=${ats2}/bin/patscc ATSFLAGS="-O2 -D_DEFAULT_SOURCE"
  '';
  installPhase = ''install -Dm755 build/json2dir "$out/bin/json2dir-ats"'';
  meta = {
    description = "ATS2 implementation of json2dir";
    homepage = "https://github.com/TheMaxMur/json2dir-ats";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
