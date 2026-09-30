# Konkretny most NTRU / włókna / gate — postęp kernelowy

Status: **WORKING, bez freeze; końcowa nierówność forall-KeyGen nadal OPEN**.
Kontynuacja na polecenie „stworz wiec dowod kernelowy”; ta sama sesja i W.

## Udowodnione i powiązane z obecnym modelem

### 1. Reprezentacja pierścienia

`CoefficientQuotient.lean` konstruuje bijekcję pomiędzy istniejącym układem
1536 współczynników a `AdjoinRoot (X^1536-X^768+1)` nad dowolnym
niezerowym pierścieniem przemiennym. Obie strony inverse są dowiedzione.

`QuotientOperations.lean` dowodzi zgodności dodawania, odejmowania,
mnożenia i redukcji modulo18433. W szczególności eksporty odnoszą się do
istniejących `Relation.mulRq` i `Relation.A`, a nie do nowej podmienionej mapy.
Jądro redukcji nad pierścieniem całkowitoliczbowym to dokładnie wielokrotności
18433, a mnożenie przez18433 jest injektywne; tych faktów nie przyjęto jako
przesłanek instancji FT1536.

### 2. Całe włókno i baza NTRU

`NTRUBasis.lean` konstruuje bijekcję przez bazę `(g,G;-f,-F)` z jawnie
wyprowadzonym odzyskaniem obu współrzędnych. Nie przyjmuje jako przesłanki
determinantu, indeksu ani surjektywności bazy.

`ActualNTRUFiber.lean` instancjuje wynik dla rzeczywistej reprezentacji
`Geometry.Vec` / `Relation.Rq` i każdego celu `c`. Przy naturalnych równaniach
NTRU, public-key i odwracalności f uzyskuje:

```
coordinates : (Vec × Vec) ≃ { z : Vec × Vec // Relation.A h z = c }
coordinates u = (centerRq c,0) + (g*u1+G*u2,-f*u1-F*u2)
```

Każdy punkt włókna ma dokładnie jedną parę współrzędnych. Dowiedziono również
`gaussian_fiber_in_basis`: reindeksowanie konkretnej sumy Gaussa o normie
`Geometry.Q` przez tę jawną bazę. Dotyczy wszystkich współczynników i celów,
nie małego modelu testowego. Same równania wejściowe nadal muszą zostać
wyprowadzone z semantyki successful source KeyGen.

### 3. Bitowy model obowiązkowej bramki

`KeygenLeafGate.lean` używa `BitVec64`/`BitVec32`, literalnych stałych
`0x4090000053700377` / `0x4114444d1a037d50` oraz unsigned subtraction,
shift/cast/xor/and/or z helpers i pętli akceptacji.

Udowodniono dla wszystkich słów i wszystkich początkowych bad flags:

- clear wynik pętli implikuje clear początkowy flag i legalność każdego liścia;
- fallback nie może ukryć nielegalnego wejścia przy zwracanym clear flag;
- zaakceptowana pętla zachowuje oryginalne słowa;
- każdy zaakceptowany liść ma dodatnie legalne słowo w zadanym zakresie,
  z `positiveNormalValue >= 1024`.

To theorem o jawnym modelu operacji słowowych. Nie dopisano nieistniejącego
dowodu parsowania/refinement całego `falcon_keygen_make` do tej pętli.
Minimum słowa maszynowego nie jest jeszcze minimum exact LDL leaf.

### 4. Cała kolejność exact stable leaves

`StableLeafAlgebra.lean` / `StableLeafSchedule.lean` dowodzą uniwersalnych
tożsamości reciprocal dla binarnych i ternarnych pivotów, a następnie dla
całej rekurencji w kolejności source: trzy branches, osiem binary levels,
reverse reciprocal druga połowa. Instancja FT1536 ma768 primary /1536 full.
Dowiedziono też, że lower >=991 wszystkich pełnych exact leaves daje
upper <=q²/991, bez założenia tego upper osobno.

Brakujące utożsamienie tej listy z LDL konkretnego coefficient Gram nie jest
ukryte w deklaracjach — to nadal osobny następny lemat.

## Wykonanie

- `run/m6_kernel_binding_fresh_001`: świeże lokalne .olean dla **41/41**
  własnych modułów pełnej zależności tych wyników wraz z wcześniejszą analityką
  M6; exit0, czyste stdout/stderr. Biblioteki Lean/Mathlib pozostają RO cache.
- `Run2.M6Audit` i `Run2.KernelBindingAudit`:31 głównych eksportów z drukowanymi
  typami i standardowymi transitive axioms, bez sorry/niestandardowego aksjomatu.
- `run/m6_binding_controls_002`: `sage kernel_binding_controls.sage ...`,exit0;
  exact QQ/symboliczne NTRU identities i pełnowymiarowa kontrola ordering na
  jawnym syntetycznym spektrum. Kontrole graniczne słów nie są próbą kluczy.
- `run/KERNEL_BINDING_RECEIPT.json` wiąże źródła, receipty, logi i rzeczywiste
  zakresy. Nie jest finalnym OUTPUTS całego RUN_002.

## Pozostały główny dowód

1. Literalne successful source execution → naturalne równania NTRU/public
   oraz zaakceptowane rzeczywiste słowa i właściwy stan pamięci.
2. FPEMU FFT / stable operations → exact spectral roots i leaves, ze
   sprawdzonymi domenami i błędem; w szczególności source value>=1024 →
   exact leaf>991. Nie wolno założyć RN binary64 na podstawie komentarza C.
3. Exact spectrum/stable schedule → LDL konkretnego Gram powyższej bazy,
   następnie affine shift i skala dla udowodnionego trójkątnego Gaussa.
4. Infinite→finite-box/tilt/tails oraz kernelowe powiązanie konkretnego
   rachunku radialnego z `rawBad`. Zamknięty typ tego ostatniego obowiązku
   pozostaje zapisany w `M6_BINDING_STATUS.md`.
5. Instancjacja cap16/Emit i końcowy domknięty forall-KeyGen z przedziałem.

Nowe wyniki zamykają konkretne ogniwa algebraiczne. Nie uzyskano jeszcze
całego wymaganego proofu prawdopodobieństwa; 1.27e-24 pozostaje warunkowe.

## Failed routes / przerwania

Wszystkie próby m6_ntru_*,m6_coefficient_*,m6_quotient_*,m6_actual_ntru_*,
m6_leaf_gate_*,m6_stable_* mają zachowane źródła i raw logs. Recursion allowance
32768 w dwóch modułach degree1536 odpowiada istniejącemu PolynomialReference;
pozostałe limity nie zmieniły się. W mapowaniu phi użyto lematu parametrycznego
po wykładnikach zamiast rozwijania konkretnych potęg w simplifierze.

Próba Sage controls_001 błędnie użyła `^` dla bitowego XOR; standardowy
preparser potraktował to jako potęgę i kontrola graniczna ją odrzuciła.
W controls_002 użyto właściwego `^^`. To naprawa checkera, nie kodu FT1536.
Nieudany przebieg zachowano. Przerwania transportu nie pozostawiły compute
joba do dublowania; stan procesów sprawdzono przed kontynuacjami.
