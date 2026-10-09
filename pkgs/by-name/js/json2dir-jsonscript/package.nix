{
  lib,
  buildNpmPackage,
  j2dSources,
  nodejs,
  makeWrapper,
}:

buildNpmPackage {
  pname = "json2dir-jsonscript";
  version = "2026-10-08";
  src = j2dSources.json2dir-jsonscript;
  npmDepsHash = "sha256-jBHMWPrTXUCELzaqBspKw5yYBTvAw6qWmJSF3ua9r9Y=";
  dontNpmBuild = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    cp -R node_modules "$out/share/$pname/"
    makeWrapper "${nodejs}/bin/node" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/run.js" \
      --set NODE_PATH "$out/share/$pname/node_modules"
    runHook postInstall
  '';

  meta = {
    description = "json2dir implemented in JSONScript and run by jsonscript-js";
    homepage = "https://github.com/json2dir-guru/json2dir-jsonscript";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-jsonscript";
  };
}
