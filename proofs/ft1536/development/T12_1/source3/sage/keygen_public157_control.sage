#!/usr/bin/env sage
# Exact auxiliary word controls for the source-certified public scalar closure.
from pathlib import Path
import hashlib,json,re,subprocess,shutil
from sage.env import SAGE_VERSION
root=next(p for p in [Path.cwd(),*Path.cwd().parents] if (p/'notes/run/KEYGEN_SUCCESS_BIG_TODO.md').is_file())
repo=root.parents[4]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def pin(p):return {'path':str(p),'sha256':sha(p)}
manifest=root/'.build/jobs/keygen_witness113_005/WITNESS113.json'
assert sha(manifest)=='dda0d8b5ec86f6b29139bf6c6ef02f30146ecf7cba87e9fe042b7b8624839ddf'
source=json.loads(manifest.read_text());vrfy=repo/'Extra/c/falcon-vrfy.c'
assert any(Path(row['path']).resolve()==vrfy.resolve() for row in source['source_inputs'])
for row in source['source_inputs']:assert sha(row['path'])==row['sha256']
M=2^32;Q=ZZ(18433);QI=ZZ(18431)
def u(x):return ZZ(x)%M
def correction(x):return u(x+(Q&u(-(x>>31))))
def add(x,y):return correction(u(x+y-Q))
def sub(x,y):return correction(u(x-y))
def mul(x,y):
    z=u(x*y);w=u((u(z*QI)&65535)*Q)
    return correction(u((u(z+w)>>16)-Q))
def half(x):return u(x+(Q&u(-(x&1))))>>1
def conv(x):return correction(x)
def reverse(x):
    y=ZZ(0)
    for _ in range(10):y=u((y<<1)|(x&1));x=x>>1
    return y
body='\n'.join(vrfy.read_text().splitlines()[741:803])
steps=re.findall(r'(y[0-9]+)\s*=\s*mq_monty(mul|sqr)\(([^;]+)\);',body)
assert len(steps)==19 and [x[0] for x in steps]==['y'+str(i) for i in range(19)]
assert 'return mq_montymul(y18, x, Qt, Q0It);' in body
def division(x,y):
    env={'x':x,'y':y,'R2t':ZZ(4564),'Qt':Q,'Q0It':QI}
    for dst,op,text in steps:
        args=[a.strip() for a in text.split(',')]
        assert args[-2:]==['Qt','Q0It']
        env[dst]=mul(env[args[0]],env[args[1]]) if op=='mul' else mul(env[args[0]],env[args[0]])
    return mul(env['y18'],x)
boundary=[ZZ(x) for x in [0,1,2,18432,18433,65535,65536,0x7fffffff,0x80000000,0xffffffff]]
pairs=[(x,y) for x in boundary for y in boundary];seed=ZZ(0x9e3779b9)
for _ in range(64):
    seed=u(seed*1664525+1013904223);x=seed
    seed=u(seed*1664525+1013904223);pairs.append((x,seed))
expected=[[conv(x),add(x,y),sub(x,y),half(x),mul(x,y),mul(x,x),division(x,y),reverse(x)] for x,y in pairs]
probe=Path.cwd()/'CONTROL157.c'
probe.write_text('#include <stdio.h>\n#include <stdint.h>\n#include <inttypes.h>\n#include "falcon-vrfy.c"\n'
 '_Static_assert(sizeof(int)==4 && sizeof(unsigned)==4 && sizeof(long)==8 && sizeof(size_t)==8, "LP64 required");\n'
 'int main(void) { uint32_t x,y; while(scanf("%" SCNx32 " %" SCNx32,&x,&y)==2) {\n'
 'printf("%08" PRIx32 " %08" PRIx32 " %08" PRIx32 " %08" PRIx32 " %08" PRIx32 " %08" PRIx32 " %08" PRIx32 " %08" PRIx32 "\\n",\n'
 'mq_conv_small((int32_t)x,Qt),mq_add(x,y,Qt),mq_sub(x,y,Qt),mq_rshift1(x,Qt),mq_montymul(x,y,Qt,Q0It),mq_montysqr(x,Qt,Q0It),mq_div_18433(x,y),rev10(x)); } return 0; }\n')
cc=shutil.which('cc');assert cc
binary=Path.cwd()/'CONTROL157'
argv=[cc,*source['profile_flags'],'-DFALCON_ASM_CORTEXM4=0','-std=c11','-ffunction-sections','-fdata-sections','-Wl,--gc-sections','-I',str(repo/'Extra/c'),str(probe),'-o',str(binary)]
compiled=subprocess.run(argv,capture_output=True,check=False)
(Path.cwd()/'CC.stdout').write_bytes(compiled.stdout);(Path.cwd()/'CC.stderr').write_bytes(compiled.stderr)
assert compiled.returncode==0 and compiled.stdout==compiled.stderr==b''
inputs=''.join(format(int(x),'08x')+' '+format(int(y),'08x')+'\n' for x,y in pairs)
(Path.cwd()/'CONTROL157_INPUT.txt').write_text(inputs)
native=subprocess.run([str(binary)],input=inputs.encode(),capture_output=True,check=False)
(Path.cwd()/'NATIVE.stdout').write_bytes(native.stdout);(Path.cwd()/'NATIVE.stderr').write_bytes(native.stderr)
assert native.returncode==0 and native.stderr==b''
actual=[[ZZ(w,16) for w in line.split()] for line in native.stdout.decode().splitlines()]
assert actual==expected
(Path.cwd()/'CONTROL157.json').write_text(json.dumps({'status':'PASS_EXACT_FINITE_AUXILIARY_CONTROL_ONLY','sage_version':SAGE_VERSION,
 'domains':['ZZ'],'cases':int(len(pairs)),'operations':['conv','add','sub','half','mul','square','div18433','rev10'],
 'source_manifest':pin(manifest),'vrfy_source':pin(vrfy),'probe':pin(probe),'binary':pin(binary),'native_compile_argv':argv,
 'native_output':pin(Path.cwd()/'NATIVE.stdout'),'division_chain_length':int(len(steps)),
 'scope':'exact public helper word algorithms, including raw boundary patterns; no full public-call success, field-range or probability claim'},indent=2)+'\n')
