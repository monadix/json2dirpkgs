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
  cmake,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-cmake";
  version = "2026-10-08";
  src = j2dSources.json2dir-cmake;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "${cmake}/bin/cmake" "$out/bin/$pname" \
      --add-flags "-P $out/share/$pname/json2dir.cmake" \
      --prefix PATH : "${
        lib.makeBinPath [
          cmake
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
    description = "json2dir-cmake upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-cmake";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-cmake";
  };
}
