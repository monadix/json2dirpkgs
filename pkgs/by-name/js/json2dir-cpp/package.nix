{
  lib,
  stdenv,
  j2dSources,
  gcc,
}:
let
  pname = "json2dir-cpp";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-7b28de5";
  src = j2dSources."json2dir-cpp";
  nativeBuildInputs = [ gcc ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    g++ -std=c++20 -O2 -Wall -o "$TMPDIR/out/json2dir" json2dir.cpp
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-cpp"
  '';
  meta = {
    description = "Modern C++ (C++20) in one file, standard library + POSIX, hand-written UTF-8 check and JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-cpp";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
