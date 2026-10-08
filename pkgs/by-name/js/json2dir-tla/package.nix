{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  gnugrep,
  gnused,
  bash,
  jre17_minimal,
  tlaplus18,
  j2dSources,
}:

let
  jre = jre17_minimal.override {
    modules = [
      "java.base"
      "java.management"
      "java.logging"
      "java.rmi"
      "java.naming"
      "java.xml"
    ];
  };
in
stdenvNoCC.mkDerivation {
  pname = "json2dir-tla";
  version = "2026-10-07";
  src = j2dSources.json2dir-tla;
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace json2dir \
      --replace-fail 'task_tmp=$(umask 077; mktemp ' 'original_umask=$(umask)
    umask 077
    task_tmp=$(mktemp ' \
      --replace-fail '"''${JSON2DIR_SHELL:-/bin/sh}" "$task_tmp/tree.sh"' 'umask "$original_umask"
    "''${JSON2DIR_SHELL:-/bin/sh}" "$task_tmp/tree.sh"'
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 json2dir "$out/share/$pname/json2dir"
    install -Dm644 Json2dir.tla "$out/share/$pname/Json2dir.tla"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    patchShebangs "$out/share/$pname"
    mkdir -p "$out/bin"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_JAVA "${jre}/bin/java" \
      --set JSON2DIR_TLA2TOOLS "${tlaplus18}/share/java/tla2tools.jar" \
      --set JSON2DIR_SHELL "${bash}/bin/bash" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          gnugrep
          gnused
          bash
        ]
      }"
    runHook postInstall
  '';

  meta = {
    description = "TLA+ (standard modules only) evaluated by TLC, emitting a shell script via a POSIX sh launcher; name safety, plan well-formedness, UTF-8 and parser invariants model-checked with TLC";
    homepage = "https://github.com/json2dir-guru/json2dir-tla";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-tla";
  };
}
