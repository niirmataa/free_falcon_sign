# V01 — REVIEW: niezależna weryfikacja P01 v2

TASK_ID=`B20_001_V01_FORMAL_FOUNDATIONS`, para `P01`.
Recenzent: **Muse Spark 1.3 Free (opencode/muse-spark-1.3-contributor-free)**,
świeży kontekst, start 2026-09-23 na polecenie właściciela.
W=`proofs/ft1536/work/B20_001/V01`, CHECKOUT=`/home/footfalcon/free_falcon_sign`, BRANCH=`main`.
Autor: MiMo V2.6 Pro (opencode/mimo-v2.6-pro) wg HANDOFF.
`PROVED 4/4` jest deklaracją autora poddaną ocenie.

## VERDICT

**VERDICT: PASS_SCOPED_REVIEW**

Dokładny odebrany zakres (verdict_scope):

- Odebrano 4/4 wymagane eksporty kontraktu w ich **rzeczywiście udowodnionym,
  wąskim zakresie** (kernel-checked, bez mixed-proof substytutu):
  1. `B20.Foundation.CExec : Program → State → Outcome → Prop` + `evalStmt_sound`/
     `CExec_complete`/`compile_refines` — semantyka **abstrakcyjnego fragmentu C**,
     NIE kod maszynowy. Konstruktory dla `skip/assign/storeU64/seq/ret/assumeFalse/
     unimplemented` oraz propagacje `seq_stuck/seq_abort/seq_nonreturn/seq_fault`.
     Ograniczenie: `abort` nie ma bazowego konstruktora (tylko propagacja
     `seq_abort`); `evalStmt` nigdy nie produkuje `abort`; `CExec_complete`
     jest powtórzeniem dźwięczności evaluatora (`CExec p s (evalStmt p s)`),
     nie dowodem determinizmu w stronę przeciwną. Do odnotowania jako
     jawny obowiązek P02, nie wada dźwięczności.
  2. `B20.Foundation.SourceBinding : PinnedSource → Program → Prop` +
     `checker_sound : checkSource src p = true → SourceBinding src p`
     (generyczne, poprawne) + `translateStmt` dla gramatyki
     `return <decimal>;` + `source17ReturnZero_translation/binding` dla
     realnego `return 0;` (tool.c:753, SHA `920ac2d8…377890`, manifest
     source17 `56974571…`). Trzeci koniunkt `SourceBinding`
     (`CExec ↔ SpecExec`) jest trywialny (`compile = id`, `Iff.rfl`).
     Wiązanie tekst→model obejmuje wyłącznie tę wąską gramatykę;
     wybór reprezentacji `fragment = "return 0;"` (bez tabulacji/otoczenia)
     oraz sama obecność `fileSha256` są w TCB (ręczne, nie dowodzone
     wydobycie z pliku). Mutacje stałej/operatora zrywają wiązanie
     (4 twierdzenia). Witness syntetyczny oznaczony osobno.
  3. `B20.Foundation.CertificateSound/certificate_sound :
     checkSqrt2 i = true → (i.lower:ℝ) < √2 < (i.upper:ℝ)` — dźwięczny
     checker exact ℤ (`Certifies`), `sqrt2Witness_sound` dla liczb Sage
     (`1414213562373095/10^15 < √2 < 1414213562373096/10^15`),
     3 kontrole negatywne odrzucone + `certificate_checker_discriminates`,
     transport `decodeNat_encodeNat : ∀ n, decodeNat (encodeNat n) = n`
     + 4 wiązania pól `*_transport` (`decide`). Liczby Sage są danymi
     checkera, ponownie sprawdzonymi kernelowo. Zakres pełny dla formatu
     √2; nowe twierdzenia arytmetyczne wymagają nowych warunków `Certifies`.
  4. `B20.Foundation.ObservedKernel/conditionalHistory/totalVariation/
     directedChi2` na Mathlib `PMF` + **trywialna instancja pinned modelu**
     (deterministyczna egzekucja `source17ReturnZeroProgram`, obserwacja
     „returned 0"): `pinnedKernel/pinnedObserved/pinned_observed_initState/
     pinned_tv_self/pinned_chi2_self/pinned_conditionalHistory_state/fresh`
     + lematy `totalVariation_self_zero/directedChi2_self_zero`.
     Ograniczenia jawne recenzenta (nie deklarowane przez autora jako
     missing, dopisane tutaj jako obowiązki): `conditionalHistory`
     warunkuje wyłącznie po `h.state = a`, **ignoruje `h.observations`**;
     instancje TV/chi² porównują prawo pinned **z nim samym** (0),
     nie pokazują nietrywialnego ograniczenia między różnymi prawami.
     Definicje są poprawne i kernel-checked, ale nie stanowią dowodu
     historycznie-warunkowanej probabilistyki ani dyskryminacji.
     Konsumenci T02–T06/P02–P03 nie mogą ich cytować jako takiej.
- Bonus `endToEnd_chain` (fragment → model → `source17ReturnZero_exec`
  → receipt) odebrany jako mały przykład rzeczywisty, nie jako dowód
  ogólnej poprawności checkera (zgodnie z TASK).
- Jawne missing types (autora + dopisek recenzenta): translacja fragmentów
  bogatych w operatory (np. `fpr_ursh`), refinement C→maszyna (kompilator
  w TCB), pełny front-end C, real PRNG/SHAKE/ChaCha/KeyGen/Sign→Verify
  — oraz dopisek V01: bazowy konstruktor `abort`, determinizm `CExec`
  w stronę przeciwną, obserwacyjne użycie `History.observations`,
  nietrywialne TV/chi² między różnymi kernelami.

Wynik PARTIAL nie odblokowuje brakującej przesłanki następnego zadania.
P02 może startować wyłącznie z powyższych formalnie odebranych eksportów
w ich wąskim zakresie; dostępność biblioteki nie dowodzi jej użycia.

## Binding (potwierdzone piny)

- P01 REPORT_SHA256: `e7431aa06716e2960a86fd60bebea2ea213e770dd3f61b39a00292ac80ddd888`
  (V01/inputs/producer_v2/REPORT.md = P01/output_v2/REPORT.md, zgodne przed/po replayu).
- P01 OUTPUTS_SHA256: `ebd4cff87995d34d318fa86512aef266a3c3c05f6147c81b8bac307cb2553386`
  (62/62 members OK, weryfikacja bajtowa `OUTPUTS.sha256`, higiena ścieżek
  bez `./`/traversal/duplikatów/samoodwołań).
- P01 HEAD (frozen): `85b8e7c4659685ef885e0121164b61e2421a926a` (istnieje,
  `fix: bind B20 reviews…`; bieżący HEAD `8b759c2d…` to późniejszy commit
  koordynatora przygotowujący V01 — nie jest mylony z pinem producenta).
- P01 HANDOFF_SHA256: `fef71b6ad36df51fde6e38991adfccb343300efb2b8f5602ed1f6ee2b8284a67`.
- TASK_SHA256: `477e41e16cee6df9a440be056c270c6761226446540ff39e8aa933750fff5bae`
  (REVIEW_TASK.md); PEER_TASK_SHA256:
  `842abf85eb84d8b6b9eb4a0e4160f37b1fd1e88a965faa04e28db5efde7664e6`.
- MANIFEST_SHA256 (kopia V01): `7e26e2fd558e541d06c4f5e5170cfaadb0a387503529b0c03722d4c6b01624ab`
  (7994 pliki, weryfikacja 7994/7994 OK).
- INPUTS autora: 7930 members; source17 manifest
  `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985`
  (17/17); tool.c SHA `920ac2d8a96408c505670eb2f044cde763ca11945d90ec24d8c6f2a048377890`
  (linia 753 `return 0;` potwierdzona `nl -ba`).
- Certyfikaty (identyczne v1≡v2, odtworzone): `33cf2381…a60a0`,
  `a6c06215…6ddbf`, `16d4ca49…9e57`.
- Toolchain: Lean4.34.0 / Mathlib4@`5ed2965256430c3649e86755f9576b54eca72435`
  + 8 pakietów git (rev-y zgodne) / SageMath10.9 (`sage <file>.sage`,
  preparser). Szczegóły w INTEGRITY.json i TOOLCHAINpins.

Rozbieżność pinów = raport, nie ciche dopasowanie — rozbieżności nie było.

## Replay (własny, świeży DEST)

- Entry: `inputs/producer_v2/tools/restore_replay.py` (rzeczywisty przypięty
  entry; REPLAY.md ma niedokładne `cd` P01 zamiast output_v2 i stary prefiks
  `replay/` w docstringu — odnotowane, nie blokujące, adapter bez edycji
  frozen: uruchomiono z własnej kopii V01).
- DEST: `V01/run/replay_DEST_001` (fresh, nieistniejący przed runem).
  Sandbox W-only: HOME/TMPDIR/TMP/TEMP/DOT_SAGE/XDG pod V01; frozen autora
  i biblioteka tylko do odczytu.
- 6/6 jobów exit=0: `sage_gen_certificate` (1.4s), `sage_check_certificate`
  (1.4s), `lean_rebuild_all` (14.6s, świeży rebuild własnego projektu,
  biblioteka reuse za bramką rev), `lean_probe_reduction` (0.6s),
  `lean_printed_types` (3.1s), `lean_axiom_scan` (3.0s).
- `semantic_match=true`, `sources_unchanged=true` (22 pliki snapshot
  przed/po identyczne), `author_W_writes.clean=true`
  (`find <lib_root> -newer <marker>` puste; ponowna kontrola po runie pusta),
  5/5 product_checks vs EXPECTED.json (4 hashe produktów + statystyki
  axiom scan). Produkty bajtowo identyczne z freeze: certyfikaty i
  `lean_printed_types.stdout` (`f755363c…`).
- `lean_rebuild_all.stdout` różni się od logu autora wyłącznie licznikami/
  czasami buildu (`[1974/2550]` vs `[2028/2618]` itd.) — świeża kompilacja,
  nie kopiowane targety (olean w DEST nowsze od markera, 10 oleanów
  własnego projektu świeżo zbudowanych). Axiom scan i printed types
  identyczne (`diff` puste). Sage stdout identyczne (`d491e967…`,
  `6574171d…`).
- Tryb zbierania bez EXPECTED nie był używany jako porównanie; runner
  wymaga EXPECTED do `semantic_match` (zgodnie z FOCUS).
- Izolacja: `network: off` w receiptach to deklaracja jobów; reuse biblioteki
  przez symlink po bramce rev (jak u autora). Prawdziwy sandbox: RW wyłącznie
  DEST + V01/home/tmp/cache; źródła/biblioteki RO (bramka `find -newer`
  + weryfikacja `git status` Mathlib czysty + rev-y 9 pakietów zgodne).
  `find -newer` jest kontrolą pomocniczą — uzupełniono ją weryfikacją
  świeżych oleanów i exact-set snapshotu. Pełna provenance oleanów
  biblioteki (pochodzenie każdego `.olean`) pozostaje poza pełnym dowodem;
  odnotowane w lukach jako ograniczenie metody, nie przesłanka tezy.

Szczegóły: REPLAY_CHECKS.json, EXECUTION_RECEIPTS.json, INTEGRITY.json,
raw logi w `replay_logs/` i `raw_logs/V01_REPLAY_RESULT.json`.

## Luki (numerowana lista; brak ukrytych desired premises)

1. `CExec`: brak bazowego konstruktora `abort` (tylko `seq_abort`).
   `abort` nieosiągalny; `evalStmt` nigdy go nie produkuje. Nie narusza
   dźwięczności; wymaga jawnego missing type dla konsumentów oczekujących
   `abort`. Kontrprzykład niepotrzebny (teza prawdziwa, słaba).
2. `CExec_complete` to alias dźwięczności, nie determinizm.
   Brak dowodu `CExec p s o → o = evalStmt p s`. Relacja wydaje się
   deterministyczna (rozłączne przesłanki `some/none`, kształty outcome),
   ale nie jest to udowodnione. Konsumenci nie mogą zakładać kompletności
   bez dodatkowego lematu.
3. `SourceBinding`: trzeci koniunkt trywialny (`compile=id`).
   `checker_sound` poprawne, ale nie jest refinementem dowolnego C.
   Realne wiązanie tekstu to wyłącznie `translateStmt` dla
   `return <decimal>;` (pojedyncza spacja, brak otoczenia/whitespace).
   Ręczny wybór `fragment` i samo przechowywanie `fileSha256` w TCB.
   Nie utożsamiać encode/decode ani hasha z translacją operatorów.
4. `conditionalHistory` nie używa `h.observations`
   (`if h.state = a then k.step a else pure fallback`). Nazwa sugeruje
   warunkowanie historią obserwacji; realizacja to przełącznik po stanie.
   Oba lematy (`_state/_fresh`) poprawne dla tej definicji, ale zakres
   to resume po stanie, nie filtracja obserwacyjna. Do rozszerzenia w P02+.
5. `pinned_tv_self/pinned_chi2_self` to instancje `self-zero`
   (prawo vs ono samo). Poprawne (0), ale bez mocy dyskryminacyjnej.
   Brak nietrywialnego ograniczenia między różnymi kernelami — jawny
   obowiązek dalszych zadań gier (T02–T06).
6. `compile_refines : CExec ↔ SpecExec` to `Iff.rfl` (definicyjne).
   Poprawne, ale puste treściowo; nie jest dowodem kompilacji C→maszyna
   (kompilator w TCB, A2).
7. Luźny bound `ball_finite_radius` (`rad < 2^-200` przy obserwowanym
   ≈2^-255, precyzja 256) — świadomy, nie zacieśniany (FAILED_ROUTES).
   Nie wpływa na dźwięczność (RIF i ℤ warunki rozstrzygają).
8. REPLAY.md: niedokładne `cd` i stary prefiks w docstringu sterownika.
   Naprawione przez użycie przypiętego entry z kopii V01 bez edycji
   frozen; adapter udokumentowany (nie jest to luka dowodowa).
9. Proweniencja buildu biblioteki: `git rev-parse HEAD` + `git status`
   czysty + rev-y pakietów zweryfikowane; pochodzenie każdego olean
   (czy zbudowany z tych źródeł, bez podmiany) nie jest w pełni
   dowodzone — ograniczenie metody reuse, nie przesłanka tezy.
   Własny projekt zawsze świeżo rebuildujemy (potwierdzone oleanami).
10. Brak kontrprzykładu do tezy (tezy prawdziwe w zadeklarowanym zakresie).
    Celowe kontrtesty recenzenta (Sage §6): zdegenerowany przedział,
    `+2ulp` dolnej, `[2,3]`, ujemny licznik — wszystkie odrzucone zgodnie
    z arytmetyką ℤ; negatywne próby Lean (`RedTestStringFailures.lean`)
    potwierdzają nieredukowalność `String.*` (błędy `rfl` zachowane).

Brak `sorry/admit/native_decide/Lean.ofReduceBool`/wyciszania warnings
(0 wystąpień). Skan aksjomatów: 36 eksportów, 10 bez aksjomatów, zbiory
`[propext]`, `[propext, Classical.choice, Quot.sound]`,
`[propext, Quot.sound]`; 0 aksjomatów celu. `Debug.lean`/`RedTest.lean`
mają jawne role (aux/README), nie są importowane przez eksporty.

## Co rzeczywiście wykazano / czego nie / wpływ / następny krok

- Wykazano: integralność pakietu (piny, 62/62, 7930, exact-set, certyfikaty),
  świeżą odtwarzalność (6/6, semantic_match), dźwięczność 4 rodzin eksportów
  w wąskim zakresie, poprawność liczb Sage (22/22 niezależne kontrole
  `sage v01_numeric_check.sage` + 21/21 i 9/9 producenta odtworzone),
  transport cyfr, kontrole negatywne i kontrtesty, czysty kernel bez
  zakazanych skrótów.
- Nie wykazano (świadomie poza zakresem lub dopisek V01): maszyny, translacji
  operatorów, pełnego front-endu, PRNG/SHAKE/ChaCha, nietrywialnych boundów
  TV/chi², obserwacyjnego warunkowania, bazy `abort`, determinizmu w obie
  strony. To nie są założenia — to jawne braki do dostarczenia dalej.
- Wpływ: fundament typów/definiuje język dla P02/P03/T02–T06, ale nie
  zastępuje ich dowodów probabilistycznych ani refinementu maszynowego.
  P02 może użyć wyłącznie odebranych eksportów w powyższym zakresie.
- Następny krok: koordynator importuje parę (`archive.py import` autora
  i recenzenta), setter zapisuje `PASS_SCOPED_REVIEW` z pinami recenzji,
  `checkpoint B20_001_P01_FINAL_001 --with-stage B20_001_V01_FINAL_001`,
  commit main jako niirmataa. Bez push. P02 startuje z BOUND odebranych
  eksportów.

owner_accepted=false; push_authorized=false. Joby recenzenta zakończone
(6/6 replay + 1/1 Sage numeryczny + kontrole Lean); brak procesów lake/lean/sage.
