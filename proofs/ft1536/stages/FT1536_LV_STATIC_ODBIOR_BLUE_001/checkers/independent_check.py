#!/usr/bin/env python3
"""Independent exact decoder and polynomial checker for the fixed witness."""
import hashlib
import json
from pathlib import Path
import sys

if len(sys.argv) not in (2, 3):
    raise SystemExit("usage: independent_check.py INPUT_DIR [OUTPUT_JSON]")
base = Path(sys.argv[1])
N, Q, B = 1536, 18433, 2093922385

def parse_ints(path):
    vals = [int(x) for x in path.read_text(encoding="ascii").split()]
    if len(vals) != N:
        raise ValueError(f"{path}: expected {N}, got {len(vals)}")
    return vals

def decode_public_key(blob):
    if len(blob) != 2881 or blob[0] != 0x8A:
        raise ValueError("public-key header/length")
    data = blob[1:]
    acc = 0
    bits = 0
    out = []
    for byte in data:
        acc = (acc << 8) | byte
        bits += 8
        while bits >= 15 and len(out) < N:
            bits -= 15
            w = acc >> bits
            acc &= (1 << bits) - 1
            if w >= Q:
                raise ValueError("non-canonical public coefficient")
            out.append(w)
    if len(out) != N or bits != 0 or acc != 0:
        raise ValueError("public-key consumption/padding")
    return out

def bit(blob, pos):
    return (blob[pos // 8] >> (7 - pos % 8)) & 1

def decode_static(blob):
    if len(blob) <= 1 or blob[0] != 0xAA:
        raise ValueError("STATIC header")
    data = blob[1:]
    pos = 0
    out = []
    for _ in range(N):
        if pos + 9 > 8 * len(data):
            raise ValueError("truncated sign/low")
        sign = bit(data, pos)
        pos += 1
        low = 0
        for _ in range(8):
            low = (low << 1) | bit(data, pos)
            pos += 1
        high = 0
        while True:
            if pos >= 8 * len(data):
                raise ValueError("truncated unary")
            b = bit(data, pos)
            pos += 1
            if b:
                break
            high += 1
        if high > 255:
            raise ValueError("unary component exceeds source bound")
        magnitude = low + (high << 8)
        if magnitude >= 32768:
            raise ValueError("witness unexpectedly needs implementation-defined narrowing")
        out.append(-magnitude if sign else magnitude)
    consumed = (pos + 7) // 8
    for p in range(pos, 8 * consumed):
        if bit(data, p):
            raise ValueError("nonzero final padding")
    if consumed != len(data):
        raise ValueError("trailing bytes")
    return out, consumed, 8 * consumed - pos

def mul_mod_phi(a, b):
    conv = [0] * (2 * N - 1)
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                if bj:
                    conv[i + j] += ai * bj
    for k in range(len(conv) - 1, N - 1, -1):
        v = conv[k]
        if v:
            conv[k - 768] += v
            conv[k - 1536] -= v
    return [x % Q for x in conv[:N]]

def center(x):
    x %= Q
    return x - Q if x > Q // 2 else x

def q0(v):
    return sum(v[i] * v[i] + v[i] * v[i + 768] + v[i + 768] * v[i + 768]
               for i in range(768))

pk_blob = (base / "canonical_public_key.bin").read_bytes()
h_text = parse_ints(base / "canonical_public_h.txt")
h_pk = decode_public_key(pk_blob)
payload = (base / "witness.bin").read_bytes()
s, decoded_bytes, padding_bits = decode_static(payload)
c = parse_ints(base / "witness_c.txt")

hs = mul_mod_phi(h_text, s)
z1 = [center(c[i] - hs[i]) for i in range(N)]
source_words = []
for x in s:
    w = x & 0xFFFFFFFF
    if w >> 31:
        w = (w + Q) & 0xFFFFFFFF
    source_words.append(w & 0xFFFF)
machine_hs = mul_mod_phi(h_text, source_words)
machine_first = [center(machine_hs[i] - c[i]) for i in range(N)]

first_norm = q0(z1)
second_norm = q0(s)
machine_norm = q0(machine_first) + second_norm
errors = []
checks = {
    "public_key_decodes_to_text_h": h_pk == h_text,
    "h_canonical": all(0 <= x < Q for x in h_text),
    "c_canonical": all(0 <= x < Q for x in c),
    "payload_shape": s == [-20000] + [0] * (N - 1),
    "challenge_spec": c == [(8670 * x) % Q for x in h_text],
    "machine_first_zero": machine_first == [0] * N,
    "extractor_congruence": all((z1[i] + hs[i] - c[i]) % Q == 0 for i in range(N)),
    "machine_short": machine_norm < B,
    "extractor_not_short": first_norm + second_norm >= B,
}
record_path = base / "witness.json"
if record_path.exists():
    record = json.loads(record_path.read_text(encoding="utf-8"))
    checks.update({
        "record_h_matches": record.get("h") == h_text,
        "record_c_matches": record.get("c") == c,
        "record_s_matches": record.get("s") == s,
        "record_z1_matches": record.get("z1") == z1,
        "record_machine_first_matches": record.get("machine_first") == machine_first,
        "record_ext_first_norm_matches": record.get("ext_first_norm") == first_norm,
        "record_second_norm_matches": record.get("second_norm") == second_norm,
        "record_ext_norm_matches": record.get("ext_norm") == first_norm + second_norm,
        "record_machine_norm_matches": record.get("machine_norm") == machine_norm,
    })
for name, ok in checks.items():
    if not ok:
        errors.append(name)
out = {
    "schema": "DAYBREAK_INDEPENDENT_CHECK_V1",
    "arithmetic": "exact Python integers; coefficients reduced in GF(18433); Phi=X^1536-X^768+1",
    "payload_sha256": hashlib.sha256(payload).hexdigest(),
    "public_key_sha256": hashlib.sha256(pk_blob).hexdigest(),
    "decoded_bytes_after_header": decoded_bytes,
    "padding_bits": padding_bits,
    "s0": s[0],
    "source_pre_ntt_word0": source_words[0],
    "source_pre_ntt_residue0": source_words[0] % Q,
    "signed_s_residue0": s[0] % Q,
    "z1_sha256_i16le": hashlib.sha256(b"".join(int(x).to_bytes(2, "little", signed=True) for x in z1)).hexdigest(),
    "ext_first_norm": first_norm,
    "second_norm": second_norm,
    "ext_norm": first_norm + second_norm,
    "machine_norm": machine_norm,
    "B": B,
    "excess": first_norm + second_norm - B,
    "checks": checks,
    "errors": errors,
    "ok": not errors,
}
rendered = json.dumps(out, indent=2, sort_keys=True) + "\n"
if len(sys.argv) == 3:
    Path(sys.argv[2]).write_text(rendered, encoding="utf-8")
print(rendered, end="")
raise SystemExit(0 if not errors else 1)
