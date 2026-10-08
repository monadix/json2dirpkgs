{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  coreutils,
  lean4,
}:
let
  pname = "json2dir-lean";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-48e2c5b";
  src = j2dSources."json2dir-lean";
  nativeBuildInputs = [
    makeWrapper
    lean4
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    lake build
  '';
  installPhase = ''
    mkdir -p "$out/bin" "$out/libexec"
    install -Dm755 .lake/build/bin/json2dir "$out/libexec/json2dir"
    makeWrapper "$out/libexec/json2dir" "$out/bin/${pname}" \
      --prefix PATH : ${coreutils}/bin
  '';
  meta = {
    description = "Lean 4 port with proofs for key parsing and value classification";
    homepage = "https://github.com/tsalkenov/json2dir-lean";
    license = lib.licenses.wtfpl;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
