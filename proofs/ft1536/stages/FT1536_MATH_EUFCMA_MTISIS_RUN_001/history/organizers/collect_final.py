#!/usr/bin/env python3
"""Archive already-completed receipts and attach explicit source/product bindings."""
import hashlib
import json
from pathlib import Path
import re
import shutil

W=Path(__file__).resolve().parent.parent
O=W/'output';R=W/'run/fresh_replay_001'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def dump(p,x):p.write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
assert json.loads((R/'REPLAY_RESULT.json').read_text())['status']=='PASS'
target=O/'replay'
target.mkdir(exist_ok=True)
shutil.copytree(R/'logs',target/'logs',dirs_exist_ok=True)
for name in ['REPLAY_RESULT.json','EXECUTION_RECEIPTS.json','SAGE_RUNS.json','COMMANDS.log','AXIOMS.json']:
    shutil.copyfile(R/name,target/name)
shutil.copytree(W/'run/guard_controls_001',target/'guard_controls',
                ignore=shutil.ignore_patterns('home','tmp','cache'),dirs_exist_ok=True)
axioms=json.loads((R/'AXIOMS.json').read_text())
dump(O/'AXIOMS.json',dict(schema='T12_1_TRANSITIVE_AXIOMS_V1',exports=axioms,
    all_exports_audited=True,unexpected_axioms=[],
    raw_log='replay/logs/Audit.stdout',raw_log_sha256=sha(R/'logs/Audit.stdout')))
receipts=json.loads((R/'EXECUTION_RECEIPTS.json').read_text())
for r in receipts['jobs']:
    r['stdout']='replay/'+r['stdout'];r['stderr']='replay/'+r['stderr']
dump(O/'EXECUTION_RECEIPTS.json',dict(schema='T12_1_FINAL_RECEIPTS_V1',
    own_fresh_replay=receipts,history_index='history/INDEX.json',
    provenance='raw per-job receipts preserved verbatim under replay/logs and history/*/logs'))
commands=[]
for d in sorted((O/'history').iterdir()):
    if d.is_dir() and (d/'RECEIPTS.json').exists():
        for r in json.loads((d/'RECEIPTS.json').read_text()):commands.append(dict(run=d.name,**r))
for r in receipts['jobs']:commands.append(dict(run='fresh_replay_001',**r))
(O/'COMMANDS.log').write_text(''.join(json.dumps(r)+'\n' for r in commands))
sruns=[]
for label,path in [('sage_001',W/'run/sage_001'),('sage_002',W/'run/sage_002'),('fresh_replay_001',R)]:
    source=path/'sage/check_bounds.sage'
    jobs=json.loads((path/('EXECUTION_RECEIPTS.json' if path==R else 'RECEIPTS.json')).read_text())
    if isinstance(jobs,dict):jobs=jobs['jobs']
    rs=[j for j in jobs if j['name'] in {'sage','sage_controls'}]
    assert len(rs)==1
    r=rs[0]
    base='replay' if path==R else 'history/'+label
    productroot=path/'work' if path==R else path
    producer_outputs={}
    for rel in ['certificates.json','generated/Certificate.lean']:
        if (productroot/rel).exists():producer_outputs[rel]=sha(productroot/rel)
    sruns.append(dict(run=label,argv=r['argv'],version='10.9',mode='sage original.sage with standard preparser',
        source_sha256=sha(source),source_in_bundle='sage/check_bounds.sage' if path==R else base+'/sage/check_bounds.sage',
        exit_code=r['exit_code'],elapsed_s=r['elapsed_s'],
        stdout=base+'/'+r['stdout'],stdout_sha256=r['stdout_sha256'],
        stderr=base+'/'+r['stderr'],stderr_sha256=r['stderr_sha256'],
        producer_outputs=producer_outputs,
        consumer_lean_source='formal/FT1536/Certificate.lean' if path==R else None))
dump(O/'SAGE_RUNS.json',dict(schema='T12_1_SAGE_BINDINGS_V1',runs=sruns))
# Full checked types remain separate from the pre-proof intended goal specification.
text=(R/'logs/Audit.stdout').read_text();last=0;typed=[]
for m in re.finditer(r"'([^']+)' (?:depends on axioms: \[[^\]]*\]|does not depend on any axioms)",text):
    typed.append(dict(name=m[1],lean_type=text[last:m.start()].strip()))
    last=m.end()
g=json.loads((O/'GOAL_SPEC.json').read_text());g['checked_declarations']=typed
dump(O/'GOAL_SPEC.json',g)
forbidden=[]
for p in (O/'formal').rglob('*.lean'):
    for n,line in enumerate(p.read_text().splitlines(),1):
        if re.search(r'\b(sorry|admit|native_decide|Lean\.ofReduceBool)\b',line) or re.match(r'^\s*axiom\b',line):
            forbidden.append(dict(path=str(p.relative_to(O)),line=n,text=line))
assert not forbidden,forbidden
dump(O/'SOURCE_SCAN.json',dict(scope='own formal/*.lean only',forbidden_matches=forbidden,
    audit_log='replay/logs/Audit.stdout',warnings_in_final_own_build=0))
semantic=[]
for p in sorted((O/'formal').rglob('*.lean')):
    semantic.append(dict(path=str(p.relative_to(O)),role='kernel source',sha256=sha(p)))
for name,role in [('sage/check_bounds.sage','authoritative Sage source'),('certificates.json','exact controls'),
                  ('formal_types.txt','checked declaration types and axioms'),('tools/replay.py','replay controller'),
                  ('BUILD.json','build configuration'),('EXPECTED.json','predeclared semantic products')]:
    semantic.append(dict(path=name,role=role,sha256=sha(O/name)))
dump(O/'SEMANTIC_FILES.json',dict(schema='T12_1_SEMANTIC_FILES_V1',files=semantic,
    historical_sources='history/; not current semantic inputs',
    imported_source_closure='LIBRARY_CLOSURE.json',scope='No mathematical assertion is sourced from Sage PASS alone.'))
# Preserve upstream license texts without modifying the imported source closure.
closure=json.loads((O/'LIBRARY_CLOSURE.json').read_text())
for key,item in closure['roots'].items():
    root=Path(item['source'])
    candidates=[root/'LICENSE',root/'LICENSE.md',root/'LICENSE.txt']
    if key=='lean':candidates += [root.parent.parent/'LICENSE']
    for p in candidates:
        if p.is_file():
            dest=O/'dependency-licenses'/key/p.name
            dest.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,dest)
print('Collected final replay, source bindings, axiom audit and semantic scope.')
