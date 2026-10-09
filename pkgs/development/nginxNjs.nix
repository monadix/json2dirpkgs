{
  lib,
  stdenvNoCC,
  nginxMainline,
  nginxModules,
}:
let
  njsModule = nginxModules.njs.overrideAttrs (old: {
    passthru = (old.passthru or { }) // {
      dynamic = true;
    };
    preConfigure = (old.preConfigure or "") + ''
      configureFlags="''${configureFlags/--add-dynamic-module=*nginx-mod-njs-1.0.1/&/nginx}"
    '';
  });
  nginx = nginxMainline.override { modules = [ njsModule ]; };
in
stdenvNoCC.mkDerivation {
  pname = "nginx-njs-root";
  version = nginx.version;
  dontUnpack = true;
  installPhase = ''
    mkdir -p "$out/usr/sbin" "$out/usr/lib/nginx/modules"
    ln -s "${nginx}/bin/nginx" "$out/usr/sbin/nginx"
    ln -s "${nginx}/modules/ngx_http_js_module.so" \
      "$out/usr/lib/nginx/modules/ngx_http_js_module.so"
  '';
  meta = {
    description = "Nginx with the matching njs dynamic module";
    license = lib.licenses.bsd2;
    platforms = [ "x86_64-linux" ];
  };
}
