import errno,hashlib,json,os
from pathlib import Path
W=Path.cwd();I=W/'inputs/bootstrap'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(I/'MANIFEST.sha256')=='f9ea278838e9d1f8f959100175f56c62217997ff25611fccc0b9353dd9fcfe40'
rows={};records=[]
def safe(p):assert p.is_file() and all(not q.is_symlink() for q in [p]+list(p.parents));return p
for line in (I/'MANIFEST.sha256').read_text().splitlines():
    h,rel=line.split('  ',1);assert not Path(rel).is_absolute() and '..' not in Path(rel).parts and rel not in rows
    p=safe(I/rel);assert sha(p)==h;rows[rel]=h;records.append(dict(path=str(p),copy='inputs/bootstrap/'+rel,sha256=h))
assert len(rows)==52
assert {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==50
for r in orig['files']:assert rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
probes=[]
for p,allow in [(W/'AGENTS.md',True),(I/'MANIFEST.sha256',False),(W.parents[3]/'AGENTS.md',False)]:
    try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert allow;value='writable_no_bytes_written'
    except OSError as e:assert not allow and e.errno==errno.EROFS;value='EROFS'
    probes.append(dict(path=str(p),result=value))
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),probes=probes,only_W_writable=True,bootstrap_readonly=True),indent=2)+'\n')
S=W/'source';S.mkdir(exist_ok=False)
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
    h,name=line.split('  ',1);assert rows['source/'+name]==h
    with (S/name).open('xb') as f:f.write((I/'source'/name).read_bytes())
assert len(list(S.iterdir()))==17
for rel in ['formal','checks','bin']:(W/rel).mkdir(exist_ok=True)
records.append(dict(path=str(I/'MANIFEST.sha256'),copy='inputs/bootstrap/MANIFEST.sha256',sha256=sha(I/'MANIFEST.sha256')))
for p,rel,want in [(Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_RANGE_2026-09-19.md'),'inputs/task.md','7eb75c4f19c32c1a20a3ec7677ef75293132e9238b8dd64cfff1f4d4f34607e0'),
 (W/'AGENTS.md','inputs/local_AGENTS.md',None),(W.parents[3]/'AGENTS.md','inputs/repo_AGENTS.md',None)]:
    safe(p);h=sha(p);assert want is None or want==h
    with (W/rel).open('xb') as f:f.write(p.read_bytes())
    records.append(dict(path=str(p),copy=rel,sha256=h))
(W/'inputs/provenance.json').write_text(json.dumps(records,indent=2)+'\n')
(W/'INPUTS.sha256').write_text(''.join(r['sha256']+'  '+r['path']+'\n' for r in records))
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(dict(manifest_sha256=sha(I/'MANIFEST.sha256'),members=52,originals=50,exact_scope=True,source_files=17,all_hashes_match=True),indent=2)+'\n')
print((W/'artifacts/bootstrap_verified.json').read_text())
