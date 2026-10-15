#!/usr/bin/env sage
# Exact word/shape consistency against pinned C; finite auxiliary evidence only.
import hashlib,json,re,sys,subprocess,shutil
from pathlib import Path
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
assert len(sys.argv)==3
label,digest=sys.argv[1:]
assert re.fullmatch(r'keygen_fftmiddle139_[0-9]{3}',label)
assert re.fullmatch(r'[0-9a-f]{64}',digest)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
folder=root/'.build/jobs'/label;candidate=folder/'FFT139_CONTROL_CANDIDATE.json';assert sha(candidate)==digest
values=json.loads(candidate.read_text());assert values['g_preserved']
for field in ['initial','pilot4','next8']:
    values[field]=[ZZ(x) for x in values[field]]
    assert len(values[field])==1536 and all(0<=x<2^64 for x in values[field])
bindings=[]
for tag,module in [('BEFORE','GeneratedFft138FirstF24'),('PILOT','GeneratedFft139MiddlePilot'),('NEXT','GeneratedFft139MiddleNext')]:
    source=root/'formal/Source3'/(module+'.lean')
    block=source.read_text().split('def dataBlock : C99FiniteMemory114.Block := ',1)[1].split('\n\ndef localSnapshot',1)[0]
    assert block==(folder/('FFT139_CONTROL_'+tag+'.txt')).read_text()
    bindings.append({'path':str(source),'sha256':sha(source)})
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
m=json.loads(manifest.read_text())
for row in m['source_inputs']:assert sha(row['path'])==row['sha256']
fft=repo/'Extra/c/falcon-fft.c'
assert sha(fft)=='06b573b636ae368dcda3eb4d89c3936ab31272123440d0d5362317e55d9ac063'
text=fft.read_text();function=text.split('falcon_FFT3(fpr *a, unsigned logn, unsigned full)\n{',1)[1].split('\n/* see internal.h */',1)[0]
body=function.split('for (v = v1; v < v2; v ++) {',1)[1].split('\n\t\t\t}',1)[0]
assert 'FPC_MUL' in body and 'FPC_ADD' in body and 'FPC_SUB' in body
probe=Path.cwd()/'CONTROL139.c'
probe.write_text('#include <stdio.h>\n#include <stdint.h>\n#include <inttypes.h>\n#include <stdlib.h>\n#include "falcon-fft.c"\n'
'_Static_assert(sizeof(int)==4 && sizeof(long)==8 && sizeof(size_t)==8, "LP64 required");\n'
'int main(int argc,char **argv) { fpr a[1536]; size_t hn=768,ht=384,v; unsigned count;\n'
'if(argc!=2) { return 2; } count=(unsigned)strtoul(argv[1],0,10); if(count>384) { return 3; }\n'
'for(v=0;v<1536;v++) { if(scanf("%" SCNx64,&a[v])!=1) { return 4; } }\n'
'fpr sr=fpr_gm3_square[4],si=fpr_gm3_square[5];\n'
'for(v=0;v<count;v++) {'+body+'\n}\n'
'for(v=0;v<1536;v++) { printf("%016" PRIx64 "\\n",a[v]); } return 0; }\n')
cc=shutil.which('cc');assert cc
binary=Path.cwd()/'CONTROL139'
argv=[cc,*m['profile_flags'],'-DFALCON_ASM_CORTEXM4=0','-std=c11','-I',str(repo/'Extra/c'),str(probe),str(repo/'Extra/c/fpr-emulated.c'),'-o',str(binary)]
r=subprocess.run(argv,capture_output=True,check=False)
(Path.cwd()/'CC.stdout').write_bytes(r.stdout);(Path.cwd()/'CC.stderr').write_bytes(r.stderr)
assert r.returncode==0 and r.stdout==r.stderr==b''
inputs=''.join(format(int(x),'016x')+'\n' for x in values['initial'])
(Path.cwd()/'CONTROL139_INPUT.txt').write_text(inputs)
for count,field in [(4,'pilot4'),(8,'next8')]:
    r=subprocess.run([str(binary),str(count)],input=inputs.encode(),capture_output=True,check=False)
    (Path.cwd()/('NATIVE'+str(count)+'.stdout')).write_bytes(r.stdout)
    (Path.cwd()/('NATIVE'+str(count)+'.stderr')).write_bytes(r.stderr)
    assert r.returncode==0 and r.stderr==b''
    words=[ZZ(x,16) for x in r.stdout.decode().splitlines()]
    assert words==values[field]
    touched=set([v+offset for v in range(count) for offset in [0,384,768,1152]])
    assert all(words[i]==values['initial'][i] for i in range(1536) if i not in touched)
(Path.cwd()/'FFT139_CONTROL.json').write_text(json.dumps({
    'status':'PASS_EXACT_FINITE_CONTROL_ONLY; NOT_A_SOURCE_OR_PROBABILITY_PREMISE',
    'sage_version':SAGE_VERSION,'domains':['ZZ'],'counts':[int(4),int(8)],'words_each':int(1536),
    'g_preserved_candidate':True,'candidate':{'path':str(candidate),'sha256':digest},
    'bound_generated_sources':bindings,'compile_argv':argv,
    'source_manifest':{'path':str(manifest),'sha256':sha(manifest)},
    'pinned_fft':{'path':str(fft),'sha256':sha(fft)},'probe':{'path':str(probe),'sha256':sha(probe)},
    'binary':{'path':str(binary),'sha256':sha(binary)}},indent=2)+'\n')
