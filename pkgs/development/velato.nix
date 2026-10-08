{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnet-sdk_8,
  dotnet-runtime_8,
}:
buildDotnetModule {
  pname = "velato";
  version = "2.1";
  src = fetchFromGitHub {
    owner = "rottytooth";
    repo = "Velato";
    rev = "8fa208bd41a1b122999d3b4cc88c86840c60276f";
    hash = "sha256-j/2ABrbZkfJu8BG/5zeOnfEgC2E6X5i5gZFQ8yqZgeE=";
  };
  dotnet-sdk = dotnet-sdk_8;
  dotnet-runtime = dotnet-runtime_8;
  projectFile = "Velato.csproj";
  nugetDeps = null;
  executables = [ "Velato" ];
  postPatch = ''
    cat > Velato.csproj <<'EOF'
    <Project Sdk="Microsoft.NET.Sdk">
      <PropertyGroup>
        <OutputType>Exe</OutputType>
        <TargetFramework>net8.0</TargetFramework>
        <AssemblyName>Velato</AssemblyName>
        <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
      </PropertyGroup>
      <ItemGroup>
        <Compile Include="Rottytooth.Esolang.Velato/**/*.cs" Exclude="Rottytooth.Esolang.Velato/Properties/AssemblyInfo.cs" />
        <Reference Include="NAudio"><HintPath>Lib/NAudio.dll</HintPath></Reference>
        <Reference Include="System.CodeDom"><HintPath>$(MSBuildToolsPath)/System.CodeDom.dll</HintPath></Reference>
      </ItemGroup>
    </Project>
    EOF
  '';
  postInstall = ''
    # Consumers of the reference compiler invoke its DLL with dotnet directly.
    mkdir -p "$out/bin"
    for file in "$out/lib/velato/"*.dll "$out/lib/velato/"*.json; do
      ln -s "$file" "$out/bin/$(basename "$file")"
    done
    install -Dm644 LICENSE "$out/share/licenses/velato/LICENSE"
    install -Dm644 Lib/license.txt "$out/share/licenses/velato/NAudio-license.txt"
  '';
  meta = {
    description = "Reference Velato MIDI compiler and transpiler";
    homepage = "https://github.com/rottytooth/Velato";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "Velato";
  };
}
