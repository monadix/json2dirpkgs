{
  stdenvNoCC,
  lib,
  glibc,
}:
stdenvNoCC.mkDerivation {
  pname = "latin1-locale";
  version = glibc.version;
  src = glibc.src;
  nativeBuildInputs = [ glibc.bin ];
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p "$out/lib/locale"
    locale_status=0
    I18NPATH="$PWD/localedata" localedef --quiet --force --no-archive \
      -i "$PWD/localedata/locales/POSIX" \
      -f "$PWD/localedata/charmaps/ISO-8859-1" \
      "$out/lib/locale/C.ISO-8859-1" || locale_status=$?
    # POSIX omits optional categories; localedef reports those warnings as 1.
    test "$locale_status" -le 1
    test -s "$out/lib/locale/C.ISO-8859-1/LC_CTYPE"
  '';
  meta = {
    description = "POSIX Latin-1 locale for byte-preserving evaluator transport";
    license = lib.licenses.lgpl21Plus;
    platforms = [ "x86_64-linux" ];
  };
}
