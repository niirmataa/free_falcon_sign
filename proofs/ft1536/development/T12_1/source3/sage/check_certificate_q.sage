# Exact source-algorithm cross-check. Standard Sage preparser, ZZ/QQ only.
from pathlib import Path
import hashlib, json, os
root=Path(os.environ['FT1536_SOURCE3_ORIGINAL_W'])/'inputs/source'
pins={'falcon-keygen.c':'0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf',
      'fpr-emulated.c':'7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f',
      'fpr-emulated.h':'242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa'}
for name,pin in pins.items(): assert hashlib.sha256((root/name).read_bytes()).hexdigest()==pin
line=(root/'falcon-keygen.c').read_text().splitlines()[7445]
assert line=='#define FT1536_KEYGEN_Q_SQUARED    ((int64_t)339775489)'
M32,M64=ZZ(2)^32,ZZ(2)^64
def u32(x): return ZZ(x)%M32
def u64(x): return ZZ(x)%M64
i=ZZ(339775489); s=u64(i)>>63; i=(i ^^ (-s))+s
m,e=u64(i),ZZ(9)-63
for shift in [32,16,8,4,2,1]:
    nt=u32(m>>(64-shift)); nt=u32(nt | u32(-nt))>>31
    m=u64(m ^^ ((m ^^ u64(m<<shift)) & u64(nt-1)))
    e+=nt*shift
m=u64(m | u32((u32(m)&0x1FF)+0x1FF)); m>>=9
t=u32(u64(i | -i)>>63); m &= u64(-t); e &= -t
e+=1076; t=u32(e)>>31; m &= u64(t-1); t=u32(m>>54); e &= -t
x=u64(((u64(s)<<63)|(m>>2))+(u64(u32(e))<<52))
x=u64(x+((0xC8>>(u32(m)&7))&1))
value=(1+QQ(x & (2^52-1))/2^52)*QQ(2)^ZZ(((x>>52)&0x7FF)-1023)
assert value==QQ(339775489)
indices=[ZZ(1535)-u for u in range(768)]
assert indices==list(reversed(range(768,1536)))
assert len(set(indices))==768 and set(indices).isdisjoint(range(768))
assert indices!=[768+u for u in range(768)]
Path('CERTIFICATE_Q_CHECK.json').write_text(json.dumps({'word':hex(x),'value':str(value),
    'source_pins':pins,'reverse_first':int(indices[0]),'reverse_last':int(indices[-1]),
    'scope':'finite exact cross-check; universal proofs in Lean'},indent=2)+'\n')
print('Q_SQUARED_EXACT',hex(x),value,'REVERSE_ENDPOINTS',indices[0],indices[-1])
