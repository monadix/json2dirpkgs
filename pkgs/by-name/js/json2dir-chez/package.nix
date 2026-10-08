{
  lib,
  stdenvNoCC,
  makeWrapper,
  chez,
  j2dSources,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-chez";
  version = "2026-10-07";
  src = j2dSources.json2dir-chez;
  nativeBuildInputs = [
    makeWrapper
    chez
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p "$NIX_BUILD_TOP/chez-build"
    cp "$src/json2dir.ss" "$NIX_BUILD_TOP/chez-build/"
    cd "$NIX_BUILD_TOP/chez-build"
    printf '%s\n' '(compile-program "json2dir.ss")' | "${chez}/bin/scheme" -q
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 "$src/json2dir.ss" "$out/share/$pname/json2dir.ss"
    install -Dm644 "$NIX_BUILD_TOP/chez-build/json2dir.so" "$out/share/$pname/json2dir.so"
    install -Dm644 "$src/LICENSE" "$out/share/licenses/$pname/LICENSE"
    mkdir -p "$out/bin"
    makeWrapper "${chez}/bin/scheme" "$out/bin/$pname" \
      --add-flags "--program $out/share/$pname/json2dir.so"
    runHook postInstall
  '';

  meta = {
    description = "Chez Scheme 10.4.1, one file, hand-written parser, FFI to libc";
    homepage = "https://github.com/json2dir-guru/json2dir-chez";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-chez";
  };
}
