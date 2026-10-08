{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  j2dSources,
  clang,
  zlib,
}:
buildDotnetModule {
  pname = "json2dir-fsharp";
  version = "1.0.0";
  src = j2dSources."json2dir-fsharp";
  projectFile = "json2dir.fsproj";
  executables = [ "json2dir" ];
  runtimeId = "linux-x64";
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = null;
  selfContainedBuild = true;
  nugetDeps = null;
  nativeBuildInputs = [ clang ];
  buildInputs = [ zlib ];
  postFixup = ''
    mv "$out/bin/json2dir" "$out/bin/json2dir-fsharp"
  '';
  meta = {
    description = "F# compiled with .NET 8 Native AOT, hand-written JSON parser";
    homepage = "https://github.com/json2dir-guru/json2dir-fsharp";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-fsharp";
  };
}
