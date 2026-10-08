{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  kotlin,
  jdk,
  headless-jre,
}:
let
  pname = "json2dir-kotlin";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-dbfc810";
  src = j2dSources."json2dir-kotlin";
  nativeBuildInputs = [
    makeWrapper
    kotlin
    jdk
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out"
    kotlinc json2dir.kt -include-runtime -d "$TMPDIR/out/json2dir.jar"
  '';
  installPhase = ''
    mkdir -p "$out/share"
    install -Dm644 "$TMPDIR/out/json2dir.jar" "$out/share/json2dir.jar"
    makeWrapper ${headless-jre}/bin/java "$out/bin/${pname}" --add-flags "-XX:TieredStopAtLevel=1 -XX:+UseSerialGC -jar $out/share/json2dir.jar"
  '';
  meta = {
    description = "Kotlin (JVM), one source file, stdlib + JDK only with a hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-kotlin";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
