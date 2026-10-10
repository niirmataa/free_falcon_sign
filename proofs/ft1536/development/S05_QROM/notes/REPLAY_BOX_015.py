#!/usr/bin/env python3
"""Fresh S05-015 closure, pinned prior artifacts; no upstream/Git writes."""
from pathlib import Path
import types,sys,json,hashlib,shutil
S=Path(__file__).resolve().parent.parent;WORK=S/'.build/box_moment_015'
ORDER=['BoxSupport015','BoxTail015','NormTail015','AcceptedMarginal015','FullMoment015','SamplerInterface015']
COUNTS=[9,8,5,9,13,3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
label=sys.argv[1];assert label and all(c.isalnum() or c=='_' for c in label)
B=WORK/label;B.mkdir(parents=True,exist_ok=False)
P=S/'notes/BUILD_KEY_SUPPORT_011.py'
expected=dict(line.split('  ',1)[::-1] for line in (S/'notes/KEY_SUPPORT_011_OUTPUTS.sha256').read_text().splitlines())['notes/BUILD_KEY_SUPPORT_011.py']
assert sha(P)==expected
source=P.read_text();marker="\nif sys.argv[1]=='prepare':";assert source.count(marker)==1
h=types.ModuleType('s05_compiler');h.__file__=str(P)
exec(compile(source.split(marker)[0],str(P),'exec'),h.__dict__);h.BUILD=B
libs=json.loads((h.BASE/'PINS.json').read_text())['library_roots']
BASE=B/'prior_library';BASE.mkdir();prior=[]
for r in json.loads((WORK/'lib/PINS.json').read_text()):
 if r['module'] in ORDER:continue
 art=Path(r['artifact']);src=Path(r['source'])
 assert sha(src)==r['source_sha256'] and sha(art)==r['artifact_sha256']
 dest=BASE/(r['module'].replace('.','/')+'.olean');dest.parent.mkdir(parents=True,exist_ok=True)
 for f in art.parent.glob(art.name+'*'):shutil.copyfile(f,dest.parent/f.name)
 prior.append({**r,'origin_artifact':str(art),'artifact':str(dest)})
assert len(prior)==65
(BASE/'PINS.json').write_text(json.dumps(prior,indent=2)+'\n')
records=[]
for name,count in zip(ORDER,COUNTS):
 d=B/'runs'/name
 if not h.compile_one(S/'formal'/(name+'.lean'),d,name,B/'lib',libs,BASE):sys.exit(1)
 r=json.loads((d/'receipt.json').read_text());so=(d/'stdout.txt').read_text();se=(d/'stderr.txt').read_text()
 assert r['warning_count']==r['error_count']==0 and not se and 'sorryAx' not in so
 assert so.count('depends on axioms:')+so.count('does not depend on any axioms')==count
 records.append({'module':name,'new_theorems':count,'receipt':str(d/'receipt.json'),'receipt_sha256':sha(d/'receipt.json'),
  'source_sha256':r['source_sha256'],'artifact':r['artifact'],'artifact_sha256':r['artifact_sha256']})
(B/'REPLAY_RECEIPT.json').write_text(json.dumps({'status':'CLEAN_FRESH_LOCAL_BUILD',
 'condition_class':'proof_obligation','conditions':['Q-SAMPLER'],'new_theorems':sum(COUNTS),
 'prior_modules_reused':65,'prior_pins_sha256':sha(BASE/'PINS.json'),'modules':records,
 'runner_sha256':sha(Path(__file__)),'scope':'Fresh015 closure with65 pinned prior artifacts; not a full upstream replay or independent review'},indent=2)+'\n')
print(json.dumps({'status':'CLEAN_FRESH_LOCAL_BUILD','new_theorems':sum(COUNTS),'replay':str(B)}))
