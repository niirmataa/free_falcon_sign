import errno,hashlib,json,os
from pathlib import Path
W=Path.cwd();I=W/'inputs/bootstrap';pin='e8eb2b091e9396d08afbdd3f8b4adebbebf97e7a0890306c5cf07c8e7beb4099'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(I/'MANIFEST.sha256')==pin
rows={};records=[]
for line in (I/'MANIFEST.sha256').read_text().splitlines():
 h,rel=line.split('  ',1);assert rel not in rows and not Path(rel).is_absolute() and '..' not in Path(rel).parts
 p=I/rel;assert p.is_file() and all(not q.is_symlink() for q in [p]+list(p.parents));assert sha(p)==h
 rows[rel]=h;records.append(dict(path=str(p),copy='inputs/bootstrap/'+rel,sha256=h))
assert len(rows)==73 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(rows)|{'MANIFEST.sha256'}
orig=json.loads((I/'ORIGINS.json').read_text());assert len(orig['files'])==71
for r in orig['files']:assert rows[r['copy']]==r['sha256'] and (I/r['copy']).stat().st_size==r['bytes']
probes=[]
for p,writable in [(W/'AGENTS.md',True),(I/'MANIFEST.sha256',False),(W.parents[3]/'AGENTS.md',False)]:
 try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert writable;v='writable_no_bytes_written'
 except OSError as e:assert not writable and e.errno==errno.EROFS;v='EROFS'
 probes.append(dict(path=str(p),result=v))
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),only_W_writable=True,bootstrap_readonly=True,probes=probes),indent=2)+'\n')
for rel in ['source','formal','checks','bin']:(W/rel).mkdir(exist_ok=False)
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,name=line.split('  ',1);assert rows['source/'+name]==h
 with (W/'source'/name).open('xb') as f:f.write((I/'source'/name).read_bytes())
for name in ['Floor','Comparator','Proposal','CDF','OrderedResidual','GuardPrefix']:
 with (W/'formal'/(name+'.lean')).open('xb') as f:f.write((I/'H3/formal'/(name+'.lean')).read_bytes())
for name in ['lean.py','dyadic.py','replaylib.py']:
 with (W/'scripts'/name).open('xb') as f:f.write((I/'H3/scripts'/name).read_bytes())
(W/'artifacts/reuse_layout.json').write_text(json.dumps(dict(formal='Six unchanged H3 modules copied to formal/; import names preserved; no old oleans.',
 scripts='lean/dyadic/replaylib are byte-identical copies; never executed under bootstrap; their cwd-based paths now refer to W.',
 inherited_hashes={n:rows['H3/formal/'+n+'.lean'] for n in ['Floor','Comparator','Proposal','CDF','OrderedResidual','GuardPrefix']},
 script_hashes={n:rows['H3/scripts/'+n] for n in ['lean.py','dyadic.py','replaylib.py']}),indent=2)+'\n')
records.append(dict(path=str(I/'MANIFEST.sha256'),copy='inputs/bootstrap/MANIFEST.sha256',sha256=pin))
for p,rel,want in [(Path('/home/footfalcon/Dokumenty/FT1536_ZADANIE_ASTRA_H3_ZERO_SCALAR_2026-09-19.md'),'inputs/task.md','0c039d00fdb229b909e6eee76b53ecb340a02c3c3b1b0cc3203bcf1332bf9fdd'),(W/'AGENTS.md','inputs/local_AGENTS.md',None),(W.parents[3]/'AGENTS.md','inputs/repo_AGENTS.md',None)]:
 h=sha(p);assert want is None or h==want
 with (W/rel).open('xb') as f:f.write(p.read_bytes())
 records.append(dict(path=str(p),copy=rel,sha256=h))
(W/'inputs/provenance.json').write_text(json.dumps(records,indent=2)+'\n');(W/'INPUTS.sha256').write_text(''.join(r['sha256']+'  '+r['path']+'\n' for r in records))
out=dict(manifest_sha256=pin,members=73,originals=71,source_files=17,exact_scope=True,all_pins_match=True)
(W/'artifacts/bootstrap_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
