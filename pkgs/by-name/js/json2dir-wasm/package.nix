{
  lib,
  stdenvNoCC,
  makeWrapper,
  wabt,
  bun,
  j2dSources,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-wasm";
  version = "2026-10-07";
  src = j2dSources.json2dir-wasm;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/$pname"
    install -Dm644 run.js "$out/share/$pname/run.js"
    mkdir -p "$out/share/$pname/out"
    "${wabt}/bin/wat2wasm" -o "$out/share/$pname/out/json2dir.wasm" json2dir.wat
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${bun}/bin/bun" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/run.js"
    runHook postInstall
  '';

  meta = {
    description = "Hand-written WebAssembly text (WASI preview1) run by Bun, with a hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-wasm";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-wasm";
  };
}
