import json,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];group=int(sys.argv[2]);assert mode in ['normal','sanitized'];cases=json.loads((W/'artifacts/fixtures.json').read_text())['cases'][group*8:(group+1)*8];assert cases;receipts=[];matches=[]
for c in cases:
 assert sha(W/c['input'])==c['input_sha256'] and sha(W/c['expected'])==c['expected_sha256'];cmd=['bin/retry-'+mode];t=time.monotonic();p=subprocess.run(cmd,input=(W/c['input']).read_bytes(),capture_output=True,timeout=60);tag='native_'+mode+'_'+c['name']
 for stream,b in [('stdout',p.stdout),('stderr',p.stderr)]:(W/'logs'/(tag+'.'+stream)).write_bytes(b)
 r=dict(case=c['name'],argv=cmd,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout_sha256=sha(W/'logs'/(tag+'.stdout')),stderr_sha256=sha(W/'logs'/(tag+'.stderr')));receipts.append(r);(W/'artifacts'/('native_receipts_'+mode+'_'+str(group)+'.json')).write_text(json.dumps(receipts,indent=2)+'\n')
 assert p.returncode==0 and not p.stderr,(c['name'],p.returncode,p.stderr.decode());assert p.stdout==(W/c['expected']).read_bytes(),c['name']
 matches.append(dict(case=c['name'],stdout_sha256=r['stdout_sha256'],stderr_sha256=r['stderr_sha256'],exact_trace_targets_bytes_frames=True));print('PASS_NATIVE',mode,c['name'])
(W/'artifacts'/('native_'+mode+'_'+str(group)+'.json')).write_text(json.dumps(dict(status='PASS_EXTRACTED_RETRY_CODEC_STATE_RESET_CONTROLS',mode=mode,group=group,matches=matches),indent=2)+'\n')
