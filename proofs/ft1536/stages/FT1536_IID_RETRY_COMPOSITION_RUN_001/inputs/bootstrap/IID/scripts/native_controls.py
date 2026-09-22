import json,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];group=int(sys.argv[2]);assert mode in ['normal','sanitized'];cases=json.loads((W/'artifacts/fixtures.json').read_text())['cases'][group*8:(group+1)*8];assert cases;receipts=[];matches=[]
for c in cases:
 assert sha(W/c['input'])==c['input_sha256'] and sha(W/c['expected'])==c['expected_sha256'];cmd=['bin/kernel-'+mode,c['mode']];t=time.monotonic();p=subprocess.run(cmd,input=(W/c['input']).read_bytes(),capture_output=True,timeout=60);tag='native_'+mode+'_'+c['name']
 for s,b in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/(tag+'.'+s)).write_bytes(b)
 receipt=dict(case=c['name'],argv=cmd,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout_sha256=sha(W/'logs'/(tag+'.stdout')),stderr_sha256=sha(W/'logs'/(tag+'.stderr')));receipts.append(receipt);(W/'artifacts'/('native_receipts_'+mode+'_'+str(group)+'.json')).write_text(json.dumps(receipts,indent=2)+'\n')
 assert p.returncode==0 and not p.stderr,(c['name'],p.returncode,p.stderr.decode())
 assert p.stdout==(W/c['expected']).read_bytes(),c['name']
 matches.append(dict(case=c['name'],stdout_sha256=receipt['stdout_sha256'],stderr_sha256=receipt['stderr_sha256'],exact_match=True));print('PASS_NATIVE',mode,c['name'],flush=True)
(W/'artifacts'/('native_'+mode+'_'+str(group)+'.json')).write_text(json.dumps(dict(status='PASS_ORIGINAL_SCALAR_GETTERS_EXACT_WORDS_AND_TRACES',mode=mode,group=group,matches=matches),indent=2)+'\n')
