{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  cbqn,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-bqn";
  version = "2026-10-07";
  src = j2dSources.json2dir-bqn;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.bqn "$out/share/$pname/json2dir.bqn"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${cbqn}/bin/BQN" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.bqn"
    runHook postInstall
  '';

  meta = {
    description = "BQN on CBQN, array-style UTF-8/JSON validation, \u2022file plus \u2022FFI to libc";
    homepage = "https://github.com/json2dir-guru/json2dir-bqn";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-bqn";
  };
}
