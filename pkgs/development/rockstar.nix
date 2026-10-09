{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  dotnet-sdk_9,
}:
let
  pegasus = fetchurl {
    url = "https://api.nuget.org/v3-flatcontainer/pegasus/4.1.0/pegasus.4.1.0.nupkg";
    hash = "sha256-JZVIOBpFo6CMhcafu1vKTtayVxmh0U33FmvVx3s+y6c=";
  };
in
stdenv.mkDerivation {
  pname = "rockstar-runtime";
  version = "1.0.0-unstable.20261008";
  src = fetchFromGitHub {
    owner = "RockstarLang";
    repo = "rockstar";
    rev = "7ed74190d0b189abc846ba79e8e48b6b4256ef1c";
    hash = "sha256-NNWfR0vp66kMnXTEXCjWkUSVxeCHD30NXbCnPu0euBQ=";
  };
  nativeBuildInputs = [ dotnet-sdk_9 ];
  sourceRoot = "source/Starship";
  buildPhase = ''
    runHook preBuild
    export DOTNET_CLI_HOME="$TMPDIR/dotnet-home"
    export NUGET_PACKAGES="$TMPDIR/nuget-packages"
    mkdir -p "$DOTNET_CLI_HOME" "$NUGET_PACKAGES" "$TMPDIR/feed"
    cp ${pegasus} "$TMPDIR/feed/pegasus.4.1.0.nupkg"
    dotnet restore Rockstar/Rockstar.csproj --source "$TMPDIR/feed"
    dotnet publish Rockstar/Rockstar.csproj --no-restore --configuration Release \
      --output "$TMPDIR/publish" -p:PublishAot=false
    runHook postBuild
  '';
  installPhase = ''
    mkdir -p "$out/lib/rockstar" "$out/bin"
    cp -r "$TMPDIR/publish/." "$out/lib/rockstar/"
    cat > "$out/bin/rockstar" <<EOF
    #!${stdenv.shell}
    exec ${dotnet-sdk_9}/bin/dotnet "$out/lib/rockstar/rockstar.dll" "\$@"
    EOF
    chmod +x "$out/bin/rockstar"
  '';
  meta = {
    description = "Rockstar interpreter from the pinned RockstarLang source";
    homepage = "https://github.com/RockstarLang/rockstar";
    license = lib.licenses.mit;
    mainProgram = "rockstar";
    platforms = [ "x86_64-linux" ];
  };
}
