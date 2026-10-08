{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  j2dSources,
}:
buildDotnetModule {
  pname = "json2dir-cs";
  version = "1.0.0";
  src = j2dSources."json2dir-cs";
  projectFile = "json2dir/json2dir.csproj";
  executables = [ "json2dir" ];
  runtimeId = "linux-x64";
  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;
  selfContainedBuild = false;
  nugetDeps = null;
  postFixup = ''
    mv "$out/bin/json2dir" "$out/bin/json2dir-cs"
  '';
  meta = {
    description = "The whole tool as a single C# expression.";
    homepage = "https://github.com/daniilvaino/json2dir-cs";
    license = lib.licenses.unlicense;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-cs";
  };
}
