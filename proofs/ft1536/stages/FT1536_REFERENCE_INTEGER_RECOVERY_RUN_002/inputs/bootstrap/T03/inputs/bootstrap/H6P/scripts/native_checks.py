import json,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];group=int(sys.argv[2]);assert mode in ['normal','sanitized'];cases=json.loads((W/'artifacts'/('fixtures_'+str(group)+'.json')).read_text())['cases'];receipts=[];matches=[]
for c in cases:
 assert sha(W/c['input'])==c['input_sha256'];cmd=['bin/'+c['exe']+'-'+mode,c['mode']];t=time.monotonic();p=subprocess.run(cmd,input=(W/c['input']).read_bytes(),capture_output=True,timeout=90);tag='native_'+mode+'_'+c['name']
 for s,b in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/(tag+'.'+s)).write_bytes(b)
 r=dict(case=c['name'],argv=cmd,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout_sha256=sha(W/'logs'/(tag+'.stdout')),stderr_sha256=sha(W/'logs'/(tag+'.stderr')));receipts.append(r);(W/'artifacts'/('native_receipts_'+mode+'_'+str(group)+'.json')).write_text(json.dumps(receipts,indent=2)+'\n')
 assert p.returncode==0 and not p.stderr,(c['name'],p.returncode,p.stderr.decode())
 if 'expected' in c:assert sha(W/c['expected'])==c['expected_sha256'] and p.stdout==(W/c['expected']).read_bytes(),c['name']
 else:
  model=json.loads((W/c['model']).read_text());lines=p.stdout.decode().splitlines();assert lines[-1]=='CANARIES PASS';events=[]
  for s in lines:
   if s.startswith('EV '):
    t=s.split();events.append([t[1],int(t[2]),[int(w,16) for w in t[3:]]])
  expected=[[n,0,a] for n,a in model['events']]+model['ifft0']+model['ifft1']+[['tx_final',0,model['tx']],['ty_final',0,model['ty']]];assert events==expected
  for name in ['w1','w2','s1','s2']:assert list(map(int,next(x for x in lines if x.startswith(name.upper()+' ')).split()[1:]))==model[name]
 matches.append(dict(case=c['name'],stdout_sha256=r['stdout_sha256'],stderr_sha256=r['stderr_sha256'],exact_words_and_frames=True));print('PASS_NATIVE',mode,c['name'])
(W/'artifacts'/('native_'+mode+'_'+str(group)+'.json')).write_text(json.dumps(dict(status='PASS_ORIGINAL_NOISE_MAP_POST_RINT_CONTROLS',mode=mode,group=group,matches=matches),indent=2)+'\n')
