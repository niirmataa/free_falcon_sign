# MPS G-2 — VSS + MAC na otwieraniach w torze sign (detekcja fałszerstw)

**Status: zamknięte w zakresie półuczciwym + fail-closed.**
To **NIE** jest malicious-secure / UC / EUF-CMA→MT-ISIS.

## Co zostało zrobione

### 1. VSS udziałów f,F (i16, ishare) — Pedersen na DL-trudnej grupie

- **Mechanizm:** Pedersen VSS (`C_t = a_t·G + r_t·H`) w Ristretto,
  zobowiązania do Shamir-wielomianów każdego współczynnika i16-poly.
  Weryfikacja: `s·G + t·H == Π C_j^{x^j}` — **bez interpolacji kontrolnej**.
- **Spójność pierścieni:** udziały VSS trzymają **niezredukowaną**
  ewaluację Shamir (Σ a_j·x^j bez mod P) — to pasuje do arytmetyki
  wykładników w Ristretto (mod L ≈ 2^252). Udział ishare = ewaluacja
  mod P (2^61−1). Ewaluacja liczona w **u128** (fix G-2-CHANGES: stary
  u64 z wrapping przepełniał się dla x≥8 przy k=2 / x≥3 przy k=3).
  xs ≤ 255 jest teraz prawdziwe (u128 pomieści do k≈10).
- **Fail-closed:** fałszywy udział → `CommitmentMismatch` (nie cicha
  kontynuacja). Testy: `g2_vss_poly_forge_f_share_aborts`,
  `g2_vss_poly_forge_f_big_share_aborts`, `g2_sign_forge_share_*_aborts`.
- **Wydajność:** pełne VSS na N=1536 × 4 poly to ~25K mnożeń Ristretto
  w debug (timeout). Integracja sign używa próbki `G2_VSS_SAMPLE=8`
  współczynników; pełny VSS demonstrują testy komponentowe.

### 2. MAC na otwieraniach w torze sign — ukryte δ nad Z_P

- **Spójność światów:** Shamir ishare jest nad P=2^61−1; MAC/SPDZ Y6
  nad GF(256). Rozstrzygnięcie: MAC jest **nad Z_P** (ta sama
  reprezentacja co udziały i16). δ, mac i wartości wszystkie w Z_P.
  GF(256) MAC (Y6) zostaje dla bitów obwodu — warstwy niezależne.
- **Mechanizm (analog Y6/Y10):**
  - `ZpMacShare` — udział wartości z MAC (`mac = δ · value mod P`)
  - `ZpDeltaShares` — ukryte δ-shares (Shamir w Z_P); δ nigdy nie
    rekonstruowane w torze
  - `dkg_zp_delta_shares` — DKG δ bez dealera (analog Y10)
  - `zp_open_with_mac_hidden_delta` — otwarcie z kontrolą:
    `z_i = mac_i − x·δ_i` → rekonstrukcja z = 0 lub `MacFail`
- **Gdzie MAC chroni:**
  - **Otwarcie maski bit-decomp** (`d = X − r` w rounding): MAC
    propagowany liniowo z f/F przez t·f (jawne) do maski r do d.
    Fałszywy udział f/F, MAC lub maska W-bitowa → `MacFail`.
  - **Maski bit-decomp** (bit-pary w `gfbit_to_pbit`): maska m z MAC
    (dealer model). Otwarcie d = b⊕m przez GF Y6 MAC.
- **Czego MAC NIE chroni (udokumentowana luka):**
  - **s1, s2 po ring-mulach:** mnożenie udział×udział (4 × N²
    reshare-muls) nie zachowuje MAC — wymaga auth triples (U4) przez
    każdy reshare-mul. Koszt: 4N² ≈ 9.4M triples. Poza zakresem spiku.
  - **Bity po AND-ach w obwodzie:** AND = reshare-mul w GF(256);
    MAC wymaga GF auth triples przez obwód. Poza zakresem.
  - **Detekcja tamper s1/s2 na pełnym N:** przez publiczną weryfikację
    (norm bound, verify_sign_equation, engine verify) — fail-closed
    na poziomie podpisu, nie MacFail.

### 3. Matrix fałszerstw — każdy wykryty

| Atak | Mechanizm detekcji | Test | Wynik |
|---|---|---|---|
| Fałszywy udział f | Pedersen VSS | `g2_vss_poly_forge_f_share_aborts` | CommitmentMismatch ✓ |
| Fałszywy udział F | Pedersen VSS | `g2_vss_poly_forge_f_big_share_aborts` | CommitmentMismatch ✓ |
| Fałszywy udział f w sign | VSS w deal | `g2_sign_forge_share_f_aborts` | abort ✓ |
| Fałszywy udział F w sign | VSS w deal | `g2_sign_forge_share_f_big_aborts` | abort ✓ |
| Fałszywy MAC f | MAC na open maski | `g2_sign_forge_mac_f_detected` | MacFail ✓ |
| Fałszywa maska W-bitowa | MAC na open d (komponent) | `g2_mac_forge_w_mask_detected` | MacFail ✓ |
| Fałszywy bit-decomp open | MAC na open d (komponent) | `g2_mac_forge_bit_decomp_open_detected` | MacFail ✓ |
| Fałszywy s1/s2 open | MAC na open (komponent) | `g2_mac_forge_s1_s2_open_detected` | MacFail ✓ |
| Fałszywy udział (wartość) | Z_P MAC | `g2_zp_mac_tamper_value_fails` | MacFail ✓ |
| Fałszywy MAC (wartość) | Z_P MAC | `g2_zp_mac_tamper_mac_fails` | MacFail ✓ |
| Fałszywy udział δ | Z_P MAC | `g2_zp_mac_tamper_delta_share_fails` | MacFail ✓ |

**Uzupełnienie G-2-CHANGES (e2e value-forge przez pełny tor sign):**

| Atak | Mechanizm detekcji | Test | Wynik |
|---|---|---|---|
| Tamper td.f value po dealu | MAC na open d (e2e sign) | `g2_sign_value_forge_f_aborts_e2e` | MacFail ✓ |
| Tamper td.f_big value po dealu | MAC na open d (e2e sign) | `g2_sign_value_forge_f_big_aborts_e2e` | MacFail ✓ |

**Uwaga (dokładność):** wiersze W-mask / bit-decomp oznaczone „komponent"
znaczy że test mutuje udziały i wywołuje `zp_open_with_mac_hidden_delta`
bezpośrednio — ten sam mechanizm co w torze sign, ale nie przez
`mps4h_sign_shares_g2`. Pełny tor e2e demonstrują testy value-forge
powyżej (MAC na open d w rounding).

### 4. Warunek max|F| < q/2 — jawna walidacja

- `validate_f_bound(f_big)` — max|F| < q/2 = 9216. Naruszenie → abort
  (`InconsistentShare`), nie cicha kontynuacja.
- `g2_deal_trapdoor` waliduje bound **przed** deal-em udziałów.
- Retained H: max|F| ≈ 54–65 ≪ 9216 na realnych kluczach (seed 0x42: 59).
- Testy: `g2_f_bound_violation_aborts`, `g2_f_bound_real_key_ok`,
  `g2_deal_f_bound_violation_aborts`.

### 5. Regresja złota

- `g2_sign_honest_engine_verify_true`: uczciwy deal + G-2 sign →
  `Ft1536Signature::verify == true` (32.7s w debug).
- Wszystkie 319 testów złota MPS4-H przechodzi (suite: 338/338).
- API `mps4h_*` nie zmienione — G-2 to równoległe funkcje `g2_*`/`*_g2`.
- **G-2-CHANGES:** testy graniczne u128 (`g2_vss_eval_x255_ok`,
  `g2_vss_eval_k3_ok`) — x=255 i k=3 nie przepełniają ewaluacji.

## Retained / uwagi

### R-G2-1: wyciek Babai (Nguyen–Regev) przez deterministyczny round

**Właściciel wskazał (2026-10-21):** deterministyczny `round_half_away`
bez szumu Gaussa to **otwarty wyciek statystyczny** (Babai rounding /
Nguyen–Regev). Atakujący z wielu podpisów może odzyskać informację
o sekretach f,F z wartości `round(t·f/q)`.

- **Status:** otwarte — fix idzie **osobnym zadaniem** (T6).
- **Plan fixu:** szum DGDG (discrete Gaussian) na udziałach **przed**
  round — `z = round((t·f + e)/q)` z e ← DGDG na udziałach, tak aby
  rounding nie ujawniał struktury t·f.
- **Nie dotyczy** bezpieczeństwa VSS/MAC (G-2 łapie fałszerstwa, nie
  wyciek statystyczny).
- **NIE deklarować** bezpieczeństwa statystycznego round dopóki fix
  nie jest wdrożony.

#### R-G2-1 SUPLEMENT T6 (2026-10-21) — fix wdrożony

**Status: closed-by-T6 = łagodzenie wdrożone. NIE jest to pełne
zamknięcie bezpieczeństwa statystycznego** (patrz ograniczenia).

Wdrożono szum DGDG(σ) na udziałach w liczniku przed /q —
`z = round((x + g)/q)` w `round_div_q_scalar_shares` (+ wariant G-2
z MAC na szumie). σ jawny parametr (`T6_GAUSS_SIGMA_DEFAULT=4`,
zakres 1..=64); deal: `deal_dgdg_shares` (re-deal `sample_gaussian_q73_clear`
+ `ishare_val`); szum **nie jest rekonstruowany** w torze sign.

Pomiary (pełne w `MPS_T6_GAUSS_NOTES.md`):
- krawędź Babai rozmyta: H(det)=0 → H(gauss σ=4)≈0.93–0.97 bita,
  wariancja z na krawędzi 0 → 0.25;
- n(σ=4, złoto)=103747771 (zbieżne z pinem F2 — E[flipy]≈1.07, na tym
  seedzie 0 flipów; honest); n(σ=8)=104106830 < bound 2093922385;
- `verify_sign_equation` + `Ft1536Signature::verify == true` z szumiem;
- suite 349/349, 0 warnings; retained F2/G/H/G2 nietknięte (`None`).

Ograniczenia (zostaje otwarte): brak full ffLDL/Gaussian sampling z C,
brak security proof, brak MAC na s1,s2 (R-G2-2), model dealu = dealer
(re-deal, nie PRSS-only), σ≪q daje słabe smużenie typowego podpisu
(P(≥1 flip)≈1−e^{−0.27σ}). **NIE deklarować** UC / EUF-CMA / bezpieczeństwa
statystycznego na tej podstawie.

### R-G2-2: brak MAC na s1,s2 po ring-mulach (patrz wyżej)

Pełne MAC na otwarciu s1,s2 wymaga auth triples przez 4 × N²
reshare-muls (koszt ~9.4M triples). Poza zakresem G-2. Detekcja tamper
s1/s2 na pełnym N: engine verify false (fail-closed na poziomie
podpisu). Komponentowy MAC na open s1/s2: `g2_mac_forge_s1_s2_open_detected`.

### R-G2-3: VSS na próbce w integracji sign

Pełny VSS na N=1536 × 4 poly = ~25K mnożeń Ristretto w debug = timeout.
Integracja sign używa `G2_VSS_SAMPLE=8` współczynników. W modelu
produkcyjnym VSS powinien obejmować wszystkie współczynniki (lub
użyć batch verification / precomputed tables).

### R-G2-4: InconsistentShare jako błąd bound max|F|

`validate_f_bound` zwraca `InconsistentShare` (najbliższy istniejący
wariant; enum SpikeError poza zakresem plików G-2). Dedykowany wariant
`FBoundViolation` byłby czytelniejszy.

## Co to NIE implikuje

1. **NIE** jest to malicious-secure MPC / UC / symulowalność.
2. **NIE** jest to dowód EUF-CMA→MT-ISIS.
3. **NIE** eliminuje wycieku Babai (R-G2-1) — osobne zadanie T6.
   *(SUPLEMENT T6: fix DGDG wdrożony — łagodzenie, patrz MPS_T6_GAUSS_NOTES.md.)*
4. Semi-honest computation + fail-closed detekcja na wejściach (VSS)
   i otwarciach maski (MAC). Ring-ule i obwód bitowy pozostają
   półuczciwe (brak auth triples).

## Powiązane

- `Y13_MALICIOUS_MAP.md` — mapa modelu złośliwego (zaktualizowana)
- `MPS_H_NOTES.md` — ZŁOTO MPS4-H (zachowane)
- `SECURITY_POSITION.md` — pkt 2 (SPDZ-MAC na otwieraniach)
- Y6–Y10 (`lib.rs`) — wzorzec SPDZ-MAC ukryte δ
- U4 (`lib.rs`) — auth triples (wzorzec do przyszłego fixu R-G2-2)

*G-2 — 2026-10-21. Suite: 338/338, 0 warnings.*
*G-2-CHANGES (T4-fix) — 2026-10-21. Suite: 342/342, 0 warnings. Suplement powyżej.*
