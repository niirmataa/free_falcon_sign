# U1 — Klein MPC (długa partia)

**Status: W TOKU.** Nie jest to gotowy Klein 73-bit z 2026/1300 ani
sampler FT1536. Rozbiór na partie A/B/C.

## U1-A — prymitywy Bernoulli [x] (234/234)

| Element | API |
|---|---|
| Losowy bit | `bernoulli_half` |
| exp(-z) oracle→share | `bernoulli_exp_clear_then_share` |
| Waga Q73 → próg cmp | `q73_weight_to_pub_threshold` (0..200) |
| Accept przez cmp | `bernoulli_q73_via_cmp` (255 Beaver/bit I1) |

Testy: bit ∈ {0,1}; z=0 → 1; z=50 → 0; freq@ln2 ≈ 50%; próg połowa ≈ 100.

## U1-B — krok Klein (model połówkowy) [x]

| Element | API |
|---|---|
| Stan | `klein_state_init` (wagi Q73 połówek) |
| Krok | `klein_step` — bit 0/1 w udziałach; zawężenie przedziału |
| Próbka | `klein_sample_bits` — n_bits kroków |

**Granica:** to **nie** jest pełny Klein 73-bit rounding ani warunkowe
Bernoulli z dokładnymi wagami podwarunków. Model połówkowy służy
pomiarowi kosztu i torowi bit-po-bicie.

## U1-C — warunkowe Bernoulli + accept [x] (240/240)

| Element | API |
|---|---|
| Suma wag | `q73_range_weight` |
| Cond. Bernoulli | `klein_cond_bernoulli` (p_q32, bez overflow) |
| Próbka cond. | `klein_sample_cond_bits` (do lo==hi) |
| Accept okno | `accept_window_q73_no_open_u` (cmp, bez open u) |
| TV | `measure_klein_cond_vs_analytical` |

Testy: symetria wag; bit; TV < 0.45 (model — nie Klein-exact);
accept window; fail-closed; `u1c_mut_overflow_cmp_detected`.

## Zostało (U1-D)

1. Piny FNV próbek cond. (jak S4)
2. Koszt Beaver/bit w liczniku `cost`
3. ULTRA-WERYFIKATOR U1

## Retained (U1)

### U1-RF-1 — saturating w porównaniu Bernoulli (bias)
- **Wynik:** `u * total < w_hi * 2^73` — obie strony saturating →
  **bias w lewo** (freq_right≈0.0005 zamiast 0.25); TV≈1 w cond-gałązce.
- **Przyczyna:** wagi Q73 × 2^73 przepełniają u128; saturating nie jest
  obejściem overflowu iloczynu.
- **Naprawa:** `prob_right_q32` (redukcja >>40 gdy w_hi ≥ 2^96) +
  `u_q32 = u>>41`. W `klein_step` **i** `klein_cond_bernoulli`.
- **Testy:** `u1d_klein_step_freq_matches_w`, `u1c_mut_overflow_cmp_detected`,
  `u1d_large_weight_cmp_prob`.
- **Wzorzec:** nie używać `saturating_mul` jako overflow-guardu; redukować
  skale przed mnożeniem / używać bezpiecznego `(w<<32)/t`.

### U1-RF-2 — kodowanie accept 10/250 vs zmienna próg cmp
- **Wynik:** przy thr≤10 accept (10) nie przechodził `u < thr`.
- **Przyczyna:** M3 wymaga **stałego** separatora `w_pub=200`.
- **Naprawa:** `accept_bit_...(..., 200)`; waga Q73 tylko etykietuje u.
- **Test:** `u1d_accept_thr_leq_10` (z=0→accept, z=50→reject).

### U1-RF-3 — `w_hi<<32` cichy wrap przy w_hi ≥ 2^96
- **Wynik:** Rust `<<` nie sygnalizuje utraty bitów; p_q32=0 → zawsze lewo.
- **Naprawa:** `prob_right_q32` z redukcją; test `u1d_large_weight_cmp_prob`.
