"""Replay in an absent child of W/tmp; never overwrite the frozen run."""
import hashlib
import json
import os
from pathlib import Path
import shutil
import stat
import subprocess
import sys

W=Path.cwd()
if len(sys.argv) not in (2,3):raise SystemExit("usage: replay_fresh.py ABSENT_DEST [EXPECTED_OUTPUTS_SHA256]")
dest=Path(sys.argv[1]).absolute()
assert ".." not in dest.parts, "destination must be a canonical path under W/tmp"
assert dest.parent.is_dir() and dest.is_relative_to(W/"tmp") and not dest.exists()
assert all(not stat.S_ISLNK(p.lstat().st_mode) for p in dest.parents)
if (W/"OUTPUTS.sha256").exists():
    assert len(sys.argv)==3,"frozen replay requires an external manifest digest"
    raw=(W/"OUTPUTS.sha256").read_bytes()
    assert hashlib.sha256(raw).hexdigest()==sys.argv[2]
    for line in raw.decode().splitlines():
        digest,rel=line.split(maxsplit=1)
        rp=Path(rel)
        assert not rp.is_absolute() and ".." not in rp.parts
        assert not any(s in {".private","private_extraction"} for s in rp.parts)
        p=W/rp
        assert all(not stat.S_ISLNK(q.lstat().st_mode) for q in [p,*p.parents])
        assert hashlib.sha256(p.read_bytes()).hexdigest()==digest,rel
else:
    assert len(sys.argv)==2,"pre-freeze rehearsal has no output manifest yet"
dest.mkdir()
for name in ["reference","inputs","scripts","resume_001","artifacts","formal","bin","logs","tmp","cache"]:
    (dest/name).mkdir()
for name in ["cache/home","cache/sage","cache/ipython","cache/mpl"]:
    (dest/name).mkdir()

files=["inputs/source_hashes.sha256","inputs/key/canonical_public_key.bin",
       "inputs/key/canonical_public_h.txt","inputs/key/KEY_COMMITMENT.json",
       "inputs/key/OUTPUTS.sha256","inputs/resume_001/KEYGEN_ATTEMPT.json",
       "inputs/resume_001/report.md","scripts/harness.c",
       "formal/Witness.lean","artifacts/lean_array_timeout.json"]
files += ["reference/"+line.split()[1] for line in (W/"inputs/source_hashes.sha256").read_text().splitlines()]
files += ["resume_001/"+name for name in ["run.py","build.py","harness_observed.c","model.py","probe.py",
          "check_sage.py","replay_c.py","mutations.py","export_lean_blocks.py","verify_bundle.py"]]
for rel in files:
    source=W/rel; target=dest/rel
    assert all(not stat.S_ISLNK(p.lstat().st_mode) for p in [source,*source.parents])
    target.parent.mkdir(parents=True,exist_ok=True)
    with target.open("xb") as f:f.write(source.read_bytes())
    assert hashlib.sha256(target.read_bytes()).digest()==hashlib.sha256(source.read_bytes()).digest()
(dest/"COMMANDS.log").touch(exist_ok=False)
commands=[]
for mode in ["base-shared","observed-shared","base-normal","base-sanitize"]:
    commands.append(["python3","-B","resume_001/build.py",mode])
commands += [["python3","-B","resume_001/probe.py"],
             ["/home/footfalcon/miniforge3/envs/sage/bin/python","-B","resume_001/check_sage.py"],
             ["python3","-B","resume_001/replay_c.py","normal"],
             ["python3","-B","resume_001/replay_c.py","sanitize"],
             ["python3","-B","resume_001/mutations.py"],
             ["python3","-B","resume_001/export_lean_blocks.py"],
             ["/home/footfalcon/.elan/toolchains/leanprover--lean4---v4.34.0/bin/lean","formal/WitnessBlocks.lean"],
             ["python3","-B","resume_001/verify_bundle.py"]]
for argv in commands:
    print(json.dumps({"fresh_cwd":str(dest),"argv":argv}),flush=True)
    subprocess.run(["python3","-B","resume_001/run.py",*argv],cwd=dest,check=True)
semantic=["artifacts/witness.json","artifacts/witness.bin","artifacts/witness_c.txt",
          "artifacts/positive_controls.json","artifacts/norm_boundaries.json",
          "artifacts/decoder_controls.json","artifacts/sage_check.json",
          "artifacts/mutations.json","artifacts/lean_blocks_binding.json",
          "formal/WitnessBlocks.lean"]
comparisons=[]
for rel in semantic:
    expected=hashlib.sha256((W/rel).read_bytes()).hexdigest()
    actual=hashlib.sha256((dest/rel).read_bytes()).hexdigest()
    assert expected==actual,rel
    comparisons.append(dict(path=rel,sha256=actual))
receipt=dict(status="FRESH_REPLAY_MATCH",destination=str(dest),compared=comparisons,
             source_overwritten=False,original_initializers_rerun=False,
             source_manifest_sha256=hashlib.sha256((W/"inputs/source_hashes.sha256").read_bytes()).hexdigest(),
             output_anchor=sys.argv[2] if len(sys.argv)==3 else "PRE_FREEZE_REHEARSAL")
output=dest/"REPLAY_RESULT.json"
with output.open("x") as f:json.dump(receipt,f,indent=2);f.write("\n")
print(json.dumps(receipt,indent=2))
