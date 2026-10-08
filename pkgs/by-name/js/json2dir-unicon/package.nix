{
  stdenv,
  lib,
  unicon-lang,
  j2dSources,
}:
let
  pname = "json2dir-unicon";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ unicon-lang ];

  buildPhase = ''
    mkdir -p out
    unicon -s -o out/json2dir json2dir.icn
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "Unicon implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
