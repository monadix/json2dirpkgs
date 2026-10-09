{
  lib,
  stdenvNoCC,
  makeWrapper,
  bash,
  gnugrep,
  findutils,
  gnused,
  coreutils,
  linuxHeaders,
  ncurses,
  j2dSources,
  ucblogo,
}:

let
  ucblogoText = ucblogo.overrideAttrs (old: {
    configureFlags = (old.configureFlags or [ ]) ++ [ "--disable-wx" ];
    buildInputs = [
      linuxHeaders
      ncurses
    ];
    # UCBLogo 6.2.5's term.c uses old empty-argument C declarations.
    NIX_CFLAGS_COMPILE = "-std=gnu17";
    postPatch = ''
      cat > termio.h <<'EOF'
      #define winsize linux_kernel_winsize
      #include <asm/termios.h>
      #undef winsize
      #include <sys/ioctl.h>
      EOF
    '';
    # glibc still provides termio.h; prefer it over the removed sgtty structure.
    ac_cv_header_termio_h = "yes";
    nativeBuildInputs = lib.filter (
      input: lib.getName input != "wrap-gapps-hook"
    ) old.nativeBuildInputs;
  });
in
stdenvNoCC.mkDerivation {
  pname = "json2dir-logo";
  version = "2026-10-08";
  src = j2dSources.json2dir-logo;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    install -d "$out/share/$pname" "$out/bin"
    cp -R "$src/." "$out/share/$pname/"
    patchShebangs "$out/share/$pname"
    makeWrapper "$out/share/$pname/json2dir" "$out/bin/$pname" \
      --set JSON2DIR_LOGO "${ucblogoText}/bin/ucblogo" \
      --set JSON2DIR_SHELL "${bash}/bin/bash" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          bash
          gnugrep
          findutils
          gnused
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "json2dir-logo upstream implementation";
    homepage = "https://github.com/json2dir-guru/json2dir-logo";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "json2dir-logo";
  };
}
