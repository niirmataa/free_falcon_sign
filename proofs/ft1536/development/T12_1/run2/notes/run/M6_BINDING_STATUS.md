# M6 — rzeczywisty stan kernelizacji, 2026-09-24

Status: **WORKING / PARTIAL_KERNEL_PROGRESS, bez freeze**.
Wiążący cel właściciela: jednolity przedział błędu poprawności dla wszystkich
successful outputs przypiętego KeyGen, w niezmienionym finite-box G16,
z gwarantowanymi trzema cyframi. Nie osiągnięto jeszcze tego całego celu.

## Nowe zamknięte ogniwa

Źródła w `run/formal/Run2/`:

1. `NormalizerComparison.lean`: dokładna partycja rzeczywistych skończonych
   sum po włóknach; z porównań względem wspólnej skali wyprowadza `FiniteFlat`
   oraz iloraz tilted normalizers. `RejectionNumericMargin` został świeżo
   przebudowany i konsumuje ten iloraz, uzyskując rejection < 2^-24.
2. `A2Theta.lean`: zbieżność nieskończonej sumy A2 i majoranta
   `theta <= 1+8*r/(1-r)^2`, z dowodem dla wszystkich par całkowitych.
   Nie przyjęto liczności powłok 6m jako nieudowodnionej przesłanki.
3. `T5ThetaNumeric.lean`: rzeczywiste pi/log/exp, dowód
   `kappa*leaf > 65*log 2` dla leaf >= 991 oraz
   `product(1536 centered A2 factors)-1 < 2^-40`. Parametrem jest dowolna
   lista rzeczywistych liści spełniających tę nierówność.
4. `ShiftedGaussian.lean`: kernelowy wzór Poissona dla dowolnego realnego
   przesunięcia, zbieżność oraz obustronne względne oszacowanie masy.
5. `TriangularGaussian.lean`: indukcja po całym nieskończonym sumowaniu
   trójkątnego Gaussa, z dowolnymi realnymi przesunięciami zależnymi od
   wcześniejszych współrzędnych; zbieżność i obie nierówności są dowiedzione.
6. `T5ScalarMass.lean`: instancjacja poprzedniego wyniku w wymiarze 3072,
   przy dodatnich scalar coefficients <= q^2/(991*2*pi*sigma^2).
   Daje względny błąd masy <= 2^-34. To pomocnicza, mniej ostra droga
   skalarna do mas przesuniętych, odrębna od centered A2 product < 2^-40.
   Nie utożsamiono tych dwóch dokładności i nie zmieniono starej closure.

## Świeże sprawdzenia

- `run/m6_fresh_kernel_001/`: wszystkie **33 moduły własnej zależności**
  przebudowane ze źródeł do nowych lokalnych produktów, exit 0 i czyste logi.
  Skompilowane biblioteki Lean/Mathlib były istniejącymi bibliotekami RO.
- `Run2.M6Audit` drukuje rzeczywiste typy 13 głównych eksportów i ich
  transitive axioms; wyłącznie propext, Classical.choice, Quot.sound.
- `run/m6_kernel_margins_002/`: `sage m6_kernel_margins.sage ...`, exit 0;
  exact QQ oraz Arb512 niezależnie przeliczają marginesy obu dróg T5,
  normalizer/rejection i warunkowego zaokrąglenia 1.27e-24.
- Automatyczny binding: `run/M6_PROGRESS_RECEIPT.json`, wytwarzany przez
  `python3 -B run/m6_progress_receipt.py`.

To replay tej zależności M6, nie finalny replay wszystkich aktualnych A1–A3.
`clean/` pozostaje niezmienionym wcześniejszym snapshotem; nowe źródła i
receipty są w `run/`. Przy finalnym pakowaniu trzeba rozszerzyć closure
bibliotek m.in. o faktycznie użyte źródła Gaussian Poisson.

## Dokładne pozostałe obowiązki — nie zakładać ich jako wniosku

### K: successful source KeyGen → właściwa krata i exact leaves

W aktualnej formalizacji nie ma jeszcze definicji semantyki przypiętego
`falcon_keygen_make` i dowodu, który z jego successful output produkuje
właściwy NTRU basis/affine-coset bijection oraz exact LDL decomposition
z wymaganymi liśćmi. Nie wolno zdefiniować legalnych kluczy przez
`FiniteFlat`, `CoefficientRange` albo pożądaną granicę delta.

Nowy `T5ScalarMass.uniform_shifted_mass_3072` wymaga rzeczywistej konstrukcji
`Tower 3072`, dowodu `CoefficientRange`, równości jego masy z masą konkretnego
włókna i poprawnej wspólnej skali. Tę konstrukcję trzeba wyprowadzić z klucza
i obowiązkowej bramki, z zachowaniem wszystkich współrzędnych i miary.

Przypięte T5-a2 opisuje taki argument, lecz nie zawiera plików Lean. Jego
skrypt `verify_t5_uniform_a2.sage:98` sprawdza wystąpienie tekstu
`proper rounding` w backendzie; model błędu w liniach 150–153 przyjmuje RN
binary64. To nie jest kernelowy source theorem dla FPEMU. Wcześniejszy
`t5_conservative_margin.sage` sprawdza arytmetykę z ostrożniejszym U=2^-48,
ale sam też nie dowodzi domains/FFT/source refinement.

Sprawdzono także dostępne eksporty historycznego H3_STABLE_NORMALIZATION:
`StableOutcome.mandatory_before_break` jest lematem boolowskim o koniunkcji,
a `deterministic_gate_transport` transportuje podaną równość. Ich prawdziwe
typy nie dostarczają brakującej semantyki całego KeyGen ani exact-leaf boundu.
Nie przeniesiono mixed source/analytical scope do nowego kernelowego claimu.

Po konstrukcji krat pozostaje transport infinite → finite proposal box,
jednolity ogon dla wszystkich cosetów/przesunięć i tilted scales.

### R: dyskretny rachunek → konkretna masa rawBad

Brakujący zamknięty typ istniejącego modelu:

```lean
FT1536.Run2.GuaranteedDigits.rawLo <=
    FT1536.Run2.LegalKeyErrorTransfer.rawBad ∧
FT1536.Run2.LegalKeyErrorTransfer.rawBad <=
    FT1536.Run2.GuaranteedDigits.rawHi
```

Istnieją ogólne kernelowe twierdzenia o zliczaniu, trójkątach centrowania,
binningu i DFT/splocie. Nie ma jeszcze kernelowego konsumenta dowodzącego,
że konkretny wynik Arb/DFT/Cython oraz wszystkie poprawki obejmują właśnie
powyższą sumę. Hash produktu i 64 małe kontrole tego nie zastępują.

### Finał

Po K/R trzeba instancjować wspólne normalizatory, finite-box tail i odrzucenie,
złożyć istniejący exact cap16/Emit transfer i otrzymać domknięty forall-KeyGen.
W szczególności status `all_key_probability_bound_proved` pozostaje false.
Wartość 1.27e-24 zachowuje dotychczasowy status numeryczny/warunkowy.

## Zachowane nieudane próby i zmiana runnera

- `m6_rejection_margin_001`: namespace shadowing w Lean import path.
  `run/job.py` przedstawia teraz jeden spójny katalog importów za pomocą
  dowiązań do RO cache; wyklucza wszystkie moduły budowane w danym jobie.
  Nie kopiuje całego cache i nie zapisuje przez dowiązania produktów własnych.
  Pierwotna wersja jest zachowana w `clean/tools/development_runner.py`.
- Pozostałe próby m6_* mają źródła i raw logs/receipty, w tym type errors,
  ostrzeżenia i dwa limity heartbeat przy normalizowaniu dużych potęg.
  Limity nie zostały zwiększone; zastosowano symboliczne nierówności zamiast
  rozwijania ogromnych stałych w linarith. Końcowe logi są czyste.
- Podgląd błędów runnera jest ograniczony do 80 wierszy na strumień; pełne
  logi są zachowane w W i przypięte hashami. To ograniczenie wyświetlania,
  nie wyciszanie ostrzeżeń Leana.
