{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  python3,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-python";
  version = "2026-10-07";
  src = j2dSources.json2dir-python;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.py "$out/share/$pname/json2dir.py"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${python3}/bin/python3" "$out/bin/$pname" \
      --add-flags "-I $out/share/$pname/json2dir.py"
    runHook postInstall
  '';

  meta = {
    description = "Python 3 standard library only, one file";
    homepage = "https://github.com/json2dir-guru/json2dir-python";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-python";
  };
}
