{
  lib,
  stdenv,
  j2dSources,
  sbcl,
}:
let
  pname = "json2dir-commonlisp";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-c004c72";
  src = j2dSources."json2dir-commonlisp";
  nativeBuildInputs = [ sbcl ];
  dontStrip = true; # SBCL appends its executable core to the ELF; stripping removes that payload.
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    sbcl --noinform --non-interactive --no-sysinit --no-userinit --eval '(with-compilation-unit () (load "json2dir.lisp"))' --eval "(sb-ext:save-lisp-and-die \"$TMPDIR/out/json2dir\" :executable t :toplevel (function json2dir:main) :save-runtime-options t)"
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm755 "$TMPDIR/out/json2dir" "$out/bin/json2dir-commonlisp"
  '';
  meta = {
    description = "Common Lisp on SBCL with sb-posix, saved as an executable core";
    homepage = "https://github.com/json2dir-guru/json2dir-commonlisp";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
