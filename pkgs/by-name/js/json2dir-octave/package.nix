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
  octave,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-octave";
  version = "2026-10-08";
  src = j2dSources.json2dir-octave;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "${octave}/bin/octave" "$out/bin/$pname" \
      --add-flags "--no-gui --quiet --no-init-file $out/share/$pname/json2dir.m" \
      --prefix PATH : "${
        lib.makeBinPath [
          octave
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
    description = "json2dir-octave upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-octave";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-octave";
  };
}
