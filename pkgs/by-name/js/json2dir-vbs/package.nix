{
  lib,
  stdenvNoCC,
  makeWrapper,
  bash,
  wine6,
  coreutils,
  j2dSources,
}:
let
  pname = "json2dir-vbs";
  src = j2dSources.${pname};
in
stdenvNoCC.mkDerivation {
  inherit pname src;
  version = "unstable";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ wine6 ];

  installPhase = ''
    mkdir -p "$out/libexec/${pname}" "$out/bin"
    cp ./json2dir.vbs "$out/libexec/${pname}/json2dir.vbs"
    cat > "$out/libexec/${pname}/run" <<SH
    #!${bash}/bin/sh
    prefix=\$(umask 077; "${coreutils}/bin/mktemp" -d "\''${TMPDIR:-/tmp}/vbs-wine.XXXXXXXX") || exit 1
    "${coreutils}/bin/chmod" 0700 "\$prefix" || exit 1
    cleanup() {
      status=\$?
      trap - EXIT
      "${wine6}/bin/wineserver" -k >/dev/null 2>&1 || true
      "${wine6}/bin/wineserver" -w >/dev/null 2>&1 || true
      "${coreutils}/bin/rm" -rf -- "\$prefix"
      exit "\$status"
    }
    trap cleanup EXIT
    trap 'exit 129' HUP
    trap 'exit 130' INT
    trap 'exit 143' TERM
    export WINEPREFIX="\$prefix"
    export WINE_UNIX_PID=\$\$
    export LC_ALL=C.UTF-8
    export WINEDEBUG=-all
    export WINEDLLOVERRIDES=mscoree,mshtml=
    unset DISPLAY WAYLAND_DISPLAY XDG_RUNTIME_DIR
    caller_umask=\$(umask)
    umask 077
    "${wine6}/bin/wineboot" -u >/dev/null 2>&1
    boot_status=\$?
    "${wine6}/bin/wineserver" -k >/dev/null 2>&1 || true
    "${wine6}/bin/wineserver" -w >/dev/null 2>&1 || true
    umask "\$caller_umask"
    if [ "\$boot_status" -ne 0 ]; then
      exit "\$boot_status"
    fi
    "${wine6}/bin/wine" cscript //nologo "Z:$out/libexec/${pname}/json2dir.vbs" "\$@"
    exit \$?
    SH
    chmod +x "$out/libexec/${pname}/run"
    makeWrapper "$out/libexec/${pname}/run" "$out/bin/${pname}" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          wine6
        ]
      }"
  '';

  meta = {
    description = "Classic Windows VBScript implementation of json2dir, run with Wine";
    homepage = "https://github.com/json2dir-guru/${pname}";
    license = lib.licenses.mit;
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
