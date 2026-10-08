{
  stdenv,
  lib,
  gobo,
  j2dSources,
}:
let
  pname = "json2dir-eiffel";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ gobo ];

  buildPhase = ''
    mkdir -p out
    cd out
    GOBO=${gobo} gec ../json2dir.ecf
  '';

  installPhase = ''
    install -Dm755 json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "Eiffel implementation of json2dir using Gobo gec";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
