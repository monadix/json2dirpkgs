{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  php,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-php";
  version = "2026-10-07";
  src = j2dSources.json2dir-php;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.php "$out/share/$pname/json2dir.php"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${php}/bin/php" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.php"
    runHook postInstall
  '';

  meta = {
    description = "Core PHP 8.1 (built-in json_decode), one file";
    homepage = "https://github.com/json2dir-guru/json2dir-php";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-php";
  };
}
