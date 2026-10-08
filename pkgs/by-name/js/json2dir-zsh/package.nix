{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  zsh,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-zsh";
  version = "2026-10-07";
  src = j2dSources.json2dir-zsh;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.zsh "$out/share/$pname/json2dir.zsh"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${zsh}/bin/zsh" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.zsh"
    runHook postInstall
  '';

  meta = {
    description = "Pure zsh (builtins plus zsh/system, zsh/files, zsh/stat modules), one file";
    homepage = "https://github.com/json2dir-guru/json2dir-zsh";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-zsh";
  };
}
