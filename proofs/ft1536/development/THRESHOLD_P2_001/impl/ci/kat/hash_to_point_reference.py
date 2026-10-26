#!/usr/bin/env python3
"""Niezależny KAT dla SHAKE256/hash_to_point (WP-012c).

Używa `hashlib.shake_256` (OpenSSL), nie kodu Rust. Piny są w
`crates/ft-threshold-core/src/shake.rs`.

Uruchomienie: python3 ci/kat/hash_to_point_reference.py
"""

import hashlib

Q = 18433
N = 1536
LIM = 65536 - (65536 % Q)


def fnv1a64_le(values: list[int]) -> int:
    h = 0xCBF29CE484222325
    for v in values:
        for byte in (v & 0xFF, (v >> 8) & 0xFF):
            h ^= byte
            h = (h * 0x100000001B3) & 0xFFFFFFFFFFFFFFFF
    return h


def hash_to_point(nonce: bytes, msg: bytes) -> list[int]:
    stream = hashlib.shake_256(nonce + msg).digest(N * 4)
    out: list[int] = []
    for i in range(0, len(stream) - 1, 2):
        w = (stream[i] << 8) | stream[i + 1]
        if w < LIM:
            out.append(w % Q)
            if len(out) == N:
                break
    return out


def main() -> None:
    print("lim =", LIM)
    print("shake256_empty =", hashlib.shake_256(b"").hexdigest(32))
    print("shake256_abc =", hashlib.shake_256(b"abc").hexdigest(32))

    nonce = bytes([0x11]) * 40
    msg = b"FT1536 P2 KAT"
    t = hash_to_point(nonce, msg)
    print("hash_to_point_len =", len(t))
    print("hash_to_point_first8 =", t[:8])
    print("hash_to_point_fnv1a64_le =", hex(fnv1a64_le(t)))


if __name__ == "__main__":
    main()
