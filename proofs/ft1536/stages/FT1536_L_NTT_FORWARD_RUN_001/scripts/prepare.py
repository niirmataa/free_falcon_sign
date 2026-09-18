"""Copy only pinned public mathematical inputs from archived checkpoints."""
import difflib,errno,hashlib,json,os
from pathlib import Path
W=Path.cwd();A=W.parents[1];P=A/'stages/FT1536_L_NTT_GLOBAL_RUN_001';L=A/'stages/FT1536_L_NTT_RUN_001';R=A/'stages/FT1536_L_RHO_RUN_001'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert W.name=='FT1536_L_NTT_FORWARD_RUN_001'
probes=[]
for p,allowed in [(W/'AGENTS.md',True),(P/'REPORT.md',False),(W.parents[3]/'AGENTS.md',False)]:
    try:fd=os.open(p,os.O_WRONLY);os.close(fd);assert allowed;res='writable_no_bytes_written'
    except OSError as e:assert not allowed and e.errno==errno.EROFS;res='EROFS'
    probes.append(dict(path=str(p),result=res))
(W/'artifacts/sandbox.json').write_text(json.dumps(dict(cwd=str(W),only_W_writable=True,probes=probes),indent=2)+'\n')
pins={'REPORT.md':'d5e5dc7cc65f2d12ade4e1928cc705b947e0203657decac59b352ff8fd1d56e8',
 'OUTPUTS.sha256':'6095dbfbb616d901e5a7991f608b94bbd7c916167f16baf7d2f50fc3e353b129',
 'source/falcon-vrfy.c':'3fe78f8df8003b760a21f4897b44b876717e30029bed031ee7d0cd224e968d42',
 'formal/ForwardProgress.lean':'ac4cc1a2a8abb7c52ef53ab98f48a3bb94a59aa1a0aa5f06de41ecfefb7c5a5b',
 'formal/InverseGlobal.lean':'b47e946cdc92b33825d075fcf37709fa7ed114680448bf4fcf0da8a4dec44c8e',
 'formal/Pipeline.lean':'f8d06c187c79c75d1e2b725728cd11b15b3f2663da621ad306d4dc1b09430874',
 'formal/SourceModel.lean':'2067c0851d41992ecdc97311e3e496a71d47f272f14867ba508cb91faf97d24f',
 'INVARIANTS.md':'20b7f16e58bd66c744ca573e3f2ccd196397d7dbbc906fe920bc2868a91a90fc',
 'SOURCE_MODEL_BINDING.md':'891596976f3b79afff55690a8568fde54786945c9caae73794c823ab1649a42a'}
for rel,want in pins.items():assert sha(P/rel)==want,rel
def manifest(base):
    rows={}
    for line in (base/'OUTPUTS.sha256').read_text().splitlines():
        h,rel=line.split('  ',1);assert not Path(rel).is_absolute() and '..' not in Path(rel).parts
        assert rel not in rows;rows[rel]=h
    return rows
pm=manifest(P);lm=manifest(L);rm=manifest(R)
records=[]
def copy(p,rel,want=None):
    assert p.is_file() and all(not q.is_symlink() for q in [p]+list(p.parents))
    data=p.read_bytes();h=hashlib.sha256(data).hexdigest();assert want is None or h==want,(p,h,want)
    out=W/rel;out.parent.mkdir(parents=True,exist_ok=True)
    with out.open('xb') as f:f.write(data)
    records.append(dict(path=str(p),copy=rel,sha256=h))
for rel in ['REPORT.md','RESULT.json','OBLIGATIONS.json','INVARIANTS.md','SOURCE_MODEL_BINDING.md','REUSED_RESULTS.md','OUTPUT_SCOPE.md']:
    copy(P/rel,'inputs/PREV/'+rel,pm[rel])
copy(P/'OUTPUTS.sha256','inputs/PREV/OUTPUTS.sha256',pins['OUTPUTS.sha256'])
copy(L/'DERIVATION.md','inputs/LOCAL/DERIVATION.md',lm['DERIVATION.md'])
copy(L/'OUTPUTS.sha256','inputs/LOCAL/OUTPUTS.sha256','f23358ce0426f04196bbd8fd4e814afb2b14541c6df13854a67c994f6074771f')
copy(R/'REPORT.md','inputs/RHO/REPORT.md',rm['REPORT.md']);copy(R/'RESULT.json','inputs/RHO/RESULT.json',rm['RESULT.json'])
copy(R/'OUTPUTS.sha256','inputs/RHO/OUTPUTS.sha256','d5cabfdaf69f080bf31b9e1903bacc4a319f87cd38cb4b643ff5e98f1240f687')
copy(R/'formal/Rho.lean','inputs/RHO/Rho.lean',rm['formal/Rho.lean'])
original=(W/'inputs/RHO/Rho.lean').read_text();adapted=original.replace('if_pos','ite_eq_left').replace('if_neg','ite_eq_right')
(W/'formal').mkdir(exist_ok=True)
with (W/'formal/Rho.lean').open('x') as f:f.write(adapted)
(W/'formal/Rho.patch').write_text(''.join(difflib.unified_diff(original.splitlines(True),adapted.splitlines(True),fromfile='inputs/RHO/Rho.lean',tofile='formal/Rho.lean')))
(W/'artifacts/adaptations.json').write_text(json.dumps(dict(file='formal/Rho.lean',old_sha256=sha(W/'inputs/RHO/Rho.lean'),new_sha256=sha(W/'formal/Rho.lean'),change='Only deprecated if_pos/if_neg aliases; no theorem or definition changes'),indent=2)+'\n')
mods=['Deps/Words','Deps/Linear','Deps/Tables','Deps/Composition','Buffer','Layouts','Twiddles','SourceModel','Expressions','BlockExpressions','BlockChecks','LocalInverse','Stages','InverseGlobal','ForwardProgress','Pipeline']
for name in mods:
    rel='formal/'+name+'.lean';copy(P/rel,rel,pm[rel])
copy(P/'inputs/source_hashes.sha256','inputs/source_hashes.sha256','2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a')
for line in (W/'inputs/source_hashes.sha256').read_text().splitlines():
    h,name=line.split('  ',1);copy(P/'source'/name,'source/'+name,h)
for name in ['tables_C.json','kernel_literals.json','constants.json']:
    rel='inputs/certificates/'+name;copy(P/rel,rel,pm[rel])
task=A/'documents/FT1536_ZADANIE_ASTRA_L_NTT_FORWARD_2026-09-18.md'
copy(task,'inputs/task.md','c25ef7c8ec9f066326e8f6f4a97760082f24d625e584a079e25c6dd75e237c9c')
copy(A/'documents/FT1536_ZASADA_CZYSTEGO_LOGU_LEAN_2026-09-18.md','inputs/clean_log.md','9f6b0731263853867914f5d1227ba62dd1059e8a79623d987204c3f4aa3d5da1')
copy(W/'AGENTS.md','inputs/local_AGENTS.md');copy(W.parents[3]/'AGENTS.md','inputs/repo_AGENTS.md')
(W/'inputs/provenance.json').write_text(json.dumps(records,indent=2)+'\n')
(W/'INPUTS.sha256').write_text(''.join(r['sha256']+'  '+r['path']+'\n' for r in records))
(W/'artifacts/inherited_modules.json').write_text(json.dumps(mods+['Rho'],indent=2)+'\n')
print(json.dumps(dict(pins_verified=len(pins),inputs_copied=len(records),inherited_modules=len(mods),source_unchanged=True,sandbox=probes),indent=2))
