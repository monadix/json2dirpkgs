{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  nodejs,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-js";
  version = "2026-10-07";
  src = j2dSources.json2dir-js;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.js "$out/share/$pname/json2dir.js"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${nodejs}/bin/node" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.js"
    runHook postInstall
  '';

  meta = {
    description = "Plain JavaScript on Node.js, one file";
    homepage = "https://github.com/json2dir-guru/json2dir-js";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-js";
  };
}
