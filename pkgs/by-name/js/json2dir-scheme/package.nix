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
  guile,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-scheme";
  version = "2026-10-08";
  src = j2dSources.json2dir-scheme;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set GUILE "${guile}/bin/guile" \
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
    description = "json2dir-scheme upstream implementation";
    homepage = "https://github.com/TheMaxMur/json2dir-scheme";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-scheme";
  };
}
