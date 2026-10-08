{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  dafny,
  dotnet-sdk_8,
  dotnetCorePackages,
}:
let
  pname = "json2dir-dafny";
in
stdenv.mkDerivation {
  inherit pname;
  version = "1.0.0";
  src = j2dSources."json2dir-dafny";
  nativeBuildInputs = [
    makeWrapper
    dafny
    dotnet-sdk_8
  ];
  buildInputs = [ dotnetCorePackages.runtime_8_0 ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    export HOME="$TMPDIR/task-home"
    export NUGET_PACKAGES="$TMPDIR/nuget"
    mkdir -p "$HOME/.nuget/NuGet" "$NUGET_PACKAGES" "$TMPDIR/out" "$TMPDIR/project"
    cat > "$HOME/.nuget/NuGet/NuGet.Config" <<'EOF'
    <configuration><packageSources><clear /></packageSources></configuration>
    EOF
    dafny translate cs --include-runtime --cores 2 json2dir.dfy -o "$TMPDIR/project/json2dir"
    cp Externs.cs "$TMPDIR/project/"
    cat > "$TMPDIR/project/json2dir.csproj" <<'EOF'
    <Project Sdk="Microsoft.NET.Sdk">
      <PropertyGroup>
        <OutputType>Exe</OutputType>
        <TargetFramework>net8.0</TargetFramework>
        <AssemblyName>json2dir</AssemblyName>
        <ImplicitUsings>enable</ImplicitUsings>
        <Nullable>enable</Nullable>
      </PropertyGroup>
    </Project>
    EOF
    dotnet restore --configfile "$HOME/.nuget/NuGet/NuGet.Config" "$TMPDIR/project/json2dir.csproj"
    dotnet build --no-restore --configuration Release "$TMPDIR/project/json2dir.csproj" \
      --output "$TMPDIR/out"
  '';
  installPhase = ''
    mkdir -p "$out/lib"
    cp -r "$TMPDIR/out"/. "$out/lib/"
    makeWrapper ${dotnetCorePackages.runtime_8_0}/bin/dotnet "$out/bin/${pname}" \
      --add-flags "$out/lib/json2dir.dll"
  '';
  meta = {
    description = "Dafny compiled to C# (.NET 8): verified parser, UTF-8 and name validation, thin C# I/O externs";
    homepage = "https://github.com/json2dir-guru/json2dir-dafny";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
