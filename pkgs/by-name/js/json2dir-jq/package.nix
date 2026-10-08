{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  bash,
  j2dSources,
  jq,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-jq";
  version = "2026-10-07";
  src = j2dSources.json2dir-jq;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 json2dir "$out/share/$pname/json2dir"
    install -Dm644 json2dir.jq "$out/share/$pname/json2dir.jq"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    patchShebangs "$out/share/$pname"
    mkdir -p "$out/bin"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_JQ "${jq}/bin/jq" \
      --set JSON2DIR_SHELL "${bash}/bin/bash" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
        ]
      }"
    runHook postInstall
  '';

  meta = {
    description = "jq evaluator (hand-written strict UTF-8 check and JSON parser in jq, raw input) emitting a shell script, plus a POSIX sh launcher";
    homepage = "https://github.com/json2dir-guru/json2dir-jq";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-jq";
  };
}
