"""Preserve the interrupted run; never rerun prepare.py or overwrite it."""
import datetime
import hashlib
import json
import os
from pathlib import Path
import stat
import subprocess

W = Path.cwd()
H = Path("/media/footfalcon/ad3fb0d5-d7b4-412a-87a3-aaf7a430d371/home/god/Szablon")
R = W / "resume_001"
PINS = {
    "INPUTS.sha256": "24041795bde8573373aaf8e26aac793f29257d145eccc9cfb9854017b2c05537",
    "scripts/prepare.py": "46e44e92efb2cda7a5812aa5949d4aa68140b95e014948e4519d8249183e2261",
    "scripts/run.py": "c094d4021ac85eb61dca0c82b1e79cca0826422ae1bea0a655ef551f16312eab",
    "scripts/build.py": "a4905716adacdefff8f728fd6cc5c446e9a237bb7e7e757380f79ecdf42cd9da",
    "scripts/harness.c": "d9addfa1ddea67a2fa689b0963755758426cd3ae04df4115b39ff6877af4bd79",
}


def read(path):
    assert not any(s in {".private", "private_extraction"} for s in path.parts)
    assert all(not stat.S_ISLNK(p.lstat().st_mode) for p in [path, *path.parents])
    assert stat.S_ISREG(path.lstat().st_mode)
    return path.read_bytes()


def digest(path):
    return hashlib.sha256(read(path)).hexdigest()


for name, expected in PINS.items():
    assert digest(W / name) == expected, name
log = read(W / "COMMANDS.log")
assert len(log.splitlines()) == 6, "newer log: inspect before resuming"
assert hashlib.sha256(log).hexdigest() == "2fad47dde79a1c135b91ae28f4b409845ff104ce072f36e28f2cb11e7e875f17"
assert hashlib.sha256(b"".join(log.splitlines(keepends=True)[:5])).hexdigest() == "7fd844fb21a9a549632d3bc307293948e11d4f3f6049dd26d6aa10b7c3591fc7"
for line in read(W / "INPUTS.sha256").decode().splitlines():
    expected, path = line.split(maxsplit=1)
    assert digest(Path(path)) == expected, path
provenance = json.loads(read(W / "inputs/provenance.json"))
for entry in provenance["files"]:
    assert digest(W / entry["copy"]) == entry["sha256"], entry["copy"]
manifest = subprocess.check_output([
    "git", "show", provenance["git_commit"] + ":" + provenance["git_manifest_path"]], cwd=H)
assert hashlib.sha256(manifest).hexdigest() == "03eaa0dd72bf365102af102959f5a02133b32d0504e7dd5b15145529c6bc3589"
assert manifest == read(W / "inputs/source_hashes.sha256")
for line in manifest.decode().splitlines():
    expected, name = line.split()
    assert digest(H / "build" / name) == digest(W / "reference" / name) == expected

entries = []
for base, dirs, files in os.walk(W, followlinks=False):
    base = Path(base)
    if base == W:
        dirs.remove("resume_001")  # our new bootstrap/logger, not interrupted work
    for name in dirs:
        assert not (base / name).is_symlink(), base / name
    for name in sorted(files):
        path = base / name
        entries.append(dict(path=str(path.relative_to(W)), sha256=digest(path),
                            size=path.stat().st_size))
assert log == read(W / "COMMANDS.log"), "concurrent log change"
snapshot = R / "snapshot"
snapshot.mkdir()
for name in ["COMMANDS.log", *PINS, "bin/lv.so"]:
    target = snapshot / name
    target.parent.mkdir(parents=True, exist_ok=True)
    with target.open("xb") as f:
        f.write(read(W / name))
receipt = dict(utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
               source_pins="17/17", original_inputs="26/26", copies="26/26",
               inherited_log_lines=6, five_line_prefix_sha256="7fd844fb21a9a549632d3bc307293948e11d4f3f6049dd26d6aa10b7c3591fc7",
               inherited_log_sha256=hashlib.sha256(log).hexdigest(),
               inherited_files=sorted(entries, key=lambda r: r["path"]),
               excluded_from_inherited_inventory=["resume_001 (new continuation files)"])
(R / "INHERITED_STATE.json").write_text(json.dumps(receipt, indent=2) + "\n")
(R / "INHERITED.sha256").write_text("".join(
    r["sha256"] + "  " + r["path"] + "\n" for r in receipt["inherited_files"]))
print(json.dumps({k: v for k, v in receipt.items() if k != "inherited_files"}, indent=2))
print("preserved_files", len(entries))
