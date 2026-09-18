"""Freeze the explicit scientific scope; keep the live log append-only."""
import datetime
import hashlib
import json
import os
from pathlib import Path
import stat

W=Path.cwd()


def read(path):
    assert all(not stat.S_ISLNK(p.lstat().st_mode) for p in [path,*path.parents]),path
    assert stat.S_ISREG(path.lstat().st_mode),path
    return path.read_bytes()


def sha(path):return hashlib.sha256(read(path)).hexdigest()


assert not (W/"OUTPUTS.sha256").exists(),"refuse to rewrite an output manifest"
result=json.loads(read(W/"RESULT.json"))
assert result["result"]=="COUNTEREXAMPLE_REQUIRED_DOMAIN"
assert result["report_sha256"]==sha(W/"REPORT.md")
verified=json.loads(read(W/"artifacts/verification_final.json"))
assert verified["original_inputs_checked"]==30 and verified["inherited_files_unchanged"]==1429
assert verified["theorems_checked"]==26

log=read(W/"COMMANDS.log")
assert hashlib.sha256(b"".join(log.splitlines(keepends=True)[:5])).hexdigest()=="7fd844fb21a9a549632d3bc307293948e11d4f3f6049dd26d6aa10b7c3591fc7"
with (W/"artifacts/COMMANDS.frozen.log").open("xb") as f:f.write(log)
cut=dict(created_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),
         bytes=len(log),lines=len(log.splitlines()),sha256=hashlib.sha256(log).hexdigest(),
         scope="exact live COMMANDS prefix before this freeze command receipt; later tail is not part of OUTPUTS")
with (W/"artifacts/COMMANDS.frozen.json").open("x") as f:json.dump(cut,f,indent=2);f.write("\n")
files=set(["REPORT.md","RESULT.json","REPLAY.md","OUTPUT_SCOPE.md","TOOLCHAIN.txt","INPUTS.sha256"])
for root in ["reference","inputs","scripts","formal","artifacts","resume_001"]:
    for base,dirs,names in os.walk(W/root,followlinks=False):
        base=Path(base)
        keep=[]
        for name in dirs:
            p=base/name;assert not p.is_symlink(),p
            rel=p.relative_to(W).as_posix()
            if name!="__pycache__" and rel!="resume_001/snapshot/bin":keep.append(name)
        dirs[:]=keep
        for name in names:
            if name.endswith((".lock",".pyc")):continue
            p=base/name
            assert stat.S_ISREG(p.lstat().st_mode) and not p.is_symlink(),p
            files.add(p.relative_to(W).as_posix())
for record in map(json.loads,log.splitlines()):
    for key in ["stdout","stderr"]:
        path=record.get(key)
        if path is not None:
            rel=Path(path);assert not rel.is_absolute() and ".." not in rel.parts
            files.add(rel.as_posix())
manifest="".join(sha(W/rel)+"  "+rel+"\n" for rel in sorted(files))
assert read(W/"COMMANDS.log")==log,"concurrent writer changed the log during freeze"
with (W/"OUTPUTS.sha256").open("x") as f:f.write(manifest)
for line in manifest.splitlines():
    digest,rel=line.split(maxsplit=1);assert sha(W/rel)==digest
print(json.dumps(dict(status="SCIENTIFIC_OUTPUTS_FROZEN",files=len(files),
                      report=str(W/"REPORT.md"),report_sha256=sha(W/"REPORT.md"),
                      outputs_sha256=sha(W/"OUTPUTS.sha256"),
                      command_prefix=cut),indent=2))
