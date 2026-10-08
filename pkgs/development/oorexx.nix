{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ncurses,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "oorexx";
  version = "5.3.0";
  src = fetchFromGitHub {
    owner = "ooRexx";
    repo = "oorexx";
    rev = "de1db87f486d430d1faa9151b8a2d5f328ab70f2";
    hash = "sha256-QPdQdILYvjMOtoM2HWWPhBbjnYe7c5tJ5pgWXCN6Xww=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [ ncurses ];
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DORX_ENABLE_IPO=OFF"
  ];

  postFixup = ''
    wrapProgram "$out/bin/rexx" --prefix REXX_PATH : "$out/lib"
  '';

  meta = {
    description = "Open Object Rexx interpreter";
    homepage = "https://www.oorexx.org/";
    license = lib.licenses.cpl10;
    platforms = [ "x86_64-linux" ];
    mainProgram = "rexx";
  };
}
