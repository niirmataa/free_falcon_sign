import json,subprocess,sys,time
from pathlib import Path
from replaylib import sha
from codec_model import literal_encode,frame
W=Path.cwd();mode=sys.argv[1];group=int(sys.argv[2]);assert mode in ['normal','sanitized'];rows=json.loads((W/'artifacts/fixtures.json').read_text())['cases'];chosen=rows[group*12:(group+1)*12];assert chosen
receipts=[]
for case in chosen:
 name=case['name'];kind=case['kind'];assert sha(W/case['input'])==case['input_sha256'] and sha(W/case['model'])==case['model_sha256'];model=json.loads((W/case['model']).read_text())
 cmd=['bin/post-'+mode,kind];t=time.monotonic();p=subprocess.run(cmd,input=(W/case['input']).read_bytes(),capture_output=True,timeout=30)
 log='logs/native_'+mode+'_'+name
 (W/(log+'.stdout')).write_bytes(p.stdout);(W/(log+'.stderr')).write_bytes(p.stderr)
 receipt=dict(name=name,mode=mode,argv=cmd,input_sha256=case['input_sha256'],exit_code=p.returncode,elapsed=time.monotonic()-t,stdout=log+'.stdout',stderr=log+'.stderr',stdout_sha256=sha(W/(log+'.stdout')),stderr_sha256=sha(W/(log+'.stderr')))
 receipts.append(receipt);(W/'artifacts'/('native_receipts_'+mode+'_'+str(group)+'.json')).write_text(json.dumps(receipts,indent=2)+'\n')
 assert p.returncode==0 and not p.stderr,(name,p.returncode,p.stderr.decode())
 lines=p.stdout.decode().splitlines()
 if kind=='rint':
  actual=[[int(x,16),int(y),int(z)] for x,y,z in map(str.split,lines)];assert actual==model
 else:
  assert lines[-1]=='CANARIES PASS'
  events=[]
  for s in lines:
   if s.startswith('EV '):
    t=s.split();events.append([t[1],int(t[2]),[int(x,16) for x in t[3:]]])
  if kind=='ifft':assert events==model['events']
  elif kind=='suffix':
   expected=[[n,0,a] for n,a in model['events']]+model['ifft0']+model['ifft1']+[['tx_final',0,model['tx']],['ty_final',0,model['ty']]];assert events==expected
   for tag in ['w1','w2','s1','s2']:assert list(map(int,next(s for s in lines if s.startswith(tag.upper()+' ')).split()[1:]))==model[tag]
  else:
   assert lines[0]==f"NORM {model['norm']} {int(model['short'])}"
   assert lines[1]==f"BYTES {model['length']} {model['bytes']}"
   assert list(map(int,next(s for s in lines if s.startswith('DECODED ')).split()[1:]))==model['s2']
   for s in lines:
    t=s.split()
    if t[0] in ['CAP','FRAME']:
     cap=int(t[1]);r,b=(literal_encode(model['s2'],cap) if t[0]=='CAP' else frame(model['s2'],cap));assert int(t[2])==r
     if kind=='codec':assert (t[3] if len(t)>3 else '')==b.hex()
 receipt['all_words_bytes_canaries_match']=True
 (W/'artifacts'/('native_receipts_'+mode+'_'+str(group)+'.json')).write_text(json.dumps(receipts,indent=2)+'\n')
 semantic=[dict(name=r['name'],stdout_sha256=r['stdout_sha256'],stderr_sha256=r['stderr_sha256'],all_words_bytes_canaries_match=True) for r in receipts]
 (W/'artifacts'/('native_'+mode+'_'+str(group)+'.json')).write_text(json.dumps(dict(status='PASS_NATIVE_EXACT_WORDS_BYTES_AND_CANARIES',mode=mode,group=group,cases=semantic),indent=2)+'\n')
 print('PASS_NATIVE',mode,name,flush=True)
