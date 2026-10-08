{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  scala,
  jdk,
  headless-jre,
}:
let
  pname = "json2dir-scala";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-6fe7732";
  src = j2dSources."json2dir-scala";
  nativeBuildInputs = [
    makeWrapper
    scala
    jdk
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/out" "$TMPDIR/classes"
    scalac -d "$TMPDIR/classes" json2dir.scala
  '';
  installPhase = ''
    mkdir -p "$out/bin" "$out/share/classes" "$out/share/lib"
    cp -r "$TMPDIR/classes"/. "$out/share/classes/"
    install -Dm644 "${scala.bare}/maven2/org/scala-lang/scala-library/${scala.version}/scala-library-${scala.version}.jar" "$out/share/lib/scala-library.jar"
    install -Dm644 "${scala.bare}/maven2/org/scala-lang/scala3-library_3/${scala.version}/scala3-library_3-${scala.version}.jar" "$out/share/lib/scala3-library.jar"
    makeWrapper ${headless-jre}/bin/java "$out/bin/${pname}" \
      --add-flags "-XX:TieredStopAtLevel=1 -XX:+UseSerialGC -cp $out/share/classes:$out/share/lib/scala-library.jar:$out/share/lib/scala3-library.jar json2dir"
  '';
  meta = {
    description = "Scala 3 (JVM), one source file, stdlib + JDK only with a hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-scala";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
