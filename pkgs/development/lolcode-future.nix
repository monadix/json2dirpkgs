{ fetchFromGitHub, lolcode }:

lolcode.overrideAttrs (old: rec {
  pname = "lolcode-future";
  version = "0.11.2-unstable-2026-09-11";
  src = fetchFromGitHub {
    owner = "justinmeza";
    repo = "lci";
    rev = "a0a376752387e81d6c0e3783fde2a19adf4a11a5";
    hash = "sha256-cvx495GElqtAm9IfCVbQxxi379oRuia4xda+Mbi/C5c=";
  };

  meta = old.meta // {
    description = "LOLCODE interpreter with the future standard library";
    mainProgram = "lolcode-lci";
  };
})
