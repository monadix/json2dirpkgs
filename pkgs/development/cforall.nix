{
  stdenv,
  lib,
  fetchFromGitHub,
  bison,
  flex,
  libtool,
  python3,
}:
stdenv.mkDerivation {
  pname = "cforall";
  version = "1.0.0-unstable-e259f63";
  src = fetchFromGitHub {
    owner = "cforall";
    repo = "cforall";
    rev = "e259f637e19be21d9a0646abc74900ba2dd8b47c";
    hash = "sha256-S4vQ81WNsRz/Ck4FA/Fy5+6fCMGAupfHt9iWXi4ul+U=";
  };
  nativeBuildInputs = [
    bison
    flex
    libtool
    python3
  ];
  patches = [ ./patches/cforall-glibc-compat.patch ];
  patchFlags = [
    "-p1"
    "--fuzz=0"
  ];
  # CFA rules emit dependency files even when Automake tracking is disabled.
  dontAddDisableDepTrack = true;
  configureFlags = [
    "--with-target-hosts=x86_64:nodebug"
    "--disable-gprofiler"
  ];
  enableParallelBuilding = true;
  meta = {
    description = "Cforall compiler and standard library";
    homepage = "https://cforall.uwaterloo.ca/";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    mainProgram = "cfa";
  };
}
