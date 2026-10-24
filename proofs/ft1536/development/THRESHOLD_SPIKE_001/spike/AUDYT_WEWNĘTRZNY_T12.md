# Audyt wewnętrzny toru MPS / spike FT1536 — 2026-10-21 (statusy T13)

Metoda: **ft-audytor** (mapa → threat model → findings → triage →  
trzy zdania). Audyt wewnętrzny = materiał wewnętrzny; narzędzia audytu  
nie są wymieniane w repo. Autor ≠ audytor.

**Źródło:** kopia living w development (migracja 2026-10-23 + update T13
2026-10-24). Zamrożony oryginał: `work/FT1536_THRESHOLD_SPIKE_001/spike/AUDYT_WEWNĘTRZNY_T12.md`
(nie nadpisywać). Korekty statusów = jawne wpisy w tabeli, nie kasowanie
findings.

---

## 0. Mapa przedmiotu (bez mapy nie ma findings)

**Przedmiot:** `spike/` — prototyp badawczy toru progowego wokół  
**działającego silnika FT1536** (q=18433, N=1536, ring X^N−X^{N/2}+1,  
secret ternary; `FT1536_IDENTITY.md`).

### Struktura (14 plików, ~19k linii)

| Moduł | Rola | Granica |
|---|---|---|
| `lib.rs` | Shamir GF(256), MacShare, DKG δ, auth triples, ceremonie seed/sk | dealer/„moment" |
| `ishare.rs` | Shamir Z_P (2^61−1), weighted DKG NTRU, MAC s1,s2, bound F | in-process DKG |
| `mpc_sign.rs` | trapdoor, hash_to_point, codec 0xAA, sampler z | z = det. Babai + DGDG |
| `shake.rs` | SHAKE256 na udziałach (Keccak-f, χ = mul) | bit-shares, nie bajt |
| `mul.rs` | mul_shamir_reshare, NTT, NTRU check | GF(256) |
| `pedersen.rs` | VSS bajtowe + Z_P | blindy |
| `prss.rs` | PRSS-lite, pairwise | in-process rng |
| `klein.rs` | Bernoulli, Q73, cond bits | stand-in vs D_Λ |
| `rejection.rs` / `select.rs` | samplery, accept cmp | fail-open w wyczerpaniu (częściowo po T13) |
| `bin/iso.rs` | demo multi-process (plikowy mailbox) | wspólny workdir |

### Przepływy sekretu

```
seed/sk (clear, „moment") → udziały f,F → z (det./DGDG) → s1,s2 → open
                                                            → engine verify
```

**Niezmieniki deklarowane vs realne:**
- Deklarowane: „klucz nie w całości w torze sign" — **realne w torze MPS**;  
  H1 setup (clear f,F) = retained/„moment".
- Deklarowane: pin F2 `103747771` — **realne**, nietknięty (regresja T13).
- Deklarowane: „semi-honest" — **realne**; brak UC/malicious proof.

---

## 1. Zakres / wyłączenia

**Audytujemy:** snapshot `spike/` (digest `67a6474…`), stan po T12-P0;
statusy po T13 (2026-10-24).  
**NIE audytujemy:** silnik FT1536 C (`Extra/c`), `ft1536_sys`,  
produkcji, sieci, Lean4 kernela. **Coverage ≠ bezpieczeństwo.**

---

## 2. Threat model

**Aktywa:** seed 32 B, f,g,F,G (trapdoor), s1,s2 (podpis), MAC δ,  
PRSS seedy, wkłady DKG.

**Granice zaufania:**
- dealer H1 / „moment" setupu (`g2_deal_trapdoor`) — retained
- koordynator DKG (widzi wkłady w clear) — in-process
- `iso` workdir — pliki, brak ACL/IPC
- silnik FT1536 — zaufany oracle (poza scope)

**Napastnik:** złośliwy uczestnik (wkład/share/MAC/rng); lokalny  
użytkownik `iso`; **nie** OS/WSZYSTKIE strony/silnik.

**Cele:** brak cichej korupcji; brak odzyskania sekretu z commitmentu;  
detekcja fałszerstw; fail-closed.

---

## 3. Tabela findings + TRIAGE (statusy T13)

| # | Finding | Sev/Conf | **Triage** | Status |
|---|---|---|---|---|
| **1** | mul `n≥k` zamiast `n≥2k−1` → cichy zły iloczyn | med/high | **REALNY BUG** | **NAPRAWIONY** (T12-P0) |
| **6** | Pedersen blind u8 → 2^16 brute-force | med/high | **REALNY BUG** | **NAPRAWIONY** (T12-P0) |
| **16** | reject fail-open: odrzucony → Ok; modulo bias | low/high | **REALNY BUG** | **NAPRAWIONY** (T13) |
| **2** | Beaver `c` bez sprawdzenia | med/high | **REALNY BUG** | **NAPRAWIONY** (T13) |
| **9** | jawny `delta_known` + liniowe MAC → skorelowane fałszerstwo | med/high | **REALNY BUG** | **RETAINED** (T13: granica modelu G-2 + test skorelowany) |
| **3** | sign bez typestate DKG/NTRU | med/high | **HARDENING** | otwarte |
| **4** | maski tej samej szerokości — wyciek z powtórzeń | med/high | **HARDENING** | otwarte |
| **7** | G2 sign bez VSS commitments | med/high | **HARDENING** | otwarte |
| **11** | zeroizacja/Clone sekretów | low/high | **HARDENING** | otwarte |
| **13** | SHAKE: brak bitness/consistency shares | low/high | **HARDENING** | otwarte |
| **14** | panic/overflow na wejściach | low/high | **HARDENING** | otwarte |
| **15** | mailbox: podmiana/replay plików | low/high | **HARDENING** | otwarte |
| **5** | det. sampling zamiast D_Λ (Eflipy) | med/high | **GRANICA MODELU** | retained (jasna) |
| **8** | centralizowany DKG/PRSS in-process | med/high | **GRANICA MODELU** | retained (jasna) |
| **10** | wspólny workdir `iso` (demo) | med/high | **GRANICA MODELU** | retained (demo) |
| **12** | seed ceremony reconstruct („moment") | low/high | **GRANICA MODELU** | retained (jasna) |

**Nie mieszamy klas w jednej liczbie:**  
**REALNY BUG: 5** (2 z T12-P0 + 2 z T13 naprawione; **#9 retained**
jako granica modelu G-2 — nie „naprawiony") · **HARDENING: 7** ·
**GRANICA MODELU: 4** (+ #9 w praktyce domyka się do tej klasy
dopóki `delta_known` jest w modelu).

---

## 4. Szczegóły kluczowe (P0/P1)

### REALNY BUG #1 — mul quorum (NAPRAWIONY)
- **Dowód:** `check_xs_p` `n>=k`; iloczyn stopień 2(k−1).  
- **Dataflow:** `mul_shamir_reshare` → interpolacja → **zły c bez Err**.  
- **Remediation:** `check_mul_quorum` `n≥2k−1` — **wykonane**;  
  test `t12_mul_quorum_requires_2k_minus_1`.

### REALNY BUG #6 — Pedersen blinds (NAPRAWIONY)
- **Dowód:** `Poly { coeffs: Vec<u8> }` → 2^16 par; `iso.rs:1407` commit `seed[0]`.  
- **Remediation:** `BlindPoly` 32 B Scalar — **wykonane**;  
  test `t12_pedersen_blind_full_entropy`.

### REALNY BUG #16 — reject fail-open (NAPRAWIONY T13)
- **Dowód:** `rejection.rs` `% span` bias; `Ok` po wyczerpaniu z odrzuconym.  
- **Remediation:** unbiased `uniform_range_pub` + `GaussQError::AttemptsExhausted`
  w Q16/Q73 — **wykonane**; testy `t13_uniform_range_*`, `t13_q16/q73_exhaustion_is_err`.
- **Retained:** fail-open cap w `sample_clear` / `sample_gaussian_clear`
  (poza scope T13) — osobny krok.

### REALNY BUG #2 — Beaver `c` (NAPRAWIONY T13)
- **Dowód:** `mul_auth_zp_with_triple`: `c.mac` ignorowane, `c.share` wchodził
  w wynik z nowym MAC.  
- **Remediation:** `check_zp_auth_triple` (c.mac + `c=a·b`) przed użyciem
  `c.share` — **wykonane**; testy `t13_beaver_*`.

### REALNY BUG #9 — jawny δ (RETAINED + test T13)
- **Dowód:** `G2Trapdoor.delta_known: u64`; tag = `delta·share`.  
  Skorelowane Δ+`delta·Δ` przechodzi zero-check.  
- **Remediation (T13):** jawne **retained** granica modelu G-2 +
  test skorelowany (`t13_correlated_forgery_*`). Pełna ukryta δ (jak Y6 /
  `dkg_zp_delta_shares`) = osobny krok zmiany modelu MAC.  
- **NIE** ogłaszać „naprawione" — `t13_correlated_forgery_with_known_delta_is_retained`
  pilnuje, że atak z δ nadal przechodzi.

---

## 5. Przeciw-dowody / niepewność

- Złoto `engine verify==true` **przeżyło** audyt i T13 — findings nie  
  podważają poprawności silnika ani codeców. Pin F2 nietknięty.
- #5/#8/#10/#12 są **udokumentowanymi granicami modelu** (semi-honest,  
  demo, „moment") — nie są „cichymi bugami".
- #9 po T13 jest **świadomie retained** (liniowy MAC + jawne δ) —
  to granica modelu dealerskiego, nie brak testu.
- Audyt **statyczny** (bez wykonania testów w scope) — ograniczenie  
  do zadeklarowania; nasze testy (414) są osobnym dowodem, nie proof.
- 400/400 **≠** dowód bezpieczeństwa.

---

## 6. Remediationy (kolejność)

1. **P0:** #1 ✅, #6 ✅  
2. **P1 REALNY BUG:** #16 ✅ (T13) → #2 ✅ (T13) → #9 retained + test (T13)  
3. **P2 HARDENING:** #3, #4, #7, #11, #13, #14, #15  
4. **GRANICA MODELU:** zostaje retained (świadomość, nie backlog)

---

## 7. Trzy zdania (update T13)

1. **Wykazano:** 5 realnych bugów — 4 naprawione (#1, #6, #16, #2),
   #9 retained z testem skorelowanym; 7 hardeningów, 4 granice modelu
   — mapa i triage rozdzielone; złoto engine-verify i pin F2 nietknięte.
2. **Najbliższy brak:** #9 jawne δ (retained G-2) oraz P2 hardeningi;
   fail-open w samplerach poza Q16/Q73.
3. **Audyt NIE rozstrzyga:** malicious-secure / UC / EUF-CMA;  
   Klein D_Λ w torze MPC (to granica modelu, nie bug); gotowości  
   produkcyjnej — i nie zamierza.

---

*Audyt wewnętrzny FT. Findings zachowane (retained) z przyczynami.  
Autor ≠ audytor. Prawda przed tempem. Statusy T13: 2026-10-24.*
