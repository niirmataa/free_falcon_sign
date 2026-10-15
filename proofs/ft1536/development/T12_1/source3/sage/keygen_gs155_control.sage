#!/usr/bin/env sage
# Auxiliary actual-C GS helper controls, not kernel or probability premises.
from pathlib import Path
import hashlib,json,subprocess,shutil
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def pin(p):return {'path':str(p),'sha256':sha(p)}
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
source=json.loads(manifest.read_text())
for row in source['source_inputs']:assert sha(row['path'])==row['sha256']
assert sha(repo/'Extra/c/falcon-fft.c')=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
vectors=root/'.build/jobs/keygen_fftvalues152_009/FFT152_CANDIDATES.json'
candidate=root/'.build/jobs/keygen_gs154_009/GS154_CANDIDATES.json'
assert sha(vectors)=='3e9da927968cec19503661809c41af3402da104bfad29c2f041e59204b24d891'
assert sha(candidate)=='dcc03ce308ed26ab1e17578ec0884e3d0487d716df97877ccabeb37ae22b987b'
v=json.loads(vectors.read_text());g=json.loads(candidate.read_text())
f=[ZZ(x) for x in v['f']['triple']];h=[ZZ(x) for x in v['g']['triple']]
assert len(f)==len(h)==1536
helper=root/'sage/keygen_fastfpr137_control.sage'
assert sha(helper)=='a90b036ca826dc9dfd72380dedc62a8ab0f3972d8fa6260b81bd0cc86a40853f'
t=helper.read_text();library=Path.cwd()/'EXACT_WORDS155.sage';library.write_text(t[t.index('M64='):t.index('boundaries=')]);load(str(library))
for values,adj,scaled in [(f,g['adj_f'],g['scaled_f']),(h,g['adj_g'],g['scaled_g'])]:
    expected=[x if i<768 else neg(x) for i,x in enumerate(values)]
    assert expected==[ZZ(x) for x in adj]
    assert [mul(x,ZZ(g['scale_word'])) for x in expected]==[ZZ(x) for x in scaled]
probe=Path.cwd()/'CONTROL155.c'
probe.write_text('#include <stdio.h>\n#include <stdint.h>\n#include <inttypes.h>\n#include "internal.h"\n'
 '_Static_assert(sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8, "LP64 required");\n'
 'static void pair(const fpr *f,const fpr *g) { for (size_t i=0;i<1536;i++) printf("%016" PRIx64 " %016" PRIx64 "\\n",f[i],g[i]); }\n'
 'int main(void) { fpr f[1536],g[1536],d[768],norm; size_t i;\n'
 'for (i=0;i<1536;i++) if(scanf("%" SCNx64 " %" SCNx64,&f[i],&g[i])!=2) return 2;\n'
 'falcon_poly_invnorm2_fft3(d,f,g,10,1); for(i=0;i<768;i++) printf("%016" PRIx64 "\\n",d[i]);\n'
 'falcon_poly_adj_fft3(f,10,1); falcon_poly_adj_fft3(g,10,1); pair(f,g);\n'
 'falcon_poly_mulconst_fft3(f,fpr_of(18433),10,1); falcon_poly_mulconst_fft3(g,fpr_of(18433),10,1); pair(f,g);\n'
 'falcon_poly_mul_autoadj_fft3(f,d,10,1); falcon_poly_mul_autoadj_fft3(g,d,10,1); pair(f,g);\n'
 'norm=fpr_of(0); for(i=0;i<1536;i++) { norm=fpr_add(norm,fpr_sqr(f[i])); norm=fpr_add(norm,fpr_sqr(g[i])); }\n'
 'printf("%016" PRIx64 "\\n",fpr_double(norm)); return 0; }\n')
cc=shutil.which('cc');assert cc
binary=Path.cwd()/'CONTROL155'
argv=[cc,*source['profile_flags'],'-DFALCON_ASM_CORTEXM4=0','-std=c11','-I',str(repo/'Extra/c'),str(probe),str(repo/'Extra/c/fpr-emulated.c'),str(repo/'Extra/c/falcon-fft.c'),'-o',str(binary)]
compiled=subprocess.run(argv,capture_output=True,check=False)
(Path.cwd()/'CC.stdout').write_bytes(compiled.stdout);(Path.cwd()/'CC.stderr').write_bytes(compiled.stderr)
assert compiled.returncode==0 and compiled.stdout==compiled.stderr==b''
inputs=''.join(format(int(x),'016x')+' '+format(int(y),'016x')+'\n' for x,y in zip(f,h))
(Path.cwd()/'CONTROL155_INPUT.txt').write_text(inputs)
native=subprocess.run([str(binary)],input=inputs.encode(),capture_output=True,check=False)
(Path.cwd()/'NATIVE.stdout').write_bytes(native.stdout);(Path.cwd()/'NATIVE.stderr').write_bytes(native.stderr)
assert native.returncode==0 and native.stderr==b''
words=[ZZ(x,16) for x in native.stdout.decode().split()]
expected=[ZZ(x) for x in g['inverse']]
for a,b in [('adj_f','adj_g'),('scaled_f','scaled_g'),('final_f','final_g')]:
    expected += [ZZ(x) for pair in zip(g[a],g[b]) for x in pair]
expected += [ZZ(g['norm_word'])]
assert len(words)==len(expected)==9985 and words==expected
(Path.cwd()/'CONTROL155.json').write_text(json.dumps({'status':'PASS_EXACT_FINITE_AUXILIARY_CONTROL_ONLY',
 'sage_version':SAGE_VERSION,'domains':['ZZ'],'source_manifest':pin(manifest),'fft_source':pin(repo/'Extra/c/falcon-fft.c'),
 'input_vectors':pin(vectors),'candidate':pin(candidate),'word_helper':pin(helper),
 'native_compile_argv':argv,'probe':pin(probe),'binary':pin(binary),'native_output':pin(Path.cwd()/'NATIVE.stdout'),
 'compared_words':int(len(words)),'gs_norm_candidate':g['norm_word'],
 'scope':'actual pinned C inverse-norm/adjoint/mulconst/mulAuto calls and ordered norm match auxiliary candidates; no kernel GS acceptance or population bound inferred'},indent=2)+'\n')
