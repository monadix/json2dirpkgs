{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  powershell,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-pwsh";
  version = "2026-10-07";
  src = j2dSources.json2dir-pwsh;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.ps1 "$out/share/$pname/json2dir.ps1"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${powershell}/bin/pwsh" "$out/bin/$pname" \
      --add-flags "-NoProfile -NonInteractive -File $out/share/$pname/json2dir.ps1"
    runHook postInstall
  '';

  meta = {
    description = "Pure PowerShell 7 with a hand-written JSON parser, one file";
    homepage = "https://github.com/json2dir-guru/json2dir-pwsh";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-pwsh";
  };
}
