{
  lib,
  stdenv,
  j2dSources,
  ghc,
}:
let
  pname = "json2dir-haskell";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-25f6fc2";
  src = j2dSources."json2dir-haskell";
  nativeBuildInputs = [ ghc ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    ghc -O -outputdir "$TMPDIR/ghc" -o "$TMPDIR/out/json2dir" json2dir.hs
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-haskell"
  '';
  meta = {
    description = "Haskell (GHC 9.6, base/bytestring/containers/unix only), hand-written strict JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-haskell";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
