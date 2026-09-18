"""New output names; inherited builder and binary remain unchanged."""
import hashlib
import json
from pathlib import Path
import shlex
import subprocess
import sys

W = Path.cwd()
mode = sys.argv[1]
assert mode in {"base-shared", "observed-shared", "base-normal", "base-sanitize"}
for line in (W / "inputs/source_hashes.sha256").read_text().splitlines():
    digest, name = line.split()
    assert hashlib.sha256((W / "reference" / name).read_bytes()).hexdigest() == digest
assert hashlib.sha256((W / "scripts/harness.c").read_bytes()).hexdigest() == "d9addfa1ddea67a2fa689b0963755758426cd3ae04df4115b39ff6877af4bd79"
line = next(l for l in (W / "reference/Makefile").read_text().splitlines() if l.startswith("CFLAGS ="))
flags = shlex.split(line.split("=", 1)[1])
outdir = W / "bin/resume_001"
outdir.mkdir(exist_ok=True)
shared = mode.endswith("shared")
source = "resume_001/harness_observed.c" if mode.startswith("observed") else "scripts/harness.c"
sources = [source, "reference/falcon-enc.c", "reference/shake.c"]
out = outdir / (mode + (".so" if shared else ""))
assert not out.exists(), "refuse to overwrite a bound binary"
extra = ["-std=c99"] + (["-shared", "-fPIC"] if shared else ["-DLV_MAIN"])
if mode.endswith("sanitize"):
    extra += ["-fsanitize=address,undefined", "-fno-sanitize-recover=all", "-g"]
argv = ["/usr/bin/gcc", *flags, *extra, "-Ireference", *sources, "-o", str(out), "-lm"]
print(json.dumps({"argv": argv}), flush=True)
p = subprocess.run(argv)
record = dict(mode=mode, argv=argv, cwd=str(W), exit_code=p.returncode,
              sources={s: hashlib.sha256((W/s).read_bytes()).hexdigest() for s in sources},
              binary=str(out.relative_to(W)),
              binary_sha256=hashlib.sha256(out.read_bytes()).hexdigest() if p.returncode == 0 else None)
with (W / ("artifacts/build-" + mode + ".json")).open("x") as f:
    json.dump(record, f, indent=2); f.write("\n")
print(json.dumps(record, indent=2))
raise SystemExit(p.returncode)
