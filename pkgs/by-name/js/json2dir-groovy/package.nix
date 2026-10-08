{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  groovy,
  jdk,
  headless-jre-desktop,
}:
let
  pname = "json2dir-groovy";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-627c473";
  src = j2dSources."json2dir-groovy";
  nativeBuildInputs = [
    makeWrapper
    groovy
    jdk
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/classes"
    groovyc -d "$TMPDIR/classes" json2dir.groovy
  '';
  installPhase = ''
    mkdir -p "$out/share/classes" "$out/share/lib" "$out/share/licenses/groovy"
    cp -r "$TMPDIR/classes"/. "$out/share/classes/"
    cp "${groovy}/lib/groovy-${groovy.version}.jar" "$out/share/lib/groovy.jar"
    cp "${groovy}/share/doc/groovy/LICENSE" "${groovy}/share/doc/groovy/NOTICE" "$out/share/licenses/groovy/"
    makeWrapper ${headless-jre-desktop}/bin/java "$out/bin/${pname}" \
      --add-flags "-XX:TieredStopAtLevel=1 -XX:+UseSerialGC -cp $out/share/classes:$out/share/lib/groovy.jar Json2dir"
  '';
  meta = {
    description = "Groovy 5 (@CompileStatic, compiled with groovyc), one source file, Groovy + JDK only with a hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-groovy";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
