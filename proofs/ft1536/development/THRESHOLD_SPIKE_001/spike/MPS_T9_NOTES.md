# MPS T9 — NTRU keygen ważony + range proof F + MAC na s1,s2

Notka robocza T9. Sekcje **T9.1** (weighted keygen) i **T9.2**
(range proof `max|F| < q/2` w MPC) zamknięte. **MAC na s1,s2** (T9.3)
— **w toku** (inny agent / osobny zakres; nie ruszane tutaj).

## T9.1 — weighted keygen NTRU offline

### Formuła ważona (dokładna)

Niech partia `i` wnosi wkład `(f^{(i)}, g^{(i)}, F^{(i)}, G^{(i)})`
oraz jawne `w_i ∈ ℕ`. Tajny klucz (NIGDY w clear w torze setupu):

```text
f = Σ_i w_i · f^{(i)}          F = Σ_i w_i · F^{(i)}
g = Σ_i w_i · g^{(i)}          G = Σ_i w_i · G^{(i)}
```

Udział strony `p` (per współczynnik `j`) — **Shamir liniowy**:

```text
f[j][p] = Σ_i w_i · share_{f^{(i)}}(j, x_p)
```

Zobowiązania Pedersena — **addytywnie homomorphiczne z wagami**:

```text
C_f[j] = Σ_i w_i · C_{f^{(i)}}[j]
w · C  = (w·a)·G + (w·r)·H          dla C = a·G + r·H
```

Skalowanie udziałów VSS: `(s, t) → (w·s mod P, w·t)` (niezredukowana
ewaluacja `w·eval` w `u128`). Spójność weryfikacji:

```text
w·(s·G + t·H) = (w·s)·G + (w·t)·H
w·Π C_j^{x^j} = Π (w·C_j)^{x^j}
```

Fałszerstwo ważonego wkładu (tamper udziału bez update zobowiązania)
→ `CommitmentMismatch` (fail-closed). Overflow `w · vss_val` w `u128`
→ `CommitmentMismatch` (brak cichego wrap-around).

### API (ishare.rs)

- `PartyTrapdoorContribution` — wkład jednej partii (bez zmian).
- `dkg_trapdoor_from_weighted_contributions(rngs, contribs, weights, xs, k, delta, vss_count)`
  — **T9.1**; `weights.len() == contribs.len()`; `w_i = 0` zeruje wkład.
- `dkg_trapdoor_from_contributions(...)` — wrapper z `w_i = 1`
  (zachowuje pin T8.3; regresja bit-exact).
- `ipoly_vss_scale_weight(shares, vss, w)` — skalowanie wkładu VSS przez `w`.
- `pedersen::zp_pedersen_scale(c, w)` — `w·C` w grupie Ristretto.

Ścieżka **nie** woła `g2_deal_trapdoor`. Wyjście to wyłącznie `G2Trapdoor`
(udziały + zobowiązania + MAC) — **pełny f,F nie powstaje w clear**.

### Retained H1 (jawne) — ważny NTRU offline

Ważny klucz NTRU wymaga `f·G − g·F = q` **na ważonej sumie wkładów**.
Ta równość NIE jest wymuszana w torze setupu spiku — wymaga procedury
offline / ceremonii (uzgodnienie sumy, ewentualna korekta, range proof
`max|F| < q/2` w MPC). **Nie udajemy pełnej ceremonii online.**

Retained (z T8.3, bez zmian):

- bound `max|F| < q/2` bez clear F — range proof w MPC (poza T9.1);
  w testach bound na rekonstrukcji, wyłącznie testowo.
- `delta_known` = retained model G-2 (MAC = δ·x liniowością).
- `g2_deal_trapdoor` = **retained / test-only (H1 moment)** — historia
  dealera w clear; nie kasować.

### Testy T9.1

- `t9_keygen_weighted_no_clear_dkg_shares_never_full` — formuła na jawnych
  wartościach: wagi `[2,1]` vs `[1,1]`, udziały ≠ sekret, brak reconstruct
  w torze setup (API = udziały).
- `t9_keygen_weighted_engine_verify` — ważony DKG `[2,1]` (c1 = full − 2·c0)
  → `mps4h_sign_shares_pairwise` → pin F2 `n = 103747771` + engine verify true.
- `t9_tamper_weighted_contribution_vss_detected` — tamper ważonego udziału
  → `CommitmentMismatch`.

## T9.2 — range proof `max|F| < q/2` w MPC (zamknięty)

### Co domknięto

Retained H1 T8: „max|F| < q/2 **nie jest** weryfikowany bez clear F".
Domknięcie: **range proof na udziałach** (`validate_f_bound_shares`) —
per współczynnik F, **bez reconstruct F** w torze. To jest realne
fail-closed przy F ≥ q/2 w ścieżce produkcyjnej (DKG / sign), nie
jawna rekonstrukcja.

### Jak działa bound (wzór H3 bit-decomp)

Per współczynnik `v` (udziały Shamir Z_P, i16):

1. `X = v + 2^{B-1}` na udziałach (`B = FBOUND_BITS = 17`);
2. bit-dekompozycja `X` maską `r` (PRSS pary bitów GF/Z_P);
   open **wyłącznie** `d = X − r` (maska — nie v);
3. `|v|` z bitów: `sign = ¬MSB`, `abs = (X_low ⊕ sign) + sign`;
4. `accept = 1{|v| < q/2}` na bitach (`gf_add_public` stałej
   `2^k − bound`, accept = ¬bit k sumy);
5. open **wyłącznie bitu accept** — v nigdy nie jest rekonstruowane.

Fail-closed: `accept = 0` → `SpikeError::FBoundViolation` (nowy wariant;
jawna walidacja `validate_f_bound` zachowuje `InconsistentShare` —
bez zmian API). `accept ∉ {0,1}` → `NonBitShare`.

### Podpięcie w torze

- `dkg_trapdoor_from_weighted_contributions` (i wrapper T8.3) —
  range proof na sumie udziałów `fb_acc` **przed** złożeniem
  `G2Trapdoor`. Zamyka lukę T8.3/T9.1.
- `mps4h_sign_shares_src` (tor złota Single/Pairwise) i
  `mps4h_sign_shares_g2` — druga linia obrony w torze sign.

`g2_deal_trapdoor` zostaje przy `validate_f_bound` na clear
(retained H1 moment dealera).

### API (ishare.rs)

- `FBOUND_BITS = 17` — bit-width dekompozycji (OFF = 2^16; abs
  i16::MIN = 32768 bez overflow).
- `fbound_scalar_shares(...)` — bound jednego współczynnika.
- `validate_f_bound_shares(rng, f_big, xs, k)` — max|F| < q/2 na
  całym `IPolyShares`.
- `SpikeError::FBoundViolation` (lib.rs).

### Retained / zastrzeżenia

- Poprawność bit-decomp zakłada |v| < 2^{B-1} (i16) — jak
  `round_div_q_*`. Sekret spoza zakresu i16 nie jest w pełni
  ujęty obwodem (ta sama klasa retained co H3).
- Semi-honest bit-circuit + abort. **Nie** deklarować malicious-secure
  / UC / EUF-CMA. Pełny MAC na accept-bit (SPDZ) — poza zakresem.
- Koszt: ~B PRSS-masek + kilkadziesiąt AND-ów na współczynnik F
  (N=1536) — rząd wielkości poniżej jednego `round_div_q` na poly.

### Testy T9.2

- `t9_fbound_ok_real_f` — realne F (max|F| ≈ 59 przy seed 0x42)
  przechodzi range proof na udziałach.
- `t9_fbound_violation_aborts` — F = ±q/2 → `FBoundViolation` (Err,
  nie panika); rant |F| = q/2−1 przechodzi.
- `t9_fbound_dkg_weighted_ok` — ważony DKG (T9.1) z realnym kluczem
  przechodzi tor z range proofem; wkład z F ≥ q/2 w sumie →
  `FBoundViolation` w DKG (bez clear F).

## T9.3 — auth triples / MAC na s1,s2 po ring-mulach (R-G2-2, zamknięty)

### Co domknięto

Luka Y13: „MAC na s1,s2 po ring-mulach — wymaga auth triples przez
4N² reshare-muls". Domknięcie: **MAC (ukryte δ) na wynikach ring-mul**
`z0·f + z1·F` i `z0·g + z1·G − t`, nie tylko na wejściach. Tamper
ring-mul → `MacFail`. Open s1,s2 z kontrolą MAC (`zp_open_poly_with_mac_hidden_delta`).

**NIE** jest to malicious-secure / UC / EUF-CMA. Model G-2: MAC = δ·x
liniowością (`delta_known` retained) + open z kontrolą δ.

### API (ishare.rs)

| API | Rola |
|---|---|
| `ZpAuthTriple` / `generate_auth_triple_zp` | trójka Beavera w Z_P z MAC = δ·val (wzorzec U4) |
| `mul_auth_zp_with_triple` | Beaver mul: open ε=x−a, ρ=y−b z kontrolą MAC; z = c + εb + ρa + ερ |
| `i_poly_mul_ring_shares_auth` | ring-mul przez N² auth triples + MAC na wyniku |
| `i_poly_mul_ring_shares_mac` | ring-mul + MAC liniowością (tańszy wariant złota) |
| `zp_mac_linearity` / `zp_mac_poly_linearity` | MAC = δ·share liniowością |
| `zp_open_with_mac_known_delta` | open z kontrolą MAC (δ jawne, model G-2) |
| `zp_open_poly_with_mac_hidden_delta` | open poly z ukrytym δ (jak Y6/U4) |

### Podpięcie w torze G-2

`mps4h_sign_shares_g2`: ring-mule przez `i_poly_mul_ring_shares_mac`
(MAC na produktach), s1,s2 z MAC, **open s1,s2 z kontrolą ukrytego δ**.
Tamper f/f_mac po DKG → `MacFail`.

Retained: `i_poly_mul_ring_shares_auth` = pełny tor N²-trójkowy
(koszt R-G2-2). Złoto używa wariantu `*_mac` (MAC liniowością na
wynikach + open z kontrolą δ) — autentyczność wyników i detekcja
tamperu; pełne Beaver-triples na 4N² muls = `*_auth` (osobny koszt).

### Testy T9.3

- `t9_mac_s_auth_triple_mul_ok_and_tamper` — auth triple mul 3·5=15;
  tamper produktu / MAC / wejścia → MacFail.
- `t9_mac_s_ok_engine_verify` — tor G-2 z MAC na s1,s2 → pin F2
  `n = 103747771` + engine verify true.
- `t9_mac_s_tamper_ring_mul_macfail` — tamper f share → MacFail.
- `t9_mac_s_tamper_mac_macfail` — tamper f_mac → MacFail.

### T9.4 — matrix fałszerstw + mapy (zamknięte)

| Atak | Detekcja | Test |
|---|---|---|
| Fałszywy ważony wkład keygen | CommitmentMismatch | `t9_tamper_weighted_contribution_vss_detected` |
| F ≥ q/2 (±q/2) | FBoundViolation | `t9_fbound_violation_aborts` |
| F ≥ q/2 w sumie DKG | FBoundViolation | `t9_fbound_dkg_weighted_ok` |
| Tamper ring-mul (f share) | MacFail | `t9_mac_s_tamper_ring_mul_macfail` |
| Tamper MAC na s1/s2 | MacFail | `t9_mac_s_tamper_mac_macfail` |
| Tamper produktu / wejścia auth mul | MacFail | `t9_mac_s_auth_triple_mul_ok_and_tamper` |

`Y13_MALICIOUS_MAP.md` zaktualizowany (sekcja T9).

## Czego T9 NIE implikuje (scope prawdy)

- **NIE** malicious-secure / UC / EUF-CMA / CDI proof.
- **NIE** „próg FT gotowy" ani pełna ceremonia keygen NTRU
  (fG−gF=q na ważonej sumie = retained H1 offline).
- **NIE** pełne Beaver-triples na 4N² w torze złota (wariant `*_auth`
  jest API; złoto używa `*_mac` + open z kontrolą δ).
- **NIE** „brak dealera klucza" w pełnym sensie (H1 retained).

## Retained (NIE kasować)

F2-1, G-1..G-3, H-1..H-4, T6, T7, T8, T9.1–T9.3. `g2_deal_trapdoor`
= retained / test-only (H1 moment). `delta_known` = retained model G-2.

## Regresja

Suite **394/394**, 0 warnings (369 lib + 14 isolation + 1 measure_fg
+ 10 spike). Pin F2 `n = 103747771`. `t8_gold_*`, `t7_gold_*`, `t6_`,
`mps4h`, `t9_*` zielone.
