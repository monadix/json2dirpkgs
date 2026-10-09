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
  typst,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-thesis";
  version = "2026-10-08";
  src = j2dSources.json2dir-thesis;
  nativeBuildInputs = [
    makeWrapper
    typst
  ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "$out/share/$pname/bin/json2dir" "$out/bin/$pname" \
      --prefix PATH : "${
        lib.makeBinPath [
          typst
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
    description = "json2dir-thesis upstream implementation";
    homepage = "https://github.com/TheMaxMur/json2dir-thesis";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-thesis";
  };
}
