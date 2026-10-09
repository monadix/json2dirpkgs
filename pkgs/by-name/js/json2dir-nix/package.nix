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
  nix,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-nix";
  version = "2026-10-08";
  src = j2dSources.json2dir-nix;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_EVALUATOR "$out/share/$pname/cli.nix" \
      --set JSON2DIR_NIX "${nix}/bin/nix" \
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
    description = "json2dir-nix upstream implementation";
    homepage = "https://github.com/TheMaxMur/json2dir-nix";
    license = lib.licenses.isc;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-nix";
  };
}
