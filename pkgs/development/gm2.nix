{
  gcc,
  glibc,
  lib,
  wrapCCWith,
  flex,
  bison,
  makeWrapper,
  coreutils,
  findutils,
}:
let
  gccWithModula2 = gcc.cc.overrideAttrs (old: {
    pname = "gcc-modula2";
    configureFlags =
      (lib.filter (flag: !(lib.hasPrefix "--enable-languages=" flag)) old.configureFlags)
      ++ [ "--enable-languages=c,c++,m2" ];
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
      flex
      bison
    ];
    passthru = (old.passthru or { }) // {
      langM2 = true;
    };
  });
in
(wrapCCWith {
  cc = gccWithModula2;
  bintools = gcc.bintools;
  libc = gcc.libc;
  libcxx = gcc.libcxx;
}).overrideAttrs
  (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ makeWrapper ];
    postFixup = (old.postFixup or "") + ''
        # GM2 consumes -B as its compiler-subprogram directory. The ordinary
        # cc-wrapper's -B flags therefore hide cc1 from GM2 (and break -E).
        # Give it one directory containing both GCC subprograms and the C startup
        # objects instead, while retaining the wrapper's include and link flags.
        searchDir="$out/libexec/gm2-search"
        mkdir -p "$searchDir"
        compilerDir="$(${findutils}/bin/find ${gccWithModula2}/libexec/gcc -type f -name cc1gm2 -printf '%h\n' | ${coreutils}/bin/head -n1)"
        test -n "$compilerDir"
        for tool in cc1 cc1gm2 collect2; do
          ln -s "$compilerDir/$tool" "$searchDir/$tool"
        done
      for crt in crt1.o Scrt1.o rcrt1.o crti.o crtn.o; do
        ln -s "${glibc}/lib/$crt" "$searchDir/$crt"
      done
      driverFlags="-B$searchDir $(cat "$out/nix-support/libc-cflags") $(cat "$out/nix-support/libc-ldflags") $(cat "$out/nix-support/cc-ldflags") -L${glibc}/lib"
      makeWrapper ${gccWithModula2}/bin/gm2 "$out/bin/gm2" \
        --prefix PATH : ${gcc.bintools}/bin \
        --add-flags "$driverFlags"
    '';
  })
