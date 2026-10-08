{
  lib,
  stdenvNoCC,
  makeWrapper,
  coreutils,
  bash,
  gawk,
  j2dSources,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-awk";
  version = "2026-10-07";
  src = j2dSources.json2dir-awk;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -Dm755 json2dir "$out/share/$pname/json2dir"
    install -Dm644 json2dir.awk "$out/share/$pname/json2dir.awk"
    patchShebangs "$out/share/$pname"
    mkdir -p "$out/bin"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_GAWK "${gawk}/bin/gawk" \
      --set JSON2DIR_SHELL "${bash}/bin/bash" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
        ]
      }"
    runHook postInstall
  '';

  meta = {
    description = "GNU awk implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/json2dir-awk";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-awk";
  };
}
