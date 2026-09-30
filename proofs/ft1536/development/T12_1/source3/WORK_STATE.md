# T12.1/source3 — żywy stan

Status: **ACTIVE / CERTIFICATE_SUFFIX_001 / WORKING**.
Wykonawca: GPT-6 Astra / openai/gpt-6-astra.
Sesja: `ses_f12636605ffeL1FZg4teLUwUf5` (bez nowej sesji/workera).

**Aktualne doprecyzowanie właściciela: „Trzy commity i push”.**
W pytaniu o sprzeczność z zakazem push we wklejonym TASK właściciel wybrał
opcję potwierdzającą nową zgodę: po trzech logicznych commitach tego
podetapu push na origin/main. Nie publikujemy między tymi krokami.
Poprzedni etap STABLE_TOP_001 pozostaje PROVED_KERNEL_SCOPED / NOT_REVIEWED.

## CERTIFICATE_SUFFIX_001 — bieżący zakres

Pozostajemy w source3, bez migracji/scalania/SOURCE_MAP/duplikatów.
Piny top REPORT `bff687ddd52b828223a7ee904fe9e0510cbd20eb60c93fcea48e19daa92ba66f`
i CLOSURE `1447448efc172809c76c56e2f0cfa6ab73054cf5b47003b57994c447e451e33a`
sprawdzone. Baza nadal NOT_REVIEWED.

Trzy logiczne commity:
1. q_squared z source fpr_of/scaled, parser suffixu i wejściowy layout/profil:
   PROVED_KERNEL_SCOPED, `CertificateQSquared.source_exists/source_exact`,
   `exact_real_value`, `CertificateSuffixSyntax.pinned_source`,
   `CertificateMemory.alias_and_pointer_add/top_legal`.
   Word `0x41b4409001000000`, decoded339775489, scratch=t3+12288 bajtów.
   Jobs `certificate_q_sage_001`, `certificate_q_002`,
   `certificate_syntax_memory_002` (syntax), `certificate_memory_003` clean.
2. Reverse reciprocal768: `CertificateIndex.index_exact/bounds/injective/covers`,
   `CertificateReverse.loop_exists/finished_complete/initialized/clear_written`.
   Snapshot pierwszej połowy zachowany, druga inicjalizowana pod1535-u;
   każdy div witness ma odpowiadający event w rzeczywistym śladzie.
   Jobs effects002/atoms001/index002/reverse004 accepted/clean.
3. Byte-memory scan1536/return, pełna kompozycja, source outcomes/reverse_order,
   mutacje i fresh closure oraz raport/handoff; następnie uzgodniony push.

Na początku wykryto job Lean właściciela w run2; nie uruchamiano drugiego
joba. Edycje źródeł i przygotowanie są niezależne, każde wykonanie ma preflight.
Zastane AGENTS/STATE/WORK_COMMITS/CURRENT i run2 pozostają cudzą pracą.

Commit1/3: `3939e25e` (q_squared/parser/layout), lokalny; push po trzecim.
Reverse ma etapowy warunek Snapshot D; końcowa kompozycja ma go wyprowadzić
z top, nie przenieść do dodatkowych assumptions całego suffixu.

## Przejęcie2026-09-30

Zweryfikowano5/5 source/target hashes według
`HANDOFF_RECONCILIATION_20260930_001.json`, SHA256
`d6e460b94b858dfbb65bb2d6c725a477d932e3fcbfeb9903bc4ea36524518eb2`.
Rozliczenie: commit `c358871ab99f4aabfefc78d0b6be873852f2678e`, main=origin/main.
Pięć historycznych różnic `pending source3` jest rozliczonych, BASELINE
pozostaje niezmieniony. Stan run2/t5 nie jest przejmowany.
Zastana zmiana `docs/onboarding/STATE.md` należy do innej pracy.

Źródła: `proofs/ft1536/development/T12_1/source3/{formal,sage,tools}`.
Runtime: ten komponent `.build/{jobs,cache,preflight}`.
Stary RUN_003 W oraz `tools/original/` i wcześniejsze notatki są read-only
proweniencją. STABLE_BINARY_004: PROVED_KERNEL_SCOPED / NOT_REVIEWED,
REPORT `3bc800efe63cc0b829b44d10d19d7d54dfc72678366a7f71c60e27b4b4378f96`,
CLOSURE `d62d6eb1104879c4b920b9e5a0324d0e2ee78cfcf41f9b8edf434a22d7a1a5e2`.

## Bieżąca kolejność

1. Rebinding runnera zakończony: `tools/job.py`,
   `.build/jobs/stable_top_bootstrap_001` accepted/clean,1.016s.
   Sprawdzono import pinowanych eksportów `_004`; nie odtwarzano ich dowodów.
2. Source fpr_of(3)→fpr_scaled(3,0), norm/FPR **PROVED_KERNEL_SCOPED**:
   `FprOfThree.source_exists` i `source_exact`, słowo `0x4008000000000000`.
   `FprScaledBinding` wiąże parser C/headera/makra; `FprScaledBridge`
   dowodzi obu kierunków zgodności reference i modelu.
3. Parser całego top `StableTopSyntax.pinned_source`, reference i dokładny
   most pętli `StableTopBodyBridge.loop_complete`: accepted/clean.
   `StableTopLoop.loop_exists/filled_all/counters` dowodzą256 iteracji,
   u=3*v i inicjalizacji768 leaves bez initial leaves/scratch reads.
4. Legalność następnych gałęzi i wspólny scratch: domknięte przez
   `StableTopBranchLayout`, `StableTopBinaryBridge`, `StableTopBranches`.
5. Istnienie/reference→operational/source outcome: `StableTop001Outcome`.
   Fresh23/23 moduły,119 twierdzeń accepted/clean; pełna pamięć/metadata/trace.

Małe lokalne commity własnych plików po logicznych krokach; push wyłącznie
po nowym sygnale właściciela. Okno Git przekazane przez właściciela/koordynatora.
Bez przyjmowania cudzych zmian,
bez amend/force, innych modeli, samodzielnego REVIEWED lub zmian C.

Uruchamianie z katalogu komponentu:
`python3 -B tools/job.py lean <jednorazowa_etykieta> Source3.Modul ...`
lub `python3 -B tools/job.py sage <jednorazowa_etykieta> nazwa.sage`.
Runner sprawdza source/product piny konsumowanych zależności, zapisuje
snapshot źródła, SOURCE_INPUTS i RECEIPTS, izoluje sieć i zapis do jobu,
utrzymuje -j1/-M6144, AS12GiB/RSS8GiB/wall1800s oraz warningAsError.

## Zapisane kroki

- `d3e50a19`: przejęcie+runner+bootstrap, wypchnięty na origin/main.
- `c679746c`: fpr_of3, wypchnięty przed późniejszym zakazem push.
  Jobs `stable_top_scaled_binding_001`, `stable_top_scaled_bridge_001`,
  `stable_top_of_three_003`, `stable_top_of_three_audit_001` accepted/clean;
  raw failed `_001/_002` zachowane. Typy/termy/aksjomaty w audycie.
- `stable_top_inputs_sage_001`: `sage check_stable_top_inputs.sage`,
  ZZ/QQ exact fpr_scaled/FPR cross-check daje3; kontrola indeksów768 i
  dwóch mutantów harmonogramu. To diagnostyka, nie dowód całej pętli.

Pętla: `stable_top_syntax_001`, `stable_top_expr_memory_002` (Expr),
`stable_top_memory_003`, `stable_top_effects_001`, `stable_top_reference_001`,
`stable_top_atoms_001`, `stable_top_body_bridge_002`, `stable_top_body_total_002`,
`stable_top_loop_002` accepted/clean. Źródłowe12 kontroli/iterację, pełne
nawiasowanie, Legal oraz przenoszony invariant frame/sticky/clear.
## Wynik STABLE_TOP_001 — do niezależnego odbioru

- `StableTop001Outcome.reference_exists`: każdy legalny before ma
  niezależne source execution, dowolne roots/bad, bez initial leaves/scratch.
- `StableTop001Outcome.source_outcome`: exact operational heap/metadata/
  trace, roots i frame, sticky dowolnego bad≠0, clear→initial clear oraz
  positive-finite/no-fallback wszystkich kontroli top i trzech binary.
- Scope: autorska semantyka fragmentu C99/GCC-LP64 i source binding,
  nie dowód całego ISO/kompilatora ani pełnego M6/KeyGen/Sign.
- `.build/jobs/stable_top_fresh_001`:23/23 accepted/clean,119 audytowanych
  twierdzeń,110.151s,maxRSS4224628KiB; standardowe aksjomaty albo brak.
- `notes/run/STABLE_TOP_001_CLOSURE.json`, SHA256
  `1447448efc172809c76c56e2f0cfa6ab73054cf5b47003b57994c447e451e33a`.
  Raport: `notes/run/STABLE_TOP_001_REPORT.md`; materiał odbiorczy:
  `notes/run/STABLE_TOP_001_REVIEW_TASK.md`.
  REPORT SHA256 `bff687ddd52b828223a7ee904fe9e0510cbd20eb60c93fcea48e19daa92ba66f`.
- Sage C probes:18 wykonań normal/UBSan,16/16 wykrytych mutantów,
  baseline22272 kontroli. Pierwszy probe `_001` nie wykrył mul→add przy
  c=1/dużym ab (zaokrąglenie); zachowany, dane w `_002` poprawione.
- `24ef6865`: lokalny commit parser/pętla. Kolejny końcowy commit jest
  zgłaszany hashem w handoffie. Żadnego push po poleceniu wstrzymania.

Następny krok: właściciel/koordynator organizuje niezależny odbiór;
recenzenta nie uruchomiono. Brak otwartego typu wymaganego dla tego
scoped stable-top; reverse reciprocal, pełny certificate, real-error,
FFT/exact Gram, KeyGen, T5, M6 i C Sign pozostają kolejnymi obowiązkami.
