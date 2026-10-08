{
  autoPatchelfHook,
  dotnetCorePackages,
  icu,
  lib,
  openssl,
  stdenv,
  zlib,
}:

let
  package = dotnetCorePackages.fetchNupkg {
    pname = "runtime.linux-x64.Microsoft.NETCore.ILAsm";
    version = "8.0.0";
    hash = "sha256-58PEqaCCoRx+kc50ul2tg6iHf07YXV+OHyyepsLK3uc=";
  };
  packageRoot = "${package}/share/nuget/packages/runtime.linux-x64.microsoft.netcore.ilasm/8.0.0";
in
stdenv.mkDerivation {
  pname = "dotnet-ilasm";
  version = "8.0.0";
  dontUnpack = true;
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    stdenv.cc.cc.lib
    icu
    openssl
    zlib
  ];
  installPhase = ''
    mkdir -p "$out/bin" "$out/share/licenses/dotnet-ilasm"
    install -Dm755 "${packageRoot}/runtimes/linux-x64/native/ilasm" "$out/bin/ilasm"
    install -Dm644 "${packageRoot}/LICENSE.TXT" "$out/share/licenses/dotnet-ilasm/LICENSE.TXT"
    install -Dm644 "${packageRoot}/THIRD-PARTY-NOTICES.TXT" "$out/share/licenses/dotnet-ilasm/THIRD-PARTY-NOTICES.TXT"
  '';
  meta = {
    description = ".NET 8.0.0 IL Assembler for Linux x86_64";
    homepage = "https://github.com/dotnet/runtime";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "ilasm";
  };
}
