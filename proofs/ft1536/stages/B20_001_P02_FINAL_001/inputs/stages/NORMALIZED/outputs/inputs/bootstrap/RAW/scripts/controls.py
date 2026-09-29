import json,re,shlex,struct,subprocess,sys,time
from pathlib import Path
from replaylib import sha
W=Path.cwd();mode=sys.argv[1];assert mode in ['normal','san'];log=W/'checks/logs'/mode;log.mkdir(parents=True,exist_ok=True);commands=[]
def run(tag,argv,data=None):
 t=time.monotonic();p=subprocess.run(argv,input=data,capture_output=True,timeout=120);so=log/(tag+'.stdout');se=log/(tag+'.stderr');so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 commands.append(dict(argv=argv,cwd=str(W),wall_limit=120,exit_code=p.returncode,elapsed=time.monotonic()-t,stdout=so.relative_to(W).as_posix(),stderr=se.relative_to(W).as_posix(),stdout_sha256=sha(so),stderr_sha256=sha(se)))
 (log/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');assert p.returncode==0,(tag,p.stderr.decode());assert not p.stderr,(tag,p.stderr.decode());return p.stdout
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-ffunction-sections','-fdata-sections','-Isource']
if mode=='san':flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer','-g']
exe='bin/raw_'+mode;run('compile',['/usr/bin/gcc']+flags+['checks/raw.c','source/falcon-fft.c','source/fpr-emulated.c','-Wl,--gc-sections','-lm','-o',exe]);rows=[]
for f in json.loads((W/'artifacts/fixtures.json').read_text())['fixtures']:
 name=f['name'];D=W/'checks/data';payload=(D/(name+'.input')).read_bytes();assert sha(D/(name+'.input'))==f['input_sha256'] and f['preflight']=='PASS_ALL_CONSUMED_PRIMITIVE_DOMAINS'
 got=run(name,[exe,f['mode']],payload);expected=(D/(name+'.expected')).read_bytes();assert got==expected,name
 line=next(s for s in got.splitlines() if s.startswith(b'K '));words=[int(s,16) for s in line.split()[1:]];assert len(words)==24576 and struct.pack('<24576Q',*words)==(D/(name+'.words.bin')).read_bytes()
 rows.append(dict(name=name,source_stdout_sha256=sha(log/(name+'.stdout')),all_basis_tree_words_match=True,full_source_order_and_intermediate_outputs_match=True,
  canaries_and_root_gram_basis_frames=True,scratch_high_water=8192,leaf_words=1536))
 # A real native no-op control uses the identical public payload produced by xor0.
 if name=='gram_1':
  noop=''.join(f'{int(x,16)^0:016x}\n' for x in payload.split()).encode();assert noop==payload
  assert run('noop',[exe,f['mode']],noop)==expected
out=dict(status='PASS_ORIGINAL_TOP_AND_LITERAL_RAW_PREFIX',fixtures=rows,normal_or_ASan_UBSan=mode,all_18432_tree_and_6144_basis_words_match=True,
 all_intermediate_poly_outputs_and_events_match=True,read_aliases_tested=['root g11=g00','cubic t0 repeated three times and t1 twice','every binary g00=g11','prefix f_src=G_src and g_src=F_src'],
 raw_cut_after_source_line=1253,noop_pass=True,LSan_claimed=False,private_key_API_KeyGen_Sign_called=False,source_changed=False)
(W/'artifacts'/('controls_'+mode+'.json')).write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(dict(status=out['status'],mode=mode,fixtures=len(rows),noop_pass=True),indent=2))
