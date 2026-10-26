#!/usr/bin/env python3
"""Niezależny KAT dla NTT ternarnego (WP-012e).

Odwzorowuje `mq_mkgm3` + `mq_NTT_ternary` + `mq_iNTT_ternary` z
`Extra/c/falcon-vrfy.c` (galaz tertiary, q=18433, n=3*2^9) w Pythonie.
Piny sa w `crates/ft-threshold-core/src/ntt.rs`.

Testy w Rust dodatkowo sprawdzaja algebrę: `mul` NTT == szkolne `Poly::mul`
(w tym samym pierscieniu), wiec kolejnosc wyjscia NTT nie jest jedynym
kryterium poprawnosci.

Uruchomienie: python3 ci/kat/ntt_reference.py
"""

Q = 18433
Q0I = 18431
R = 10237
R2 = 4564
LOGN = 10
LOGN_MAX = 11
GM_SIZE = 1 << LOGN_MAX
N = 3 << (LOGN - 1)


def montymul(x: int, y: int) -> int:
    z = (x * y) & 0xFFFFFFFF
    w = (((z * Q0I) & 0xFFFF) * Q) & 0xFFFFFFFF
    z = ((z + w) >> 16) & 0xFFFFFFFF
    z = (z - Q) & 0xFFFFFFFF
    if z >> 31:
        z = (z + Q) & 0xFFFFFFFF
    return z


def addq(x: int, y: int) -> int:
    d = (x + y - Q) & 0xFFFFFFFF
    if d >> 31:
        d = (d + Q) & 0xFFFFFFFF
    return d


def subq(x: int, y: int) -> int:
    d = (x - y) & 0xFFFFFFFF
    if d >> 31:
        d = (d + Q) & 0xFFFFFFFF
    return d


def divq(x: int, y: int) -> int:
    return x * pow(y, Q - 2, Q) % Q


def rev10(x: int) -> int:
    y = 0
    for _ in range(10):
        y = (y << 1) | (x & 1)
        x >>= 1
    return y


def mkgm3(logn: int) -> tuple[list[int], list[int]]:
    gm = [0] * GM_SIZE
    igm = [0] * GM_SIZE
    g = montymul(25, R2)
    k = logn
    while k < LOGN_MAX:
        g = montymul(g, g)
        k += 1
    ig = divq(R2, g)

    if logn == 1:
        gm[1] = g
        igm[1] = ig
    else:
        x, ix = g, ig
        g2 = montymul(g, g)
        g4 = montymul(g2, g2)
        ig2 = montymul(ig, ig)
        ig4 = montymul(ig2, ig2)
        k = LOGN_MAX - logn
        b = 1 << (logn - 1)
        for u in range(0, b, 2):
            gm[b + rev10(u << k)] = x
            igm[b + rev10(u << k)] = ix
            x = montymul(x, g4)
            ix = montymul(ix, ig4)
            gm[b + rev10((u + 1) << k)] = x
            igm[b + rev10((u + 1) << k)] = ix
            x = montymul(x, g2)
            ix = montymul(ix, ig2)

    k = logn - 2
    for u in range(1 << k, 1 << (k + 1)):
        y = gm[u << 1]
        z = igm[u << 1]
        gm[u] = montymul(y, montymul(y, y))
        igm[u] = montymul(z, montymul(z, z))
    for u in range((1 << k) - 1, 0, -1):
        v = u << 1
        gm[u] = montymul(gm[v], gm[v])
        igm[u] = montymul(igm[v], igm[v])
    gm[0] = gm[1]
    w = gm[1]
    igm[0] = divq(R2, subq(addq(w, w), R))
    return gm, igm


def ntt(a: list[int], gm: list[int]) -> None:
    n = len(a)
    hn = n >> 1
    r = gm[1]
    for u in range(hn):
        a0, a1 = a[u], a[u + hn]
        b = montymul(a1, r)
        a[u] = addq(a0, b)
        a[u + hn] = subq(addq(a0, a1), b)

    t, m = hn, 2
    while t > 3:
        ht = t >> 1
        v1 = 0
        for u1 in range(m):
            s = gm[m + u1]
            for v in range(v1, v1 + ht):
                a0, a1 = a[v], a[v + ht]
                a1 = montymul(a1, s)
                a[v] = addq(a0, a1)
                a[v + ht] = subq(a0, a1)
            v1 += t
        t = ht
        m <<= 1

    w = montymul(gm[1], gm[1])
    v = 1 << (LOGN - 1)
    for u in range(0, n, 3):
        fa, fb, fc = a[u], a[u + 1], a[u + 2]
        x = gm[v]
        x2 = montymul(x, x)
        fb0 = montymul(fb, x)
        fb1 = montymul(fb0, w)
        fb2 = montymul(fb1, w)
        fc0 = montymul(fc, x2)
        fc1 = montymul(fc0, w)
        fc2 = montymul(fc1, w)
        a[u] = addq(fa, addq(fb0, fc0))
        a[u + 1] = addq(fa, addq(fb1, fc2))
        a[u + 2] = addq(fa, addq(fb2, fc1))
        v += 1


def intt(a: list[int], igm: list[int]) -> None:
    n = len(a)
    hn = n >> 1

    w = montymul(igm[1], igm[1])
    v = 1 << (LOGN - 1)
    for u in range(0, n, 3):
        f0, f1, f2 = a[u], a[u + 1], a[u + 2]
        x = igm[v]
        x2 = montymul(x, x)
        f11 = montymul(f1, w)
        f12 = montymul(f11, w)
        f21 = montymul(f2, w)
        f22 = montymul(f21, w)
        a[u] = addq(f0, addq(f1, f2))
        a[u + 1] = montymul(x, addq(f0, addq(f11, f22)))
        a[u + 2] = montymul(x2, addq(f0, addq(f12, f21)))
        v += 1

    t, m = 6, 1 << (LOGN - 2)
    while t < n:
        ht = t >> 1
        v1 = 0
        for u1 in range(m):
            s = igm[m + u1]
            for v in range(v1, v1 + ht):
                a0, a1 = a[v], a[v + ht]
                a[v] = addq(a0, a1)
                a[v + ht] = montymul(subq(a0, a1), s)
            v1 += t
        t <<= 1
        m >>= 1

    r = igm[0]
    for u in range(hn):
        a0, a1 = a[u], a[u + hn]
        b = montymul(r, subq(a0, a1))
        a[u] = subq(addq(a0, a1), b)
        a[u + hn] = addq(b, b)

    ni = divq(R, n)
    for u in range(n):
        a[u] = montymul(a[u], ni)


def fnv1a64_le(values: list[int]) -> int:
    h = 0xCBF29CE484222325
    for v in values:
        for byte in (v & 0xFF, (v >> 8) & 0xFF):
            h ^= byte
            h = (h * 0x100000001B3) & 0xFFFFFFFFFFFFFFFF
    return h


def poly_mul_schoolbook(a: list[int], b: list[int]) -> list[int]:
    acc = [0] * (2 * N - 1)
    for i in range(N):
        if a[i] == 0:
            continue
        for j in range(N):
            acc[i + j] = (acc[i + j] + a[i] * b[j]) % Q
    # X^N = X^(N/2) - 1, redukcja od najwyzszego stopnia w dol.
    for k in range(2 * N - 2, N - 1, -1):
        c = acc[k]
        if c == 0:
            continue
        acc[k] = 0
        acc[k - N] = (acc[k - N] - c) % Q
        acc[k - N + N // 2] = (acc[k - N + N // 2] + c) % Q
    return acc[:N]


def main() -> None:
    gm, igm = mkgm3(LOGN)
    a = [(i * i * 13 + 7 * i + 3) % Q for i in range(N)]

    assert len(gm) == GM_SIZE and len(igm) == GM_SIZE
    e = list(a)
    ntt(e, gm)
    print("ntt_first8 =", e[:8])
    print("ntt_fnv1a64_le =", hex(fnv1a64_le(e)))

    back = list(e)
    intt(back, igm)
    print("roundtrip_ok =", back == a)

    b = [(i * 29 + 5) % Q for i in range(N)]
    eb = list(b)
    ntt(eb, gm)
    prod = [montymul(montymul(e[i], eb[i]), R2) for i in range(N)]
    intt(prod, igm)
    print("mul_first8 =", prod[:8])
    print("mul_matches_schoolbook =", prod == poly_mul_schoolbook(a, b))
    print("mul_fnv1a64_le =", hex(fnv1a64_le(prod)))


if __name__ == "__main__":
    main()
