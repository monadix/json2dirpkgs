#!/usr/bin/env python3
"""Run the tester's complete applicable suites against built package executables."""

import argparse
import hashlib
import json
from pathlib import Path
import shlex
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--tester", required=True, type=Path)
    parser.add_argument("--sizes", type=Path, default=ROOT / "data/sizes.json")
    parser.add_argument("--out", type=Path, default=ROOT / "data/validation.json")
    parser.add_argument("names", nargs="*")
    args = parser.parse_args()
    output = args.out.resolve()
    output.parent.mkdir(parents=True, exist_ok=True)
    # Even tester compilation failures must not retain an earlier successful report.
    output.unlink(missing_ok=True)
    tester = args.tester.resolve()
    selection = json.loads((ROOT / "data/selection.json").read_text())
    original = {i["name"]: i for i in selection["implementations"]}
    sizes = json.loads(args.sizes.read_text())
    packages = {i["name"]: i for i in sizes["packages"] if i["status"] == "built"}
    requested = args.names or sorted(original)
    if set(requested) - original.keys() or len(requested) != len(set(requested)):
        parser.error("unknown or duplicate implementation")
    names = [name for name in requested if name in packages]
    excluded = [{"name": name, "status": "not-built"} for name in requested if name not in packages]
    if not names:
        output.write_text(json.dumps({"complete": False, "fullPass": False, "allSelectedPass": False,
            "requestedPackages": requested, "excluded": excluded, "implementations": []}, indent=2) + "\n")
        return 1
    work_root = ROOT / ".work"
    work_root.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix="tester-", dir=work_root))
    for folder in ("cases", "src"):
        if (work / folder).exists():
            shutil.rmtree(work / folder)
        shutil.copytree(tester / folder, work / folder, dirs_exist_ok=True,
                        ignore=shutil.ignore_patterns("bin", "obj"))
    # Identify the actual copied snapshot, including uncommitted tester changes.
    snapshot = hashlib.sha256()
    for folder in ("cases", "src"):
        for path in sorted((work / folder).rglob("*")):
            if path.is_file():
                snapshot.update(path.relative_to(work).as_posix().encode() + b"\0")
                snapshot.update(hashlib.sha256(path.read_bytes()).digest())
    manifests = work / "implementations"
    manifests.mkdir(exist_ok=True)
    for path in manifests.glob("*.json"):
        path.unlink()
    for name in names:
        executable = Path(packages[name]["outputs"][0]) / "bin" / name
        if not executable.is_file():
            raise ValueError(f"missing packaged executable: {executable}")
        item = original[name]
        manifest = {"name": name, "repo": item["repo"], "description": item["description"],
                    "language": item["language"], "command": "PATH=/nonexistent " + shlex.quote(str(executable)), "source": "."}
        for field in ("timeout", "suites"):
            if field in item["manifest"]:
                manifest[field] = item["manifest"][field]
        (manifests / (name + ".json")).write_text(json.dumps(manifest) + "\n")
    subprocess.run(["dotnet", "build", str(work / "src/Json2dirTester"), "-c", "Release", "--nologo"], check=True)
    log_path = work / "validation.log"
    print(f"Tester work directory: {work}", flush=True)
    with log_path.open("w") as log:
        result = subprocess.run([
            "dotnet", str(work / "src/Json2dirTester/bin/Release/net10.0/json2dir-tester.dll"),
            "run", "--all", "--json", str(output),
        ], cwd=work, stdout=log, stderr=subprocess.STDOUT)
    if output.exists():
        report = json.loads(output.read_text())
        report["testerRevision"] = subprocess.check_output(
            ["git", "-C", str(tester), "rev-parse", "HEAD"], text=True).strip()
        report["testerSnapshotSha256"] = snapshot.hexdigest()
        report["validationLog"] = str(log_path.relative_to(ROOT))
        report["packageSources"] = {name: packages[name]["source"] for name in names}
        report["packageOutputs"] = {name: packages[name]["outputs"] for name in names}
        report["requestedPackages"] = requested
        report["excluded"] = excluded
        report["selectedPackageCount"] = len(original)
        report["executablePathEnvironment"] = "/nonexistent; wrappers must supply their dependencies"
        report["complete"] = not excluded and result.returncode in (0, 1) and {
            i["name"] for i in report["implementations"]
        } == set(names)
        report["fullPass"] = report["complete"] and all(
            len(i["results"]) >= original[i["name"]]["total"]
            and all(r["status"] == "pass" for r in i["results"])
            for i in report["implementations"]
        )
        report["allSelectedPass"] = report["fullPass"] and set(requested) == set(original)
        output.write_text(json.dumps(report, indent=2) + "\n")
        for implementation in report["implementations"]:
            results = implementation["results"]
            print(implementation["name"], {status: sum(r["status"] == status for r in results)
                                           for status in ("pass", "fail", "skip")})
        if result.returncode == 0 and not report["fullPass"]:
            return 1
    return result.returncode if result.returncode else int(not output.exists())


if __name__ == "__main__":
    raise SystemExit(main())
