# wire v1 — zamrożony format komunikatów (WP-027)

## Co tu jest

| Ścieżka | Rola | Status |
|---|---|---|
| `schema/envelope.cddl` | `body` + `envelope` + reguły `msg_id`/`mac` | **FROZEN v1** |
| `schema/payloads_v0.cddl` | pola payloadów 24 typów (SPEC §9.4) | v0-normatywne; kodery/wektory z ruchami w G2; `SIGN_OPEN` DRAFT → WP-041 |
| `vectors/envelope_v1.txt` | wektor end-to-end: wejścia → `body_cbor`, `msg_id`, `mac_input`, `mac`, `envelope_cbor` + **10 wariantów non-canonical** | pin |
| `../ci/wire/cbor_reference.py` | niezależna referencja (Python, własna implementacja CBOR) | narzędzie |
| `../ci/wire/run_wire_vectors.sh` | regeneracja + `cmp` bajtów | CI |

## Implementacja Rust

- `crates/ft-threshold-protocol/src/cbor.rs` — ścisły podzbiór kanonicznego
  CBOR (uint/bstr/mapa; odrzuca nint/text/array/tag/float, formy
  nieskrócone, długości nieokreślone i zarezerwowane, śmieci po
  elemencie). Bez zależności zewnętrznych.
- `crates/ft-threshold-protocol/src/envelope.rs` — `Body::to_cbor`,
  `Body::try_from(&[u8])`, `Envelope::to_bytes`, `Envelope::try_from(&[u8])`;
  MAC nad `canonical(envelope \ {3})`, `msg_id` nad `canonical(body)`
  (SPEC §9.3).
- Testy: `tests/wire_vectors.rs` (4) + jednostki w `cbor.rs` (4, w tym
  wektory RFC 8949 Apendyks A dla uint i odrzucenia form nieskróconych).

## Regeneracja wektora

```sh
cd proofs/ft1536/development/THRESHOLD_P2_001/impl
./ci/wire/run_wire_vectors.sh            # weryfikacja (cmp)
./ci/wire/run_wire_vectors.sh --update   # tylko ze świadomą zmianą formatu
```

## Zasady zamrożenia

1. Zmiana któregokolwiek bajtu formatu = `WIRE_VERSION = 2` i **nowe**
   domeny MAC/msg_id; nie ma „małych poprawek” w v1.
2. Dekoder odrzuca non-canonical (nie normalizuje) — zgodnie z SPEC §9.2.
3. Piny `pk` (2881 B) i `sig` (≤ 10370 B) w `KAT/` (WP-024) są spójne z
   `schema/payloads_v0.cddl` (`setup_final_payload`, `sign_final_payload`).
4. Nieznany `msg_type` = `Err` (SPEC §9.5); limity w `envelope.rs`
   (`MAX_PAYLOAD_BYTES` = 1 MiB, ostrzejsze niż 16 MiB z §9.2).

## Granice

- Format jest zamrożony, ale **nie** jest to odbiór ani dowód
  bezpieczeństwa; nadal wymagany niezależny recenzent G1 (autor ≠
  recenzent).
- Payloady typów 0x01–0x24 nie mają jeszcze kodera Rust — ich wektory
  powstaną z implementacją ruchów (G2), na tej samej maszynie CBOR.
- TLS 1.3/mTLS i exporter kluczy (O-09/WP-045) pozostają poza tym
  zamrożeniem; `derive_psk` jest wyłącznie ścieżką TEST-ORACLE.
