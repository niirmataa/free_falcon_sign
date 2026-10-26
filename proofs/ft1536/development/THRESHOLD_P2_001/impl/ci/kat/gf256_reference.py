#!/usr/bin/env python3
"""Niezależny KAT dla GF(2^8)/Shamir (WP-012a).

Ten skrypt nie korzysta z kodu Rust. Implementuje AES-owe mnożenie
bitowe i ręcznie składa wielomian Shamira. Wynik jest pinowany w
`crates/ft-threshold-core/src/gf256.rs` (test
`split_matches_independent_reference_kat`).

Uruchomienie: python3 ci/kat/gf256_reference.py
"""

FIELD_POLY = 0x1B


def mul(a: int, b: int) -> int:
    p = 0
    for _ in range(8):
        if b & 1:
            p ^= a
        hi = a & 0x80
        a = (a << 1) & 0xFF
        if hi:
            a ^= FIELD_POLY
        b >>= 1
    return p


def inv(a: int) -> int:
    if a == 0:
        raise ValueError("inv(0)")
    r = 1
    for _ in range(254):
        r = mul(r, a)
    return r


def eval_poly(coeffs: list[int], x: int) -> int:
    acc = 0
    for c in reversed(coeffs):
        acc = mul(acc, x) ^ c
    return acc


def main() -> None:
    # Wektor: secret=0x42, współczynnik liniowy=0x11, x=1,2,3 (k=2).
    secret = 0x42
    coeffs = [secret, 0x11]
    xs = [1, 2, 3]
    shares = [eval_poly(coeffs, x) for x in xs]
    print("secret =", hex(secret))
    print("coeffs =", [hex(c) for c in coeffs])
    print("xs     =", xs)
    print("shares =", [hex(y) for y in shares])

    # Znane iloczyny AES (kontrola implementacji).
    print("0x57 * 0x83 =", hex(mul(0x57, 0x83)))
    print("0x53 * 0xca =", hex(mul(0x53, 0xCA)))
    print("inv(0x53)   =", hex(inv(0x53)))


if __name__ == "__main__":
    main()
