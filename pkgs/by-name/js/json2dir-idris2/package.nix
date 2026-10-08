{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  idris2,
  chez,
  coreutils,
}:
let
  pname = "json2dir-idris2";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-f0d004d";
  src = j2dSources."json2dir-idris2";
  nativeBuildInputs = [
    makeWrapper
    idris2
    chez
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    idris2 --source-dir src --build-dir "$TMPDIR/idris" -o json2dir src/Main.idr
  '';
  installPhase = ''
    mkdir -p "$out/libexec" "$out/bin"
    cp -r "$TMPDIR/idris/exec"/. "$out/libexec/"
    makeWrapper "$out/libexec/json2dir" "$out/bin/${pname}" \
      --prefix PATH : ${
        lib.makeBinPath [
          chez
          coreutils
        ]
      }
  '';
  meta = {
    description = "Idris 2 0.8.0 on Chez Scheme: total UTF-8 check, JSON parser and validation; names carry a proof that they are simple; libc via the FFI";
    homepage = "https://github.com/json2dir-guru/json2dir-idris2";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
