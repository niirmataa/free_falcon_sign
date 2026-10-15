#!/usr/bin/env sage
# Exact auxiliary controls and GS word candidates; never probability premises.
from pathlib import Path
import hashlib,json,subprocess,shutil
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def pin(p):return {'path':str(p),'sha256':sha(p)}
helper=root/'sage/keygen_fastfpr137_control.sage'
assert sha(helper)=='a90b036ca826dc9dfd72380dedc62a8ab0f3972d8fa6260b81bd0cc86a40853f'
text=helper.read_text();library=Path.cwd()/'EXACT_WORDS154.sage'
library.write_text(text[text.index('M64='):text.index('boundaries=')])
load(str(library))
def divword(x,y):
    xu=(x&(2^52-1))|2^52;yu=(y&(2^52-1))|2^52;q=ZZ(0)
    for _ in range(55):
        mask=u64((u64(xu-yu)>>63)-1)
        q=u64((q|(mask&1))<<1)
        xu=u64(u64(xu-(mask&yu))<<1)
    q=q|((xu|u64(-xu))>>63)
    w=q>>55;q=q^^((q^^((q>>1)|(q&1)))&u64(-w))
    ex=(x>>52)&0x7ff;ey=(y>>52)&0x7ff;e=ex-ey-55+w
    d=(ex+0x7ff)>>11;s=((x^^y)>>63)&d;e=e&(-d);q=q&u64(-d)
    return pack(s,e,q)
one=ZZ(0x3ff0000000000000)
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
source=json.loads(manifest.read_text())
for row in source['source_inputs']:assert sha(row['path'])==row['sha256']
vectors=root/'.build/jobs/keygen_fftvalues152_009/FFT152_CANDIDATES.json'
assert sha(vectors)=='3e9da927968cec19503661809c41af3402da104bfad29c2f041e59204b24d891'
v=json.loads(vectors.read_text());f=[ZZ(x) for x in v['f']['triple']];g=[ZZ(x) for x in v['g']['triple']]
assert len(f)==len(g)==1536
den=[add(add(mul(f[i],f[i]),mul(f[i+768],f[i+768])),add(mul(g[i],g[i]),mul(g[i+768],g[i+768]))) for i in range(768)]
inv=[divword(one,x) for x in den]
boundary=[ZZ(x) for x in [0,1,0x8000000000000000,0x3ff0000000000000,0xbff0000000000000,0x0010000000000000,0x000fffffffffffff,0x7fefffffffffffff,0xffefffffffffffff,0x7ff0000000000000,0x7ff8000000000000,0xffffffffffffffff]]
pairs=[(x,y) for x in boundary for y in boundary];seed=ZZ(0x9e3779b97f4a7c15)
for _ in range(64):
    seed=u64(seed*6364136223846793005+1442695040888963407);x=seed
    seed=u64(seed*6364136223846793005+1442695040888963407);pairs.append((x,seed))
pairs += [(one,x) for x in den]
probe=Path.cwd()/'CONTROL154.c'
probe.write_text('#include <stdio.h>\n#include <stdint.h>\n#include <inttypes.h>\n#include "internal.h"\n'
 '_Static_assert(sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8, "LP64 required");\n'
 'int main(void) { uint64_t x,y; while (scanf("%" SCNx64 " %" SCNx64, &x,&y)==2) {\n'
 'printf("%016" PRIx64 " %016" PRIx64 " %016" PRIx64 "\\n", fpr_div(x,y), fpr_inv(y), fpr_of(18433)); } return 0; }\n')
cc=shutil.which('cc');assert cc
binary=Path.cwd()/'CONTROL154';argv=[cc,*source['profile_flags'],'-DFALCON_ASM_CORTEXM4=0','-std=c11','-I',str(repo/'Extra/c'),str(probe),str(repo/'Extra/c/fpr-emulated.c'),'-o',str(binary)]
compiled=subprocess.run(argv,capture_output=True,check=False)
(Path.cwd()/'CC.stdout').write_bytes(compiled.stdout);(Path.cwd()/'CC.stderr').write_bytes(compiled.stderr)
assert compiled.returncode==0 and compiled.stdout==compiled.stderr==b''
inputs=''.join(format(int(x),'016x')+' '+format(int(y),'016x')+'\n' for x,y in pairs)
(Path.cwd()/'CONTROL154_INPUT.txt').write_text(inputs)
native=subprocess.run([str(binary)],input=inputs.encode(),capture_output=True,check=False)
(Path.cwd()/'NATIVE.stdout').write_bytes(native.stdout);(Path.cwd()/'NATIVE.stderr').write_bytes(native.stderr)
assert native.returncode==0 and native.stderr==b''
lines=native.stdout.decode().splitlines();assert len(lines)==len(pairs)
scale=pack(0,14-54,ZZ(18433)*2^(54-14))
for line,(x,y) in zip(lines,pairs):assert [ZZ(w,16) for w in line.split()]==[divword(x,y),divword(one,y),scale]
adjf=[x if i<768 else neg(x) for i,x in enumerate(f)];adjg=[x if i<768 else neg(x) for i,x in enumerate(g)]
scaledf=[mul(x,scale) for x in adjf];scaledg=[mul(x,scale) for x in adjg]
outf=[mul(x,inv[i%768]) for i,x in enumerate(scaledf)];outg=[mul(x,inv[i%768]) for i,x in enumerate(scaledg)]
trace=[ZZ(0)]
for x,y in zip(outf,outg):trace.append(add(add(trace[-1],mul(x,x)),mul(y,y)))
candidate={'status':'AUXILIARY_WORD_CANDIDATES_ONLY; SOURCE_GS_AND_KERNEL_NUMERIC_CHECKS_OPEN',
 'vectors':pin(vectors),'denominator':list(map(str,den)),'inverse':list(map(str,inv)),
 'scale_word':str(scale),'adj_f':list(map(str,adjf)),'adj_g':list(map(str,adjg)),
 'scaled_f':list(map(str,scaledf)),'scaled_g':list(map(str,scaledg)),
 'final_f':list(map(str,outf)),'final_g':list(map(str,outg)),
 'norm_trace':list(map(str,trace)),'norm_word':str(double(trace[-1]))}
candidate_path=Path.cwd()/'GS154_CANDIDATES.json';candidate_path.write_text(json.dumps(candidate,indent=2)+'\n')
(Path.cwd()/'CONTROL154.json').write_text(json.dumps({'status':'PASS_EXACT_FINITE_CONTROL_ONLY',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'cases':int(len(pairs)),'selected_denominators':int(768),
 'source_manifest':pin(manifest),'word_helper':pin(helper),'probe':pin(probe),'binary':pin(binary),
 'native_compile_argv':argv,'native_output':pin(Path.cwd()/'NATIVE.stdout'),'candidate':pin(candidate_path),
 'scope':'pinned portable C div/inv and integer-scale controls; GS candidate operations remain auxiliary; no population or real-error claim'},indent=2)+'\n')
