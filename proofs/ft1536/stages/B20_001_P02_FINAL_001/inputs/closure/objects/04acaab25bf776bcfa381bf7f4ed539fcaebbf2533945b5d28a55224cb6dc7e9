import json,subprocess,sys,time
from pathlib import Path
from replaylib import sha
from codec_model import literal_encode,frame
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','sanitized'];rows=json.loads((W/'artifacts/fixtures.json').read_text())['cases'];receipts=[];matches=[]
for c in rows:
 assert sha(W/c['input'])==c['input_sha256'];cmd=['bin/'+c['exe']+'-'+mode,c['mode']];t=time.monotonic();p=subprocess.run(cmd,input=(W/c['input']).read_bytes(),capture_output=True,timeout=30);tag='native_'+mode+'_'+c['name']
 for s,b in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/(tag+'.'+s)).write_bytes(b)
 receipt=dict(case=c['name'],argv=cmd,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout_sha256=sha(W/'logs'/(tag+'.stdout')),stderr_sha256=sha(W/'logs'/(tag+'.stderr')));receipts.append(receipt);(W/'artifacts'/('native_receipts_'+mode+'.json')).write_text(json.dumps(receipts,indent=2)+'\n')
 assert p.returncode==0 and not p.stderr,(c['name'],p.returncode,p.stderr.decode())
 if 'expected' in c:assert sha(W/c['expected'])==c['expected_sha256'] and p.stdout==(W/c['expected']).read_bytes(),c['name']
 else:
  assert sha(W/c['model'])==c['model_sha256'];model=json.loads((W/c['model']).read_text());lines=p.stdout.decode().splitlines();assert lines[-1]=='CANARIES PASS';events=[]
  for s in lines:
   if s.startswith('EV '):q=s.split();events.append([q[1],int(q[2]),[int(w,16) for w in q[3:]]])
  if c['mode']=='suffix':
   expected=[[n,0,a] for n,a in model['events']]+model['ifft0']+model['ifft1']+[['tx_final',0,model['tx']],['ty_final',0,model['ty']]];assert events==expected
   for tag0 in ['w1','w2','s1','s2']:assert list(map(int,next(s for s in lines if s.startswith(tag0.upper()+' ')).split()[1:]))==model[tag0]
  else:
   assert lines[0]==f"NORM {model['norm']} {int(model['short'])}" and lines[1]==f"BYTES {model['length']} {model['bytes']}"
   assert list(map(int,next(s for s in lines if s.startswith('DECODED ')).split()[1:]))==model['s2']
   for s in lines:
    q=s.split()
    if q[0] in ['CAP','FRAME']:
     cap=int(q[1]);r,b=literal_encode(model['s2'],cap) if q[0]=='CAP' else frame(model['s2'],cap);assert int(q[2])==r and (q[3] if len(q)>3 else '')==b.hex()
 matches.append(dict(case=c['name'],stdout_sha256=receipt['stdout_sha256'],stderr_sha256=receipt['stderr_sha256'],exact_match=True));print('PASS_NATIVE',mode,c['name'],flush=True)
(W/'artifacts'/('native_'+mode+'.json')).write_text(json.dumps(dict(status='PASS_ORIGINAL_C_JOINT_SCALAR_GETTERS_POST_WORDS_BYTES',mode=mode,matches=matches),indent=2)+'\n')
