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
  jdk,
  saxon-he,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-xslt";
  version = "2026-10-08";
  src = j2dSources.json2dir-xslt;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_JAVA "${jdk}/bin/java" \
      --set JSON2DIR_SAXON "${saxon-he}/share/java/saxon-he-12.10.jar" \
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
    description = "json2dir-xslt upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-xslt";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-xslt";
  };
}
