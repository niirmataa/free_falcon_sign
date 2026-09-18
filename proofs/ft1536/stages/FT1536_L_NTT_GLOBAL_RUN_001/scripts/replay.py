"""Fresh replay, no carried .olean/binaries/cache, frozen semantic baseline."""
import hashlib,json,os,shutil,subprocess
from pathlib import Path
W=Path.cwd();R=W/'replay';assert not R.exists()
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def copy(p):
    assert p.is_file() and not p.is_symlink()
    target=R/p.relative_to(W);target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,target)
scripts=['run.py','export_twiddles.py','export_block_checks.py','prepare_controls.py','control_run.py','sage_controls.py','build_final.py']
for name in scripts:copy(W/'scripts'/name)
for folder in ['source','inputs']:
    for p in sorted((W/folder).rglob('*')):
        assert not p.is_symlink()
        if p.is_file():copy(p)
for p in sorted((W/'formal').rglob('*.lean')):
    if 'attempts' not in p.parts and p.name not in ['Twiddles.lean','BlockChecks.lean','Audit.lean']:copy(p)
for d in ['bin','artifacts','logs']:(R/d).mkdir(exist_ok=True)
semantic=[]
for folder,pattern in [('formal','*.lean'),('source','*'),('checks','*.c'),('checks','*.txt'),('checks','*.trace'),('logs/final','*')]:
    for p in sorted((W/folder).rglob(pattern)):
        if p.is_file() and 'attempts' not in p.parts:semantic.append(p.relative_to(W).as_posix())
semantic+=['artifacts/twiddle_binding.json','artifacts/control_binding.json','artifacts/controls.json','artifacts/sage_controls.json','artifacts/formal_audit.json']
semantic=sorted(set(semantic));baseline={p:sha(W/p) for p in semantic}
with (W/'artifacts/replay_baseline.sha256').open('x') as f:
    f.write(''.join(h+'  '+p+'\n' for p,h in baseline.items()))
prefix=(W/'COMMANDS.log').read_bytes()
(W/'artifacts/replay_prefix.json').write_text(json.dumps(dict(bytes=len(prefix),sha256=hashlib.sha256(prefix).hexdigest(),semantic_manifest_sha256=sha(W/'artifacts/replay_baseline.sha256')),indent=2)+'\n')
cmds=[(30,['python3','-B','scripts/export_twiddles.py']),
      (30,['python3','-B','scripts/export_block_checks.py']),
      (180,['python3','-B','scripts/build_final.py']),
      (30,['python3','-B','scripts/prepare_controls.py']),
      (120,['python3','-B','scripts/control_run.py']),
      (120,['/home/footfalcon/.local/bin/sage','scripts/sage_controls.py'])]
for limit,argv in cmds:
    p=subprocess.run(['python3','-B','scripts/run.py',str(limit)]+argv,cwd=R,timeout=limit+10)
    assert p.returncode==0,argv
comparison=[]
for rel,want in baseline.items():
    actual=sha(R/rel);assert actual==want,(rel,want,actual)
    comparison.append(dict(path=rel,sha256=actual))
assert (W/'COMMANDS.log').read_bytes()[:len(prefix)]==prefix
result=dict(status='PASS',fresh_root=str(R),no_carried_olean_binary_cache=True,semantic_files_equal=len(comparison),
            files=comparison,baseline_sha256=sha(W/'artifacts/replay_baseline.sha256'),
            note='timings, cwd-bearing receipts and binary/cache products are excluded from semantic equality and retained separately')
(W/'artifacts/replay_result.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='files'},indent=2))
