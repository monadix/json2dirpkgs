{
  stdenv,
  lib,
  compcert,
  j2dSources,
}:
let
  pname = "json2dir-compcert";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ compcert ];

  buildPhase = ''
    mkdir -p out
    ccomp -O -o out/json2dir json2dir.c
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "CompCert C implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
