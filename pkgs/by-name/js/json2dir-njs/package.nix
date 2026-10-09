{
  lib,
  stdenvNoCC,
  makeWrapper,
  bash,
  coreutils,
  findutils,
  gnugrep,
  gawk,
  curl,
  nginxNjs,
  j2dSources,
}:
let
  pname = "json2dir-njs";
  src = j2dSources.${pname};
in
stdenvNoCC.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ nginxNjs ];

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir ./json2dir.js "$out/libexec/${pname}/"
    chmod +x "$out/libexec/${pname}/json2dir"
    substituteInPlace "$out/libexec/${pname}/json2dir" \
      --replace-fail '    kill "$pid" 2>/dev/null' '    kill -TERM "$pid" 2>/dev/null || true
    i=0
    while kill -0 "$pid" 2>/dev/null && [ "$i" -lt 50 ]; do sleep 0.1; i=$((i + 1)); done
    if kill -0 "$pid" 2>/dev/null; then kill -KILL "$pid" 2>/dev/null || true; fi'
    makeWrapper "$out/libexec/${pname}/json2dir" "$out/bin/${pname}" \
      --set NGINX_ROOT "${nginxNjs}" \
      --set JSON2DIR_SHELL "${bash}/bin/sh" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          findutils
          gnugrep
          gawk
          curl
          bash
          nginxNjs
        ]
      }"
  '';

  meta = {
    description = "nginx njs implementation of json2dir using a private WebDAV server";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
