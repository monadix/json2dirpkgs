{
  lib,
  stdenvNoCC,
  makeWrapper,
  racket,
  j2dSources,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-racket";
  version = "2026-10-07";
  src = j2dSources.json2dir-racket;
  nativeBuildInputs = [
    makeWrapper
    racket
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p build
    cp "$src/json2dir.rkt" build/
    "${racket}/bin/raco" make build/json2dir.rkt
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 "$src/json2dir.rkt" "$out/share/$pname/json2dir.rkt"
    cp -r build/compiled "$out/share/$pname/"
    install -Dm644 "$src/LICENSE" "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${racket}/bin/racket" "$out/bin/$pname" \
      --add-flags "$out/share/$pname/json2dir.rkt"
    runHook postInstall
  '';

  meta = {
    description = "Racket (racket/base only), hand-written JSON parser over bytes, compiled .zo";
    homepage = "https://github.com/json2dir-guru/json2dir-racket";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-racket";
  };
}
