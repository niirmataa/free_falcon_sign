import difflib,hashlib,json,re,shlex,subprocess,time
from pathlib import Path
from replaylib import sha,verify_manifest
W=Path.cwd();I=W/'inputs/bootstrap';boot=verify_manifest(I,'MANIFEST.sha256','16977cc646bf5bd5af62f7f86e1c992ab24cafd05188a3c5dbeeae96e2a7a97e')
assert len(boot)==198 and {p.relative_to(I).as_posix() for p in I.rglob('*') if p.is_file()}==set(boot)|{'MANIFEST.sha256'}
for line in (I/'CANDIDATE.sha256').read_text().splitlines():
 h,n=line.split('  ',1);assert sha(W/'source'/n)==h
old=json.loads((I/'ROOT/artifacts/numeric_certificate.json').read_text())['source_sha256']
for n in ['falcon-sign.c','falcon-fft.c','fpr-emulated.c']:assert sha(W/'source'/n)==old[n]
header=(W/'source/fpr-emulated.h').read_text();start='static inline long\nfpr_floor(fpr x)\n';end='\nstatic inline int64_t\nfpr_trunc(fpr x)'
a,z=header.split(start,1);body,b=z.split(end,1)
ob=body.replace('uint64_t t, mask;','uint64_t t;').replace('\t/* FT1536: preserve the raw-word result with an unsigned selection. */\n\tmask = -(uint64_t)((uint32_t)(63 - cc) >> 31);\n\txi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));','\txi ^= (xi ^ -(int64_t)t) & -(int64_t)((uint32_t)(63 - cc) >> 31);')
previous=a+start+ob+end+b;assert hashlib.sha256(previous.encode()).hexdigest()==old['fpr-emulated.h']
assert ''.join(difflib.unified_diff(previous.splitlines(True),header.splitlines(True),fromfile='baseline/source/fpr-emulated.h',tofile='candidate/source/fpr-emulated.h'))==(I/'FLOOR/PATCH.diff').read_text()
(W/'inputs/previous_fpr-emulated.h').write_text(previous)
sign=(W/'source/falcon-sign.c').read_text();sl=sign.splitlines(True)
prereq=sl[147]+sl[1318]+''.join(sl[1064:1095]);assert 'typedef int (*samplerZ)' in prereq
(W/'checks/prerequisites.inc').write_text(prereq)
original=''.join(sl[1847:1892]);cut=original.replace('do_sign(', 'target_prefix_slice(',1)
cut+='\t} /* cut after1892, before any sampler call */\n\t(void)samp;(void)samp_ctx;(void)s1;(void)s2;\n\t(void)tx;(void)ty;(void)tz;(void)b00;(void)b10;(void)tree;\n}\n'
(W/'checks/target_prefix.inc').write_text(cut)
(W/'artifacts/diffs/target_prefix.patch').write_text(''.join(difflib.unified_diff(original.splitlines(True),cut.splitlines(True),fromfile='source/falcon-sign.c:1848-1892',tofile='checks/target_prefix.inc')))
(W/'checks/binding_unit.c').write_text('#include "../source/internal.h"\n#include "prerequisites.inc"\n#include "target_prefix.inc"\n')
flags=shlex.split(re.search(r'^CFLAGS = (.*)$',(W/'source/Makefile').read_text(),re.M)[1]);flags=[s.replace('\\"','"') for s in flags]+['-std=c99','-Isource']
out=W/'artifacts/preprocessed';out.mkdir(exist_ok=True);cmds=[];defs={}
def functions(text):
 found={}
 for m in re.finditer(r'^([A-Za-z_]\w*)\s*\([^;{}]*\)\s*\{',text,re.M):
  i=m.end();depth=1
  while depth:depth+=(text[i]=='{')-(text[i]=='}');i+=1
  found[m[1]]=text[m.start():i]
 return found
for k,unit in enumerate(['checks/binding_unit.c','source/falcon-fft.c','source/fpr-emulated.c']):
 cmd=['/usr/bin/gcc']+flags+['-E','-P',unit];t=time.monotonic();p=subprocess.run(cmd,capture_output=True,timeout=60);so=out/f'unit{k}.i';se=out/f'unit{k}.stderr';so.write_bytes(p.stdout);se.write_bytes(p.stderr)
 cmds.append(dict(argv=cmd,cwd=str(W),exit_code=p.returncode,limit=60,elapsed=time.monotonic()-t,stdout_sha256=sha(so),stderr_sha256=sha(se)));(out/'commands.json').write_text(json.dumps(cmds,indent=2)+'\n');assert p.returncode==0 and not p.stderr
 for n,text in functions(p.stdout.decode()).items():
  if n in defs:assert re.sub(r'\s+','',defs[n])==re.sub(r'\s+','',text),n
  defs[n]=text
graph={n:sorted(set(re.findall(r'\b(\w+)\s*\(',text.split('{',1)[1]))&defs.keys()) for n,text in defs.items()}
todo=['target_prefix_slice'];seen=set()
while todo:
 n=todo.pop()
 if n not in seen:seen.add(n);todo+=graph[n]
assert {'falcon_FFT3','fpr_of','fpr_scaled','fpr_inverse_of','fpr_div','fpr_mul','fpr_add','falcon_poly_mul_fft3','falcon_poly_mulconst3'}<=seen
assert not seen&{'fpr_floor','ffSampling_fft3','do_sign','load_skey','sampler_large','falcon_prng_init'}
assert 'for (int i = 0; i < 55; i ++)' in defs['fpr_div'] and '__asm__' not in defs['fpr_div']
enc=(W/'source/falcon-enc.c').read_text();assert '*x ++ = (uint16_t)(w % q)' in enc
outdata=dict(status='PASS_LITERAL_TARGET_CUT_ACTIVE_DEPENDENCIES_AND_CALLER_SPANS',source_pin=sha(I/'CANDIDATE.sha256'),
 slice=dict(source='source/falcon-sign.c',first=1848,last=1892,copy='checks/target_prefix.inc',sha256=sha(W/'checks/target_prefix.inc'),diff='artifacts/diffs/target_prefix.patch',
  changes=['function renamed','scopes closed at cut','unused post-cut variables/parameters explicitly discarded'],no_sampler_call=True),
 source_order=['convert hm to t0','FFT3(t0)','inverse(q)','copy t1=t0','mul t1,b01','scale t1,-ni','mul t0,b11','scale t0,ni'],
 target_dependencies=sorted(seen),call_graph=graph,body_sha256={n:hashlib.sha256(defs[n].encode()).hexdigest() for n in sorted(seen)},flags=flags,
 source_transport='Relevant C bodies byte-identical ROOT; old header reconstructed and verified, sole floor change unreachable; normalized basis-preservation pin consumed',
 caller=dict(allocations=[3242,3257],hash_to_point=3325,outer_loop=[3330,3409],do_sign_call=[3372,3373],future_norm_check=3388,
  hash_to_point_source='falcon-enc.c564-592',scope='Legal entry and defined H2P-return binding only; no propagation through unproved sampler/postprocessing or future norm acceptance'),
 whole_normalized_sk_preserved=True,write_footprint='tmp[0,3072)',future_scratch_initialized_claimed=False,
 source_changed=False,production_source_changed=False,new_source_patch_integrated=False,owner_accepted=False)
(W/'artifacts/source_binding.json').write_text(json.dumps(outdata,indent=2)+'\n');print(json.dumps(dict(status=outdata['status'],functions=len(seen),cut_sha256=outdata['slice']['sha256']),indent=2))
