{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  jdk,
  headless-jre,
}:
let
  pname = "json2dir-java";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-a73f6c4";
  src = j2dSources."json2dir-java";
  nativeBuildInputs = [
    makeWrapper
    jdk
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    javac -d "$TMPDIR/classes" Json2dir.java
  '';
  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/classes"; cp -r "$TMPDIR/classes"/. "$out/share/classes/"; makeWrapper ${headless-jre}/bin/java "$out/bin/json2dir-java" --add-flags "-XX:TieredStopAtLevel=1 -XX:+UseSerialGC -cp $out/share/classes Json2dir"
  '';
  meta = {
    description = "Java 21, one source file, JDK only with a hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-java";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
