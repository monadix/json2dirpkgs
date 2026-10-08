{
  stdenv,
  lib,
  makeWrapper,
  janet,
  j2dSources,
}:
let
  pname = "json2dir-janet";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ janet ];

  installPhase = ''
    mkdir -p "$out/share/${pname}" "$out/bin"
    cp ./json2dir.janet "$out/share/${pname}/json2dir.janet"
    makeWrapper "${janet}/bin/janet" "$out/bin/${pname}" \
      --add-flags "$out/share/${pname}/json2dir.janet"
  '';

  meta = {
    description = "Janet implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
