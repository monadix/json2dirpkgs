{
  stdenv,
  lib,
  mojo-bin,
  patchelf,
}:
let
  runtimeLibraries = [
    "libKGENCompilerRTShared.so"
    "libAsyncRTMojoBindings.so"
    "libMSupportGlobals.so"
    "libAsyncRTRuntimeGlobals.so"
  ];
in
stdenv.mkDerivation {
  pname = "mojo-runtime-libs";
  version = "1.0.0";
  dontUnpack = true;
  nativeBuildInputs = [ patchelf ];

  installPhase = ''
    modularLib=$(find "${mojo-bin}/lib" -type d \
      -path '*/site-packages/modular/lib' -print -quit)
    test -n "$modularLib"
    mkdir -p "$out/lib"
    for name in ${lib.escapeShellArgs runtimeLibraries}; do
      install -m755 "$modularLib/$name" "$out/lib/$name"
    done
    for library in "$out"/lib/*.so; do
      patchelf --set-rpath '$ORIGIN:${
        lib.makeLibraryPath [
          stdenv.cc.libc
          stdenv.cc.cc.lib
        ]
      }' "$library"
    done
  '';

  meta = {
    description = "Runtime support libraries for Mojo 1.0.0 compiled programs";
    longDescription = "Contains the four shared libraries required to execute Mojo-compiled binaries. The source compiler distribution provides no separate redistribution grant for these runtime files.";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
