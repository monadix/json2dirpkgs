{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  clojure,
  jdk,
  headless-jre,
  unzip,
}:
let
  pname = "json2dir-clojure";
  clojureJar = "${clojure}/libexec/clojure-tools-${clojure.version}.jar";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-1cd5b8b";
  src = j2dSources."json2dir-clojure";
  nativeBuildInputs = [
    makeWrapper
    clojure
    jdk
    unzip
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    mkdir -p "$TMPDIR/classes"
    java -Dclojure.compile.path="$TMPDIR/classes" \
      -cp "${clojureJar}:$PWD/src:$TMPDIR/classes" \
      clojure.main -e "(compile 'json2dir.core)"
  '';
  installPhase = ''
    mkdir -p "$out/share/classes" "$out/share/lib" "$out/share/licenses/clojure"
    cp -r "$TMPDIR/classes"/. "$out/share/classes/"
    cp "${clojureJar}" "$out/share/lib/clojure-tools.jar"
    unzip -p "$out/share/lib/clojure-tools.jar" LICENSE > "$out/share/licenses/clojure/LICENSE"
    makeWrapper ${headless-jre}/bin/java "$out/bin/${pname}" \
      --add-flags "-XX:TieredStopAtLevel=1 -XX:+UseSerialGC -cp $out/share/classes:$out/share/lib/clojure-tools.jar json2dir.core"
  '';
  meta = {
    description = "json2dir in Clojure: clojure.core and JDK interop only, hand-written JSON parser, AOT-compiled";
    homepage = "https://github.com/json2dir-guru/json2dir-clojure";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
