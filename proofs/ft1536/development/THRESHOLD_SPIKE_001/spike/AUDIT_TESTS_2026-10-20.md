# Audyt testów — T-THRESHOLD spike (ULTRA explore)

**Werdykt startowy: YELLOW** → po poprawkach: **107/107 PASS**.
Pełny raport: subagent `explore-5` (model ultra), retained w aktach.

## Co naprawione (priorytet 1–2 z audytu)

| # | Problem | Naprawa |
|---|---|---|
| B1 | `s7_vector_fingerprint_pin` bez pinu | twarde `assert_eq!(fp, 3040856859571456136)` |
| B2 | `tt41_select_*` bez asercji | `found == OR accept-bits` |
| B3 | tautologia `all_rejected <= trials` | `accepted + all_rejected == trials` |
| B4 | `macshare_zeroize_on_drop` > test | przemianowany `macshare_open_roundtrip_no_zeroize_claim` |
| B5 | `tt50` arytmetyka stałych | test struktury 64 B + komentarz |
| B6 | `v1` self-compare | usunięty ogon |
| B7 | `m3` overclaim | `m3_mul_output_len_and_check` + komentarz |
| E | `PairwiseSeed: Clone` (H-31) | **bez Clone**, `ZeroizeOnDrop` |
| C1–C4 | brak min-k, PartyCountMismatch, u==w | testy `tests_mink`, `tt41_boundary_u_eq_w` |

## Nadal otwarte z audytu (retained)

- Statistical tests na `OsRng` (flake teoretyczny) — F-18/F-20
- `u<w` w `share_accept_bit_from_u` — **jawne** (TT-41 częściowe; nie „shared MPC compare")
- PRSS n>3 / missing pair seed
- G_frag MAC tamper (happy path tylko)
- `Vec<u8>` copy udziałów (soft H-31)

## Pliki

- `src/*` po poprawkach
- FNV piny: `VECTOR_PINS.md` + `rejection.rs` (sample_clear 42 → 3040856859571456136)
