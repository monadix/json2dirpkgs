{
  lib,
  stdenv,
  j2dSources,
  gm2,
  glibc,
}:
let
  pname = "json2dir-modula2";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-f7e20c6";
  src = j2dSources."json2dir-modula2";
  nativeBuildInputs = [ gm2 ];
  buildInputs = [ glibc.static ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    # GNU Modula-2's libc definition exposes the variadic open as three arguments.
    substituteInPlace json2dir.mod \
      --replace-fail 'libc.open(m^.name, ORdOnly + ODirectory + ONoFollow)' \
                     'libc.open(m^.name, ORdOnly + ODirectory + ONoFollow, 0)'
    PATH=/nonexistent ${gm2}/bin/gm2 -static -O2 -I"$PWD" json2dir.mod -o "$TMPDIR/out/json2dir" -lm
    PATH=/nonexistent ${gm2}/bin/gm2 -I"$PWD" -c json2dir.mod -o "$TMPDIR/out/json2dir.o"
    PATH=/nonexistent ${gm2}/bin/gm2 -O2 -I"$PWD" json2dir.mod -o "$TMPDIR/out/json2dir-dynamic" -lm
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-modula2"
  '';
  meta = {
    description = "Modula-2 (GNU Modula-2, PIM) with hand-written JSON parser and libc bindings";
    homepage = "https://github.com/json2dir-guru/json2dir-modula2";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
