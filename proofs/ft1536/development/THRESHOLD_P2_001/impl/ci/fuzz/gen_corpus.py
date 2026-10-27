#!/usr/bin/env python3
"""WP-022 — generator deterministycznego korpusu fuzz dla wire v1.

Korpus powstaje z NIEZALEŻNEJ referencji CBOR (`ci/wire/cbor_reference.py`):
- `ok_body.bin`, `ok_envelope.bin` — poprawne, kanoniczne bajty,
- `bad_XX_<name>.bin` — 10 wariantów non-canonical (muszą być odrzucone),
- `mut_XX.bin` — 32 mutacje seedowane `ok_envelope` (bit-flip, obcięcie,
  wstawka, nadpisanie) — dopuszczalne Ok albo Err, ale bez paniki.

Wszystkie pliki są deterministyczne (xorshift64 o stałym ziarnie), więc
regeneracja musi być bitowo identyczna. Format nazwy jest kontraktem
testu Rust: prefiks decyduje o oczekiwanym wyniku.

Uruchomienie:
    python3 ci/fuzz/gen_corpus.py OUT_DIR
Regeneracja/porównanie: `ci/fuzz/run_fuzz_corpus.sh [--update]`.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "wire"))

import cbor_reference as R  # noqa: E402

SEED = 0x5DEECE66D
MUTATIONS = 32


class Xorshift:
    """Ten sam generator co w harnessach C/Rust (zamrożony kontrakt)."""

    def __init__(self, seed: int) -> None:
        self.s = seed & 0xFFFFFFFFFFFFFFFF or 1

    def next(self) -> int:
        x = self.s
        x ^= (x << 13) & 0xFFFFFFFFFFFFFFFF
        x ^= x >> 7
        x ^= (x << 17) & 0xFFFFFFFFFFFFFFFF
        self.s = x
        return x

    def below(self, n: int) -> int:
        return self.next() % n


def mutate(rng: Xorshift, data: bytes, idx: int) -> bytes:
    """Jedna deterministyczna mutacja wg `idx % 4`."""
    kind = idx % 4
    if kind == 0 and len(data) > 0:
        # bit-flip w losowym bajcie
        out = bytearray(data)
        pos = rng.below(len(data))
        out[pos] ^= 1 << rng.below(8)
        return bytes(out)
    if kind == 1 and len(data) > 2:
        # obcięcie 1..=len-1
        cut = 1 + rng.below(len(data) - 1)
        return data[:cut]
    if kind == 2:
        # wstawka 1..=16 bajtów w losowe miejsce
        pos = rng.below(len(data) + 1)
        extra = bytes(rng.below(256) for _ in range(1 + rng.below(16)))
        return data[:pos] + extra + data[pos:]
    # nadpisanie 1..=16 bajtów
    if len(data) == 0:
        return data
    out = bytearray(data)
    pos = rng.below(len(out))
    for i in range(1 + rng.below(16)):
        if pos + i < len(out):
            out[pos + i] = rng.below(256) & 0xFF
    return bytes(out)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("out_dir", help="katalog docelowy korpusu")
    args = ap.parse_args()

    out = Path(args.out_dir)
    out.mkdir(parents=True, exist_ok=True)
    for old in out.glob("*.bin"):
        old.unlink()

    body = R.body_cbor()
    mac = R.mac_of(R.PSK, body)
    env = R.envelope_cbor(body, mac)

    bads = {
        "bad_01_version_nonshort": R.body_cbor(version_nonshort=True),
        "bad_02_epoch_nonshort": R.body_cbor(epoch_nonshort=True),
        "bad_03_indefinite_map": R.body_cbor(indefinite=True),
        "bad_04_keys_unsorted": R.body_cbor(keys_unsorted=True),
        "bad_05_dup_key5": R.body_cbor(dup_key5=True),
        "bad_06_extra_key9": R.body_cbor(extra_key9=True),
        "bad_07_trailing_byte": R.body_cbor(trailing=True),
        "bad_08_tag_on_sid": R.body_cbor(tag_on_sid=True),
        "bad_09_text_sender": R.body_cbor(text_sender=True),
        "bad_10_missing_key8": R.body_cbor(drop_key8=True),
    }

    files: list[tuple[str, bytes]] = [
        ("ok_body.bin", body),
        ("ok_envelope.bin", env),
    ]
    for name, data in bads.items():
        files.append((f"{name}.bin", data))

    rng = Xorshift(SEED)
    for i in range(MUTATIONS):
        files.append((f"mut_{i:02}.bin", mutate(rng, env, i)))

    for name, data in files:
        (out / name).write_bytes(data)
    print(f"OK: {len(files)} plików w {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
