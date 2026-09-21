import json,re,shlex,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];log=W/'checks/logs'/mode;log.mkdir(parents=True,exist_ok=True);rows=[]
def run(tag,argv,data=None):
 t=time.monotonic();p=subprocess.run(argv,input=data,capture_output=True,timeout=180);so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 rows.append(dict(argv=argv,cwd=str(W),limit=180,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout=so.relative_to(W).as_posix(),stderr=se.relative_to(W).as_posix(),stdout_sha256=sha(so),stderr_sha256=sha(se)));(log/'commands.json').write_text(json.dumps(rows,indent=2)+'\n');assert p.returncode==0 and not p.stderr,(tag,p.returncode,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
exe='bin/ordered_'+mode;run('compile',['/usr/bin/gcc']+flags+['checks/ordered.c','source/falcon-fft.c','source/fpr-emulated.c','-lm','-o',exe]);cases=[]
for r in json.loads((W/'artifacts/fixtures.json').read_text())['fixtures']:
 name=r['name'];D=W/'checks/data';p=D/(name+'.input');assert sha(p)==r['input_sha256']
 got=run(name,[exe,r['mode']],p.read_bytes());assert got==(D/(name+'.expected')).read_bytes(),name
 cases.append(dict(name=name,result=r['result'],all_ordered_words_and_outcomes_match=True,stdout_sha256=sha(log/(name+'.stdout'))))
 if name=='normal_endpoints':assert run('noop',[exe,r['mode']],p.read_bytes())==got
out=dict(status='PASS_ORIGINAL_ORDERED_RECURSION_SCRIPTED_RELATION_CONTROLS',mode=mode,cases=cases,all3072_positions_on_completed_top=True,
 nonreturn_is_prefix_stop_not_zero=True,fault_zero_not_normal_residual=True,tree_root_inputs_and_canaries_preserved=True,noop_pass=True,LSan_claimed=False,
 actual_Sign_or_real_sampler_law_claimed=False)
(W/'artifacts'/('controls_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],mode=mode,cases=len(cases)),indent=2))
