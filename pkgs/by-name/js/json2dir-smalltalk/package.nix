{
  lib,
  stdenvNoCC,
  makeWrapper,
  j2dSources,
  gnu-smalltalk,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-smalltalk";
  version = "2026-10-07";
  src = j2dSources.json2dir-smalltalk;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm644 json2dir.st "$out/share/$pname/json2dir.st"
    install -Dm644 LICENSE "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${gnu-smalltalk}/bin/gst" "$out/bin/$pname" \
      --add-flags "-q -f $out/share/$pname/json2dir.st"
    runHook postInstall
  '';

  meta = {
    description = "GNU Smalltalk (gst 3.2.5), core classes only, one file";
    homepage = "https://github.com/json2dir-guru/json2dir-smalltalk";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-smalltalk";
  };
}
