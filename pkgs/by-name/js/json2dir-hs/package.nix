{
  lib,
  stdenv,
  j2dSources,
  haskellPackages,
}:
let
  pname = "json2dir-hs";
  compiler = haskellPackages.ghcWithPackages (p: [ p.aeson ]);
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-14e3661";
  src = j2dSources.json2dir-hs;
  nativeBuildInputs = [ compiler ];
  dontConfigure = true;
  buildPhase = ''ghc -O2 -outputdir "$TMPDIR/ghc" -o "$TMPDIR/json2dir-hs" json2dir-hs.hs'';
  installPhase = ''install -Dm755 "$TMPDIR/json2dir-hs" "$out/bin/json2dir-hs"'';
  meta = {
    description = "Haskell implementation of json2dir using aeson";
    homepage = "https://github.com/KovalevDima/json2dir-hs";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
