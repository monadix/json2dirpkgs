{
  lib,
  stdenvNoCC,
  makeWrapper,
  oorexx,
  j2dSources,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-rexx";
  version = "2026-10-07";
  src = j2dSources.json2dir-rexx;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.rex "$out/share/$pname/json2dir.rex"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${oorexx}/bin/rexx" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.rex"
    runHook postInstall
  '';

  meta = {
    description = "Open Object Rexx implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/json2dir-rexx";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-rexx";
  };
}
