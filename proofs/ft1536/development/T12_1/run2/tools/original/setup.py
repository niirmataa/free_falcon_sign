import hashlib,json,shutil
from pathlib import Path
W=Path(__file__).resolve().parent.parent
old=W.parent/'FT1536_MATH_EUFCMA_MTISIS_RUN_001/output'
B=W/'inputs/bootstrap'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def verify(root,name,pin):
    p=root/name;assert sha(p)==pin
    files=[]
    for line in p.read_text().splitlines():
        h,n=line.split(maxsplit=1);assert sha(root/n)==h,n;files.append(n)
    return len(files)
b=verify(B,'MANIFEST.sha256','fe10e6e2f05022bbe0f699551ff09d9c22c5a00cfea8f6a744d85355d61a8aad')
o=verify(old,'OUTPUTS.sha256','a9e3af2ebccc221035024fabc7631fa47a93b841c1611e3e79f28ccf5ee5c98f')
assert sha(B/'TASK.md')=='b4c11e3cf2a8cf3939a88400a2ea157b9d835e52c02aa974494b93b5f1376e45'
shutil.copytree(old/'formal',W/'run/formal',dirs_exist_ok=True)
for p in (W/'run/formal').rglob('*'):
    if p.is_file():p.chmod(0o644)
shutil.copyfile(old.parent/'run/job.py',W/'run/job.py')
shutil.copyfile(old/'LIBRARY_CLOSURE.json',W/'run/INHERITED_LIBRARY_CLOSURE.json')
(W/'run/SETUP.json').write_text(json.dumps(dict(bootstrap_files=b,prior_files=o,
    inherited_sources={str(p.relative_to(old)):sha(p) for p in (old/'formal').rglob('*.lean')},
    source_origin=str(old),inherited_rebuilt_in_final=True),indent=2)+'\n')
print('PASS bootstrap',b,'prior',o)
