# P01 — REPORT: formalny fundament, semantyka źródła, kontrakt certyfikatów

TASK_ID=`B20_001_P01_FORMAL_FOUNDATIONS`, ROADMAP_ID=F02–F09, para V01.
W=`proofs/ft1536/work/B20_001/P01`, CHECKOUT=`/home/footfalcon/free_falcon_sign`,
BRANCH=main, SOURCE_BASE=`ef62824a10a69962dc8347410ee3f424bfa2b12e`.
Status: **PROVED (zakres PARTIAL_SCOPE)** — 4/4 wymagane eksporty kernel-checked;
pełna instancja pinned modelu; jawne missing types w NEXT_INTERFACE.md.

**Rewizja v2** (po uwagach recenzenta do v1; freeze v1 w `output/` zachowany):
kompletne przypięte źródła/configi/logi replayu w manifeście (`formal/`,
`aux/`, `build/`, `certificates/`, `tools/`, `replay/`); replay odtwarza
pakiet do **nowego DEST** (nic nie kasuje w W autora; brama czystości
potwierdza 0 zapisów); `Debug.lean`/`RedTest.lean` w `aux/` z opisanymi
rolami. Dowody matematyczne i certyfikaty **bez zmian** (produkty bajtowo
identyczne z v1: `33cf2381…`, `a6c06215…`, `16d4ca49…`).

## 1. Stack i bootstrap

- **Lean4.34.0** (`leanprover/lean4:v4.34.0`), **Mathlib4@`5ed2965256430c3649e86755f9576b54eca72435`**
  (tag v4.34.0), **SageMath10.9**. Piny zgodne z TOOLCHAIN_PINS.json.
- Mathlib zmaterializowany w `bootstrap/mathlib4` (git rev = pin; receipt
  `run/logs/acquire_mathlib.log`), build/replay **network-off** (bezpośrednia
  ścieżka toolchainu; `elan` self-update odrzucony — FAILED_ROUTES#3).
- W-only sandbox: HOME/TMPDIR/DOT_SAGE/XDG cache pod W; brak systemowego tmp.

## 2. Wymagane eksporty (INPUT_CONTRACT.required_goal_exports) — 4/4

1. **B20.Foundation.CExec** — `Program → State → Outcome → Prop` z
   konstruktorami dla używanego fragmentu C (`skip/assign/storeU64/seq/ret/
   assumeFalse/unimplemented`) **i wszystkich** error/nonreturn outcomes
   (`stuck/abort/nonreturn/fault`) na granicy `seq` (osobne konstruktory
   `seq_stuck/seq_abort/seq_nonreturn/seq_fault`). Typy słów/pamięci/śladów:
   `Word8/32/64=BitVec`, `Memory`, `State`, `Outcome`, fixed `ABI`,
   modularność unsigned (`u64Add_toNat`). `evalStmt_sound`/`CExec_complete`:
   evaluator ⊆ relacja. Świadoma granica: **semantyka C abstrakcyjna, nie kod
   maszynowy** (TASK §4).
2. **B20.Foundation.SourceBinding** — `PinnedSource → Program → Prop` +
   `checker_sound` (akceptacja checkera ⇒ wiązanie tokeny/AST ↔ semantyka) dla
   dowolnego programu. Dla realnego przypiętego fragmentu `return 0;`
   (tool.c:753, SHA `920ac2d8…377890`) **poprawność translacji** tekstu:
   `translateStmt` (na redukowalnych `List Char`), `source17ReturnZero_
   translation`, `source17ReturnZero_binding`. Mutacje stałej i operatora
   zrywają binding (4 twierdzenia odrzucenia). Synthetic shape witness
   oznaczony osobno (TASK §5).
3. **B20.Foundation.CertificateSound** — exact rational interval ⇒ twierdzenie
   matematyczne: `checkSqrt2 = true → lower < √2 < upper` (ℤ-warunki
   `Certifies`, kernel-checked `decide`); `sqrt2Witness_sound` dla liczb z
   Sage. **Testy negatywne §5 odrzucone**: fałszywa nierówność, odwrócony
   endpoint, brakujący denominator (3× `*_rejected` + `certificate_checker_
   discriminates`). Transport indeksów/rozmiarów: `decodeNat/encodeNat/
   decodeInt`, `decodeNat_encodeNat` (dźwięczność transportu dla każdego
   `Nat`) +4 wiązania pól certyfikatu do literałów checkera (`*_transport`).
4. **B20.Foundation.ObservedKernel** — `ObservedKernel`, `conditionalHistory`,
   `totalVariation`, `directedChi2` na Mathlib PMF (konkretne instancje
   biblioteki) + lematy ogólne oraz **pełna instancja pinned modelu**:
   `pinnedKernel` (deterministyczna egzekucja `source17ReturnZeroProgram`),
   `pinnedObserved`, `pinned_observed_initState`, `pinned_tv_self`,
   `pinned_chi2_self`, `pinned_conditionalHistory_state/fresh`.

Bonus end-to-end (mały rzeczywisty przykład, TASK §4): `endToEnd_chain` —
pinned fragment → model → teza kernela (`source17ReturnZero_exec`) → receipt.

## 3. Rachunek Sage (sage lemma.sage / preparser / ZZ-QQ-balls)

- `run/certificates/gen_sqrt2_certificate.sage` (producer) — **21/21 PASS**:
  tryb preparsera (`parent(1) is ZZ`, `parent(1/3) is QQ`, `2^10=1024`);
  surowe warunki ℤ certyfikatu; `RealBallField(256)` z jawnym promieniem
  (≈2^-255; bound testu świadomy luźny `rad<2^-200`); `RealIntervalField(256)`
  outward rounding; testy negatywne odrzucone; cyfry transportu zgodne.
- `run/certificates/check_certificate.sage` (niezależny konsument JSON) —
  **9/9 PASS**: akceptacja witnessa, odrzucenie3 wadliwych, cyfry, RIF.
- Liczby Sage są **danymi wejściowymi checkera** (CertificateInput) i są
  ponownie sprawdzane kernelowo w Lean (`sqrt2Witness_checked`, `*_transport`)
  — PASS Sage nie jest sam w sobie tezą.
- Kluczowe znalezisko FAILED_ROUTES#15: `QQ.numerator()` redukuje GCD=5;
  checker/transport pracują na surowych ℤ.

## 4. Replay (własny, przed freeze) — procedura v2

`tools/restore_replay.py <NOWY_DEST>` odtwarza pakiet w świeżym katalogu
DEST; W autora tylko do odczytu (brama czystości `find -newer` = 0 zapisów).
6 jobów **wszystkie exit=0** (sage×2, lean rebuild, probe redukcji, printed
types, axiom scan); źródła przed/po identyczne (hash gate, exact set plików
pakietu); semantic match vs EXPECTED.json (5/5 product_checks). Biblioteka
(Mathlib+8 pakietów git) reuse'owana za bramką provenance rev. Dwa replaye
autora: A (zbieranie produktów; identyczność z v1) i B (tryb porównawczy,
`semantic_match=true`) — pinowany w `replay/REPLAY_RESULT.json` +
`replay/logs/`. Receipty: EXECUTION_RECEIPTS.json, SAGE_RUNS.json,
COMMANDS.log.

## 5. Skan aksjomatów (TASK §5)

36 eksportów skanowanych `#print axioms`: **0 aksjomatów celu**; wyłącznie
standardowe `[propext]`, `[propext, Quot.sound]`, `[propext, Classical.choice,
Quot.sound]`; 10 eksportów bez żadnych aksjomatów (m.in. `compile_refines`,
`sqrt2Witness_checked`, cała rodzina `*_rejected`, `*_transport`). Rozkład w
AXIOMS.json. Zakazane skróty: 0 (ASSUMPTIONS.json `forbidden_shortcuts_
checked`).

## 6. Czego nie ma (zgodnie z TASK §8 — brak lematu ≠ założenie)

- kod maszynowy / C→machine refinement (A2, TCB);
- translacja fragmentów source17 bogatych w operatory (np. `fpr_ursh`) —
  jawny missing type dla konsumentów (NEXT_INTERFACE.md);
- pełny front-end C (gramatyka `translateStmt` = `return <stała>;`);
- real PRNG/SHAKE/ChaCha, KeyGen, Sign→Verify — poza zakresem P01.

Wszystkie nieudane trasy (18, w tym3 uwagi recenzenta do v1 naprawione w v2)
z logami/komunikatami: FAILED_ROUTES.md.
owner_accepted=false; werdykt i scope należą do V01.
