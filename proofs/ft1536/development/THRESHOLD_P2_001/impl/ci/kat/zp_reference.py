#!/usr/bin/env python3
"""Niezależny KAT dla `Z_P` (P = 2^61−1) i MAC z ukrytym δ (WP-013).

Liczy wszystko wprost w Pythonie (bez kodu Rust). Piny są w
`crates/ft-threshold-core/src/zp.rs` i `.../mac.rs`.

Uruchomienie: python3 ci/kat/zp_reference.py
"""

P = (1 << 61) - 1

SECRET = 0x0123456789ABCDEF % P
COEFFS = [0x0F1E2D3C4B5A6978 % P, 0x1111222233334444 % P]
XS = [1, 2, 3, 5]

DELTA = 0x0F1E2D3C4B5A6978 % P
DELTA_COEFFS = [0x7E57C0DE12345678 % P]
VALUE = 0x0123456789ABCDEF % P
MAC = DELTA * VALUE % P
MAC_COEFFS = [0x00C0FFEE12345678 % P]


def eval_poly(poly: list[int], x: int) -> int:
    acc = 0
    for c in reversed(poly):
        acc = (acc * x + c) % P
    return acc


def split(secret: int, xs: list[int], coeffs: list[int]) -> list[tuple[int, int]]:
    poly = [secret] + coeffs
    return [(x, eval_poly(poly, x)) for x in xs]


def lagrange_at_zero(xs: list[int], ys: list[int]) -> int:
    acc = 0
    for i, xi in enumerate(xs):
        num = 1
        den = 1
        for j, xj in enumerate(xs):
            if i == j:
                continue
            num = num * (-xj) % P
            den = den * (xi - xj) % P
        acc = (acc + ys[i] * num * pow(den, P - 2, P)) % P
    return acc


def fnv1a64_le(values: list[int]) -> int:
    h = 0xCBF29CE484222325
    for v in values:
        for byte in v.to_bytes(8, "little"):
            h ^= byte
            h = (h * 0x100000001B3) & 0xFFFFFFFFFFFFFFFF
    return h


def main() -> None:
    shares = split(SECRET, XS, COEFFS)
    ys = [y for _, y in shares]
    print("shares =", [(x, hex(y)) for x, y in shares])
    print("ys_fnv1a64_le =", hex(fnv1a64_le(ys)))

    for k in (3, 4):
        print(f"reconstruct_k{k} =", hex(lagrange_at_zero(XS[:k], ys[:k])))

    lambdas = []
    for i, xi in enumerate(XS):
        num = 1
        den = 1
        for j, xj in enumerate(XS):
            if i == j:
                continue
            num = num * (-xj) % P
            den = den * (xi - xj) % P
        lambdas.append(num * pow(den, P - 2, P) % P)
    print("lambdas_sum =", hex(sum(lambdas) % P))
    print("lambdas =", [hex(v) for v in lambdas])

    # MAC z ukrytym δ: value i mac dzielone osobno, δ tylko w udziałach.
    delta_shares = split(DELTA, XS[:2], DELTA_COEFFS)
    value_shares = split(VALUE, XS[:2], COEFFS[:1])
    mac_shares = split(MAC, XS[:2], MAC_COEFFS[:1])
    print("delta_ys =", [hex(y) for _, y in delta_shares])
    print("value_ys =", [hex(y) for _, y in value_shares])
    print("mac_ys =", [hex(y) for _, y in mac_shares])

    xs2 = XS[:2]
    v = lagrange_at_zero(xs2, [y for _, y in value_shares])
    zs = [
        (m - v * d) % P
        for (_, m), (_, d) in zip(mac_shares, delta_shares)
    ]
    z = lagrange_at_zero(xs2, zs)
    print("open_value =", hex(v), "z =", z, "ok =", v == VALUE and z == 0)

    # Atak: +Δ do udziału wartości, +Δ do MAC (bez δ) — musi wykryć.
    bad_zs = [
        (m + 1 - (v + 1) * d) % P
        for (_, m), (_, d) in zip(mac_shares, delta_shares)
    ]
    print("tamper_detected =", lagrange_at_zero(xs2, bad_zs) != 0)


if __name__ == "__main__":
    main()
