import datetime
import hashlib
import json
from pathlib import Path
import stat
import subprocess
import sys

W = Path.cwd()
H = Path("/media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon")
K = H / "evidence/candidates/framework_d641/T2C3-CANONICAL-KEYGEN-001-20260819-a1"
extra = [
    (K / "KEYGEN_ATTEMPT.json", "e357d32d0aa91e6b80af2a83674965fbad776699c6c6f999fa71376ec52a7370"),
    (K / "report.md", "98eeeac23886fb678a491eab4ee796ebbaf2900e0ab0f2043cf53a7d01f50637"),
    (W.parent / "FT1536_KONTYNUACJA_GPT_ASTRA_LV_STATIC_2026-09-17.md", "1251db3045a6c7c309be5f3d819a2a99233a8f480c71792e155dcca40583c302"),
    (W.parent / "FT1536_SRODOWISKO_SAGE_LEAN_2026-09-17.md", "6bef38e9173fcd33cd31ede9fab019699521722bdac6249abca9404cfb106511"),
]
dest = W / "inputs/resume_001"
dest.mkdir()
records = []
for path, expected in extra:
    assert all(not stat.S_ISLNK(p.lstat().st_mode) for p in [path, *path.parents])
    b = path.read_bytes(); assert hashlib.sha256(b).hexdigest() == expected
    with (dest / path.name).open("xb") as f: f.write(b)
    records.append(dict(path=str(path), sha256=expected, copy=str((dest/path.name).relative_to(W))))
(W / "resume_001/EXTRA_INPUTS.sha256").write_text("".join(r["sha256"]+"  "+r["path"]+"\n" for r in records))
(W / "resume_001/EXTRA_PROVENANCE.json").write_text(json.dumps(records, indent=2)+"\n")
for name in ["cache/home", "cache/ipython", "cache/sage", "cache/mpl"]:
    (W / name).mkdir(exist_ok=True)
commands = [["/usr/bin/gcc", "--version"], [sys.executable, "--version"],
            ["/home/footfalcon/miniforge3/envs/sage/bin/python", "-c", "import sys; from sage.env import SAGE_VERSION; print(sys.version); print(\"SageMath \"+SAGE_VERSION)"],
            ["/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean", "--version"]]
versions = []
for argv in commands:
    p = subprocess.run(argv, capture_output=True, text=True)
    row = dict(argv=argv, cwd=str(W), exit_code=p.returncode, stdout=p.stdout, stderr=p.stderr)
    versions.append(row); print(json.dumps(row), flush=True)
    assert p.returncode == 0
(W / "artifacts/toolchain.json").write_text(json.dumps(versions, indent=2)+"\n")
(W / "TOOLCHAIN.txt").write_text(
    "New L_V-STATIC check, not historical Sage/Lean replay.\n" +
    "UTC "+datetime.datetime.now(datetime.timezone.utc).isoformat()+"\n"+
    "LP64 target; exact widths also statically checked by standalone harness.\n"+
    "Signed narrowing: tested GCC two-complement modulo representation; signed overflow is not assumed.\n"+
    "Compiler flags copied from reference/Makefile; see artifacts/build-*.json.\n"+
    "Child filesystem read-only except W; caches/TMPDIR under W; network unshared.\n\n"+
    "\n".join(v["stdout"] for v in versions))
print("EXTRA_INPUTS 4/4 verified; versions recorded")
