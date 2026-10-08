{
  lib,
  stdenv,
  j2dSources,
  gfortran,
}:
let
  pname = "json2dir-fortran";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-5506161";
  src = j2dSources."json2dir-fortran";
  nativeBuildInputs = [ gfortran ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    gfortran -std=f2008 -O2 -static-libgfortran json2dir.f90 -o "$TMPDIR/out/json2dir"
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-fortran"
  '';
  meta = {
    description = "Modern Fortran (2008+) with ISO_C_BINDING, one file";
    homepage = "https://github.com/json2dir-guru/json2dir-fortran";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
