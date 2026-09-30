# Exact cross-check, not a dependency or replacement of the Lean proof.
# Run with the standard Sage preparser: sage check_stable_top_inputs.sage.
from pathlib import Path
import hashlib
import json
import os

source = Path(os.environ['FT1536_SOURCE3_ORIGINAL_W']) / 'inputs/source'
pins = {
    'falcon-keygen.c': '0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf',
    'fpr-emulated.c': '7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f',
    'fpr-emulated.h': '242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa',
}
for name, pin in pins.items():
    assert hashlib.sha256((source/name).read_bytes()).hexdigest() == pin

M32, M64 = ZZ(2)^32, ZZ(2)^64
def u32(x): return ZZ(x) % M32
def u64(x): return ZZ(x) % M64

# fpr_scaled(3,0), C M0 lines151--204, including the actual NORM64 macro.
i, sc = ZZ(3), ZZ(0)
s = u64(i) >> 63
i = (i ^^ (-s)) + s
m, e = u64(i), ZZ(9)+sc
e -= 63
normalization = []
for shift in [32,16,8,4,2,1]:
    nt = u32(m >> (64-shift))
    nt = u32(nt | u32(-nt)) >> 31
    m = u64(m ^^ ((m ^^ u64(m << shift)) & u64(nt-1)))
    e += nt*shift
    normalization.append({'shift':int(shift),'mantissa':str(m),'exponent':int(e)})
m = u64(m | u32((u32(m) & 0x1FF)+0x1FF))
m >>= 9
t = u32(u64(i | -i) >> 63)
m &= u64(-t)
e &= -t

# Literal FPR body from header39--55.
e += 1076
t = u32(e) >> 31
m &= u64(t-1)
t = u32(m >> 54)
e &= -t
x = u64(((u64(s) << 63) | (m >> 2)) + (u64(u32(e)) << 52))
f = u32(m) & 7
x = u64(x + ((0xC8 >> f) & 1))
assert x == ZZ(0x4008000000000000)
exponent = (x >> 52) & 0x7FF
fraction = x & (2^52-1)
value = QQ(2)^ZZ(exponent-1023) * (1+QQ(fraction)/2^52)
assert value == QQ(3)

# Finite schedule diagnostics; the universal loop proof remains a Lean goal.
reads = [3*v+j for v in range(256) for j in range(3)]
writes = [offset+v for v in range(256) for offset in [0,256,512]]
assert reads == list(range(768))
assert sorted(writes) == list(range(768))
assert len(set(writes)) == 768
assert max([2*v+j for v in range(256) for j in range(3)]) != 767
assert sorted([offset+v for v in range(256) for offset in [0,255,512]]) != list(range(768))
result = {'mode':'Sage standard preparser; ZZ/QQ exact; diagnostic only',
          'source_pins':pins,'fpr_of_3_word':hex(x),'decoded_value':str(value),
          'normalization':normalization,'reads':len(reads),'writes':len(writes),
          'schedule_mutations_detected':['u step 2','second store offset 255']}
Path('FPR_OF_3_CROSSCHECK.json').write_text(json.dumps(result,indent=2)+'\n')
print('EXACT_CROSSCHECK_PASS',hex(x),'decoded=',value,'reads/writes=',len(reads),len(writes))
