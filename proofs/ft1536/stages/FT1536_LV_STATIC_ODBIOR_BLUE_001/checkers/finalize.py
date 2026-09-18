#!/usr/bin/env python3
"""Freeze command log and create exact input/output SHA-256 manifests."""
import datetime
import hashlib
import json
import os
from pathlib import Path
import stat

W = Path(__file__).resolve().parents[1]

def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

external_inputs = [
    Path("/home/footfalcon/Dokumenty/AGENTS.md"),
    Path("/home/footfalcon/Dokumenty/FT1536_DAYBREAK_BLUE_ODBIOR_LV_STATIC_2026-09-17.md"),
    Path("/home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001/REPORT.md"),
    Path("/home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001/RESULT.json"),
    Path("/home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001/OUTPUTS.sha256"),
    Path("/home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001/OUTPUT_SCOPE.md"),
    Path("/home/footfalcon/Dokumenty/FT1536_LV_STATIC_RUN_001/REPLAY.md"),
]
local_inputs = [W / "AGENTS.md", W / "formal/WitnessBlocks.lean", W / "replay/harness.c"]
for root_name in ("inputs", "reference"):
    local_inputs.extend(sorted(p for p in (W / root_name).rglob("*") if p.is_file()))
all_inputs = external_inputs + sorted(set(local_inputs))
input_lines = []
for p in all_inputs:
    st = p.lstat()
    if not stat.S_ISREG(st.st_mode) or p.is_symlink():
        raise SystemExit("unsafe input: " + str(p))
    label = p.relative_to(W).as_posix() if p.is_relative_to(W) else str(p)
    input_lines.append(f"{digest(p)}  {label}\n")
(W / "INPUTS.sha256").write_text("".join(input_lines), encoding="utf-8")

record = {
    "started_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
    "cwd": str(W),
    "argv": ["python3", "-B", "checkers/finalize.py"],
    "exit_code": 0,
    "note": "self-recorded successful final manifest creation; no child process",
}
with (W / "COMMANDS.log").open("a", encoding="utf-8") as f:
    f.write(json.dumps(record, sort_keys=True) + "\n")
(W / "COMMANDS.frozen.log").write_bytes((W / "COMMANDS.log").read_bytes())

top = [
    "DAYBREAK_REVIEW.md", "DAYBREAK_RESULT.json", "INPUTS.sha256",
    "TOOLCHAIN.txt", "OUTPUT_SCOPE.md", "computation-contract.json",
    "COMMANDS.frozen.log",
]
paths = [W / name for name in top]
for root_name in ("checkers", "computations/independent-001", "formal", "inputs", "reference", "logs"):
    paths.extend(p for p in (W / root_name).rglob("*") if p.is_file())
for p in (W / "replay").rglob("*"):
    if p.is_file() and p.name not in ("lv-normal", "lv-sanitize"):
        paths.append(p)
unique = sorted(set(paths), key=lambda p: p.relative_to(W).as_posix())
lines = []
for p in unique:
    st = p.lstat()
    if not stat.S_ISREG(st.st_mode) or p.is_symlink():
        raise SystemExit("unsafe output: " + str(p))
    rel = p.relative_to(W).as_posix()
    if rel == "OUTPUTS.sha256":
        continue
    lines.append(f"{digest(p)}  {rel}\n")
(W / "OUTPUTS.sha256").write_text("".join(lines), encoding="utf-8")

for raw in (W / "OUTPUTS.sha256").read_text().splitlines():
    expected, rel = raw.split("  ", 1)
    if digest(W / rel) != expected:
        raise SystemExit("post-write output verification failed: " + rel)
print(json.dumps({
    "inputs": len(input_lines),
    "outputs": len(lines),
    "outputs_manifest_sha256": digest(W / "OUTPUTS.sha256"),
    "review_sha256": digest(W / "DAYBREAK_REVIEW.md"),
}, indent=2, sort_keys=True))
