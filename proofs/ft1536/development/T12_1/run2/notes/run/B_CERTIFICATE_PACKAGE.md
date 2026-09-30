# Pakiet certyfikatu (b) — wiązanie liczb silnika z masami okien

Stan: 2026-09-24, W=FT1536_MATH_EUFCMA_MTISIS_RUN_002.
Cel (b): zamknąć hipotezy `hbLo`/`hbHi` z
`Run2/RadialBinningSandwich.enclosure_of_binning_certificates`:

    hbLo : engineLo - aliasCap <= 4*768 * loTriangleMass
    hbHi : 4*768 * hiTriangleMass <= engineHi + missCap

gdzie `loTriangleMass`/`hiTriangleMass` to sumy `blockLaw.mass b *
indicator (region1 b) * windowMassWin 0 b (loWin/hiWin ...)` — a silnik
liczy dokładnie `4*768 * (waga_pary * gap_CDF)` po trójkącie kanonicznym.

## 1. Warstwa symboliczna (kernel, UDOWODNIONA)

| element | moduł | status |
|---|---|---|
| `inverse_power_is_cyclic_convolution` — inverseDFT(DFT(x)^k) = k-fold cyclic convolution | `Run2/DiscreteFourier` | proved |
| `dft_convolution`, `convolutionPower` | `Run2/DiscreteFourier` | proved |
| `iid_pgf` — n-fold PGF power dla IID | `Run2/GeneratingFunction` | proved |
| `probability_bracket`, `interval_lower/upper` — sandwich binningowy | `Run2/Binning` | proved |
| `radialHit_window` — zdarzenie = okno `[B-ce, B-e)` na restEnergy | `Run2/RadialWindowSplit` | proved |
| `canonical_window_split` — masa = `∑ b, waga * windowMass` (ksztalt `weight × gap`) | `Run2/RadialWindowSplit` | proved |
| `loWin ⊆ trueWin ⊆ hiWin`, `windowMass_bin_sandwich` | `Run2/RadialBinningSandwich` | proved |
| `radialSum_4_768` — struktura 4*768 (symetrie) | `Run2/RadialSymmetry` | proved |
| `restEnergy_as_sums`, `rawLaw_mass_prod`, `restMass_prod` — 1535-termowa suma/Iloczyn mas | `Run2/RestEnergyBridge` | proved |
| `certificate_sound`, `cyclic`, `cut_cyclic` + test negatywny `rejects_changed_product` (decide) | `Run2/PackedConvolution` | proved |

Wniosek: struktura obliczenia silnika (k-ty fold cykliczny 1535-rozkladu,
okna CDF, wagowo-oknowa masa pary) jest w calosci uzasadniona kernelowo.

## 2. Warstwa liczbowa (certyfikat obliczenia, artefakty)

Artefakty (piny, W=RUN_002):
- `run/arb_radial_full_001/arb_radial_result.json` — endpointy (dokładne
  rationals `lower_endpoint`/`upper_endpoint` = krawędzie kulek Arb
  `lower.lower().exact_rational()`/`upper.upper()`), mode=full,
  precision_bits=128; `not_final_probability: true`, pending:
  alias/omitted-block tails, multiple changes, legal-key/retry bridge.
- `run/radial_closure_001/centering_interval_closure.json` — poprawki
  (aliases/input_tail/multiple_changes/signed16_emit/theta) jako kule
  RealBallField(512), raw_lower/raw_upper, honest_lower/upper (rationals).
- `run/tail_obligations_001` + `run/tail_obligations_002` — checkers Sage
  (Arb512, exact QQ): 6/6 PASS (ogony tau9217/emit, piny cap).
- `run/radial_kernel_mul20_ffi_001`, `run/radial_kernel_rejection_proof_001` —
  benchmarki packed-Nat (decide) + test negatywny fold-fixtures.
- tryb testowy `arb_radial.sage`: exact_QQ_CDF_matches = 64/64 (porownanie
  FFT-konwolucji z dokladnym QQ p^3) — walidacja implementacji.

Sposób liczenia (z `run/sage/arb_radial.sage`): enumeracja dokładnych
całkowitych multiplicitatyw A2 (counts), binning po szerokości 16 z wagami
t^r, DFT (FLINT `acb_dft_rad2`), potęga punktowa 1535, inverse DFT, CDF,
okna `gap = CDF(lhi-base) - CDF(llo-1-base)`, mnożenie przez wagę pary
`t^{Q(a,b)}/G`, suma po trójkącie × 4*768. Arytmetyka FLINT/Arb = kule
z kierunkowym zaokrągleniem (dolna/górna krawędź gwarantowana).

## 3. Architektura akceptacji (propozycja)

1. **Wartości liczbowe = certified computation**: obliczenia FLINT/Arb
   (kule z kierunkowym zaokrągleniem) + Sage/RealBallField dla poprawek.
   Akceptacja jak dla checkerów: artefakt + pin + rerun-or-not.
2. **Struktura = kernel** (sekcja 1) — juz domknieta.
3. **Cross-validation**: tryb testowy exact-QQ (64/64) + packed-Nat fold
   certificate (benchmarks, `certificate_sound`) + test negatywny
   `rejects_changed_product` (decide).
4. **Otwarte formalnie**: integracja tych warstw w jeden „sealed"
   certifikat (np. packed-Nat dla całkowitej warstwy counts/convolution +
   przyjęcie kul Arb jako interval certificates w rejestrze).

## 4. Czego NIE pokrywamy (uczciwie)

- Pełnoskalowy packed decide dla 2^25 wektorów jest niewykonalny w kernelu
  (benchmark: exponent 20 = 14.9 s/2.4 GiB; 22 = granicznie; 25 ≈ 60 GiB —
  poza budżetem). Certyfikat packed-Nat ma sens walidacyjny (skala testowa)
  oraz dla całkowitej warstwy counts w skalowalnym kawałku.
- Równość `gap = windowMass` w formie liczbowej jest przyjęciem warstwy 2
  (certified computation), nie twierdzeniem kernelowym — kernel gwarantuje,
  że JEŚLI liczby z warstwy 2 opisują masę okien, TO (b) i cały łańcuch
  trzymają. To jest świadoma granica: „brak dowodu" ≠ „brak redukcji";
  redukcja jest pełna, liczby są certyfikowane zewnętrznie.

## 5. Następne kroki do freeze

1. Ekstrakcja całkowitej warstwy (counts/binned) do packed-Nat z rzeczywistego
   przebiegu (Cython-enumeracja jak w arb_radial.sage) + certificate_sound
   na skali walidacyjnej i/lub kawałkach.
2. Przyjęcie rejestrów checkerów (tail_obligations, radial_closure,
   arb_radial_result) jako interval certificates w manifest freeze.
3. Domknięcie `GuaranteedDigits.three_significant_digits` wariantem z
   `enclosure_of_binning_certificates` (już jest) + oświadczenie zakresu
   (all successfulKeyGen — nadal hipoteza flat/reject do rozliczenia z T5).
