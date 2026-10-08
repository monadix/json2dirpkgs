{
  stdenvNoCC,
  gcc-unwrapped,
  gcc,
  patchelf,
  xz,
  lib,
}:

let
  gccWithObjC = gcc-unwrapped.override {
    langObjC = true;
    langCC = false;
  };
in
stdenvNoCC.mkDerivation {
  pname = "gnu-libobjc-runtime";
  version = gccWithObjC.version;
  dontUnpack = true;
  nativeBuildInputs = [
    gccWithObjC
    patchelf
    xz
  ];
  disallowedReferences = [ gccWithObjC ];
  installPhase = ''
    mkdir -p "$out/include" "$out/lib" "$TMPDIR/gcc-source"
    tar -xJf "${gccWithObjC.src}" -C "$TMPDIR/gcc-source" \
      --strip-components=2 "gcc-${gccWithObjC.version}/libobjc/objc"
    cp -r "$TMPDIR/gcc-source/objc" "$out/include/"
    cp "${gccWithObjC.lib}/lib/libobjc.so.4.0.0" "$out/lib/libobjc.so.4.0.0"
    ln -s libobjc.so.4.0.0 "$out/lib/libobjc.so.4"
    ln -s libobjc.so.4.0.0 "$out/lib/libobjc.so"
    patchelf --set-rpath "${gccWithObjC.lib}/lib:${gcc.libc}/lib" "$out/lib/libobjc.so.4.0.0"
    mkdir -p "$out/share/licenses/gnu-libobjc-runtime"
    tar -xJOf "${gccWithObjC.src}" "gcc-${gccWithObjC.version}/COPYING.RUNTIME" \
      > "$out/share/licenses/gnu-libobjc-runtime/COPYING.RUNTIME"
    tar -xJOf "${gccWithObjC.src}" "gcc-${gccWithObjC.version}/COPYING3" \
      > "$out/share/licenses/gnu-libobjc-runtime/COPYING3"
  '';
  meta = {
    description = "GNU Objective-C runtime library and headers from GCC";
    homepage = "https://gcc.gnu.org/";
    license = lib.licenses.WITH lib.licenses.gpl3Plus lib.licenses.gccException31;
    platforms = [ "x86_64-linux" ];
  };
}
