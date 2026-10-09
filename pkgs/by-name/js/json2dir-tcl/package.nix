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
  tcl,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-tcl";
  version = "2026-10-08";
  src = j2dSources.json2dir-tcl;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "${tcl}/bin/tclsh" "$out/bin/$pname" \
      --add-flags " $out/share/$pname/json2dir.tcl" \
      --prefix PATH : "${
        lib.makeBinPath [
          tcl
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
    description = "json2dir-tcl upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-tcl";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-tcl";
  };
}
