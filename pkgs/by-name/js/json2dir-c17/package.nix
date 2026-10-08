{
  lib,
  stdenv,
  j2dSources,
  gcc,
}:
let
  pname = "json2dir-c17";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-ae747f5";
  src = j2dSources."json2dir-c17";
  nativeBuildInputs = [ gcc ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    gcc -std=c17 -pedantic-errors -Wall -Wextra -O2 -o "$TMPDIR/out/json2dir" json2dir.c
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-c17"
  '';
  meta = {
    description = "ISO C17 + POSIX in one file (_Generic, _Static_assert, anonymous unions, char32_t), gcc -std=c17 -pedantic-errors, hand-written UTF-8 check and JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-c17";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
