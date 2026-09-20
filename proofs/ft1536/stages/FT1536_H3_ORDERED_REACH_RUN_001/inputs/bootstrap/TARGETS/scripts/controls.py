import json,re,shlex,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];log=W/'checks/logs'/mode;log.mkdir(parents=True,exist_ok=True);cmds=[]
def run(tag,argv,data=None):
 t=time.monotonic();p=subprocess.run(argv,input=data,capture_output=True,timeout=120);so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 cmds.append(dict(argv=argv,cwd=str(W),limit=120,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout=so.relative_to(W).as_posix(),stderr=se.relative_to(W).as_posix(),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (log/'commands.json').write_text(json.dumps(cmds,indent=2)+'\n');assert p.returncode==0 and not p.stderr,(tag,p.returncode,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
exe='bin/targets_'+mode;run('compile',['/usr/bin/gcc']+flags+['checks/targets.c','source/falcon-fft.c','source/fpr-emulated.c','-lm','-o',exe]);rows=[]
for r in json.loads((W/'artifacts/fixtures.json').read_text())['fixtures']:
 name=r['name'];p=W/'checks/data'/(name+'.input');assert sha(p)==r['input_sha256'] and r['preflight']=='PASS_ALL_CANONICAL_AND_SOURCE_OPERAND_DOMAINS'
 got=run(name,[exe,r['mode']],p.read_bytes());assert got==(W/'checks/data'/(name+'.expected')).read_bytes(),name
 rows.append(dict(name=name,full_snapshots_t0_t1_ni_match=True,frame_sk_hm_outputs_ctx_tmp_suffix=True,stdout_sha256=sha(log/(name+'.stdout'))))
 if name=='dense_dense':assert run('noop',[exe,r['mode']],p.read_bytes())==got
out=dict(status='PASS_ORIGINAL_TARGET_PREFIX_AND_FULL_FRAME',mode=mode,fixtures=rows,word_outputs_each_target=1536,normalized_key_words_preserved=24576,
 tmp_write_prefix=3072,tmp_suffix_preserved=7680,hm_words_preserved=1536,s1_s2_context_preserved=True,no_callback_invoked=True,noop_pass=True,LSan_claimed=False,
 do_sign_or_sampling_or_Sign_or_KeyGen_executed=False)
(W/'artifacts'/('controls_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='fixtures'}|dict(fixtures=len(rows)),indent=2))
