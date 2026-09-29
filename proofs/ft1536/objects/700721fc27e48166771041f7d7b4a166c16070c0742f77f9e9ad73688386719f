# V01 — GOAL_TYPE_AUDIT (typy vs kontrakt §3)

Źródło typów: `formal_printed_types.txt` (43 `#check`, produkt `lean_printed_types`,
hash `f755363c…` identyczny w replayu V01).

## 1. B20.Foundation.CExec

- Drukowane: `B20.Foundation.CExec : Program → State → Outcome → Prop` — zgodne.
- `Program = CStmt` (`skip/assign/storeU64/seq/ret/assumeFalse/unimplemented`);
  `State = {mem, locals}`; `Memory.bytes : Nat → Option Word8`;
  `Word8/32/64 = BitVec`; `ABI` fixed (deklarowany, nie dowodzony z hardware);
  `u64Add` modularny (`u64Add_toNat`).
- `Outcome = returned/stuck/abort/nonreturn/fault` — 4 nienormalne parami rozłączne
  (7 lematów `*_ne_*`).
- Konstruktory CExec (14): `skip`, `assign_ok/assign_err`, `store_ok/store_err`,
  `ret_ok/ret_err`, `seq_returned/seq_stuck/seq_abort/seq_nonreturn/seq_fault`,
  `assume_false`, `unimplemented`. Pokrywają używany fragment i propagacje
  wszystkich 4 outcomes na granicy `seq`. **Luka**: brak bazy `abort`
  (nieosiągalny); odnotowana w REVIEW i REVIEW_RESULT.
- `evalStmt_sound/CExec_complete : ∀ p s, CExec p s (evalStmt p s)` — ten sam
  kierunek (evaluator ⊆ relacja); brak konwersu. Nazwa `complete` myląca,
  treść prawdziwa w jedną stronę.

## 2. B20.Foundation.SourceBinding

- Drukowane: `SourceBinding : PinnedSource → CStmt → Prop`; `checker_sound :
  checkSource src p = true → SourceBinding src p` — zgodne.
- `PinnedSource = {name,fileSha256,fragment,tokens}`; `SourceToken = name/num`.
- `checkSource = decide (tokens = encodeStmt p) && decide (decodeStmt = some p)`.
- `translateStmt : String → Option CStmt` (przez `translateChars : List Char → …`,
  redukowalne prymitywy; podstawa: pozytywny probe `RedTest.lean`).
- `SourceTranslation src p := translateStmt src.fragment = some p`.
- Instancja: `source17ReturnZeroFragment` (`return 0;`, fileSha `920ac2d8…`)
  → `source17ReturnZeroProgram` (`.ret (.const 0)`); `translation` i `binding`
  przez `decide`. Mutacje (`return 1;`, `goto 0;`) odrzucone na obu warstwach.
- Trzeci koniunkt `SourceBinding` (`∀ s o, CExec ↔ SpecExec`) trywialny
  (`compile=id`). Zakres translacji: wyłącznie `return <decimal>;`.

## 3. B20.Foundation.CertificateSound

- Drukowane: `certificate_sound/CertificateSound : ∀ i, checkSqrt2 i = true →
  (i.lower:ℝ) < √2 < (i.upper:ℝ)` — zgodne.
- `RationalInterval = {lowerNum,lowerDen,upperNum,upperDen : Int}`;
  `Certifies` = dodatniość + `lower²<2·lowerDen²` + `2·upperDen²<upperNum²`
  + uporządkowanie (exact ℤ, `decide`); `checkSqrt2 = decide Certifies`.
- `sqrt2Witness` z `CertificateInput` (`1414213562373095/10^15`,
  `1414213562373096/10^15`); `sqrt2Witness_checked` (`decide`) i `sound`.
- Negatywy: `false/reversed/missing` (`decide` → false) + `discriminates`.
- Transport: `decodeNat/encodeNat/decodeInt`; `decodeNat_encodeNat : ∀ n,
  decodeNat (encodeNat n) = n` (indukcja po fuel); 4× `*_transport` (`decide`)
  wiążą cyfry Sage z literałami Lean. Cyfry zgodne (Sage §5, Lean, JSON).

## 4. B20.Foundation.ObservedKernel (+ TV/chi²/history)

- Drukowane: `ObservedKernel : Type → Type → Type`; `conditionalHistory :
  ObservedKernel α β → History α β → α → PMF β`; `totalVariation :
  PMF → PMF → ℝ`; `directedChi2 : PMF → PMF → WithTop ℝ` — zgodne.
- `ObservedKernel = {step, observation, fallback}`; `History = {state,
  observations}`; `conditionalHistory k h a = if h.state = a then k.step a
  else pure fallback` — **ignoruje `observations`**.
- `totalVariation = (∑ |p−q|)/2`; `directedChi2 = ⊤` gdy `p` poza wsparciem
  `q`, inaczej `∑ (p−q)²/q`. Lematy `self_zero` poprawne.
- Instancja pinned: `pinnedKernel` (deterministyczny `evalStmt
  source17ReturnZeroProgram`, obserwacja `w == 0`, fallback `stuck`),
  `pinnedObserved = pure (observation …)`, `pinned_observed_initState`,
  `pinned_tv_self/pinned_chi2_self` (self-vs-self = 0),
  `pinned_conditionalHistory_state/fresh` (dwa ramiona `if`).
- Wszystkie na Mathlib `PMF` (konkretne instancje biblioteki). Zakres:
  definicje + trywialne self-instancje; brak nietrywialnych boundów.

## End-to-end

- `endToEnd_chain : SourceTranslation … ∧ CExec … returned 0 … ∧
  sqrt2Witness.checkSqrt2 = true` — kompozycja `translation + ret_ok +
  certificate`. Mały przykład rzeczywisty, nie dowód ogólnego checkera.

Wniosek: typy realizują cel bez osłabienia w zadeklarowanym wąskim zakresie;
każda zmiana zakresu (abort baza, obserwacje, nietrywialne TV/chi², operatory,
maszyna, frontend, PRNG) wymaga nowego lematu — nie jest założeniem.
