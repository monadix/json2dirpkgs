{
  lib,
  stdenv,
  j2dSources,
  makeWrapper,
  nodejs,
  typescript,
}:
let
  pname = "json2dir-ts";
in
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-5942c06";
  src = j2dSources."json2dir-ts";
  nativeBuildInputs = [
    makeWrapper
    nodejs
    typescript
  ];
  dontConfigure = true;
  buildPhase = ''
    set -eo pipefail
    cat > src/node-builtins.d.ts <<'TYPES'
    type Buffer = Uint8Array;
    declare const Buffer: {
      from(value: string): Buffer;
      compare(a: Buffer, b: Buffer): number;
    };
    declare class TextDecoder {
      constructor(label?: string, options?: { fatal?: boolean });
      decode(input?: Uint8Array): string;
    }
    declare const process: {
      argv: string[];
      stderr: { write(text: string): void };
      exitCode?: number;
    };
    declare module "node:fs" {
      export interface Stats { mode: number; isDirectory(): boolean; }
      export function readFileSync(fd: number): Buffer;
      export function lstatSync(path: string, options: { throwIfNoEntry: false }): Stats | undefined;
      export function unlinkSync(path: string): void;
      export function openSync(path: string, flags: string, mode?: number): number;
      export function writeFileSync(fd: number, content: string): void;
      export function fchmodSync(fd: number, mode: number): void;
      export function fstatSync(fd: number): Stats;
      export function closeSync(fd: number): void;
      export function mkdirSync(path: string): void;
      export function symlinkSync(target: string, path: string): void;
    }
    declare module "node:path" { export function join(...paths: string[]): string; }
    TYPES
    sed -i 's/"types": \["node"\]/"types": []/' tsconfig.json
    tsc --outDir "$TMPDIR/out/dist"
  '';
  installPhase = ''
    mkdir -p "$out/share/dist"
    cp -r "$TMPDIR/out/dist"/. "$out/share/dist/"
    cp package.json "$out/share/package.json"
    makeWrapper ${nodejs}/bin/node "$out/bin/${pname}" \
      --add-flags "$out/share/dist/main.js"
  '';
  meta = {
    description = "TypeScript on Node.js, validated into a typed tree first";
    homepage = "https://github.com/json2dir-guru/json2dir-ts";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
  };
}
