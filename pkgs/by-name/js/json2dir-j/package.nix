{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  j,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-j";
  version = "2026-10-07";
  src = j2dSources.json2dir-j;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.ijs "$out/share/$pname/json2dir.ijs"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${j}/bin/jconsole" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.ijs"
    runHook postInstall
  '';

  meta = {
    description = "J (jsoftware J9), base library only; hand-written JSON parser, libc via 15!:0";
    homepage = "https://github.com/json2dir-guru/json2dir-j";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-j";
  };
}
