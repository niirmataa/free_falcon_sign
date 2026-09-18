import difflib,errno,hashlib,json,os,stat
from pathlib import Path
W=Path.cwd();DOC=W.parent;P=DOC/'FT1536_L_NTT_RUN_001'
def read(p):
    assert not any(s in {'.private','private_extraction'} for s in p.parts)
    assert all(not stat.S_ISLNK(t.lstat().st_mode) for t in [p,*p.parents]);assert stat.S_ISREG(p.lstat().st_mode)
    return p.read_bytes()
def sha(p):return hashlib.sha256(read(p)).hexdigest()
pins=[(DOC/'AGENTS.md','e5d9cc7b5120aad39da592f796eef44cc8a1c71bc6c43b311f48362d60fdd038'),
 (W/'AGENTS.md','d3d55658f2435f73c0e5ec221898992fa4d25da66901c4d0e31b71563dec8009'),
 (DOC/'FT1536_ZADANIE_ASTRA_L_NTT_GLOBAL_2026-09-18.md','e2fae27504e275d769b939ddecf429dfcec8c4461f0ed9d420f6cb3a5380313a'),
 (DOC/'FT1536_PODSUMOWANIE_L_NTT_PARTIAL_2026-09-18.md','6a3b1699290448ccb02256ff06be978abb7f6b4b35fcfe45a85ec4b95d69394d'),
 (DOC/'FT1536_ZASADA_CZYSTEGO_LOGU_LEAN_2026-09-18.md','9f6b0731263853867914f5d1227ba62dd1059e8a79623d987204c3f4aa3d5da1'),
 (P/'REPORT.md','b89d618d7c1d3992fa1a9ea0ae8c84dcc348448f035905b87a03c37e20dfd650'),
 (P/'OUTPUTS.sha256','f23358ce0426f04196bbd8fd4e814afb2b14541c6df13854a67c994f6074771f'),
 (P/'CLAIM.md','c8e62a9d55cb8922d6cc3c673c249452983879329f92ab4ab79ab1eeb07c65c6'),
 (P/'DERIVATION.md','f91c0052528f84f85b2379dfc9c9c1df3c34f352836d2535ca88c25e7a9ab367'),
 (P/'OBLIGATIONS.json','5467801aac9c25f3c1f757f3c640fefcbb6074524874da0312a6e97aaa163bd8')]
for p,h in pins:assert sha(p)==h,p
denied=[]
for p in [P/'REPORT.md',DOC/'FT1536_L_RHO_RUN_001/REPORT.md',DOC/'AGENTS.md']:
    try:fd=os.open(p,os.O_WRONLY|os.O_CLOEXEC)
    except OSError as e:assert e.errno==errno.EROFS;denied.append(str(p))
    else:os.close(fd);raise RuntimeError('original writable')
(W/'artifacts/sandbox_write_probe.txt').write_text('ONLY_NEW_W\n')
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),write_inside_W=True,originals_EROFS=denied,original_bytes_written=0,network='unshared',PID_namespace='unshared'),indent=2)+'\n')
for rel in ['source','inputs','inputs/context','inputs/formal','inputs/certificates','formal','formal/Deps','bin']:(W/rel).mkdir()
records=[]
def take(p,rel,h):
    b=read(p);assert hashlib.sha256(b).hexdigest()==h
    with (W/rel).open('xb') as f:f.write(b)
    records.append(dict(path=str(p),sha256=h,copy=rel))
for i,(p,h) in enumerate(pins):take(p,'inputs/context/'+str(i)+'_'+p.name,h)
manifest=read(P/'inputs/source_hashes.sha256');assert hashlib.sha256(manifest).hexdigest()=='2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a'
(W/'inputs/source_hashes.sha256').write_bytes(manifest)
for line in manifest.decode().splitlines():
    h,n=line.split();take(P/'source'/n,'source/'+n,h)
om={rel:h for h,rel in (l.split(maxsplit=1) for l in read(P/'OUTPUTS.sha256').decode().splitlines())}
adapt=[]
for name in ['Words','Linear','Tables','Composition']:
    rel='formal/'+name+'.lean';take(P/rel,'inputs/formal/'+name+'.lean',om[rel])
    original=read(W/'inputs/formal'/ (name+'.lean')).decode();new=original
    if name=='Words':
        assert new.count('Int.ofNat_nonneg')==1
        new=new.replace('Int.ofNat_nonneg','Int.natCast_nonneg')
    (W/'formal/Deps'/(name+'.lean')).write_text(new)
    if new!=original:
        diff=''.join(difflib.unified_diff(original.splitlines(True),new.splitlines(True),fromfile='inputs/formal/'+name+'.lean',tofile='formal/Deps/'+name+'.lean'))
        (W/'formal/Deps'/(name+'.patch')).write_text(diff)
    adapt.append(dict(file=name,original_sha256=hashlib.sha256(original.encode()).hexdigest(),working_sha256=hashlib.sha256(new.encode()).hexdigest(),change='proof alias only' if new!=original else 'byte-identical'))
for rel,name in [('RESULT.json','PREV_RESULT.json'),('artifacts/constants_certificate.json','constants.json'),
 ('artifacts/kernel_literals.json','kernel_literals.json'),('artifacts/source_binding.json','source_binding.json'),
 ('artifacts/tables_C.json','tables_C.json'),('inputs/L_RHO_RESULT.json','L_RHO_RESULT.json'),
 ('inputs/public/witness.json','witness.json')]:take(P/rel,'inputs/certificates/'+name,om[rel])
(W/'INPUTS.sha256').write_text(''.join(r['sha256']+'  '+r['path']+'\n' for r in records))
(W/'inputs/provenance.json').write_text(json.dumps(records,indent=2)+'\n')
(W/'artifacts/formal_adaptations.json').write_text(json.dumps(adapt,indent=2)+'\n')
print(json.dumps(dict(consumed_inputs=len(records),source_files=17,write_isolation='CONFIRMED',adaptations=adapt),indent=2))
