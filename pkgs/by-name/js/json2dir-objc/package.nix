{
  lib,
  stdenv,
  j2dSources,
  clang,
  gnu-libobjc,
}:
let
  pname = "json2dir-objc";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-3b619ea";
  src = j2dSources."json2dir-objc";
  nativeBuildInputs = [ clang ];
  buildInputs = [ gnu-libobjc ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    clang -fobjc-runtime=gcc -I${gnu-libobjc}/include -L${gnu-libobjc}/lib \
      -Wl,-rpath,${gnu-libobjc}/lib -O2 -Wall -o "$TMPDIR/out/json2dir" json2dir.m -lobjc
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-objc"
  '';
  meta = {
    description = "Objective-C on the bare GNU libobjc runtime (own root class, no Foundation), one file";
    homepage = "https://github.com/json2dir-guru/json2dir-objc";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
