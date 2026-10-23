# Spike 012 — PRSS-lite (pary nasion, udziały zera, masked open)

**Status: PROTOTYP.** Budulec zamiast jednoseedowego PRSS (san-mpc).

## Co jest (`src/prss.rs`)

| Element | Opis |
|---|---|
| `pair_seed(nonce_i, nonce_j)` | wspólne K pary z nonce'ów (symetryczne) |
| `prf_bytes` | strumień z (K, counter) — FNV-lanes, **nie SHA** |
| `ZeroShareStream` | udział zera strony: +ρ/−ρ z par (GF: −ρ=ρ) |
| `check_zero_sum` | suma udziałów zera == 0 |
| `masked_open_demo` | sekret ⊕ maska-zero → otwarcie == sekret |

## Wynik: 52/52 PASS

| # | Test | Twierdzenie |
|---|---|---|
| p1 | `pair_seed` symetryczne | K(i,j)=K(j,i) |
| p2 | zero shares | ⊕ stron == 0 (16 counterów) |
| p3 | masked open | otwarcie == secret |
| p4 | PRF deterministyczny | ten sam counter → ten sam strumień |

## Granice (uczciwie)

- **Nie** jest pairwise CDI (brak dowodu/profilu CDI).
- **Nie** generuje trójek Beaver — do tego OT/HE albo BGW degree-reduction
  (spike 011: sacrifice-mul nadal ufa jednemu mnożeniu).
- `hash256` = 4×FNV — **nie kryptograficzne** (spike bez SHA).
- K pary znane obu stronom pary — nie jest to sekret między nimi.

## Po co to jest

Udziały zera (maski) = fundament pod:
1. masked open / verifiable open bez ujawniania udziału,
2. stopień redukcji w BGW mnożeniu (przyszły krok triple-gen),
3. PRSS zamiast centralnego dealera losowości.
