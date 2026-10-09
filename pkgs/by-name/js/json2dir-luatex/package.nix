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
  texlive,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-luatex";
  version = "2026-10-08";
  src = j2dSources.json2dir-luatex;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_LUATEX "${texlive.combined.scheme-basic}/bin/luatex" \
      --set JSON2DIR_EVALUATOR "$out/share/$pname/json2dir.tex" \
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
    description = "json2dir-luatex upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-luatex";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-luatex";
  };
}
