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
  dotnet-sdk_10,
}:

stdenvNoCC.mkDerivation {
  pname = "json2dir-msbuild";
  version = "2026-10-08";
  src = j2dSources.json2dir-msbuild;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "${dotnet-sdk_10}/bin/dotnet" "$out/bin/$pname" \
      --add-flags "msbuild $out/share/$pname/json2dir.proj -nologo -noAutoResponse -nodeReuse:false -verbosity:quiet" \
      --set DOTNET_CLI_TELEMETRY_OPTOUT 1 \
      --set DOTNET_NOLOGO 1 \
      --set MSBUILDENABLEALLPROPERTYFUNCTIONS 1

    runHook postInstall
  '';

  meta = {
    description = "json2dir-msbuild upstream implementation";
    homepage = "https://github.com/daniilvaino/json2dir-msbuild";
    license = lib.licenses.unlicense;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-msbuild";
  };
}
