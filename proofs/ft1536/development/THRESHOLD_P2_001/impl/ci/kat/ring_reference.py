#!/usr/bin/env python3
"""Niezależny KAT dla R_q = Z_q[X]/(X^N - X^(N/2) + 1) (WP-012b).

Implementacja szkolna + redukcja przez tożsamość X^e = X^(e-m) - X^(e-2m).
Nie korzysta z kodu Rust. Piny są w
`crates/ft-threshold-core/src/ring.rs` (test `mul_matches_independent_reference_kat`).

Uruchomienie: python3 ci/kat/ring_reference.py
"""

Q = 18433
N = 1536
M = N // 2


def mul(a: list[int], b: list[int]) -> list[int]:
    c = [0] * (2 * N - 1)
    for i, x in enumerate(a):
        if not x:
            continue
        for j, y in enumerate(b):
            if y:
                c[i + j] = (c[i + j] + x * y) % Q
    for e in range(2 * N - 2, N - 1, -1):
        v = c[e]
        if v:
            c[e - M] = (c[e - M] + v) % Q
            c[e - N] = (c[e - N] - v) % Q
            c[e] = 0
    return c[:N]


def fnv1a64_le(values: list[int]) -> int:
    h = 0xCBF29CE484222325
    for v in values:
        for byte in (v & 0xFF, (v >> 8) & 0xFF):
            h ^= byte
            h = (h * 0x100000001B3) & 0xFFFFFFFFFFFFFFFF
    return h


def main() -> None:
    a = [(7 * i + 3) % Q for i in range(N)]
    b = [(13 * i + 5) % Q for i in range(N)]
    c = mul(a, b)
    print("first8 =", c[:8])
    print("fnv1a64_le =", hex(fnv1a64_le(c)))

    x = [0] * N
    x[1] = 1
    x_n1 = [0] * N
    x_n1[N - 1] = 1
    print("x*x^(N-1) =", [(i, v) for i, v in enumerate(mul(x, x_n1)) if v])

    p = [0] * N
    p[0] = 1
    for _ in range(3 * N):
        p = mul(p, x)
    print("x^(3N) =", [(i, v) for i, v in enumerate(p) if v])


if __name__ == "__main__":
    main()
