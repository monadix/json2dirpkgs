{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  ksh93,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-ksh";
  version = "2026-10-07";
  src = j2dSources.json2dir-ksh;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.ksh "$out/share/$pname/json2dir.ksh"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${ksh93}/bin/ksh" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.ksh"
    runHook postInstall
  '';

  meta = {
    description = "Pure ksh93u+m shell built-ins (including libcmd mkdir/ln/chmod/rm), one file";
    homepage = "https://github.com/json2dir-guru/json2dir-ksh";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-ksh";
  };
}
