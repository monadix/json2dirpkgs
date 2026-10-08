{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  swi-prolog,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-prolog";
  version = "2026-10-07";
  src = j2dSources.json2dir-prolog;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.pl "$out/share/$pname/json2dir.pl"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${swi-prolog}/bin/swipl" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.pl"
    runHook postInstall
  '';

  meta = {
    description = "SWI-Prolog, one file, hand-written DCG JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-prolog";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-prolog";
  };
}
