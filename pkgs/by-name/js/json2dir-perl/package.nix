{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  perl,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-perl";
  version = "2026-10-07";
  src = j2dSources.json2dir-perl;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.pl "$out/share/$pname/json2dir.pl"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${perl}/bin/perl" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.pl"
    runHook postInstall
  '';

  meta = {
    description = "Perl 5, core only, hand-written JSON parser, one file";
    homepage = "https://github.com/json2dir-guru/json2dir-perl";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-perl";
  };
}
