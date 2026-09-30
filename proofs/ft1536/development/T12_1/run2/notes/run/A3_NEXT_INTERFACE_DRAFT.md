# NEXT_INTERFACE — otwarte obowiązki po kompozycji zasobów

## M6: endpointy silnika i dokładne masy okien

Konsument:
`FT1536.Run2.RadialBinningSandwich.enclosure_of_binning_certificates`.
Brak kernelowych eksportów rozliczających jego nazwane wejścia:

```lean
hbLo : (engineLo : ℝ) - (aliasCap : ℝ) ≤ 4 * 768 * loTriangleMass
hbHi : 4 * 768 * hiTriangleMass ≤ (engineHi : ℝ) + (missCap : ℝ)
hchange : changeProbability ^ 2 ≤ (changeCap2 : ℝ)
htail : mean rawLaw (fun z => indicator (unsignedHalf z.2)) ≤ (emitCap : ℝ)
```

Potrzebny jest dowód wiążący liczby konkretnego silnika z **dokładnymi**
masami okien, wraz z alias/missing corrections. Symboliczne DFT, binning,
symetrie, rest-energy product i counts-fold zachowują zakres swoich typów.
`CountsFoldCertificate.exact_fold` nie dostarcza hbLo/hbHi.

ChangedTailReduction redukuje hchange do ogona pojedynczej współrzędnej
przy `tau9217`. Rachunek Arb512 sprawdza liczby, lecz pełna formalna
konsumpcja odpowiedniego analitycznego/certyfikowanego ogona nadal jest
obowiązkiem. Analogicznie dotyczy to unsignedHalf/emitCap.

Osiągnięty wynik: kernelowe twierdzenie warunkowe prowadzi z tych wejść
do `GuaranteedDigits.rawLo ≤ rawBad ∧ rawBad ≤ GuaranteedDigits.rawHi`.
Nie przyjęto żadnego aksjomatu stwierdzającego tę końcową nierówność.

## All-KeyGen, flatness/rejection i T5 (osobny W, RO)

Docelowy eksport konsumpcyjny musi mieć postać:

```lean
∀ h : Rq, SuccessfulPinnedCKeyGen h →
  FiniteFlat h GuaranteedDigits.flatBudget ∧
  (∀ c, CorrectnessProbability.rejection h c ≤ GuaranteedDigits.rejectBudget)
```

`SuccessfulPinnedCKeyGen` jest tutaj **nazwą brakującego source-bound
interfejsu**, nie nową definicją dopuszczalnych kluczy przez żądaną własność.
Trzeba udowodnić most od rzeczywistych successful outputs przypiętego C
do tego samego materiału klucza, bramki, Grama i exact leaves.

Aktualny T5 konsument:
`T5BoxTransport.flat_reject_of_towers (h) (hk : KeyTowerTransportCert h)`.
`KeyTowerTransportCert h` wymaga wspólnej dodatniej skali v, wieży każdego
włókna przy alpha o tej skali i

```lean
BoxTransportCert h v :=
  ∀ c : Rq, infFiberMass h c alpha - fiberMass h c alpha
    ≤ transportBudget * v
```

Do dostarczenia w tamtym W: Gram/Cholesky/source-leaf binding dla wymaganej
populacji kluczy oraz końcowy transport poza box po3072 współrzędnych.
Obecne per-coordinate Chernoff/MGF nie są automatycznie gotowym
BoxTransportCert. `T5FlatReject.all_key_flat_reject` ma nadal wejście
`T5AnalyticObligation`; model `successfulKeyGen` z równań/bramki nie jest
sam w sobie source proofem C. Piny odczytanych źródeł: `T5_DEPENDENCY_STATUS.json`.
RUN_002 nie przejmuje wykonania ani nie dokonuje odbioru tego W.

Po dostarczeniu powyższych wejść konsument `GuaranteedDigits.three_significant_digits`
ma dokładny typ:

```lean
(h : Rq) →
(GuaranteedDigits.rawLo ≤ rawBad ∧ rawBad ≤ GuaranteedDigits.rawHi) →
FiniteFlat h GuaranteedDigits.flatBudget →
(∀ c, rejection h c ≤ GuaranteedDigits.rejectBudget) →
1265 / 10^27 < delta h ∧ delta h < 1275 / 10^27
```

Te trzy przesłanki trzeba wyprowadzić dla tej samej definicji h i tego
samego modelu Sign. CENTERING_CLOSURE ma PARTIAL_PROOF, a jego lokalny
Rejection i parametry hraw/hbridge/Adm wymagają właściwych mostów.

## Instancjacja redukcji do docelowego schematu

Złożona A3 jest warunkowa. Pozostają konkretne lokalne programy A/S,
mały e dla pełnego joint-law w odpowiednim kierunku, powiązanie μKey/μH,
most do rzeczywistego C Sign/Verify oraz real PRNG. Nie zastępuje się tych
obowiązków diagnostyką, zgodnością hashy, założeniem końcowego advantage ani
nowym podzbiorem kluczy wybranym według tezy do udowodnienia.

## Następny krok proceduralny

Niezależny recenzent ocenia wydrukowane typy, lokalność przesłanek,
referencyjny model instrukcji/alokacji, erasure i fresh replay. Koordynator
importuje zaakceptowany rzeczywisty zakres do stages i wykonuje lokalny
commit. Wykonawca tego W nie prowadzi Git, push ani uruchamiania innych sesji.
