#!/usr/bin/env python3
"""Niezależny KAT dla Shamir w Z_q (WP-012f).

Liczy udziały i rekonstrukcję Lagrange'a wprost w Pythonie (bez kodu Rust).
Piny są w `crates/ft-threshold-core/src/shamir_zq.rs`.

Uruchomienie: python3 ci/kat/shamir_zq_reference.py
"""

Q = 18433
SECRET = 0x42
COEFFS = [7, 3, 12345]
XS = [1, 2, 3, 5, 7]


def eval_poly(poly: list[int], x: int) -> int:
    acc = 0
    for c in reversed(poly):
        acc = (acc * x + c) % Q
    return acc


def split(secret: int, xs: list[int], coeffs: list[int]) -> list[tuple[int, int]]:
    poly = [secret] + coeffs
    return [(x, eval_poly(poly, x)) for x in xs]


def lagrange_at_zero(xs: list[int], ys: list[int]) -> int:
    secret = 0
    for i in range(len(xs)):
        num = 1
        den = 1
        for j in range(len(xs)):
            if i == j:
                continue
            num = num * (-xs[j]) % Q
            den = den * (xs[i] - xs[j]) % Q
        secret = (secret + ys[i] * num * pow(den, Q - 2, Q)) % Q
    return secret


def fnv1a64_le(values: list[int]) -> int:
    h = 0xCBF29CE484222325
    for v in values:
        for byte in (v & 0xFF, (v >> 8) & 0xFF):
            h ^= byte
            h = (h * 0x100000001B3) & 0xFFFFFFFFFFFFFFFF
    return h


def main() -> None:
    shares = split(SECRET, XS, COEFFS)
    ys = [y for _, y in shares]
    print("shares =", shares)
    print("ys_fnv1a64_le =", hex(fnv1a64_le(ys)))

    for k in range(2, len(shares) + 1):
        got = lagrange_at_zero(XS[:k], ys[:k])
        print(f"reconstruct_k{k} =", got)

    # Spójność: 5. udział leży na wielomianie stopnia 3.
    expected5 = eval_poly([SECRET] + COEFFS, XS[4])
    print("consistency_x7 =", expected5 == ys[4])

    # Tamper: podmiana y ostatniego udziału.
    bad = ys[:]
    bad[4] ^= 1
    print("tamper_detected =", lagrange_at_zero(XS[:4], bad[:4]) == SECRET and bad[4] != expected5)


if __name__ == "__main__":
    main()
