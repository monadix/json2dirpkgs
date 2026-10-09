{
  lib,
  stdenvNoCC,
  makeWrapper,
  bash,
  gnugrep,
  findutils,
  gnused,
  coreutils,
  j2dSources,
  uiua,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-uiua";
  version = "2026-10-08";
  src = j2dSources.json2dir-uiua;
  nativeBuildInputs = [
    makeWrapper
    uiua
  ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "$out/share/$pname/bin/json2dir" "$out/bin/$pname" \
      --set UIUA "${uiua}/bin/uiua" \
      --set UIUA_RECURSION_LIMIT 1000 \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
          gnugrep
          findutils
          gnused
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "json2dir-uiua upstream implementation";
    homepage = "https://github.com/TheMaxMur/json2dir-uiua";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-uiua";
  };
}
