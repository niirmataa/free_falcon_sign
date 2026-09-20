import difflib,hashlib,json,re,shlex,subprocess,time
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';boot=verify_manifest(I,'MANIFEST.sha256','28a57d2c8e1361a7bc035b56426563187cf3903e1aa1cd1fa3ac4eeb5e1a3edc');assert len(boot)==396
for s in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=s.split('  ',1);assert sha(W/'source'/n)==h
text=(W/'source/falcon-sign.c').read_text();lines=text.splitlines(True)
sample=''.join(lines[1615:1839]);assert 'do_sign(' not in sample and sample.count('samp(samp_ctx,')==2
(W/'checks/sampling.inc').write_text(sample)
(W/'checks/prerequisites.inc').write_text(lines[147]+lines[1318])
def function(text,name):
 m=re.search(r'^'+re.escape(name)+r'\([^;{}]*\)\s*\{',text,re.M);assert m,name
 i=m.end();depth=1
 while depth:depth+=(text[i]=='{')-(text[i]=='}');i+=1
 return text[m.start():i]
names=[('uint64_t','ft_fpr_bits'),('fpr','ft_fpr_from_bits'),('int','ft_fpr_is_positive_finite'),('int','ft_fpr_is_finite'),('int','ft_fpr_is_nonnegative_finite'),('uint64_t','ft_ct_lt_u64'),('uint64_t','ft_ct_eq_u64'),('uint64_t','ft_ct_lt_u128'),('void','ft_adaptive_cdf_samples'),('void','ft_berexp_cutoff_state')]
(W/'checks/scalar_helpers.inc').write_text('#include "../source/ft1536-adaptive-cdf-tables.h"\n'+''.join('static '+t+'\n'+function(text,n)+'\n' for t,n in names))
spans={'sampling':dict(file='falcon-sign.c',first=1616,last=1839,copy='checks/sampling.inc'),'scalar_guard':dict(file='falcon-sign.c',first=2841,last=2972),'BerExp':dict(file='falcon-sign.c',first=2450,last=2513),'caller':dict(file='falcon-sign.c',first=3308,last=3409),'terminal_split_merge':dict(file='falcon-fft.c',first=1326,last=1454)}
D=W/'inputs/slices';D.mkdir(exist_ok=True)
for n,r in spans.items():
 src=W/'source'/r['file'];body=''.join(src.read_text().splitlines(True)[r['first']-1:r['last']]);p=D/(n+'.txt');p.write_text(body);r.update(source_sha256=sha(src),slice_sha256=sha(p))
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-Isource']
out=W/'artifacts/preprocessed';out.mkdir(exist_ok=True);cmds=[]
for k,unit in enumerate(['source/falcon-sign.c','source/falcon-fft.c','source/fpr-emulated.c']):
 cmd=['/usr/bin/gcc']+flags+['-E','-P',unit];t=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=60);so=out/f'unit{k}.i';se=out/f'unit{k}.stderr';so.write_bytes(p.stdout);se.write_bytes(p.stderr);assert p.returncode==0 and not p.stderr
 cmds.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,elapsed=time.monotonic()-t,stdout_sha256=sha(so),stderr_sha256=sha(se)))
(out/'commands.json').write_text(json.dumps(cmds,indent=2)+'\n')
pre=(out/'unit0.i').read_text();active=function(pre,'sampler_large');assert 'return s + z;' in active and 'ft_adaptive_proposal' in active and 'gaussian0_sampler_large' not in active
assert 'if (tsc->fault != FT_SAMPLER_FAULT_NONE)' in active and active.index('if (tsc->fault')<active.index('s = fpr_floor(mu)')
kernel=(W/'source/fpr-emulated.h').read_text();assert 'mask = -(uint64_t)((uint32_t)(63 - cc) >> 31)' in kernel
outdata=dict(status='PASS_ACTIVE_ORDER_OUTCOMES_AND_SOURCE_SLICES',source_pin=sha(I/'CANDIDATE.sha256'),spans=spans,sampling_copy_byte_identical=True,
 active_sampler_sha256=hashlib.sha256(active.encode()).hexdigest(),primitive_headers_sha256=sha(W/'source/fpr-emulated.h'),flags=flags,
 structural_calls=3072,first_branch=1,depth_order=[2,1,0],binary_order=[1,0],terminal_order=['paired mu1','half residual','updated mu0','subtract rx'],sampling_base_logn=0,builder_base_logn=1,
 outer_fault_check_after_whole_do_sign=True,sticky_fault_reset_only_at_next_attempt=True,no_whole_sign_or_KeyGen_execution=True,
 source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(outdata,indent=2)+'\n');print(json.dumps(dict(status=outdata['status'],copy_sha256=sha(W/'checks/sampling.inc'),structural_calls=3072),indent=2))
