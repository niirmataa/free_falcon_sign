# MPS T8 — pairwise PRSS/CDI + keygen bez clear f,F

**Status: PASS_SCOPED** (kod+testy w W; niezależny weryfikator w toku).
**Wejście:** 365/365 (T7). **Wyjście:** 384/384, 0 warnings.
NIE jest to malicious-secure / UC / EUF-CMA ani „próg FT gotowy".

---

## Co T8 domyka (najbliższy brak meldunku T7)

1. **Pairwise PRSS/CDI** — osobne rng każdej wirtualnej partii (nie jeden
   in-process rng). Strumienie zer i maski bitowe z wkładów per partia.
2. **Keygen f,F bez clear** — `dkg_trapdoor_from_contributions`: udziały
   f,F powstają z wkładów per partia + Pedersen VSS; brak momentu, w którym
   jeden proces widzi pełny f i F w clear w nowym torze setupu.

---

## T8.1 — pairwise PRSS (osobne rng)

| API | Plik | Rola |
|---|---|---|
| `pairwise_zero_streams(rngs)` | `prss.rs` | ZeroShareStream per strona; nonce z własnego rng; `pair_seed` obustronnie; Σ `next_zero()` = 0 |
| `pairwise_prss_bit_masks(rngs, coins, w, ...)` | `prss.rs` | `w` par masek bitowych; wkłady z `rngs[i]`, `coins` = monety reshare-mul (NIE maski) |
| `paired_bit_mask_prss_pairwise(rngs, coins, ...)` | `ishare.rs` | T7.1 na osobnych rng; `b = ⊕ β_i` nigdy w clear |

**Testy:** `t8_pairwise_prss_zero_shares_sum_zero`,
`t8_pairwise_prss_zero_shares_independent_streams`,
`t8_pairwise_prss_bit_masks_separate_rngs` (prss.rs + ishare.rs),
`t8_pairwise_prss_independent_party_coins` — różne monety stron → różne bity.

**Różnica vs T7:** T7 (`paired_bit_mask_prss`) brał **jeden** `rng` na wszystkie
partie (in-process symulacja). T8: **osobny rng per partia** — wkłady
nieskorelowane, jak w realnym CDI. `coins` (reshare-mul) jest jawnie oddzielony
od materiału masek.

## T8.2 — DGDG / maski z pairwise PRSS

| API | Plik |
|---|---|
| `prss_dgdg_shares_pairwise(rngs, ...)` | `ishare.rs` |
| `prss_dgdg_poly_shares_pairwise(rngs, ...)` | `ishare.rs` |
| `prss_dgdg_shares_with_mac_pairwise(rngs, ...)` | `ishare.rs` |
| `mps4h_sign_shares_pairwise(rngs, coins, ...)` | `ishare.rs` — pełny tor złota na pairwise |

**Testy:** `t8_pairwise_dgdg_range_and_secrecy`,
`t8_pairwise_dgdg_matches_clear_formula`, `t8_pairwise_dgdg_mac_consistent`,
`t8_gold_pairwise_prss_engine_verify`, `t8_gold_pairwise_dgdg_engine_verify`.

**Złoto (zachowane bit-exact):** `z1 = round((t·f+g)/q)`, `z0 = round((−t·F+g')/q)`;
`s1 = z0·g + z1·G − t`, `s2 = z0·f + z1·F`; `s2·h − s1 = t`;
`encode_sig_static(s2)` → `Ft1536Signature::verify == true`.
**Pin F2:** `n = 103747771` (z≡clear) — asserowany w torach pairwise.

## T8.3 — keygen f,F bez clear (DKG z contributions)

**Nowe API:** `dkg_trapdoor_from_contributions(rngs, contribs, xs, k, delta_known, vss_count)`
w `ishare.rs` + `PartyTrapdoorContribution` (f, g, f_big, g_big per partia).

- Każda strona wnosi wkład i16 → Shamir shares + **Pedersen VSS** per wkład.
- Suma udziałów = udziały f,F (liniowość); zobowiązania addytywnie homomorphiczne.
- Fałszerstwo wkładu → `CommitmentMismatch` (VSS).
- **NIGDY** `g2_deal_trapdoor` z pełnym f,F w jednym clear w tym torze.

**Testy:** `t8_keygen_no_clear_dkg_shares_never_full` (udziały ≠ sekret,
brak reconstruct w torze), `t8_keygen_no_clear_dkg_engine_verify`,
`t8_keygen_no_clear_dkg_g2_engine_verify`.

**Retained H1 (zastrzeżenie — jawnie):**
- Wygenerowanie ważnego wkładu NTRU (`fG − gF = q` na SUMIE) wymaga
  procedury offline — poza zakresem spiku.
- `max|F| < q/2` **nie jest** weryfikowany bez clear F (range proof w MPC —
  retained; w testach bound na rekonstrukcji, wyłącznie testowo).
- `g2_deal_trapdoor` **zostaje retained** jako model dealera testowego /
  H1-moment (T7.3). Ścieżka złota T8 używa DKG; stary tor jawnie oznaczony.
- `delta_known` = retained model G-2 (MAC = δ·x liniowością).

## T8.4 — matrix fałszerstw (fail-closed)

| Atak | Detekcja | Test |
|---|---|---|
| Tamper maski PRSS pairwise | MacFail | `t8_tamper_prss_pairwise_mask_macfail` |
| Tamper szumu PRSS pairwise | MacFail | `t8_tamper_prss_pairwise_noise_macfail` |
| Fałszywy wkład DKG (VSS) | CommitmentMismatch | `t8_tamper_dkg_contribution_vss_detected` |
| Fałszywy joint share DKG | CommitmentMismatch | `t8_tamper_dkg_joint_share_detected` |
| Fałszywy udział w sign (DKG) | MacFail | `t8_tamper_dkg_share_sign_macfail` |
| Suma zero-shares ≠ 0 | assert / fail | `t8_tamper_prss_zero_share_sum_detected` |

---

## Czego T8 NIE implikuje (scope prawdy)

- **NIE** malicious-secure / UC / symulowalność / dowód redukcji.
- **NIE** „brak dealera klucza" w pełnym sensie — H1 (ważny NTRU, bound F)
  ma retained moment/offline; DKG domyka clear f,F w torze, nie całą ceremonię.
- **NIE** pełne CDI security proof (Cramer–Damgård–Ishai) — to prototyp
  pairwise z osobnymi rng, nie dowód bezpieczeństwa.
- **NIE** trójki Beaver / pełne SPDZ / odporność na korelowane fałszerstwa ≥k.
- **NIE** „próg FT gotowy" — nadal brak pełnego keygen NTRU, range proof F,
  i auth triples (R-G2-2).

## Retained (NIE kasować)

F2-1, G-1..G-3, H-1..H-4, T6, T7 — historia nietknięta.
`g2_deal_trapdoor`, `deal_dgdg_*`, `paired_bit_mask` (clear-dealer) = retained
modele testowe / porównania dystrybucji.

## Pliki

- `prss.rs` — `pairwise_prss_bit_masks`, `pairwise_zero_streams`, testy.
- `ishare.rs` — `*_pairwise`, `dkg_trapdoor_from_contributions`, testy T8.
- `Y13_MALICIOUS_MAP.md` — update mapy luk.
- Regresja: 384/384, 0 warnings; złoto `t7_gold_*`/`t6_`/`mps4h` zielone.
