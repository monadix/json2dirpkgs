{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  bash,
  j2dSources,
  ngnk,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-k";
  version = "2026-10-07";
  src = j2dSources.json2dir-k;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 json2dir "$out/share/$pname/json2dir"
    install -Dm644 json2dir.k "$out/share/$pname/json2dir.k"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    patchShebangs "$out/share/$pname"
    mkdir -p "$out/bin"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_K "${ngnk}/bin/k" \
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
    description = "ngn/k evaluator (array-style UTF-8 check and JSON parser) emitting a shell script, plus a POSIX sh launcher";
    homepage = "https://github.com/json2dir-guru/json2dir-k";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-k";
  };
}
