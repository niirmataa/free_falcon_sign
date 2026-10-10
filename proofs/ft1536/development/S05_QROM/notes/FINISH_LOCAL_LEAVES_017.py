#!/usr/bin/env python3
"""After complete finite checks: verify pins, install, compile final interface/replay."""
from pathlib import Path
import hashlib,json,subprocess,sys,time
S=Path(__file__).resolve().parent.parent;B=S/'.build/local_leaves_017'
run=B/sys.argv[1];run.mkdir(exist_ok=False)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def command(args,label):
 with (run/(label+'.log')).open('w') as f:
  p=subprocess.run([sys.executable,'-B',*map(str,args)],stdout=f,stderr=subprocess.STDOUT)
 assert p.returncode==0,(label,p.returncode)
 print(label,'PASS',flush=True)
watch=B/'witness_build003'
while not (watch/'COMPLETE.json').exists():
 p=watch/'progress.jsonl'
 if p.exists():
  for r in map(json.loads,p.read_text().splitlines()):
   assert r['exit_code']==r['warning_count']==r['error_count']==0,('failed finite witness',r)
 time.sleep(2)
selected=json.loads((B/'witness_sources003/SELECTED.json').read_text())
receipt_records=[]
builder=S/'notes/BUILD_LOCAL_LEAVES_017.py'
for q in selected['selected']:
 d=B/'runs'/q['label'];r=json.loads((d/'receipt.json').read_text())
 assert r['exit_code']==r['warning_count']==r['error_count']==0
 assert r['source_sha256']==q['sha256']==sha(Path(r['command'][-1]))
 assert sha(Path(r['artifact']))==r['artifact_sha256']
 assert sha(d/'stdout.txt')==r['stdout_sha256'] and sha(d/'stderr.txt')==r['stderr_sha256']
 so=(d/'stdout.txt').read_text();assert not (d/'stderr.txt').read_text() and 'sorryAx' not in so
 assert so.count('depends on axioms:')==1
 atoms=so.split('depends on axioms:')[1].split('[')[1].split(']')[0].replace('\n','').replace(' ','').split(',')
 assert set(atoms)<={'propext','Classical.choice','Quot.sound'}
 pins={x['module']:x for x in json.loads((B/'lib/PINS.json').read_text())}
 if q['module'] not in pins:command([builder,'install',q['module'],q['label']],'install_'+q['module'])
 else:assert pins[q['module']]['source_sha256']==q['sha256'] and pins[q['module']]['artifact_sha256']==r['artifact_sha256']
 receipt_records.append({**q,'receipt':str(d/'receipt.json'),'receipt_sha256':sha(d/'receipt.json'),
   'artifact_sha256':r['artifact_sha256'],'elapsed_seconds':r['elapsed_seconds'],
   'compiler_peak_rss_KiB':r.get('compiler_peak_rss_KiB')})
(run/'FINITE_WITNESS_RECEIPT.json').write_text(json.dumps({'status':'ALL_SELECTED_FINITE_WITNESSES_CLEAN',
 'selected_manifest_sha256':sha(B/'witness_sources003/SELECTED.json'),'modules':receipt_records,
 'logical_rows':61441,'kernel_small_blocks_in_prefix':1920,'kernel_individual_remaining_rows':46081},indent=2)+'\n')
agg=selected['aggregate']['module'];assert sha(B/'generated'/(agg+'.lean'))==selected['aggregate']['sha256']
command([builder,'generated',agg,'aggregate001'],'aggregate')
command([builder,'install',agg,'aggregate001'],'install_aggregate')
command([builder,'ActualInterface017','actual001'],'actual')
command([builder,'install','ActualInterface017','actual001'],'install_actual')
command([S/'notes/REPLAY_LOCAL_LEAVES_017.py','final','structural_replay001'],'final_replay')
(run/'COMPLETE.json').write_text(json.dumps({'status':'FINAL_INTERFACE_AND_REPLAY_CLEAN','finite_receipt_sha256':sha(run/'FINITE_WITNESS_RECEIPT.json'),
 'actual_receipt_sha256':sha(B/'runs/actual001/receipt.json'),
 'replay_receipt_sha256':sha(B/'structural_replay001/REPLAY_RECEIPT.json')},indent=2)+'\n')
