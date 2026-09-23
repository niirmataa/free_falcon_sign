# P01 — NEXT_INTERFACE (dla konsumentów P02/P03 i dalej)

## Co wolno konsumować natychmiast (odebrane eksporty po V01)

- `B20.Foundation.CExec` + `evalStmt_sound/CExec_complete/compile_refines` —
  semantyka modelowanego fragmentu C; **nowe składniki C wymagają rozszerzenia
  gramatyki i nowych konstruktorów** (zgłoś do P01-suplement lub nowy TASK).
- `SourceBinding` + `checker_sound` — generyczne dla dowolnego programu;
  nowe fragmenty tekstowe podpinamy przez `translateStmt` (obecnie
  `return <stała>;`) lub przez bezpośredni `tokens`+`SourceTranslation`-zapis.
- `CertificateSound` — format exact rational interval; nowe twierdzenia
  arytmetyczne = nowe `Certifies`-warunki + checker w tym samym schemacie
  (ℤ-decidable ⇒ `decide`).
- `Transport.decodeNat_encodeNat` — transport liczb/rozmiarów/indeksów z
  JSON Sage do literałów Lean; `*_transport` pokazuje schemat wiązania pól.
- `ObservedKernel/totalVariation/directedChi2/conditionalHistory` + schemat
  instancji pinned modelu (`pinnedKernel`) — podmieniamy `step` na własny
  kernel gry; lematy self-zero są generyczne.

## Jawne missing types do dostarczenia przez dalsze zadania

1. **Translacja fragmentów bogatych w operatory** (np. `fpr_ursh`: `^=`,
   `>>`, `&`, `-(uint64_t)`): nowe konstruktory `CExpr` (binop/xor/shift),
   `evalExpr` dla nich, `encodeStmt/decodeStmt`, mutacje, binding tekstu.
   To NIE jest założenie — brak tej translacji jest udokumentowany
   (ASSUMPTIONS A3, FAILED_ROUTES „brakujące typy").
2. **C→machine refinement** (kompilator w TCB; A2).
3. **Real PRNG bridge / SHAKE / ChaCha / KeyGen / Sign→Verify** — poza
   zakresem fundamentu; potrzebują też definicji gier (T02-T06).
4. Pełny front-end C (gramatyka `translateStmt` jest zamierzenie wąska).

## Konwencje

- Liczby z Sage: zawsze surowe ℤ (NIE `QQ.numerator()` — redukcja GCD!)
  i zawsze ponownie sprawdzone kernelowo w Lean.
- Testy negatywne (fałszywa nierówność/odwrócony endpoint/brakujący
  denominator/mutacje źródła) są obowiązkowym dodatkiem do każdego nowego
  checkera (TASK §5).
- Skan `#print axioms` każdego eksportu do AXIOMS danego TASK.
