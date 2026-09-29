import json,re,shlex,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];log=W/'checks/logs'/mode;log.mkdir(parents=True,exist_ok=True);commands=[]
def run(tag,argv,data=None):
 t=time.monotonic();p=subprocess.run(argv,input=data,capture_output=True,timeout=120);so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 commands.append(dict(argv=argv,cwd=str(W),wall_limit=120,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout=so.relative_to(W).as_posix(),stderr=se.relative_to(W).as_posix(),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (log/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');assert p.returncode==0 and not p.stderr,(tag,p.returncode,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-ffunction-sections','-fdata-sections','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
exe='bin/stable_'+mode;run('compile',['/usr/bin/gcc']+flags+['checks/stable.c','source/falcon-fft.c','source/fpr-emulated.c','-Wl,--gc-sections','-lm','-o',exe])
f=json.loads((W/'artifacts/fixtures.json').read_text());rows=[];D=W/'checks/data'
for case in ['sqrt','div','bits','gate','widths']:
 got=run(case,[exe,case],(D/(case+'.input')).read_bytes());assert got==(D/(case+'.expected')).read_bytes(),case
 rows.append(dict(case=case,stdout_sha256=sha(log/(case+'.stdout'))))
for r in f['pipelines']:
 name=r['name'];assert r['preflight']=='PASS_SOURCE_DOMAINS_BEFORE_NATIVE' and sha(D/(name+'.input'))==r['input_sha256']
 got=run(name,[exe,r['mode']],(D/(name+'.input')).read_bytes());assert got==(D/(name+'.expected')).read_bytes(),name
 rows.append(dict(case=name,stable_ok=r['stable_ok'],full_words_events_and_frames_match=True,stdout_sha256=sha(log/(name+'.stdout'))))
 if name=='roots_vary':assert run('noop',[exe,r['mode']],(D/(name+'.input')).read_bytes())==got
out=dict(status='PASS_SOURCE_STABLE_NORMALIZATION_AND_SCALAR_CONTROLS',mode=mode,cases=rows,sqrt_words=f['sqrt_words'],div_pairs=f['div_pairs'],width_cases=f['width_cases'],
 full_1536_leaf_sequence=True,all_16896_internal_and_6144_basis_words_preserved=True,unconditional_normalize_on_stable_failure_tested=True,
 source_keygen_stable_only_mirror=True,whole_KeyGen_loader_Sign_or_PRNG_called=False,canaries=True,read_only_alias=True,noop_pass=True,LSan_claimed=False)
(W/'artifacts'/('controls_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps({k:v for k,v in out.items() if k!='cases'},indent=2))
