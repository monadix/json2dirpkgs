{
  lib,
  stdenv,
  fetchurl,
  gnutar,
  gzip,
  gmp,
  zstd,
  autoPatchelfHook,
}:
stdenv.mkDerivation {
  pname = "fstar";
  version = "2026.09.27";
  src = fetchurl {
    url = "https://github.com/FStarLang/FStar/releases/download/v2026.09.27/fstar-v2026.09.27-Linux-x86_64.tar.gz";
    hash = "sha256-yvu7iWDv6yb10wvER7YauKUHlolIUHolgFha/ROXeB0=";
  };
  nativeBuildInputs = [
    gnutar
    gzip
    autoPatchelfHook
  ];
  buildInputs = [
    gmp
    zstd
  ];
  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out"
    tar -xzf "$src" -C "$TMPDIR"
    cp -r "$TMPDIR/fstar/." "$out/"
  '';
  meta = {
    description = "F* compiler release with its bundled runtime and Z3 solvers";
    homepage = "https://github.com/FStarLang/FStar";
    license = lib.licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
}
