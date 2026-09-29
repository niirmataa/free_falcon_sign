# Scalar oracle for the seven pinned primitives; run with the Sage preparser.
# Exact ZZ arithmetic mirroring the C semantics bit-for-bit (no floats).
import json
import os
import random
from pathlib import Path
from sage.version import version as sage_version

assert (1/2).parent() is QQ
assert 2^5 == 32
M64 = ZZ(2)^64
M32 = ZZ(2)^32

def u64(v):
    return ZZ(v) % M64

def u32(v):
    return ZZ(v) % M32

def neg64(x):
    return (-u64(x)) % M64

def spec_neg(x):
    return u64(x) ^^ (ZZ(1) << 63)

def spec_double(x):
    x = u64(x)
    return (x + ((((x >> 52) & 2047) + 2047) >> 11) % M32 * (ZZ(1) << 52)) % M64

def spec_half(x):
    x = u64(x)
    x1 = (x - (ZZ(1) << 52)) % M64
    t = ((((x1 >> 52) & 2047) + 1) >> 11) % M32
    return x1 & ((t - 1) % M64)

def spec_pack(s, e, m):
    e1 = ZZ(e) + 1076
    t = (u32(e1) >> 31) % M32
    m1 = u64(m) & ((t - 1) % M64)
    t2 = (m1 >> 54) % M32
    e2 = (e1 % M32) & ((-t2) % M32)
    x = (((u64(s) << 63) | (m1 >> 2)) + ((e2 % M32) << 52)) % M64
    f = m1 & 7
    return (x + ((200 >> f) & 1)) % M64

def spec_rint(x):
    x = u64(x)
    y = (x >> 52) & 2047
    e = (1085 - y) % M32
    m0 = ((x << 10) | (ZZ(1) << 62)) % M64 & (M64 // 2 - 1)
    mask = (-(((e - 64) % M32) >> 31)) % M64
    m1 = m0 & mask
    e2 = e & 63
    d = (m1 << (63 - e2)) % M64
    dd = (d % M32) | (((d >> 32) % M32) & 0x1FFFFFFF)
    dd %= M32
    f = ((d >> 61) % M32) | ((((dd | (-dd % M32)) % M32) >> 31))
    f %= M32
    m2 = ((m1 >> e2) + ((200 >> f) & 1)) % M64
    s = (x >> 63) % M32
    return ((m2 ^^ ((M64 - s) % M64)) + s) % M64

def spec_floor(x):
    x = u64(x)
    e = (x >> 52) & 2047
    t = x >> 63
    m0 = ((x << 10) | (ZZ(1) << 62)) % M64 & (M64 // 2 - 1)
    xi = (m0 ^^ ((M64 - t) % M64)) + t
    xi_s = xi if xi < 2^63 else xi - M64
    cc = 1085 - e
    xi1 = (xi_s // (ZZ(2)^(cc & 63))) % M64
    mask = (-((((63 - cc) % M32) >> 31))) % M64
    return ((xi1 & (M64 - 1 - mask)) | (((M64 - t) % M64) & mask)) % M64

def ybits(x):
    return (u64(x) >> 52) & 2047

def in_rint(x):
    return ybits(x) <= 1072

def in_floor(x):
    return ybits(x) <= 1072 and u64(x) != (ZZ(1) << 63)

def in_pack(s, e):
    return -(2^31) <= ZZ(e) + 1076 < 2^31

rows = []
n_in = 0
n_obs = 0

def emit(op, cells, scope):
    global n_in, n_obs
    rows.append('%s %s %s\n' % (op, ' '.join(cells), scope))
    if scope == 'in':
        n_in += 1
    else:
        n_obs += 1

def hx(v):
    return '%016x' % u64(v)

# Boundary word inventory shared by single-word ops.
bounds = {0, 1, 2, (ZZ(1) << 63) - 1, (ZZ(1) << 63), (ZZ(1) << 63) + 1,
          M64 - 1, M64 - 2, (ZZ(1) << 52) - 1, (ZZ(1) << 52), (ZZ(1) << 52) + 1,
          (ZZ(1) << 62), (ZZ(1) << 62) + 1, 0x0123456789abcdef, 0xfedcba9876543210,
          0x7ff0000000000000, 0xfff0000000000000, 0x7ff0000000000001,
          0x7ff8000000000000, 0xfff8000000000001, 0x7fffffffffffffff}
for bit in (0, 1, 10, 11, 31, 32, 51, 52, 53, 62, 63):
    bounds.update([ZZ(2)^bit, M64 - ZZ(2)^bit, (ZZ(2)^bit) + 1])
# Halves and ties: k.5 words across the exponent range.
for k in range(-2, 8):
    bounds.add(u64((1023 + k) * (ZZ(1) << 52) + (ZZ(1) << 51)))
for w in sorted(bounds):
    for op, fn in (('neg', spec_neg), ('double', spec_double), ('half', spec_half)):
        emit(op, [hx(w), hx(fn(w))], 'in')
# Full exponent sweep for rint/floor with fixed mantissa patterns.
mants = [0, M64 // 2 - 1, 0xAAAAAAAAAAAAAAAA % (ZZ(1) << 52), 0x5555555555555 % (ZZ(1) << 52)]
for y in range(2048):
    for mant in mants:
        w = ((ZZ(y) << 52) | mant) % M64
        for wv in (w, w | (ZZ(1) << 63)):
            emit('rint', [hx(wv), hx(spec_rint(wv))], 'in' if in_rint(wv) else 'obs')
            emit('floor', [hx(wv), hx(spec_floor(wv))], 'in' if in_floor(wv) else 'obs')
# Raw -0 floor is out of contract: observed value, recorded separately.
emit('floor', [hx(ZZ(1) << 63), hx(spec_floor(ZZ(1) << 63))], 'obs')
# Deterministic PRNG sweep across all single-word ops.
rng = random.Random(1536)
for _ in range(1500):
    w = ZZ(rng.getrandbits(64))
    for op, fn in (('neg', spec_neg), ('double', spec_double), ('half', spec_half)):
        emit(op, [hx(w), hx(fn(w))], 'in')
    emit('rint', [hx(w), hx(spec_rint(w))], 'in' if in_rint(w) else 'obs')
    emit('floor', [hx(w), hx(spec_floor(w))], 'in' if in_floor(w) else 'obs')
# Pack grid: s in {0,1}, e across the t-edge and full int32-safe range, m patterns.
mpats = [0, 1, 2, 7, 8, (ZZ(1) << 54) - 1, (ZZ(1) << 54), M64 - 1, M64 - 2,
         0xAAAAAAAAAAAAAAAA, 0x5555555555555555]
es = list(range(-1081, -1071)) + [-2000, -1500, -1077, -1076, 0, 1, 1071, 1072,
      2047, 2048, -2048, -(2^31) + 1076 - 1, 2^31 - 1076 - 2]
for s in (0, 1):
    for e in es:
        for m in mpats:
            emit('pack', ['%d' % s, '%d' % e, hx(m), hx(spec_pack(s, e, m))], 'in')
# Pack extremes stay in-domain for s (cast matches) but are observed.
for s in (2, -1, 2^31 - 1, -(2^31)):
    emit('pack', ['%d' % s, '0', hx(0x123456789abcdef), hx(spec_pack(s, 0, 0x123456789abcdef))], 'obs')
# Pack preflight rejects: e + 1076 overflows int.
rejects = [(0, 2^31 - 1, 0), (0, -(2^31), 0)]
# Sub wiring rows (mild values only: fpr_add internals are unresolved).
subwords = [0, 1, 2, 0x3FF0000000000000, 0xBFF0000000000000, 0x3FF8000000000000,
            0x4000000000000000, 0xC000000000000000, 0x0123456789abcdef,
            0x8000000000000000]
for a in subwords:
    for b in subwords:
        emit('subw', [hx(a), hx(b)], 'in')

dest = Path(os.environ['P02_DEST']) / 'build'
dest.mkdir(exist_ok=True)
case_lines = []
for (s, e, m) in rejects:
    case_lines.append('pack %d %d %s 0 in_reject\n' % (s, e, hx(m)))
case_lines.extend(rows)
(dest / 'scalar_cases.txt').write_text(''.join(case_lines))
certificate = {
    'schema': 'P02_SCALAR_ORACLE_V1', 'sage_version': sage_version,
    'preparser': True, 'domains': ['ZZ'],
    'oracle': 'exact integer mirror of the pinned C BitVec semantics (no host floats)',
    'in_cases': n_in, 'obs_cases': n_obs, 'reject_cases': len(rejects),
    'scope_in': ['neg', 'double', 'half', 'pack(s,e in-domain)', 'rint(y<=1072)',
                 'floor(y<=1072,x!=-0)', 'subw(wiring only)'],
    'scope_obs': ['rint(y>1072,NaN,Inf)', 'floor(y>1072,NaN,Inf,raw-0)', 'pack(extreme s)'],
    'scope_note': ('obs rows check C against the total literal spec as consistency '
                   'evidence only; the kernel contract covers in-rows. subw checks '
                   'fpr_sub(x,y)==fpr_add(x,y^sign) wiring, not add arithmetic. '
                   'pack rejects assert preflight (e+1076 int overflow).'),
    'mutations_expect': 'each mutant must produce MISMATCH (exit 1)',
    'formal_premise': False,
    'formal_correspondence': ['B20.Fpr.neg_execution', 'B20.Fpr.double_execution',
        'B20.Fpr.half_execution', 'B20.Fpr.pack_execution', 'B20.Fpr.rint_execution',
        'B20.Fpr.floor_execution', 'B20.Fpr.sub_refines_via_add_obligation'],
    'scope': 'finite diagnostic controls supporting, not replacing, the universal kernel theorems',
}
(dest / 'scalar_oracle.json').write_text(json.dumps(certificate, indent=int(2), default=int) + '\n')
print(json.dumps(certificate, sort_keys=True, default=int))
