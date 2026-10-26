#!/usr/bin/env python3
"""WP-027 — niezależna referencja kanonicznego CBOR + wektory wire v1.

Ten skrypt NIE korzysta z kodu Rust ani z silnika C. Implementuje
kanoniczne kodowanie CBOR (RFC 8949 §4.2) od zera dla dwóch kształtów
SPEC §9.3 (`body`, `envelope`), liczy `msg_id` (SHAKE256) i `mac`
(HMAC-SHA256 według `envelope.rs`/SPEC), a także generuje warianty
non-canonical, które dekoder Rust MUSI odrzucić.

Uruchomienie:
    python3 ci/wire/cbor_reference.py OUT.txt        # wektor do pliku
Regeneracja/porównanie: `ci/wire/run_wire_vectors.sh [--update]`.
"""

from __future__ import annotations

import argparse
import hashlib
import hmac
import sys

KEY_DOMAIN = b"FT1536/threshold/v1/envelope-key"
MAC_DOMAIN = b"FT1536/threshold/v1/mac"
MSGID_DOMAIN = b"FT1536/threshold/v1/msgid"

MAX_PAYLOAD_BYTES = 1 << 20

# Wejścia syntetyczne i publiczne (jak w KAT WP-024).
PSK = bytes(range(0x90, 0xB0))                 # 32 B
SID = bytes(range(0x21, 0x41))                 # 32 B
SENDER = bytes([0xA1] * 16)                    # 16 B
RECIPIENT = bytes([0xB2] * 16)                 # 16 B
EPOCH = 7
ROUND = 3
SEQ = 2
MSG_TYPE = 0x05                                # VSS_SHARE
PAYLOAD = b"wp027-vector-payload"              # 20 B, jawny


def enc_uint(v: int) -> bytes:
    """Kanoniczny uint (major 0): wyłącznie najkrótsza forma."""
    if v < 0:
        raise ValueError("nint poza zakresem protokołu")
    if v < 24:
        return bytes([v])
    if v < 1 << 8:
        return bytes([0x18, v])
    if v < 1 << 16:
        return bytes([0x19]) + v.to_bytes(2, "big")
    if v < 1 << 32:
        return bytes([0x1A]) + v.to_bytes(4, "big")
    return bytes([0x1B]) + v.to_bytes(8, "big")


def enc_bstr(b: bytes) -> bytes:
    """Kanoniczny bstr (major 2)."""
    return enc_head_len(2, len(b)) + b


def enc_head_len(major: int, n: int) -> bytes:
    """Nagłówek długości/liczby w najkrótszej formie (major != 0..23)."""
    if n < 24:
        return bytes([(major << 5) | n])
    if n < 1 << 8:
        return bytes([(major << 5) | 24, n])
    if n < 1 << 16:
        return bytes([(major << 5) | 25]) + n.to_bytes(2, "big")
    if n < 1 << 32:
        return bytes([(major << 5) | 26]) + n.to_bytes(4, "big")
    return bytes([(major << 5) | 27]) + n.to_bytes(8, "big")


def body_pairs() -> list[tuple[int, bytes]]:
    """Pary (klucz, wartość-encoder) w porządku kanonicznym 1..8."""
    return [
        (1, enc_uint(1)),                     # version
        (2, enc_bstr(SID)),                   # sid
        (3, enc_uint(EPOCH)),                 # epoch
        (4, enc_uint(ROUND)),                 # round
        (5, enc_uint(SEQ)),                   # seq
        (6, enc_uint(MSG_TYPE)),              # msg_type
        (7, enc_bstr(SENDER)),                # sender
        (8, enc_bstr(PAYLOAD)),               # payload
    ]


def body_cbor(
    *,
    version_nonshort: bool = False,
    epoch_nonshort: bool = False,
    indefinite: bool = False,
    keys_unsorted: bool = False,
    dup_key5: bool = False,
    extra_key9: bool = False,
    trailing: bool = False,
    tag_on_sid: bool = False,
    text_sender: bool = False,
    drop_key8: bool = False,
) -> bytes:
    pairs = body_pairs()
    if version_nonshort:
        pairs[0] = (1, bytes([0x18, 0x01]))
    if epoch_nonshort:
        pairs[2] = (3, bytes([0x18, EPOCH]))
    if tag_on_sid:
        # Tag(0) przed bstr sid: major 6 jest w protokole zakazany.
        pairs[1] = (2, bytes([0xC0]) + pairs[1][1])
    if text_sender:
        # text string (major 3) zamiast bstr, ta sama długość.
        pairs[6] = (7, enc_head_len(3, len(SENDER)) + SENDER)
    if keys_unsorted:
        pairs[2], pairs[3] = pairs[3], pairs[2]
    if drop_key8:
        pairs = pairs[:-1]
    out = bytearray(enc_head_len(5, len(pairs)))
    if indefinite:
        out = bytearray(b"\xbf")
    for key, val in pairs:
        out += enc_uint(key)
        out += val
        if key == 5 and dup_key5:
            out += enc_uint(5)
            out += enc_uint(SEQ)
    if indefinite:
        out += b"\xff"
    if extra_key9:
        out += enc_uint(9)
        out += enc_uint(0)
    if trailing:
        out += b"\x00"
    return bytes(out)


def auth_bytes(body: bytes) -> bytes:
    """canonical(envelope \\ {3}) = mapa {1: body, 2: recipient}."""
    return enc_head_len(5, 2) + enc_uint(1) + body + enc_uint(2) + enc_bstr(RECIPIENT)


def envelope_cbor(body: bytes, mac: bytes) -> bytes:
    return (
        enc_head_len(5, 3)
        + enc_uint(1)
        + body
        + enc_uint(2)
        + enc_bstr(RECIPIENT)
        + enc_uint(3)
        + enc_bstr(mac)
    )


def shake256(data: bytes, n: int = 32) -> bytes:
    return hashlib.shake_256(data).digest(n)


def k_mac(psk: bytes, sid: bytes, epoch: int, sender: bytes, recipient: bytes) -> bytes:
    return hmac.new(psk, KEY_DOMAIN + sid + epoch.to_bytes(8, "big") + sender + recipient,
                    hashlib.sha256).digest()


def mac_of(psk: bytes, body: bytes) -> bytes:
    return hmac.new(k_mac(psk, SID, EPOCH, SENDER, RECIPIENT),
                    MAC_DOMAIN + auth_bytes(body), hashlib.sha256).digest()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("out", help="ścieżka wektora wyjściowego")
    args = ap.parse_args()

    body = body_cbor()
    msg_id = shake256(MSGID_DOMAIN + body)
    mac = mac_of(PSK, body)
    env = envelope_cbor(body, mac)

    if len(PAYLOAD) > MAX_PAYLOAD_BYTES:
        raise ValueError("payload ponad limit")

    bads = {
        "bad_version_nonshort": body_cbor(version_nonshort=True),
        "bad_epoch_nonshort": body_cbor(epoch_nonshort=True),
        "bad_indefinite_map": body_cbor(indefinite=True),
        "bad_keys_unsorted": body_cbor(keys_unsorted=True),
        "bad_dup_key5": body_cbor(dup_key5=True),
        "bad_extra_key9": body_cbor(extra_key9=True),
        "bad_trailing_byte": body_cbor(trailing=True),
        "bad_tag_on_sid": body_cbor(tag_on_sid=True),
        "bad_text_sender": body_cbor(text_sender=True),
        "bad_missing_key8": body_cbor(drop_key8=True),
    }

    lines = [
        "# WP-027 — wektor wire v1 (kanoniczny CBOR, SPEC §9.3).",
        "# Wejścia syntetyczne i publiczne; referencja: ci/wire/cbor_reference.py.",
        "format = FT-WIRE-01",
        "version = 1",
        f"psk = {PSK.hex()}",
        f"sid = {SID.hex()}",
        f"sender = {SENDER.hex()}",
        f"recipient = {RECIPIENT.hex()}",
        f"epoch = {EPOCH}",
        f"round = {ROUND}",
        f"seq = {SEQ}",
        f"msg_type = {MSG_TYPE}",
        f"payload = {PAYLOAD.hex()}",
        f"body_cbor = {body.hex()}",
        f"msg_id = {msg_id.hex()}",
        f"mac_input = {auth_bytes(body).hex()}",
        f"mac = {mac.hex()}",
        f"envelope_cbor = {env.hex()}",
    ]
    for name in sorted(bads):
        lines.append(f"{name} = {bads[name].hex()}")

    with open(args.out, "w", encoding="utf-8") as f:
        f.write("\n".join(lines) + "\n")
    print(f"OK: {args.out} ({len(lines)} linii)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
