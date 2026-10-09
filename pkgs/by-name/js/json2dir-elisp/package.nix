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
  emacs,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-elisp";
  version = "2026-10-08";
  src = j2dSources.json2dir-elisp;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "${emacs}/bin/emacs" "$out/bin/$pname" \
      --add-flags "-Q --script $out/share/$pname/json2dir.el --" \
      --prefix PATH : "${
        lib.makeBinPath [
          emacs
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
    description = "json2dir-elisp upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-elisp";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-elisp";
  };
}
