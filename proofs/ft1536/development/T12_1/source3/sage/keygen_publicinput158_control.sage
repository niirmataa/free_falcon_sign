#!/usr/bin/env sage
# Exhaustive auxiliary signed16 promotion/conv/narrow controls; not an acceptance premise.
from pathlib import Path
import hashlib,json,subprocess,shutil
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
def result(x):
    signed=ZZ(x) if x<2^15 else ZZ(x)-2^16
    raw=signed%2^32
    lifted=(raw+(ZZ(18433)&(-(raw>>31)%2^32)))%2^32
    narrowed=lifted%2^16
    return [lifted,narrowed,narrowed%256,narrowed//256]
expected=[result(ZZ(x)) for x in range(2^16)]
assert all(row[1]==row[2]+256*row[3] for row in expected)
assert [expected[i][1] for i in [0,1,65535]]==[0,1,18432]
probe=Path.cwd()/'CONTROL158.c'
probe.write_text('#include <stdio.h>\n#include <stdint.h>\n#include <inttypes.h>\n#include "falcon-vrfy.c"\n'
 '_Static_assert(sizeof(int)==4 && sizeof(int16_t)==2 && sizeof(uint16_t)==2 && sizeof(long)==8 && sizeof(size_t)==8, "LP64 and16-bit objects required");\n'
 'int main(void) { uint32_t x; while(scanf("%" SCNx32,&x)==1) { int16_t input=(int16_t)(uint16_t)x; uint32_t value=mq_conv_small(input,Qt); uint16_t output=(uint16_t)value; const unsigned char *bytes=(const unsigned char *)&output;\n'
 'printf("%08" PRIx32 " %04" PRIx16 " %02x %02x\\n",value,output,(unsigned)bytes[0],(unsigned)bytes[1]); } return 0; }\n')
cc=shutil.which('cc');assert cc
binary=Path.cwd()/'CONTROL158'
argv=[cc,*source['profile_flags'],'-DFALCON_ASM_CORTEXM4=0','-std=c11','-ffunction-sections','-fdata-sections','-Wl,--gc-sections','-I',str(repo/'Extra/c'),str(probe),'-o',str(binary)]
compiled=subprocess.run(argv,capture_output=True,check=False)
(Path.cwd()/'CC.stdout').write_bytes(compiled.stdout);(Path.cwd()/'CC.stderr').write_bytes(compiled.stderr)
assert compiled.returncode==0 and compiled.stdout==compiled.stderr==b''
inputs=''.join(format(int(x),'04x')+'\n' for x in range(2^16));(Path.cwd()/'CONTROL158_INPUT.txt').write_text(inputs)
native=subprocess.run([str(binary)],input=inputs.encode(),capture_output=True,check=False)
(Path.cwd()/'NATIVE.stdout').write_bytes(native.stdout);(Path.cwd()/'NATIVE.stderr').write_bytes(native.stderr)
assert native.returncode==0 and native.stderr==b''
actual=[[ZZ(w,16) for w in line.split()] for line in native.stdout.decode().splitlines()]
assert actual==expected
(Path.cwd()/'CONTROL158.json').write_text(json.dumps({'status':'PASS_EXHAUSTIVE_WORD16_AUXILIARY_CONTROL_ONLY','sage_version':SAGE_VERSION,
 'domains':['ZZ'],'cases':int(len(expected)),'operations':['signed16 promotion','mq_conv_small','uint16 narrowing','actual little-endian object bytes'],
 'source_manifest':pin(manifest),'vrfy_source':pin(vrfy),'probe':pin(probe),'binary':pin(binary),'native_compile_argv':argv,
 'native_output':pin(Path.cwd()/'NATIVE.stdout'),'selected_values':['0','1','18432'],
 'scope':'all65536 input bit patterns; no public-call success, sampler law or probability inference'},indent=2)+'\n')
