{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ncurses,
  libbsd,
}:
stdenv.mkDerivation {
  pname = "cfunge";
  version = "1.001-unstable-2026-10-08";
  src = fetchFromGitHub {
    owner = "VorpalBlade";
    repo = "cfunge";
    rev = "29e4cfa1cc1f4553bf0e2908f819e913c32dfda8";
    hash = "sha256-Vb1Cg4h+uDk4I8XFnTnoS1LsHQVH1xg58wDpEeZF/R8=";
  };
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    ncurses
    libbsd
  ];
  postPatch = ''
        substituteInPlace lib/genx/genx.c \
          --replace-fail '#include <string.h>' '#include <string.h>
    #include <bsd/string.h>'
        substituteInPlace src/prng.c \
          --replace-fail '#if defined(HAVE_arc4random_buf) && defined(HAVE_arc4random_stir)' '#if 0 /* glibc declares arc4random_buf but does not provide arc4random_stir */'
  '';
  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DCMAKE_EXE_LINKER_FLAGS=-lbsd"
  ];
  meta = {
    description = "Cfunge Funge-98 interpreter";
    homepage = "https://github.com/VorpalBlade/cfunge";
    license = lib.licenses.gpl3Plus;
    mainProgram = "cfunge";
    platforms = [ "x86_64-linux" ];
  };
}
