{
  stdenv,
  lib,
  gnucobol,
  j2dSources,
}:
let
  pname = "json2dir-cobol";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ gnucobol.bin ];
  buildInputs = [ gnucobol.lib ];

  buildPhase = ''
    mkdir -p out
    cobc -x -O json2dir.cob -o out/json2dir
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "GnuCOBOL implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
