import hashlib,json,re,shutil
from pathlib import Path
W=Path(__file__).resolve().parent.parent;O=W/'output';R=W/'run/fresh_replay_001'
old=W.parent/'FT1536_MATH_EUFCMA_MTISIS_RUN_001/output'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def dump(p,x):p.write_text(json.dumps(x,indent=2,sort_keys=True)+'\n')
res=json.loads((R/'REPLAY_RESULT.json').read_text());assert res['status']=='PASS'
H=O/'history';H.mkdir(exist_ok=True);history=[];commands=[]
for d in sorted((W/'run').iterdir()):
    if not d.is_dir() or not (d/'formal').exists() or d.name.startswith('fresh_replay'):continue
    h=H/d.name;h.mkdir(exist_ok=True)
    for sub in ['formal','sage','logs','generated']:
        if (d/sub).exists():shutil.copytree(d/sub,h/sub,dirs_exist_ok=True)
    for name in ['RECEIPTS.json','error_certificate.json']:
        if (d/name).exists():shutil.copyfile(d/name,h/name)
    rec=json.loads((d/'RECEIPTS.json').read_text()) if (d/'RECEIPTS.json').exists() else []
    history.append(dict(name=d.name,jobs=[dict(name=r['name'],exit_code=r['exit_code']) for r in rec]))
    commands.extend(dict(run=d.name,**r) for r in rec)
dump(H/'INDEX.json',history)
shutil.copytree(W/'run/failed-tools',H/'failed-tools',dirs_exist_ok=True)
(H/'organizers').mkdir(exist_ok=True)
for p in (W/'run').glob('*.py'):shutil.copyfile(p,H/'organizers'/p.name)
shutil.copyfile(W/'WORK_STATE.md',H/'WORK_STATE.md')
shutil.copyfile(W/'run/SETUP.json',O/'SOURCE_ORIGINS.json')
for p in (old/'formal/FT1536').glob('*.lean'):
    assert sha(p)==sha(O/'formal/FT1536'/p.name),p.name
shutil.copytree(R/'logs',O/'replay/logs',dirs_exist_ok=True)
for name in ['REPLAY_RESULT.json','EXECUTION_RECEIPTS.json','SAGE_RUNS.json','COMMANDS.log','AXIOMS.json']:
    shutil.copyfile(R/name,O/'replay'/name)
shutil.copytree(W/'run/guard_controls_001',O/'replay/guards',
    ignore=shutil.ignore_patterns('home','tmp','cache'),dirs_exist_ok=True)
ax=json.loads((R/'AXIOMS.json').read_text())
dump(O/'AXIOMS.json',dict(exports=ax,unexpected_axioms=[],raw='replay/logs/AuditRun2.stdout',
    raw_sha256=sha(R/'logs/AuditRun2.stdout')))
receipts=json.loads((R/'EXECUTION_RECEIPTS.json').read_text())
for r in receipts['jobs']:
    r['stdout']='replay/'+r['stdout'];r['stderr']='replay/'+r['stderr']
    commands.append(dict(run='fresh_replay_001',**r))
dump(O/'EXECUTION_RECEIPTS.json',dict(final_clean_replay=receipts,history='history/INDEX.json'))
(O/'COMMANDS.log').write_text(''.join(json.dumps(r)+'\n' for r in commands))
sage=[]
for name,src,work in [('sage_inherited','check_bounds.sage','inherited'),('sage_emit_error','check_emit_error.sage','new')]:
    r=next(r for r in receipts['jobs'] if r['name']==name)
    sage.append(dict(source='sage/'+src,source_sha256=sha(O/'sage'/src),receipt=r,
        producers={str(p.relative_to(R/'work'/work)):sha(p) for p in (R/'work'/work).rglob('*')
                   if p.is_file() and p.suffix in {'.json','.lean'}},mode='sage original.sage with preparser',version='10.9'))
dump(O/'SAGE_RUNS.json',sage)
semantic=[];bad=[]
for p in sorted((O/'formal').rglob('*.lean')):
    semantic.append(dict(path=str(p.relative_to(O)),sha256=sha(p),role='kernel source'))
    for n,line in enumerate(p.read_text().splitlines(),1):
        if re.search(r'\b(sorry|admit|native_decide|Lean\.ofReduceBool)\b',line) or re.match(r'^\s*axiom\b',line):
            bad.append(dict(path=str(p.relative_to(O)),line=n))
assert not bad,bad
for name in ['tools/replay.py','BUILD.json','EXPECTED.json','sage/check_bounds.sage','sage/check_emit_error.sage',
             'formal_types.txt','certificates.json','error_certificate.json']:
    semantic.append(dict(path=name,sha256=sha(O/name),role='semantic input/product'))
dump(O/'SEMANTIC_FILES.json',dict(files=semantic,library_closure='LIBRARY_CLOSURE.json',history_not_current=True))
dump(O/'SOURCE_SCAN.json',dict(forbidden_matches=[],scope='current own+inherited formal sources',warnings=0))
text=(R/'logs/AuditRun2.stdout').read_text();last=0;types=[]
for m in re.finditer(r"'([^']+)' (?:depends on axioms: \[[^\]]*\]|does not depend on any axioms)",text):
    types.append(dict(name=m[1],lean_type=text[last:m.start()].strip()));last=m.end()
g=json.loads((O/'GOAL_SPEC.json').read_text());g['checked_declarations']=types;dump(O/'GOAL_SPEC.json',g)
shutil.copytree(old/'dependency-licenses',O/'dependency-licenses',dirs_exist_ok=True)
summary=dict(jobs=len(res['receipts']),exports=len(ax),
    matched_products=len(res['comparisons']),job_elapsed_s=sum(r['elapsed_s'] for r in res['receipts']),
    maxrss_kib=max(r['cumulative_child_maxrss_kib'] for r in res['receipts']),
    history_runs=len(history),library_modules=res['library_modules'],library_artifacts=res['library_artifacts'])
dump(W/'run/FINAL_SUMMARY.json',summary)
print(json.dumps(summary,indent=2))
