{ fetchurl, perlPackages }:
perlPackages.buildPerlPackage {
  pname = "Acme-Chef";
  version = "1.03";
  src = fetchurl {
    url = "https://cpan.metacpan.org/authors/id/W/WE/WERNERMP/Acme-Chef-1.03.tar.gz";
    hash = "sha256-XZNi3thLJxfWHEeloc/RM5XVWa3RWK/QsImbNkS7z0w=";
  };
  doCheck = false;
}
