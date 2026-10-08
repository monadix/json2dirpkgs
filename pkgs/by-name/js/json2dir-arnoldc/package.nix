{
  stdenv,
  lib,
  makeWrapper,
  bash,
  coreutils,
  gawk,
  openjdk21,
  jre21_minimal,
  arnoldc,
  j2dSources,
}:
let
  pname = "json2dir-arnoldc";
  src = j2dSources.${pname};
  classDir = "$out/libexec/${pname}/out";
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [
    makeWrapper
    openjdk21
  ];

  buildPhase = ''
    mkdir -p out
    cp json2dir.arnoldc out/
    (cd out && ${openjdk21}/bin/java -jar ${arnoldc}/share/ArnoldC.jar json2dir.arnoldc)
  '';

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir "$out/libexec/${pname}/json2dir"
    cp -r ./out "$out/libexec/${pname}/out"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_JAVA "${jre21_minimal}/bin/java" \
      --set JSON2DIR_CLASSES "${classDir}" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          gawk
          bash
          jre21_minimal
        ]
      }"
  '';

  meta = {
    description = "ArnoldC implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
