# Nowe inwarianty i dokładna pozostała luka

## Bufor w trakcie etapu

`Mem=Nat→Int`, `store s i x j=if j=i then x else s j`,
`runSteps step(n+1)s=step n(runSteps step n s)`.
Dla injective addr i zapisów local/frame:

```
runSteps step n s (addr b k) =
  if b<n then op b (fun l => s(addr b l)) k else s(addr b k).
```

Dowód: indukcja po każdym n, oddzielne b=n i b≠n, snapshot jeszcze
nieprzetworzonego bloku i frame wszystkich wcześniejszych. Pair count768,
triple count512. Layouty mają dekodery, bounds i cover całych1536 komórek.
`point_prefix` daje analogiczny fakt dla jednoelementowych pętli długości1536.

## Range i dziedziny

`CanonMem s := ∀i<1536, 0<=s i<18433`.
`forward_canonical`, `inverse_canonical` są bezwarunkowymi instancjami dla
rzeczywistych operatorów i harmonogramów, przy canonical wejściu.
`CanonVec`, `canonical_fixed`, `liftForward_agrees`, `liftInverse_agrees`
łączą Fin1536→Int ze źródłową dziedziną canonical. Lift jest definicją
matematycznego interfejsu, nie zmianą wykonania C.

## Domknięty globalny inverse

Expressions.eval_linear jest dowodem indukcyjnym soundness liniowych wyrażeń
source: równość na trzech formalnych wektorach bazowych implikuje równość dla
wszystkich canonical danych bloku. BlockExpressions wiąże wyrażenia z każdym
operatorem SourceModel przez równości definicyjne. BlockChecks sprawdza wszystkie
1024 przypięte wiersze (wyjątek specjalnego i=0 obsługuje root_checked).
local_at używa formalnego row_ids/unitRow_id, więc nie ignoruje fizycznego indeksu.

Stages składa rzeczywiste pętle in-place: inverse stage * forward stage =
scaleMem2/3. Dowód używa prefix_invariant, cover i frame, nie tylko macierzy.
Homogeneity przenosi skalę przez inverse kolejnych etapów. Indukcja
`middle_reverse_inverse` daje scaleMem(2^length ps) dla listy etapów i jej
rzeczywistej listy odwrotnej. Dla ośmiu etapów:

```
inverse cubic ∘ forward cubic                 → factor3
reverse eight inverse binary ∘ eight forward → factor2^8
inverse root ∘ forward root                   → factor2
scale ni6187                                 → ordinary18421
3*2^8*2=1536; 1536*18421=1 (mod18433).
```

Końcowe pełne typy:

```
inverseMem_forwardMem : ∀s, CanonMem s → inverseMem(forwardMem s)=s
inverseC_forwardC : ∀v, CanonVec v → inverseC(forwardC v)=v
inverse_forward : ∀v, liftInverse(liftForward v)=canonical v
```

Ostatnia teza nie przyjmuje forward correctness, inverse correctness,
global invariant ani source-model equivalence jako parametrów.
Jej aksjomaty: propext, Classical.choice, Quot.sound (standard Lean).

## Forward: nowy postęp i brak domknięcia

root_coefficients dowodzi dla KAŻDEGO s i i<768:
dolna połowa = `(s[i]+14649*s[i+768])%q`,
górna = `(s[i]+(1-14649)*s[i+768])%q`.
binary_coefficients dowodzi coefficient-level A±sB dla całego rzeczywistego
etapu, we wszystkich fizycznych parach. Nie udowodniono jeszcze, że po
kolejnych ośmiu etapach te lokalne reszty mają globalne etykiety CRT żądanej Phi.

Dokładnie brakująca teza B:

```
∀ canonical v, ∀i<512, ∀j<3,
 forwardC(v)[3*i+j] =
 (sum k=0..1535, v[k]*(alpha_i*14648^j)^k) mod18433,
 alpha_i=(gmAt(512+i)*5184) mod18433.
```

Najbliższy obowiązek: indukcyjne połączenie coefficient-level split
`binary_coefficients` z wielomianową resztą rodzica modulo X^t−tau i dziecka
modulo X^(t/2)∓s, z etykietami i adresami wszystkich ośmiu etapów. Następnie
trzeba powiązać cubic z ewaluacją w podanym porządku. Fakty tablicowe są
dostępne, lecz nie stanowią same w sobie tego globalnego twierdzenia.

Osobny konsekwentny obowiązek D: dowód multiplicativity dla zachowanej
definicji `productCoefficient/remMonomial`, z canonicalizacją liftu:

```
∀h r, liftForward(product h r)=pointMul(liftForward h)(liftForward r).
```

`Pipeline.L_NTT_pending_forward` ma dokładnie tę jedną jawną przesłankę.
Odwrotność jest już podstawiona z nowego dowodu; nie ma drugiej otwartej
przesłanki inverse_forward. Bez forward_product nie ma pełnego L_NTT ani
podstawienia wyniku PRODUCT przez L_RHO. Ograniczone kontrole ewaluacji
Sage nie zmieniają statusu tych kwantyfikowanych tez.
