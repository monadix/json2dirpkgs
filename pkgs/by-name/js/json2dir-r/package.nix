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
  R,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-r";
  version = "2026-10-08";
  src = j2dSources.json2dir-r;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "${R}/bin/Rscript" "$out/bin/$pname" \
      --add-flags "--vanilla $out/share/$pname/json2dir.R" \
      --prefix PATH : "${
        lib.makeBinPath [
          R
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
    description = "json2dir-r upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-r";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-r";
  };
}
