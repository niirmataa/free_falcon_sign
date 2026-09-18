#!/usr/bin/env python3
"""Independent structural and cryptographic audit of RUN_001 OUTPUTS."""
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import stat
import sys

if len(sys.argv) != 2:
    raise SystemExit("usage: audit_manifest.py RUN_ROOT")
root = Path(sys.argv[1])
manifest = root / "OUTPUTS.sha256"
errors = []
entries = {}

for lineno, raw in enumerate(manifest.read_text(encoding="utf-8").splitlines(), 1):
    parts = raw.split("  ", 1)
    if len(parts) != 2 or len(parts[0]) != 64:
        errors.append(f"malformed line {lineno}")
        continue
    digest, name = parts
    pp = PurePosixPath(name)
    if pp.is_absolute() or name in ("", ".") or ".." in pp.parts:
        errors.append(f"unsafe path line {lineno}: {name!r}")
        continue
    if name in entries:
        errors.append(f"duplicate path line {lineno}: {name}")
        continue
    entries[name] = digest

for name, digest in entries.items():
    path = root.joinpath(*PurePosixPath(name).parts)
    try:
        st = path.lstat()
    except FileNotFoundError:
        errors.append(f"missing: {name}")
        continue
    if not stat.S_ISREG(st.st_mode) or path.is_symlink():
        errors.append(f"not a plain regular file: {name}")
        continue
    got = hashlib.sha256(path.read_bytes()).hexdigest()
    if got != digest:
        errors.append(f"hash mismatch: {name}")

fixed = {"REPORT.md", "RESULT.json", "REPLAY.md", "OUTPUT_SCOPE.md",
         "TOOLCHAIN.txt", "INPUTS.sha256"}
expected = set(fixed)
for dirname in ("reference", "inputs", "scripts", "formal", "artifacts", "resume_001"):
    base = root / dirname
    for dirpath, dirnames, filenames in os.walk(base, followlinks=False):
        dp = Path(dirpath)
        dirnames[:] = [d for d in dirnames
                       if d != "__pycache__" and not (dp == root / "resume_001" / "snapshot" and d == "bin")]
        for filename in filenames:
            p = dp / filename
            rel = p.relative_to(root).as_posix()
            if filename.endswith((".lock", ".pyc")):
                continue
            if p.is_symlink() or not p.is_file():
                errors.append(f"source-scope non-regular entry: {rel}")
            else:
                expected.add(rel)

frozen_log = root / "artifacts" / "COMMANDS.frozen.log"
for lineno, raw in enumerate(frozen_log.read_text(encoding="utf-8").splitlines(), 1):
    try:
        rec = json.loads(raw)
    except json.JSONDecodeError:
        errors.append(f"malformed frozen command line {lineno}")
        continue
    for key in ("stdout", "stderr"):
        name = rec.get(key)
        if isinstance(name, str):
            expected.add(name)

extra = sorted(set(entries) - expected)
missing_scope = sorted(expected - set(entries))
if extra:
    errors.append("manifest paths outside declared scope: " + ", ".join(extra))
if missing_scope:
    errors.append("declared-scope paths missing: " + ", ".join(missing_scope))

meta = json.loads((root / "artifacts" / "COMMANDS.frozen.json").read_text())
frozen = frozen_log.read_bytes()
live = (root / "COMMANDS.log").read_bytes()
if len(frozen) != meta["bytes"] or hashlib.sha256(frozen).hexdigest() != meta["sha256"]:
    errors.append("frozen COMMANDS metadata mismatch")
if not live.startswith(frozen):
    errors.append("live COMMANDS does not preserve frozen prefix")

out = {
    "schema": "DAYBREAK_MANIFEST_AUDIT_V1",
    "manifest_sha256": hashlib.sha256(manifest.read_bytes()).hexdigest(),
    "entries": len(entries),
    "expected_scope_entries": len(expected),
    "duplicates": len(entries) != len(manifest.read_text().splitlines()),
    "unsafe_paths": any("unsafe path" in x for x in errors),
    "symlinks_in_manifest": any("not a plain" in x for x in errors),
    "frozen_command_bytes": len(frozen),
    "live_command_bytes": len(live),
    "frozen_prefix_preserved": live.startswith(frozen),
    "errors": errors,
    "ok": not errors,
}
print(json.dumps(out, indent=2, sort_keys=True))
raise SystemExit(0 if not errors else 1)
