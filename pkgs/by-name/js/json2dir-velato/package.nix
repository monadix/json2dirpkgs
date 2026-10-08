{
  stdenv,
  lib,
  makeWrapper,
  bash,
  coreutils,
  gawk,
  dotnet-sdk_8,
  dotnet-runtime_8,
  latin1-locale,
  velato,
  j2dSources,
}:
let
  pname = "json2dir-velato";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [
    makeWrapper
    dotnet-sdk_8
  ];

  buildPhase = ''
    export DOTNET_ROOT=${dotnet-sdk_8}/share/dotnet
    export VELATO=${velato}/bin/Velato.dll
    sh ./build.sh
  '';

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir "$out/libexec/${pname}/json2dir"
    mkdir -p "$out/libexec/${pname}/out"
    cp ./out/json2dir.dll ./out/json2dir.runtimeconfig.json \
      "$out/libexec/${pname}/out/"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set DOTNET_ROOT "${dotnet-runtime_8}/share/dotnet" \
      --set JSON2DIR_DOTNET "${dotnet-runtime_8}/bin/dotnet" \
      --set JSON2DIR_EVALUATOR "$out/libexec/${pname}/out/json2dir.dll" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --set LOCPATH "${latin1-locale}/lib/locale" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          gawk
          bash
          dotnet-runtime_8
        ]
      }"
  '';

  meta = {
    description = "Velato implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
