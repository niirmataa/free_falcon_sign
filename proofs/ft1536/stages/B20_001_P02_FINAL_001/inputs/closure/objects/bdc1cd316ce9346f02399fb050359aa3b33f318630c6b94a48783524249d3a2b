import json,re,shlex,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];log=W/'checks/logs'/mode;log.mkdir(parents=True,exist_ok=True);commands=[]
def run(tag,argv,data=None):
 tick=time.monotonic();p=subprocess.run(argv,input=data,capture_output=True,timeout=180);so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 commands.append(dict(argv=argv,cwd=str(W),exit_code=p.returncode,limit=180,elapsed=time.monotonic()-tick,stdout=so.relative_to(W).as_posix(),stderr=se.relative_to(W).as_posix(),stdout_sha256=sha(so),stderr_sha256=sha(se)));(log/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');assert p.returncode==0 and not p.stderr,(tag,p.returncode,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
for stem in ['build_tree','ordered']:
 run('compile_'+stem,['/usr/bin/gcc']+flags+['checks/'+stem+'.c','source/falcon-fft.c','source/fpr-emulated.c','-lm','-o','bin/'+stem+'_'+mode])
f=json.loads((W/'artifacts/fixtures.json').read_text());D=W/'checks/data';rows=[]
for kind in ['flat','vary','tilted']:
 out=run('build_'+kind,['bin/build_tree_'+mode],(D/(kind+'.gram.input')).read_bytes());assert out==(D/(kind+'.build.expected')).read_bytes()
for r in f['fixtures']:
 name=r['name'];assert sha(D/(name+'.input'))==r['input_sha256'];out=run(name,['bin/ordered_'+mode,'top'],(D/(name+'.input')).read_bytes());assert out==(D/(name+'.expected')).read_bytes()
 rows.append(dict(name=name,raw_stable_normalized_builder_match=True,full_sampling_words_and_outcomes_match=True,result=r['result'],stdout_sha256=sha(log/(name+'.stdout'))))
 if name=='vary_normal':assert run('noop',['bin/ordered_'+mode,'top'],(D/(name+'.input')).read_bytes())==out
out=dict(status='PASS_ORIGINAL_RAW_STABLE_AND_SAMPLING_NEW_METRIC_CASES',mode=mode,cases=rows,source_frames_canaries=True,noop_pass=True,LSan_claimed=False,
 no_real_KeyGen_Sign_or_private_loader=True,scripted_tape_not_probability_law=True)
(W/'artifacts'/('controls_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],mode=mode,fixtures=len(rows)),indent=2))
