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
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-sed";
  version = "2026-10-08";
  src = j2dSources.json2dir-sed;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_SED "${gnused}/bin/sed" \
      --set JSON2DIR_SHELL "${bash}/bin/bash" \
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
    description = "json2dir-sed upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-sed";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-sed";
  };
}
