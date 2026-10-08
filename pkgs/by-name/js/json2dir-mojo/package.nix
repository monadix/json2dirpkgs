{
  stdenv,
  lib,
  mojo-bin,
  mojo-runtime-libs,
  patchelf,
  j2dSources,
}:
let
  pname = "json2dir-mojo";
  src = j2dSources.${pname};
in
stdenv.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [
    mojo-bin
    patchelf
  ];

  postPatch = ''
    substituteInPlace json2dir.mojo \
      --replace-fail 'p.as_c_string_span()' 'p.as_c_string_slice().unsafe_ptr()'
  '';

  buildPhase = ''
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    mkdir -p out
    mojo build json2dir.mojo -o out/json2dir
  '';

  installPhase = ''
    install -Dm755 out/json2dir "$out/bin/${pname}"
    patchelf --set-rpath "${mojo-runtime-libs}/lib:${
      lib.makeLibraryPath [
        stdenv.cc.libc
        stdenv.cc.cc.lib
      ]
    }" \
      "$out/bin/${pname}"
  '';

  meta = {
    description = "Mojo implementation of json2dir";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.unfree;
    longDescription = "The implementation source is MIT-licensed, but its compiled executable requires runtime libraries from the proprietary Mojo compiler distribution; the runtime library package does not assert a redistribution grant.";
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
