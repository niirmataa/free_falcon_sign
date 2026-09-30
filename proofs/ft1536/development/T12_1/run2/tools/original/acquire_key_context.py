import hashlib,json,shutil
from pathlib import Path
W=Path(__file__).resolve().parent.parent
REPO=W.parents[3]
stage=REPO/'proofs/ft1536/stages/FT1536_H3_ROOT_LDL_RUN_001'
t5=stage/'inputs/bootstrap/legacy/T5'
dest=W/'inputs/legal_key_context'
dest.mkdir(exist_ok=True)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(t5/'THEOREM.md')=='21b7e453a3a9529c463f492234d078a3e737105cb539e553adce5e103a6c5784'
pins={n:h for h,n in (line.split(maxsplit=1) for line in (stage/'OUTPUTS.sha256').read_text().splitlines())}
origins=[]
for p in sorted(t5.rglob('*')):
    if not p.is_file():continue
    assert sha(p)==pins[str(p.relative_to(stage))]
    target=dest/'T5'/p.relative_to(t5);target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(p,target)
    origins.append(dict(copy=str(target.relative_to(dest)),original=str(p),sha256=sha(p)))
m0=REPO/'proofs/ft1536/stages/FT1536_M0_CONTRACT_RUN_001'
for rel,pin in [('source/falcon-keygen.c','0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf'),
                ('PROFILE.json',None)]:
    p=m0/rel
    if pin:assert sha(p)==pin
    target=dest/'M0'/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,target)
    origins.append(dict(copy=str(target.relative_to(dest)),original=str(p),sha256=sha(p)))
(dest/'ORIGINS.json').write_text(json.dumps(origins,indent=2)+'\n')
(dest/'MANIFEST.sha256').write_text(''.join(f'{sha(p)}  {p.relative_to(dest)}\n' for p in sorted(dest.rglob('*'))
    if p.is_file() and p.name!='MANIFEST.sha256'))
print('LEGAL_KEY_CONTEXT_PASS',len(origins),'MANIFEST',sha(dest/'MANIFEST.sha256'))
