# Measured package sizes

Snapshot: 2026-10-08T12:34:44.759018+00:00. Target: `x86_64-linux`.

All 107 selected implementations and 30 shared dependencies built successfully.

Fresh validation: 106/107 implementations pass all 367 cases. SystemVerilog
passes 365/367 with the original 10-second deadline; its two remaining cases
pass with a diagnostic 60-second deadline in 13.7 and 16.6 seconds on an Intel i7-1165G7 laptop.
The reference results used Icarus 11, while this pinned Nixpkgs provides 13.
The original deadline remains unchanged in the full-suite report.

| Measurement | Size |
| --- | ---: |
| Implementation outputs | 320.86 MiB |
| Implementation runtime union | 7.17 GiB |
| Shared dependency outputs | 322.57 MiB |
| Implementation and shared dependency closure union | 8.33 GiB |
| Additional compressed runtime cache | 138.05 MiB |
| Additional compressed cache including shared dependencies | 335.61 MiB |

Output and closure sizes are uncompressed NAR bytes. Cache sizes use actual XZ
preset 6 streams, exclude paths served by cache.nixos.org, and deduplicate shared
paths. The combined cache includes the explicitly packaged shared compilers;
it does not include every transitive build input. Cachix encoding may differ.

Individual closures overlap; their sizes must not be added together.

Raw reports: [implementations](sizes.json), [shared dependencies](dependency-sizes.json),
[runtime cache](cache-size.json), [shared dependency cache](dependency-cache-size.json),
[full validation](validation.json), [SystemVerilog diagnostics](systemverilog-diagnostics.json).
The validation report records separate full-suite retests for repaired packages;
`packageValidationLogs` and `validationCampaigns` identify their original runs.

## Implementations

| Package | Output KiB | Runtime closure MiB | Tests passed |
| --- | ---: | ---: | ---: |
| json2dir-ada | 680.2 | 37.1 | 367/367 |
| json2dir-algol60 | 49.8 | 63.2 | 367/367 |
| json2dir-algol68 | 15.3 | 94.9 | 367/367 |
| json2dir-aot | 1542.6 | 90.0 | 367/367 |
| json2dir-apl | 10.9 | 73.6 | 367/367 |
| json2dir-arnoldc | 97.7 | 373.8 | 367/367 |
| json2dir-asm | 3.7 | 0.0 | 367/367 |
| json2dir-awk | 12.8 | 66.1 | 367/367 |
| json2dir-basic | 62.4 | 40.2 | 367/367 |
| json2dir-bcpl | 15.5 | 64.9 | 367/367 |
| json2dir-bqn | 11.0 | 39.9 | 367/367 |
| json2dir-brainfuck | 124.6 | 107.8 | 367/367 |
| json2dir-c17 | 21.2 | 36.5 | 367/367 |
| json2dir-c23 | 21.1 | 36.5 | 367/367 |
| json2dir-c89 | 21.3 | 36.5 | 367/367 |
| json2dir-cforall | 59.9 | 87.8 | 367/367 |
| json2dir-checkedc | 24.8 | 36.5 | 367/367 |
| json2dir-chez | 43.2 | 50.6 | 367/367 |
| json2dir-cil | 10.4 | 173.0 | 367/367 |
| json2dir-cilk | 1017.1 | 37.5 | 367/367 |
| json2dir-clojure | 13912.3 | 115.6 | 367/367 |
| json2dir-cobol | 53.1 | 59.1 | 367/367 |
| json2dir-commonlisp | 118192.3 | 163.5 | 367/367 |
| json2dir-compcert | 22.7 | 36.5 | 367/367 |
| json2dir-cpp | 91.4 | 47.1 | 367/367 |
| json2dir-crystal | 508.5 | 59.4 | 367/367 |
| json2dir-cs | 134.4 | 180.6 | 367/367 |
| json2dir-d | 1221.5 | 48.2 | 367/367 |
| json2dir-dafny | 326.3 | 173.3 | 367/367 |
| json2dir-dart | 6198.7 | 92.8 | 367/367 |
| json2dir-eiffel | 339.0 | 36.8 | 367/367 |
| json2dir-elixir | 11.7 | 1131.9 | 367/367 |
| json2dir-emojicode | 519.6 | 47.5 | 367/367 |
| json2dir-erlang | 11.1 | 1111.4 | 367/367 |
| json2dir-false | 7.3 | 62.7 | 367/367 |
| json2dir-fennel | 15.9 | 51.0 | 367/367 |
| json2dir-forth | 46.9 | 64.5 | 367/367 |
| json2dir-fortran | 343.2 | 47.3 | 367/367 |
| json2dir-freepascal | 213.8 | 0.2 | 367/367 |
| json2dir-fsharp | 3544.4 | 91.9 | 367/367 |
| json2dir-gleam | 237.8 | 1111.6 | 367/367 |
| json2dir-gnuc | 33.3 | 36.5 | 367/367 |
| json2dir-go | 1768.2 | 3.8 | 367/367 |
| json2dir-groovy | 7914.1 | 148.6 | 367/367 |
| json2dir-hare | 303.7 | 0.3 | 367/367 |
| json2dir-haskell | 1429.0 | 71.9 | 367/367 |
| json2dir-holyc | 123.0 | 36.6 | 367/367 |
| json2dir-idris2 | 209.0 | 63.9 | 367/367 |
| json2dir-intercal | 399.0 | 63.1 | 367/367 |
| json2dir-j | 9.2 | 63.9 | 367/367 |
| json2dir-janet | 9.6 | 40.7 | 367/367 |
| json2dir-java | 16.5 | 102.0 | 367/367 |
| json2dir-jq | 15.5 | 63.9 | 367/367 |
| json2dir-js | 7.3 | 257.1 | 367/367 |
| json2dir-jsonnet | 9.6 | 82.8 | 367/367 |
| json2dir-k | 11.9 | 66.8 | 367/367 |
| json2dir-koka | 1434.0 | 37.9 | 367/367 |
| json2dir-kotlin | 5561.1 | 107.4 | 367/367 |
| json2dir-kr | 21.2 | 36.5 | 367/367 |
| json2dir-ksh | 11.3 | 43.6 | 367/367 |
| json2dir-lean | 139316.2 | 197.5 | 367/367 |
| json2dir-lolcode | 21.9 | 64.3 | 367/367 |
| json2dir-lua | 13.2 | 64.1 | 367/367 |
| json2dir-luajit | 13.7 | 51.0 | 367/367 |
| json2dir-mercury | 54.6 | 2568.2 | 367/367 |
| json2dir-modula2 | 1372.2 | 37.8 | 367/367 |
| json2dir-mojo | 89.9 | 50.2 | 367/367 |
| json2dir-neovim | 13.1 | 261.7 | 367/367 |
| json2dir-nim | 146.5 | 36.6 | 367/367 |
| json2dir-objc | 43.5 | 37.8 | 367/367 |
| json2dir-ocaml | 1870.0 | 38.3 | 367/367 |
| json2dir-odin | 60.0 | 36.5 | 367/367 |
| json2dir-perl | 9.9 | 106.9 | 367/367 |
| json2dir-php | 7.8 | 250.1 | 367/367 |
| json2dir-pli | 234.6 | 0.2 | 367/367 |
| json2dir-pony | 207.5 | 47.2 | 367/367 |
| json2dir-prolog | 11.0 | 1409.4 | 367/367 |
| json2dir-puppet | 13.9 | 123.6 | 367/367 |
| json2dir-purescript | 134.5 | 257.3 | 367/367 |
| json2dir-pwsh | 15.2 | 300.2 | 367/367 |
| json2dir-python | 7.7 | 211.9 | 367/367 |
| json2dir-racket | 50.1 | 1290.6 | 367/367 |
| json2dir-raku | 10.2 | 193.6 | 367/367 |
| json2dir-rexx | 13.2 | 60.1 | 367/367 |
| json2dir-rocq | 1884.2 | 38.3 | 367/367 |
| json2dir-ruby | 7.6 | 96.9 | 367/367 |
| json2dir-scala | 9673.8 | 111.4 | 367/367 |
| json2dir-smalltalk | 15.3 | 972.2 | 367/367 |
| json2dir-sml | 278.7 | 48.0 | 367/367 |
| json2dir-snobol4 | 21.3 | 89.8 | 367/367 |
| json2dir-subleq | 109.5 | 63.3 | 367/367 |
| json2dir-swift | 77.2 | 73.2 | 367/367 |
| json2dir-systemverilog | 69.0 | 71.3 | 365/367 |
| json2dir-thue | 40.7 | 62.8 | 367/367 |
| json2dir-tla | 24.4 | 385.1 | 367/367 |
| json2dir-ts | 7.9 | 257.1 | 367/367 |
| json2dir-unicon | 32.2 | 100.9 | 367/367 |
| json2dir-v | 320.8 | 36.8 | 367/367 |
| json2dir-vala | 46.2 | 56.9 | 367/367 |
| json2dir-vbnet | 1542.6 | 90.0 | 367/367 |
| json2dir-velato | 33.2 | 190.4 | 367/367 |
| json2dir-vhdl | 18.8 | 1130.6 | 367/367 |
| json2dir-wasm | 10.6 | 114.2 | 367/367 |
| json2dir-whitespace | 60.6 | 63.6 | 367/367 |
| json2dir-why3 | 1454.0 | 50.9 | 367/367 |
| json2dir-zsh | 12.1 | 51.4 | 367/367 |
| nuon2dir | 10.5 | 137.8 | 367/367 |

## Shared dependencies

| Package | Output KiB | Runtime closure MiB |
| --- | ---: | ---: |
| arnoldc | 12655.0 | 12.4 |
| bcpl-cintcode | 2223.2 | 38.6 |
| cforall | 28979.6 | 87.8 |
| checkedc | 61.6 | 855.6 |
| dotnet-ilasm | 1580.5 | 97.3 |
| emojicode | 55444.4 | 445.7 |
| gleam-stdlib | 605.1 | 0.6 |
| gm2 | 74.1 | 767.5 |
| gnu-libobjc | 235.7 | 37.8 |
| gobo | 53363.4 | 440.0 |
| headless-jre | 54352.9 | 100.2 |
| headless-jre-desktop | 91617.5 | 139.0 |
| holyc | 1149.5 | 37.6 |
| ironspring-pli | 3404.7 | 3.3 |
| ksh93 | 2406.1 | 41.7 |
| latin1-locale | 40.8 | 0.0 |
| lolcode-future | 1645.5 | 42.3 |
| mojo-runtime-libs | 3233.6 | 50.1 |
| ngnk | 286.9 | 4.1 |
| oorexx | 7777.3 | 60.1 |
| opencilk | 61.6 | 600.1 |
| portableFalse | 22.8 | 36.5 |
| purescript-package-set | 967.4 | 0.9 |
| sqrun | 504.9 | 47.5 |
| thue | 37.0 | 47.0 |
| tlaplus18 | 4397.1 | 4.3 |
| tritium | 240.8 | 81.4 |
| velato | 1970.0 | 174.9 |
| whitespacers | 895.3 | 47.8 |
| why3-ocaml-driver | 78.2 | 0.1 |
