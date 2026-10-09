{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  dotnet-sdk_7,
  python3,
  unzip,
}:
let
  rtUtil = fetchurl {
    url = "https://api.nuget.org/v3-flatcontainer/rt.util.core/2.0.1720/rt.util.core.2.0.1720.nupkg";
    hash = "sha256-+m7j5DaCA19PLJr0aXMD7VvNtMhnSDI1buoFZVrxAgA=";
  };
  commandLine = fetchurl {
    url = "https://api.nuget.org/v3-flatcontainer/system.commandline/2.0.0-beta4.22272.1/system.commandline.2.0.0-beta4.22272.1.nupkg";
    hash = "sha256-zSO+CYnMH8deBHDI9DHhCPj79Ce3GOzHCyH1/TiHxcc=";
  };
  nugetFeed = stdenvNoCC.mkDerivation {
    pname = "hexagony-nuget-feed";
    version = "1";
    dontUnpack = true;
    installPhase = ''
      mkdir -p "$out/share/nuget/source/rt.util.core/2.0.1720" \
        "$out/share/nuget/source/system.commandline/2.0.0-beta4.22272.1"
      cp ${rtUtil} "$out/share/nuget/source/rt.util.core/2.0.1720/rt.util.core.2.0.1720.nupkg"
      cp ${commandLine} "$out/share/nuget/source/system.commandline/2.0.0-beta4.22272.1/system.commandline.2.0.0-beta4.22272.1.nupkg"
      python3 -c 'import base64, hashlib, pathlib, sys; p = pathlib.Path(sys.argv[1]); p.with_suffix(p.suffix + ".sha512").write_text(base64.b64encode(hashlib.sha512(p.read_bytes()).digest()).decode())' \
        "$out/share/nuget/source/rt.util.core/2.0.1720/rt.util.core.2.0.1720.nupkg"
      python3 -c 'import base64, hashlib, pathlib, sys; p = pathlib.Path(sys.argv[1]); p.with_suffix(p.suffix + ".sha512").write_text(base64.b64encode(hashlib.sha512(p.read_bytes()).digest()).decode())' \
        "$out/share/nuget/source/system.commandline/2.0.0-beta4.22272.1/system.commandline.2.0.0-beta4.22272.1.nupkg"
      unzip -p "$out/share/nuget/source/rt.util.core/2.0.1720/rt.util.core.2.0.1720.nupkg" '*.nuspec' \
        > "$out/share/nuget/source/rt.util.core/2.0.1720/rt.util.core.nuspec"
      unzip -p "$out/share/nuget/source/system.commandline/2.0.0-beta4.22272.1/system.commandline.2.0.0-beta4.22272.1.nupkg" '*.nuspec' \
        > "$out/share/nuget/source/system.commandline/2.0.0-beta4.22272.1/system.commandline.nuspec"
    '';
    nativeBuildInputs = [
      python3
      unzip
    ];
  };
in
stdenv.mkDerivation {
  pname = "hexagony-runtime";
  version = "1.0.0-unstable.20261008";
  src = fetchFromGitHub {
    owner = "SirBogman";
    repo = "Hexagony";
    rev = "770406a73d4be5cc2914f848a98428fd79089987";
    hash = "sha256-bI03Wi4lcaNJSTTeBhJH2G11o7EjZjJHJfYauEjMq8s=";
  };
  nativeBuildInputs = [
    dotnet-sdk_7
    nugetFeed
  ];
  buildPhase = ''
    runHook preBuild
    export DOTNET_CLI_HOME="$TMPDIR/dotnet-home"
    mkdir -p "$DOTNET_CLI_HOME"
    dotnet restore Hexagony.csproj -p:NuGetAudit=false
    dotnet publish Hexagony.csproj --no-restore --configuration Release \
      --output "$TMPDIR/publish"
    runHook postBuild
  '';
  installPhase = ''
    mkdir -p "$out/lib/hexagony" "$out/bin"
    cp -r "$TMPDIR/publish/." "$out/lib/hexagony/"
    cat > "$out/bin/Hexagony" <<EOF
    #!${stdenv.shell}
    exec ${dotnet-sdk_7}/bin/dotnet "$out/lib/hexagony/Hexagony.dll" "\$@"
    EOF
    chmod +x "$out/bin/Hexagony"
  '';
  meta = {
    description = "Hexagony interpreter from the pinned SirBogman source";
    homepage = "https://github.com/SirBogman/Hexagony";
    license = lib.licenses.mit;
    mainProgram = "Hexagony";
    platforms = [ "x86_64-linux" ];
  };
}
