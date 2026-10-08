{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  bash,
  j2dSources,
  snobol4,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-snobol4";
  version = "2026-10-07";
  src = j2dSources.json2dir-snobol4;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 json2dir "$out/share/$pname/json2dir"
    install -Dm644 json2dir.sno "$out/share/$pname/json2dir.sno"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    patchShebangs "$out/share/$pname"
    mkdir -p "$out/bin"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_SNOBOL4 "${snobol4}/bin/snobol4" \
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
    description = "SNOBOL4 evaluator (CSNOBOL4 2.3.4, recursive patterns) emitting a shell script, plus a POSIX sh launcher";
    homepage = "https://github.com/json2dir-guru/json2dir-snobol4";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-snobol4";
  };
}
