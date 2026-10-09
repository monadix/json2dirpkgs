"""Transport JSON unchanged to the upstream client in a fresh QEMU guest."""
import importlib.util
import os
from pathlib import Path
import re
import stat
import subprocess
import sys
import tempfile


def main():
    if len(sys.argv) != 1:
        print("Usage: json2dir-syscall < document.json", file=sys.stderr)
        return 1
    spec = importlib.util.spec_from_file_location("upstream_vm", "@upstream@/testing/vm.py")
    upstream = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(upstream)
    cwd = Path.cwd()
    mask = os.umask(0o022)
    entries = [(name, content, stat.S_IFREG | 0o644) for name, content in (
        ("input", sys.stdin.buffer.read()), ("cwd", os.fsencode(cwd.relative_to(cwd.parent))),
        ("uid", str(os.getuid()).encode()),
        ("gid", str(os.getgid()).encode()), ("mask", f"{mask:o}".encode()),
    )]
    with tempfile.TemporaryDirectory(prefix="json2dir-syscall-") as work:
        work = Path(work)
        initrd = work / "initrd.gz"
        initrd.write_bytes(Path("@initrd@/initrd").read_bytes() + upstream.archive(entries))
        console = work / "console.log"
        # QEMU's fsdev option uses doubled commas for literal commas in paths.
        parent = str(cwd.parent).replace(",", ",,")
        result = subprocess.run([
            "@qemu@/bin/qemu-system-x86_64", "-accel", "tcg", "-m", "256M", "-smp", "1",
            "-display", "none", "-monitor", "none", "-serial", f"file:{console}",
            "-kernel", "@kernel@/bzImage", "-initrd", str(initrd),
            "-append", "console=ttyS0 rdinit=/init panic=1 quiet", "-no-reboot", "-nic", "none",
            "-fsdev", f"local,id=host,path={parent},security_model=none",
            "-device", "virtio-9p-pci,fsdev=host,mount_tag=host",
        ], stdout=subprocess.PIPE, stderr=subprocess.PIPE, timeout=55)
        log = console.read_text(errors="replace")
        match = re.search(r"J2D_RESULT=(\d+)", log)
        if result.returncode or not match or "J2D_DONE" not in log or "J2D_INFRA_FAILURE" in log:
            print(log[-6000:], file=sys.stderr)
            print(result.stderr.decode(errors="replace"), file=sys.stderr)
            return 126
        status = int(match[1])
        if status:
            print("\n".join(line for line in log.splitlines() if line.startswith("json2dir:")), file=sys.stderr)
        return status


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception as error:
        print(f"VM infrastructure: {error}", file=sys.stderr)
        sys.exit(126)
