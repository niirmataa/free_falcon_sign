#!/usr/bin/env python3
"""Fresh bounded016 build including all generated public integer modules."""
from pathlib import Path
import json,hashlib,shutil,types,sys
S=Path(__file__).resolve().parent.parent;W=S/'.build/implementation_016'
ORDER=['FiniteLaw016','FiniteIndex016','CapExecution016','RejectionDomination016','BitTapes016',
 'ProductLaw016','CapDomination016','CoarseBudget016','SamplerCode016','SamplerSupport016',
 'SamplerAC016','ProgramLaw016','RawConditioning016','RawPairDomination016','ActualTables016',
 'ImplementationBridge016','ActualInterface016']
COUNTS=[7,1,8,8,7,6,3,6,5,11,3,6,6,5,6,5,3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
label=sys.argv[1];assert label and all(c.isalnum() or c=='_' for c in label)
B=W/label;B.mkdir(parents=True,exist_ok=False);BASE=B/'prior';BASE.mkdir()
P=S/'notes/BUILD_KEY_SUPPORT_011.py';expected=dict(line.split('  ',1)[::-1] for line in (S/'notes/KEY_SUPPORT_011_OUTPUTS.sha256').read_text().splitlines())['notes/BUILD_KEY_SUPPORT_011.py'];assert sha(P)==expected
text=P.read_text();marker="\nif sys.argv[1]=='prepare':";assert text.count(marker)==1
h=types.ModuleType('helper');h.__file__=str(P)
# A64MiB stack for this fresh closure; same CPU/memory/wall limits as the bounded helper.
exec(compile(text.split(marker)[0].replace("'-s8192'","'-s65536'"),str(P),'exec'),h.__dict__);h.BUILD=B
libs=json.loads((S/'notes/BOX_MOMENT_015_INPUTS.json').read_text())['library_roots']
generated=json.loads((W/'generated/MANIFEST.json').read_text())['modules'];new=set(ORDER)|{x['module'] for x in generated};prior=[]
for r in json.loads((W/'lib/PINS.json').read_text()):
 if r['module'] in new:continue
 src=Path(r['source']);art=Path(r['artifact']);assert sha(src)==r['source_sha256'] and sha(art)==r['artifact_sha256']
 dest=BASE/(r['module'].replace('.','/')+'.olean');dest.parent.mkdir(parents=True,exist_ok=True)
 for f in art.parent.glob(art.name+'*'):shutil.copyfile(f,dest.parent/f.name)
 prior.append({**r,'artifact':str(dest),'origin_artifact':str(art)})
assert len(prior)==74,len(prior)
(BASE/'PINS.json').write_text(json.dumps(prior,indent=2)+'\n')
sequence=[(x['module'],Path(x['source']),0) for x in generated]+[(m,S/'formal'/(m+'.lean'),c) for m,c in zip(ORDER,COUNTS)]
results=[]
for name,src,count in sequence:
 d=B/'runs'/name
 if not h.compile_one(src,d,name,B/'lib',libs,BASE):sys.exit(1)
 r=json.loads((d/'receipt.json').read_text());so=(d/'stdout.txt').read_text();se=(d/'stderr.txt').read_text()
 assert r['warning_count']==r['error_count']==0 and not se and 'sorryAx' not in so
 assert so.count('depends on axioms:')+so.count('does not depend on any axioms')==count
 results.append({'module':name,'source':str(src),'source_sha256':sha(src),'new_audited_exports':count,
  'artifact':r['artifact'],'artifact_sha256':r['artifact_sha256'],'receipt':str(d/'receipt.json'),
  'receipt_sha256':sha(d/'receipt.json'),'elapsed_seconds':r['elapsed_seconds']})
(B/'REPLAY_RECEIPT.json').write_text(json.dumps({'status':'CLEAN_FRESH_CLOSURE','prior_modules_reused':len(prior),'prior_pin_sha256':sha(BASE/'PINS.json'),
 'proof_modules':len(ORDER),'generated_data_modules':len(generated),'new_audited_exports':sum(COUNTS),'modules':results,
 'runner_sha256':sha(Path(__file__)),'scope':'All new016 proof modules and generated literal data freshly built; inherited74 project modules reused; not independent review or full ROM replay'},indent=2)+'\n')
print(json.dumps({'status':'CLEAN_FRESH_CLOSURE','new_audited_exports':sum(COUNTS),'proof_modules':len(ORDER),'data_modules':len(generated),'seconds':sum(x['elapsed_seconds'] for x in results)}))
