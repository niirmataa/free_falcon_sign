# Spike 010 — DKG seeda (dealer nie zna sekretu)

**Status: PROTOTYP.** Ostatnia główna własność F-13.

## Protokół (k=2, n=3)

```
strona i: s_i ← losowe 32 B (wkład)
          f_i(·) — Shamir k=2 na każdym bajcie, f_i(0)=s_i[b]
          deal{i}_{x}.bin = f_i(x) (32 B) dla x∈{1,2,3}
strona j: col_j = ⊕_i f_i(xs[j])     // seed = ⊕_i s_i nigdy nie istnieje
          G_frag na col_j (64 muls Beaver, mailbox)
```

- **Żaden proces dealera** — nie ma `seed.bin`.
- Trójki Beavera = **preprocessing** (`triple-dealer`) — nie sekret.
- Oracle w teście: jawne `contrib{p}.bin` (s_i) **tylko na koniec**;
  `g_frag_local(⊕ s_i)` == otwarty bajt z udziałów out.

## Wynik: 47/47 PASS

```
cargo test --manifest-path spike/Cargo.toml
→ 34 unit + 3 isolation + 10 integration

cargo run --bin iso -- dkg /tmp/iso-dkg
→ DKG_PARTY_DONE p=0..2 / DKG_OK opened0=..
```

| # | Test | Twierdzenie |
|---|---|---|
| s10 | `iso dkg` | DKG seeda + G_frag == oracle `g_frag_local` |

## Retained (F-14)

- **Wyścigi mailboxa:** `fs::write` nie jest atomowy → pusty plik przy
  `exists()`. Naprawa: `tmp`+`rename`, unikalne `pub{p}.tmp`, walidacja długości.
- Równoległe testy izolacji = flake → mutex w `tests/isolation.rs`.

## Granice

- Dealer = model testowy dla **trójek** (preprocessing), nie dla sekretu.
- `contrib{p}.bin` (s_i) jawne w oracle testowym — to „moment".
- Semi-honest; brak SPDZ-MAC / Pedersen VSS / złośliwych.
- Nie threshold FT / MPC-90 / produkt.
