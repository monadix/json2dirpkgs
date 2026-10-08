{
  stdenv,
  lib,
  makeWrapper,
  bash,
  coreutils,
  bcpl-cintcode,
  j2dSources,
}:
let
  pname = "json2dir-bcpl";
  src = j2dSources.${pname};
  bcplRoot = "${bcpl-cintcode}/BCPL/cintcode";
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # The 2015 64-bit Cintcode compiler expects its 64-bit compiled command path.
    substituteInPlace json2dir \
      --replace-fail 'BCPLROOT=$bcpl BCPLPATH=$bcpl/cin BCPLHDRS=$bcpl/g' \
        'BCPL64ROOT=$bcpl BCPL64PATH=$bcpl/cin64 BCPL64HDRS=$bcpl/g' \
      --replace-fail '"$bcpl/bin/cintsys" -q -m ' '"$bcpl/bin/cintsys64" -m '
    # The standard 2015 Cintcode runtime has writef but no errwritef global.
    substituteInPlace json2dir.b \
      --replace-fail 'errwritef(' 'writef('
  '';

  buildPhase = ''
    mkdir -p out
    BCPL64ROOT=${bcplRoot} \
      BCPL64PATH=${bcplRoot}/cin64 \
      BCPL64HDRS=${bcplRoot}/g \
      PATH=${bcplRoot}/bin:$PATH \
      ${bcplRoot}/bin/cintsys64 -c bcpl json2dir.b to out/json2dir < /dev/null > /dev/null
    test -s out/json2dir
  '';

  installPhase = ''
    mkdir -p "$out/libexec/${pname}/out" "$out/bin"
    cp ./json2dir "$out/libexec/${pname}/json2dir"
    cp ./out/json2dir "$out/libexec/${pname}/out/json2dir"
    chmod +x "$out/libexec/${pname}/json2dir"
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set JSON2DIR_BCPL "${bcplRoot}" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${bcplRoot}/bin:${
        lib.makeBinPath [
          coreutils
          bash
        ]
      }"
  '';

  meta = {
    description = "BCPL implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
