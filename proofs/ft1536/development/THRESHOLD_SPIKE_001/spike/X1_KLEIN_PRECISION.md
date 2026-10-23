# X1 — Klein-lite 73-bit precision stand-in (Q16)

**Status: STAND-IN / pomiar.** To **NIE jest Klein 73-bit** i nie twierdzi
osiągnięcia precyzji 73-bitowej. Deklaracja zakresu poniżej.

## Czym to jest

| Element | Decyzja |
|---|---|
| Skala wag | **2^16** (`GAUSS_Q_ONE = 65536`) — W(x) ∈ [0, 2^16] |
| `gauss_weight_q(x, sigma_q)` | W(x) = 2^16 · exp(-x²/(2σ²)); `sigma_q = σ · 2^16` |
| `exp_neg_q16(z_q16)` | szereg Taylora, pośrednia **Q64** (i128), ≤60 składników |
| Floaty w wadze | **brak** (`exp` nieużywane) |
| Propozycja | U{-w..=w}, accept iff u < W(x), u ~ U{0..2^16-1} |

## Dlaczego 2^16, a nie 2^73 (i co z „73-bit")

- Falcon/Klein używa **~73-bitowej** precyzji `exp` w samplerze — to
  **motywacja** (mało biasu, kontrolowany rounding), nie parametr tego API.
- Typ zwracany `u64` nie pomieści wagi w skali 2^73; 2^16 wystarcza do
  stand-inu i jest spójne z torami 8-bitowymi (accept_bit / GF(256)).
- **Zakres twierdzenia:** przybliżenie exp(-x²/2σ²) w Q16, empiria TV
  vs dyskretny target z tej samej wagi. **Poza zakresem:** wierność Klein
  73-bit, zgodność F04/F05 z 2026/1300, brak rounding-bias na poziomie
  bitów LSB Kleina, bezpieczeństwo MPC samplera.

## Założenia jawne (A1–A6)

- **A1** σ podane w Q16 (`sigma_q = σ·2^16`); σ=0 → odmowa (fail-closed).
- **A2** Target TV liczony vs `target_gaussian_q_absx_pmf_q` — **ta sama**
  waga Q16 (mierzymy bias vs własny stand-in, nie vs analityczną Gausę).
- **A3** Tor `sample_gaussian_q_clear` jest **jawny** (oracle/pomiar).
  Brak sekretów w API; `Share`/`MacShare`/`BeaverTriple` bez `Clone`.
- **A4** Cap prób 10_000 = awaryjne zamknięcie retained (nie cichy sukces).
- **A5** Underflow (z ≳ 12 → W=0) i przepełnienia pośrednich → W=0
  (odmowa akceptacji). Suma targetu przy zerowej masie → wektor zer,
  nie rozkład jednostajny.
- **A6** Statystyka (TV, hist) na f64 — jak w `measure_gauss_vs_target`;
  ścieżka wagi pozostaje całkowita.

## Koszt vs accept_bit (255 Beaver, I1)

| tor | Beaver triples | uwagi |
|---|---|---|
| `gauss_weight_q` / `exp_neg_q16` | **0** | lokalna arytmetyka całkowita (i128) |
| `sample_gaussian_q_clear` | **0** | oracle; brak muls na udziałach |
| accept_bit (I1, Horner P_w) | **255 / bit** | baza; `cmp::mul_vec` × 255 |
| probed select okna t_max (I2) | t_max × 259 | w tym t_max × 255 na accept bity |

**Wniosek kosztowy:** stand-in Q16 **nie zmienia** ceny accept_bit
(255 Beaver/bit). Koszt wag jest lokalny i pomijalny względem toru
predykatu; ewentualny tor share-native Kleina dalej płaci porównanie /
polynomial-eval na udziałach (I1/I2), nie mnożenie wag.

## Retained findings (X1)

1. **Szereg na u128 + `saturating_sub`:** przy z_real > 1 pierwszy składnik
   naprzemienny przekracza sumę → clamp do 0 → wagi zepsute.
   → naprawa: suma **i128** (możliwe ujemne sumy częściowe).
2. **Q32 / ≤32 składników:** przy z_real ≳ 6 kancylacja + ucięty ogon
   szeregu dawały niemonotoniczne W (np. W(14) > W(13) przy σ=3).
   → naprawa: pośrednia **Q64** + **≤60** składników (porównanie z
   `exp` referencyjnym: |błąd| ≤ 1 ULP Q16 na siatce testowej σ=3).

## Testy (green, `tests_x1`)

- `x1_exp_neg_q16_basic` — W(0)=2^16, exp(-0.5)≈39744, monotoniczność, underflow=0
- `x1_gauss_weight_q_x0_is_q_one` — W(0)=2^16
- `x1_gauss_weight_q_monotone_in_absx` — monotoniczność + symetria + punkt odniesienia
- `x1_fail_closed_edges` — σ=0 → 0 / `Err`; w=0 → `Err`; underflow → 0; target-masa 0 → zera
- `x1_sample_gaussian_q_vs_target_tv` — TV < 0.12 (n=3000, σ=2, w=8)
- `x1_sample_gaussian_q_deterministic` — determinizm + FNV pin `3753615015437430794`
- `x1_target_pmf_q_sums_to_q_one` — suma PMF Q16 = 2^16

## Następnie (poza X1)

- share-native accept-bit dla wag Q16 (bez dealera) — droga I1/I2
- rozliczenie biasu vs **analityczna** dyskretna Gaussa (nie vs W_q)
- budżet precyzji TT-43 / zgodność F04/F05 (2026/1300)

---

## Y4 — kontynuacja: precyzja Q73 (2026-10-21)

Wypełnia lukę „73-bit" z `SECURITY_POSITION` pkt 3 **częściowo** (wagi
i bias, nie pełny Klein MPC):

| Element | Y4 |
|---|---|
| Skala | **2^73** (`GAUSS_Q73_ONE: u128`) |
| `exp_neg_q73(z_q32)` | szereg, z w Q32, underflow z≳50 → 0 |
| `gauss_weight_q73` | W(x)=2^73·exp(-x²/2σ²); σ w Q32 (bez σ² overflow) |
| `sample_gaussian_q73_clear` | accept iff u < W, u ~ U{0..2^73-1} |
| Bias | TV vs **analityczna** dyskretna Gaussa (`target_gaussian_analytical_absx_pmf`) |
| Dowody | siatka vs f64 exp (err < 1e-6); TV < 0.12 (n=4000); determinizm; fail-closed |

**Retained Y4:** (1) `σ²` w u128 przepełniał się dla σ=3·2^73 → waga 0;
σ redukowane do Q32. (2) z_real liczone z błędem ×½ (2^94 zamiast 2^95)
→ W(1)≈exp(-0.0625) zamiast exp(-0.125); naprawione + test siatki.

**Granica:** to **nie** jest pełny Klein (bit-by-bit Bernoulli, 73-bit
rounding, tor na udziałach). Q73 + bias vs analityka = wymagana precyzja
i rozliczenie P0.1 w warstwie jawnej. Klein MPC = dalszy tor.
