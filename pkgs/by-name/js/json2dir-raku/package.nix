{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  rakudo,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-raku";
  version = "2026-10-07";
  src = j2dSources.json2dir-raku;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.raku "$out/share/$pname/json2dir.raku"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${rakudo}/bin/rakudo" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.raku"
    runHook postInstall
  '';

  meta = {
    description = "Raku (Rakudo on MoarVM), core only: JSON grammar, IO::Path";
    homepage = "https://github.com/json2dir-guru/json2dir-raku";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-raku";
  };
}
