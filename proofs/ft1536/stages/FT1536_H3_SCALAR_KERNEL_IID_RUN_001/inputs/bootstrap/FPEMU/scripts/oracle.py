"""Independent rational binary64 oracle: integer division, ties-to-even, isqrt.

No host float, C-style limb multiplication, sticky transducer or restoring loop.
"""
from fractions import Fraction as Q
from math import isqrt

MASK = (1 << 64)-1
SIGN = 1 << 63
FRAC = (1 << 52)-1

def p2(e):
    return Q(1 << e) if e >= 0 else Q(1, 1 << -e)

def value(w):
    e, f = (w >> 52) & 2047, w & FRAC
    assert e != 2047
    q = f*p2(-1074) if e == 0 else ((1 << 52)+f)*p2(e-1075)
    return -q if w & SIGN else q

def signed(w):
    return w-(1 << 64) if w & SIGN else w

def fl2(q):
    assert q > 0
    e = q.numerator.bit_length()-q.denominator.bit_length()
    return e-1 if q < p2(e) else e

def rnint(q):
    a, r = divmod(q.numerator, q.denominator)
    return a + (2*r > q.denominator or (2*r == q.denominator and (a & 1)))

def rn(q, negative_zero=False):
    q = Q(q)
    s = SIGN if q < 0 or (not q and negative_zero) else 0
    q = abs(q)
    if not q:
        return s
    e = fl2(q)
    if e < -1022:
        return s | rnint(q/p2(-1074))
    m = rnint(q/p2(e-52))
    if m == 1 << 53:
        e += 1
        m >>= 1
    if e > 1023:
        return s | (2047 << 52)
    return s | ((e+1023) << 52) | (m-(1 << 52))

def sqrt_rn(q):
    assert q >= 0
    if not q:
        return 0
    e = fl2(q)//2
    unit = p2(e-52)
    a = q/(unit*unit)
    m = isqrt(a.numerator//a.denominator)
    midpoint_square = Q((2*m+1)**2, 4)
    m += a > midpoint_square or (a == midpoint_square and (m & 1))
    return rn(m*unit)

def normal(w):
    return 0 < ((w >> 52) & 2047) < 2047

def nz(w):
    return (w & (SIGN-1)) == 0
