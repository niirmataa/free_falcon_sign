#!/usr/bin/env python3
"""Niezależny KAT dla PRSS (WP-012d).

Liczy klucze par i udziały zera wyłącznie z `hashlib.shake_256`, nie z
kodu Rust. Piny są w `crates/ft-threshold-core/src/prss.rs`.

Uruchomienie: python3 ci/kat/prss_reference.py
"""

import hashlib
import struct

Q = 18433
DOMAIN = b"FT1536-P2/prss-pair/v1"
CTX = b"FT1536-P2/prss/v1"


def nonce(i: int) -> bytes:
    return bytes([0x20 + i]) * 16


def lp(data: bytes) -> bytes:
    return struct.pack(">I", len(data)) + data


def pair_key(a: bytes, b: bytes, ctx: bytes = CTX) -> bytes:
    lo, hi = sorted([a, b])
    return hashlib.shake_256(DOMAIN + lp(ctx) + lp(lo) + lp(hi)).digest(32)


def prf(key: bytes, counter: int, label: bytes, n: int = 8) -> int:
    stream = hashlib.shake_256(key + struct.pack(">Q", counter) + label).digest(n)
    return int.from_bytes(stream, "big")


def zero_share_zq(me: int, other: int, counter: int) -> int:
    rho = prf(pair_key(nonce(me), nonce(other)), counter, b"zq") % Q
    return rho if me < other else (-rho) % Q


def zero_share_gf(me: int, other: int, counter: int) -> int:
    return prf(pair_key(nonce(me), nonce(other)), counter, b"gf", 1)


def main() -> None:
    print("key01 =", pair_key(nonce(0), nonce(1)).hex())
    print("key02 =", pair_key(nonce(0), nonce(2)).hex())
    print("key12 =", pair_key(nonce(1), nonce(2)).hex())

    for counter in (0, 7):
        print("counter =", counter)
        for me in range(3):
            shares = [
                (other, zero_share_zq(me, other, counter), zero_share_gf(me, other, counter))
                for other in range(3)
                if other != me
            ]
            total = sum(s[1] for s in shares) % Q
            x = 0
            for s in shares:
                x ^= s[2]
            print("  me", me, shares, "sum_zq", total, "xor_gf", x)


if __name__ == "__main__":
    main()
