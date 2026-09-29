"""Independent V02 integer oracle for selected source-word cases; diagnostic only.

Run with `sage check_words.sage`, the standard Sage preparser and exact ZZ/QQ.
Every emitted row is a reproducible C test vector, not a formal premise.
"""
from pathlib import Path
import json

here = Path(__file__).resolve().parent
M64 = ZZ(2)^64 - 1
M32 = ZZ(2)^32 - 1
SGN = ZZ(2)^63


def u64(x):
    return ZZ(x) & M64


def u32(x):
    return ZZ(x) & M32


def signed64(x):
    x = u64(x)
    return x - (M64 + 1) if x & SGN else x


def exponent(x):
    return (ZZ(x) >> 52) & 2047


def literal_rint(x):
    x = u64(x)
    m = (((x << 10) | (ZZ(1) << 62)) & (SGN - 1))
    e = ZZ(1085) - exponent(x)
    m &= u64(-(((e - 64) & M32) >> 31))
    e &= 63
    d = u64(m << (63 - e))
    dd = (d & M32) | ((d >> 32) & 0x1fffffff)
    f = (d >> 61) | ((u32(dd | u32(-dd))) >> 31)
    m = (m >> e) + ((0xc8 >> f) & 1)
    return u64(-m if x >> 63 else m)


def literal_floor(x):
    x = u64(x)
    t = x >> 63
    m = (((x << 10) | (ZZ(1) << 62)) & (SGN - 1))
    xi = -m if t else m
    cc = 1085 - exponent(x)
    xi >>= (cc & 63)
    mask = u64(-((u32(63 - cc)) >> 31))
    return u64((u64(xi) & u64(~mask)) | (u64(-t) & mask))


def literal_pack(s, e, m):
    assert -2^31 <= e + 1076 < 2^31
    e1 = u32(e + 1076)
    t = e1 >> 31
    m = u64(m) & u64(t - 1)
    t = u32(m >> 54)
    e1 &= u32(-t)
    x = u64(((u64(s) << 63) | (m >> 2)) + (e1 << 52))
    return u64(x + ((0xc8 >> (m & 7)) & 1))


def as_rational(x):
    x = u64(x)
    y = exponent(x)
    assert y < 2047
    f = x & (ZZ(2)^52 - 1)
    mant = f if y == 0 else ZZ(2)^52 + f
    k = (1 - 1023 - 52) if y == 0 else (y - 1023 - 52)
    r = QQ(mant) * (QQ(2)^k)
    return -r if x & SGN else r


def ties_even_round(r):
    a, b = ZZ(r.numerator()), ZZ(r.denominator())
    q, rem = a // b, a % b
    return q + (1 if 2 * rem > b or (2 * rem == b and q % 2 != 0) else 0)


words = [0, SGN, 1, SGN + 1, ZZ(2)^52 - 1, SGN + ZZ(2)^52 - 1,
         0x3fe0000000000000, 0xbfe0000000000000,
         0x3ff0000000000000, 0xbff0000000000000,
         0x3ff8000000000000, 0xbff8000000000000,
         0x4004000000000000, 0xc004000000000000,
         0x3fefffffffffffff, 0xbfefffffffffffff,
         0x4300000000000000, 0xc300000000000000,
         0x3ff0000000000001, 0xbff0000000000001,
         0x000fffffffffffff, 0x800fffffffffffff,
         0x4310000000000000, 0x7ff0000000000000, 0x7ff8000000000001]
words += [u64(0x9e3779b97f4a7c15 * (i + 37)) for i in range(31)]
words = list(dict.fromkeys(words))
rows = []
counts = {}


def add(op, a, b, c, expected):
    rows.append((op, f'{u64(a):016x}', f'{u64(b):016x}',
                 f'{u64(c):016x}', f'{u64(expected):016x}'))
    counts[op] = counts.get(op, 0) + 1


for x in words:
    add('neg', x, 0, 0, x ^^ SGN)
    add('double', x, 0, 0, u64(x + (((((x >> 52) & 2047) + 2047) >> 11) << 52)))
    h = u64(x - ZZ(2)^52)
    t = ((((h >> 52) & 2047) + 1) >> 11)
    add('half', x, 0, 0, h & u64(t - 1))
    add('sub_stub', x, 0x3ff0000000000000, 0,
        u64(x + (0x3ff0000000000000 ^^ SGN)))
    add('le', x, x % 9, 0, x)
    for n in (0, 1, 31, 32, 33, 63):
        add('ursh', x, n, 0, x >> n)
        add('ulsh', x, n, 0, u64(x << n))
        add('irsh', x, n, 0, u64(signed64(x) >> n))
    if exponent(x) <= 1072:
        add('rint', x, 0, 0, literal_rint(x))
        if x != SGN:
            add('floor', x, 0, 0, literal_floor(x))
        if exponent(x) <= 1072 and abs(as_rational(x)) < QQ(2)^60:
            assert signed64(literal_rint(x)) == ties_even_round(as_rational(x)), hex(int(x))

for s in (0, 1, M32):
    for e in (-1076, -1075, -1022, -1, 0, 1023, 2^31 - 1 - 1076):
        for m in (0, 1, 7, ZZ(2)^54, SGN - 1, M64):
            add('pack', s, u32(e), m, literal_pack(s, ZZ(e), m))

assert literal_floor(SGN) == M64  # raw -0 -> -1 is outside floorDomain
assert literal_rint(SGN) == 0
assert exponent(0x4310000000000000) == 1073  # beyond rint/floor domain
assert all((ZZ(row[2], 16) < 64) for row in rows if row[0] in ('ursh','ulsh','irsh'))

(here / 'review_vectors.tsv').write_text(''.join('\t'.join(row) + '\n' for row in rows))
summary = dict(schema='V02_EXACT_WORD_CONTROL_V1', sage_version=str(version()),
               preparser=True, exact_domains=['ZZ', 'QQ'], counts=counts,
               rows=len(rows), raw_minus_zero_floor='0xffffffffffffffff (-1), excluded',
               invalid_shift_64='excluded, must be rejected by domain',
               add='synthetic fpr_add stub, tests wiring only',
               scope='selected finite diagnostic vectors; no universal source refinement')
(here / 'sage_result.json').write_text(json.dumps(summary, indent=2, sort_keys=True) + '\n')
print(json.dumps(summary, sort_keys=True))
