# S05 — większy pakiet015: od(M) do skończonej odpowiedzi

Baza `80233ea4132ba1bbb3065b3b5fc5e6d291e4e710`.
Status: **ZAKOŃCZONY ZAKRES 015 / WARUNKOWY**. Klasa: obowiązki Q-SAMPLER i później
Q-RESC; bez nowych założeń kryptograficznych. Własne źródła i runtime
wyłącznie w S05. Małe commity są checkpointami, nie pytaniami o kontynuację.

## Cel pakietu

- [x] Z dokładnego `SamplerMassCondition014.MassCondition` uzyskać potrzebną
      zbieżność i transport całego włókna do rzeczywistego skończonego boxu.
- [x] Wyprowadzić ogon boxu z progu `3*65536²/4` i temperatury9/16,
      korzystając z istniejącego `CenteringTriangle.three_square` i encoderów.
- [x] Wyprowadzić skończone normalizatory, flatness i jednolity ogon normy
      przy temperaturze1811939328/2093922385. Stałe sprawdzić Sage i kernelowo.
- [x] Złożyć marginal i pełną odpowiedź (łącznie z `none`) przez istniejące
      `FiberBinding`/`EmitMixture`/`Divergence`; zachować anulowanie pierwszego
      momentu i bound `1+z²`, bez zastępowania go luźnym `(1+z)²`.
- [x] Przenieść wynik przez jawną dominację `J≤K*publicJoint`, z AC i pełnym
      momentem. Faktyczne dostarczenie tej dominacji przez kod007 pozostaje
      oddzielnym obowiązkiem; nie przedstawiać konstruktora jako instancji.
- [x] Zachować próby, piny, koszty, wspólny świeży build i polski checkpoint.

## Mapa ponownego użycia i granice

- `PublicSimulation.encodeVec/decode_encodeVec/full_norm_support_in_box`:
  istniejąca reprezentacja boxu i normy, bez nowego codec modelu.
- `T5BoxBound.decode_injective/fiberEmbed`: struktura osadzenia; jego
  `TowerRep` i budżet1023 nie są automatycznie dostępne z wariantu991.
- `CenteringTriangle.three_square`: dokładna mocna granica A2.
- `GaussianFiberTilt`: rzeczywiste skończone masy i ogon normy.
- `NormalizerComparison.finiteFlat_of_common_scale`: ogólny konsument,
  bez wyspecjalizowanego helpera wymagającego2^-40.
- `FiberBinding.public_joint_factor/signBody_is_mix`,
  `EmitMixture.mix_ac/second_le_inv/cap_emit`, `Divergence.joint_chi2`:
  pełna odpowiedź z zachowanymi abortami i kierunkiem J/P.

Dokładne wejście to trzy temperatury014. Nie dodajemy7/8 pod nazwą starego(M).
Jeżeli użyjemy konserwatywnych stałych innych niż w tekstowym007, zapisujemy
różnicę jawnie i dowodzimy końcowej nierówności bez wzmacniania przesłanek.

Poza tym pakietem: source → kanoniczne H≥991, pełny emitted KeyGen/Sign/PRG,
wykonalny Lean Sampler007 i jego bit-cost oraz mechanizmy QROM. Aktywny
source3 pozostaje u swojego wykonawcy. Nowe commity ROM czytamy jako wejścia.

## Zamknięcie pakietu

47 nowych twierdzeń,6 modułów, świeży build czysty. Ta sama przesłanka(M)
i ta sama jawna dominacja1+2^-60 dają **e≤2^-47**, mocniej od007.
Oszacowanie pośrednie przekracza1+2^-48: zachowano kernelowy negatywny
wynik o tej obwiedni, bez twierdzenia o dolnej granicy rzeczywistego J/P.
`SamplerInterface015.on_keys/same_key_law` używają istniejącego wrappera011;
wszystkie stany są objęte przez wywołanie zawsze z publicznym initial.

Ostatni checkbox oznacza checkpoint i receipt, nie ukończenie programu QROM.
Kod007/Dom/zasoby/source pozostają jawnie OPEN; następnym pakietem jest016.
