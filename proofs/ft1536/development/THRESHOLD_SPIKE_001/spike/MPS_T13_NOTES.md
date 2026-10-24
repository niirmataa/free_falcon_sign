# MPS_T13_NOTES — naprawy realnych bugów audytu (#16, #2, #9)

**Data:** 2026-10-24 · **W:** `proofs/ft1536/development/THRESHOLD_SPIKE_001/`
**Wejście:** 403/403 (378 lib + 14 iso + 1 measure + 10 spike), P0 (#1, #6) naprawione.
**Wyjście:** 414/414 (389 lib + 14 iso + 1 measure + 10 spike), 0 warnings.
**Status:** SPIKE/PROTOTYP — **nie** malicious-secure, **nie** próg FT gotowy.

Baza triage: `AUDYT_WEWNĘTRZNY_T12.md` (źródło zamrożone W + kopia living
w development z statusami T13). Autor ≠ audytor. Bez nazw narzędzi
zewnętrznych w repo — „wewnętrzny audyt bezpieczeństwa".

---

## Co naprawiono (kolejność P1)

### #16 — reject fail-open + modulo bias → **NAPRAWIONY**

**Dowód (przed):**
- `rejection.rs` `uniform_range_pub`: `rng.next_u32() % span` — bias reszty.
- `sample_gaussian_q_clear` / `sample_gaussian_q73_clear`: po `attempts > 10_000`
  `Ok(SampleOutcome { x, attempts })` z **ostatnim odrzuconym** kandydatem.

**Naprawa:**
- `uniform_range_pub`: unbiased bounded sampling (power-of-two mask +
  rejection ogona `v >= (u32::MAX/span)*span`).
- `GaussQError::AttemptsExhausted`; wyczerpanie Q16/Q73 → **`Err`**
  (fail-closed), nigdy Ok z odrzuconym kandydatem.

**Testy:**
- `t13_uniform_range_no_modulo_bias` — pomiar 30k, span=3, rel.err < 5%/bin.
- `t13_uniform_range_covers_span` — pełne pokrycie [-8,8].
- `t13_q16_exhaustion_is_err`, `t13_q73_exhaustion_is_err` — ConstRng +
  σ z wagą 0 poza x=0 → `AttemptsExhausted`.
- `t13_q73_honest_path_still_ok` — ścieżka uczciwa nietknięta.

**Retained (świadomie poza scope promptu):** `sample_clear`,
`sample_mpc_naive`, `sample_gaussian_clear` mają dawny fail-open na capie
(returns SampleOutcome, nie Result). Prompt wskazywał Q16/Q73. Zmiana API
tych samplerów = osobny krok. Oznaczone w pułapkach.

### #2 — Beaver `c` sprawdzony → **NAPRAWIONY**

**Dowód (przed):** `mul_auth_zp_with_triple` (`ishare.rs`) używał
`triple.c[i].share` **bez** `c.mac` i bez `c = a·b`; wynik dostawał nowy MAC
liniowy — zepsute `c` (także z „poprawnym" MAC dla złej wartości) przechodziło.

**Naprawa:**
- Nowa `check_zp_auth_triple`: open a, b, c z kontrolą MAC (c.mac w
  dataflow) + `c == a·b`; wywoływana **przed** użyciem `c.share` w
  `mul_auth_zp_with_triple`. `c ≠ a·b` lub tamper → `MacFail`.

**Testy:**
- `t13_beaver_wrong_c_with_valid_mac_rejected` — podmiana c na dobrze
  sformułowany zły iloczyn → MacFail w check i w mul.
- `t13_beaver_good_c_ok_and_c_mac_in_dataflow` — poprawne c → OK;
  tamper `c.mac` → MacFail.
- `t13_beaver_tamper_c_share_without_mac_rejected` — share bez update MAC.

### #9 — jawny `delta_known` + skorelowane fałszerstwo → **RETAINED + test**

**Dowód:** `G2Trapdoor.delta_known`; MAC = δ·val liniowością. Skorelowane
(Δ w wartości + δ·Δ w MAC) przechodzi zero-check — liniowy MAC jest
informacyjnie fałszowalny, gdy napastnik zna δ.

**Decyzja (ft-prawda, zakres promptu):** prompt dopuszcza „ukryte δ (jak Y6)
**lub** jawne retained + test skorelowanego fałszerstwa". Pełna ukryta δ
w G-2 = zmiana modelu dealerskiego MAC (delta_known jest używane przy
tworzeniu MAC w całym torze). Wybór: **jawne retained (granica modelu G-2)
+ test skorelowany** — bez cichego ogłaszania „naprawione".

**Testy (skorelowane, nie value-only / MAC-only):**
- `t13_correlated_forgery_without_delta_detected` — Δ + zły Δ_mac →
  MacFail (known-δ open i hidden-δ open).
- `t13_correlated_forgery_with_known_delta_is_retained` — Δ + δ·Δ przy
  znanym δ → **przechodzi** (retained; test pilnuje statusu).
- `t13_value_only_and_mac_only_detected` — kontrast: jednostronne wykryte.

**Co to zmienia w projekcie:** jawne `delta_known` jest **granicą modelu
dealerskiego G-2**, nie „cichym bugiem do zignorowania". Tor produkcyjny
ma iść przez `dkg_zp_delta_shares` / ukryte δ (jak Y6). Do tego czasu
nie deklarować odporności na skorelowane fałszerstwa przy wycieku δ.

---

## Regresja złota

| Zestaw | Wynik |
|---|---|
| lib | 389/389 (378 + 11 t13) |
| isolation | 14/14 |
| measure_fg | 1/1 |
| spike | 10/10 |
| **razem** | **414/414**, 0 warnings |

Pin F2 `103747771` nietknięty (`t9_mac_s_ok_engine_verify`, `mps4h_*`).
`t12_*`, `t10_*`, `t9_*`, `t8_gold_*`, `t6_`, `mps4h` zielone.

---

## Księga pułapek (T13)

1. **Reject fail-open** → objaw: Ok z odrzuconym kandydatem po capie →
   przyczyna: „awaryjne zamknięcie" zwracało SampleOutcome zamiast Err →
   naprawa: `AttemptsExhausted`; Q16/Q73 fail-closed. Wzorzec: cap = Err,
   nigdy cisza.
2. **Modulo bias** → objaw: `u32 % span` faworyzuje resztę → przyczyna:
   brak rejection ogona → naprawa: maska dla potęg 2 + rejection reszty.
3. **Beaver c bez checka** → objaw: zły iloczyn z nowym MAC → przyczyna:
   `c.share` wchodzi bez `c.mac` i `c=a·b` → naprawa: `check_zp_auth_triple`
   przed użyciem. Wzorzec: triple = a·b **przed** Beaver-em.
4. **Jawny δ + liniowy MAC** → objaw: skorelowane Δ+δ·Δ przechodzi →
   przyczyna: MAC informacyjnie fałszowalny przy znanym δ → naprawa:
   retained + test skorelowany; produkcyjnie ukryte δ (Y6/DKG). Wzorzec:
   nie ogłaszać „wykryte" bez testu skorelowanego i bez usunięcia δ z modelu.
5. **API Result vs Outcome** → zmiana fail-open na Err wymusza zmianę
   sygnatury; stare samplery (`sample_clear` itp.) zostają z retained
   fail-open do osobnego kroku — nie psuć złota na siłę.

---

## Trzy zdania

1. **Wykazano:** #16 (unbiased range + Err na wyczerpaniu) i #2 (check
   `c=a·b` + `c.mac`) naprawione z testami; suite 414/414; pin F2 nietknięty.
2. **Najbliższy brak:** #9 jawny δ = retained granica G-2 (skorelowane
   fałszerstwo przy znanym δ przechodzi — test to pilnuje); dalej hardeningi
   P2 (#3,#4,#7,#11,#13,#14,#15) i fail-open w `sample_clear`/`sample_gaussian_clear`.
3. **NIE implikuje:** malicious-secure / UC / EUF-CMA / gotowości progu FT;
   naprawy to detekcja i fail-closed w spiku, nie dowód bezpieczeństwa.

---

*FT1536 MPS T13. Retained failures zachowane. Prawda przed tempem.*
