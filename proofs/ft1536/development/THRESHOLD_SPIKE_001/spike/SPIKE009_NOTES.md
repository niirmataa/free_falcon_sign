# Spike 009 — G_frag między procesami (64 × Beaver)

**Status: PROTOTYP.** Domyka ścieżkę F-13: wyprowadzanie **bez** agregacji
kolumn w jednym procesie.

## Architektura

```
full-dealer (osobny proces, potem exit)
  → col{i}.bin (32 B) + trip{m}_{p}.bin (64 rund × 3 partie)
worker p=0|1|2 (osobne procesy)
  → tylko col{p}; 64 rundy:
       (d_p,e_p) → mailbox/r{m}_de{p}.bin
       d,e      → mailbox/r{m}_pub.bin   (z 3 de, rekonstrukcja masek)
       z_p = finish(d,e); lokalne XOR w out
  → out{p}.bin (64 B udziałów G_frag)
```

Kolumny **nie** opuszczają procesu party. Mailbox widzi tylko (d,e) — maski.

## Wynik: 46/46 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 34 unit + 2 isolation + 10 integration: ALL PASS

cargo run --bin iso -- full /tmp/iso-full
→ WORKER_DONE p=0..3 / FULL_OK opened0=..
```

| # | Test | Twierdzenie |
|---|---|---|
| s8 | `iso demo` | kolumny izolowane po dealerze |
| s9 | `iso full` | 64 muls G_frag **między** procesami; out0≠out1≠out2 |

## Co to wykazuje (wąsko)

- Łańcuch `H_fold`→`G_frag` biegnie w **osobnych procesach**; każdy worker
  ma tylko swoją kolumnę + jawne maski z mailboxa.
- Otwarcie bajtu (`open_g_frag_byte`) tylko na kontrakt (2 z 3 out).

## Czego nadal NIE

- **Dealer zna seed** (model testowy) — DKG osobno.
- Brak SPDZ-MAC / złośliwych; semi-honest.
- Brak audytu syscalli (strace/seccomp) — „nie czyta cudzych plików"
  jest kontraktem kodu, nie dowodem jądra.
- To nie threshold FT / MPC-90 / produkt.
