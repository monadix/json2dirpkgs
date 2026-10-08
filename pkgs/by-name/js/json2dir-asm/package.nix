{
  stdenv,
  lib,
  jwasm,
  j2dSources,
}:
let
  pname = "json2dir-asm";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ jwasm ];

  buildPhase = ''
    mkdir -p out
    jwasm -q -bin -Fo=out/json2dir.bin json2dir.asm
    mv out/json2dir.bin out/json2dir
    chmod +x out/json2dir
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "x86-64 Linux assembly implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
