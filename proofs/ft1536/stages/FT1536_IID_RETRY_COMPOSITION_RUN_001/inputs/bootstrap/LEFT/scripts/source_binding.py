import difflib,hashlib,json,re,shlex,shutil,subprocess,time
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';r=verify_manifest(I,'MANIFEST.sha256','5bbd7b14d05275ad0cf46a72e9b8d24d5c67001f7597761edb07d86d444173d4');assert len(r)==579
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h
src=(W/'source/falcon-sign.c').read_text();lines=src.splitlines(True)
def function(name):
 m=re.search(r'^'+re.escape(name)+r'\([^;{}]*\)\s*\{',src,re.M);assert m,name
 i=m.end();depth=1
 while depth:depth+=(src[i]=='{')-(src[i]=='}');i+=1
 return src[m.start():i]
parts={
 'sampling.inc':''.join(lines[1615:1839]),'prerequisites.inc':lines[147]+lines[1318],
 'raw_tree.inc':''.join(lines[503:752]),'normalize.inc':''.join(lines[962:1040]),
 'stable_core.inc':''.join('static '+t+'\n'+function(n)+'\n' for t,n in [('uint64_t','ft_fpr_bits'),('fpr','ft_fpr_from_bits'),('int','ft_fpr_is_positive_finite'),('fpr','ft_stable_positive'),('void','ft_stable_binary_inplace'),('void','ft_stable_top_branch')])}
for name,text in parts.items():(W/'checks'/name).write_text(text)
table=(W/'source/ft1536-adaptive-cdf-tables.h').read_text().splitlines(True)
(W/'checks/coefficients.inc').write_text('#define FT_ADAPTIVE_CDF_LEVELS 5\n'+''.join(table[19:23]))
assert sha(W/'checks/sampling.inc')==sha(I/'ORDERED/checks/sampling.inc')
assert 'ffSampling_fft3' not in parts['raw_tree.inc'] and 'load_skey' not in parts['stable_core.inc']
reuse=[]
for old,new in [('ORDERED/checks/ordered.c','checks/ordered.c'),('TOWER/scripts/node_model.py','scripts/node_model.py'),('TOWER/scripts/node2_model.py','scripts/node2_model.py'),('TOWER/scripts/tower_model.py','scripts/tower_model.py')]:
 dst=W/new
 if dst.exists():assert sha(dst)==sha(I/old)
 else:shutil.copyfile(I/old,dst)
 reuse.append(dict(input='inputs/bootstrap/'+old,copy=new,sha256=sha(dst),byte_identical=True))
(W/'artifacts/control_reuse.json').write_text(json.dumps(reuse,indent=2)+'\n')
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-Isource']
D=W/'artifacts/preprocessed';D.mkdir(exist_ok=True);commands=[]
for k,unit in enumerate(['source/falcon-sign.c','source/falcon-fft.c','source/fpr-emulated.c']):
 cmd=['/usr/bin/gcc']+flags+['-E','-P',unit];tick=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=60);so=D/f'unit{k}.i';se=D/f'unit{k}.stderr';so.write_bytes(p.stdout);se.write_bytes(p.stderr);assert p.returncode==0 and not p.stderr
 commands.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,elapsed=time.monotonic()-tick,stdout_sha256=sha(so),stderr_sha256=sha(se)))
(D/'commands.json').write_text(json.dumps(commands,indent=2)+'\n')
body=(D/'unit0.i').read_text();assert 'ft_adaptive_proposal' in body and 'ft_ffldl_probe_record_leaf' not in body
out=dict(status='PASS_PINNED_METRIC_BUILDER_NORMALIZER_AND_SAMPLING_BINDING',source_pin=sha(I/'CANDIDATE.sha256'),slices={n:sha(W/'checks'/n) for n in parts},
 source_spans=dict(raw_L_and_D=[504,752],stable_top_binary=[760,828],source_normalization=[963,1040],sampling=[1616,1839],sigma_reads=[1633,1645],dss_and_bank=[2791,2866]),
 actual_metric_objects='real source root spectrum; actual raw L and real raw pivots; source stable D and paired/stored width uses in the exact physical map',
 no_KeyGen_private_loader_Sign_or_do_sign_execution=True,raw_L_not_replaced=True,source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
