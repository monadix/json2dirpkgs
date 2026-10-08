{
  stdenv,
  lib,
  cforall,
  j2dSources,
}:
let
  pname = "json2dir-cforall";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ cforall ];

  buildPhase = ''
    mkdir -p out
    cfa -nodebug -O2 json2dir.cfa -o out/json2dir
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "Cforall implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
