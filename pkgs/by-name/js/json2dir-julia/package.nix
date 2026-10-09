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
  julia,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-julia";
  version = "2026-10-08";
  src = j2dSources.json2dir-julia;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "${julia}/bin/julia" "$out/bin/$pname" \
      --add-flags "--startup-file=no --history-file=no --compile=min -O0 $out/share/$pname/json2dir.jl" \
      --prefix PATH : "${
        lib.makeBinPath [
          julia
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
    description = "json2dir-julia upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-julia";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-julia";
  };
}
