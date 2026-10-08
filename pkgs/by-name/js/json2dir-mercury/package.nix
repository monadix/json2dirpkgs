{
  stdenv,
  lib,
  mercury,
  j2dSources,
}:
let
  pname = "json2dir-mercury";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ mercury ];

  buildPhase = ''
    mkdir -p out
    cp json2dir.m out/
    (cd out && mmc --grade hlc.gc --make json2dir)
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "Mercury implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
