{
  stdenv,
  lib,
  emojicode,
  j2dSources,
}:
let
  pname = "json2dir-emojicode";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ emojicode ];

  buildPhase = ''
    sh ./build.sh ${emojicode}
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
  '';

  meta = {
    description = "Emojicode implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
