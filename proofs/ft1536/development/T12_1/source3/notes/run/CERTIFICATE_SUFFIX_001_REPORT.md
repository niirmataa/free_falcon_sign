# T12.1/source3 — CERTIFICATE_SUFFIX_001

**Wynik autora: PROVED_KERNEL_SCOPED / NOT_REVIEWED.** Dotyczy wyłącznie
suffixu keygen7757–7776, z jawnym wejściem po prefixie, n1536/hn768.
Fresh replay i piny opisano w sekcji7. Nie jest to dowód całego
ft_keygen_leaf_certificate, FFT/LDL prefixu lub successful KeyGen.

Autor: GPT-6 Astra / openai/gpt-6-astra, ta sama sesja
`ses_f12636605ffeL1FZg4teLUwUf5`. Katalog pozostaje
`proofs/ft1536/development/T12_1/source3`; runtime w ignorowanym `.build/`.
Bez migracji/scalania SOURCE_MAP, porządkowania duplikatów, innych modeli
lub uruchamiania recenzenta. Projekt Niirmata; Falcon Project / Thomas
Pornin i licencje źródeł zachowane.

| Cel | Eksport |
|---|---|
| A — niepustość dla całego Legal | `CertificateSuffix001Outcome.reference_exists` |
| B — dokładne bytes/metadata/trace/return | `CertificateSuffix001Outcome.complete` |
| C — roots/frame/sticky/accepted ranges | `CertificateSuffix001Outcome.source_outcome` |
| D — dokładne reverse order i accepted scan | `CertificateSuffix001Outcome.reverse_order` |

## 1. Piny, zależności i Git

Konsumowane jako PROVED_KERNEL_SCOPED / NOT_REVIEWED:

- STABLE_TOP_001 REPORT
  `bff687ddd52b828223a7ee904fe9e0510cbd20eb60c93fcea48e19daa92ba66f`;
- STABLE_TOP_001 CLOSURE
  `1447448efc172809c76c56e2f0cfa6ab73054cf5b47003b57994c447e451e33a`;
- STABLE_BINARY_004 REPORT
  `3bc800efe63cc0b829b44d10d19d7d54dfc72678366a7f71c60e27b4b4378f96`;
- STABLE_BINARY_004 CLOSURE
  `d62d6eb1104879c4b920b9e5a0324d0e2ee78cfcf41f9b8edf434a22d7a1a5e2`.

Nie zmieniono tych raportów ani ich źródeł. Runnery konsumują też
historyczne LeafRange/LeafScan/LeafCertificateSuffix/LeafWordBounds przez
source/product/receipt hashes w `SOURCE3_AUDIT_INPUTS.json`, SHA256
`b0cacca9992875074906188b6e09203598e10d6a785a5791b46f8acdb2b8edb8`.
Nie traktuje się ich historycznego PARTIAL zakresu jako pełnego KeyGen.

| Źródło M0 | SHA256 |
|---|---|
| falcon-keygen.c | `0a09b6ed2363308f54584dfd1e2d33ee1b4601a68c77712c50da920b5074a5cf` |
| fpr-emulated.c | `7cb06c9ea8f8bfc205a207cd73af367d299005d4bfec26333ced702f1c024e5f` |
| fpr-emulated.h | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| Makefile | `25cd0345332882ccab4beea68d5139955c871499733ab9f5fa3cc8ef898d5049` |

Profil: FALCON_ASM_CORTEXM4=0, fpr uint64_t, little-endian, GCC-LP64,
size_t64. Produkcyjnego C ani parametrów nie edytowano.

Właściciel wyjaśnił sprzeczność między wstępem a zakazem push w TASK,
wybierając **„Trzy commity i push”**. Obowiązuje jedna publikacja po trzech
logicznych commitach. Zapisane kroki:
1. `3939e25e`: q_squared/parser/layout;
2. `ad72a2d5`: reverse768, snapshot, write/trace relation;
3. końcowy commit scanu/kompozycji/replay/report — hash w handoffie.

Zastane root AGENTS, STATE, WORK_COMMITS, CURRENT oraz prace run2/t5
pozostają cudzą pracą; nie wchodzą do commitów tego podetapu. Zmiany
ROADMAP dotyczą wyłącznie rozwinięcia T12.1/source3. Nie wykonano
amend/force, pomijania hooks, stages import/tag ani samodzielnego REVIEWED.

## 2. Source q_squared i wejście suffixu

`CertificateQSquared.macro_source` parsuje dokładną linię7446:
`#define FT1536_KEYGEN_Q_SQUARED ((int64_t)339775489)`.
`source_exists/source_exact` konsumują FprScaledBinding/FprScaledBridge
i source fpr_of; rzeczywista konwersja C int literal→int64 jest częścią
referencji. Wynik **`0x41b4409001000000`** jest wyprowadzony z wykonania
scaled/norm/FPR, nie przyjęty jako przesłanka. `exact_real_value` dowodzi
kernelowo odkodowania339775489; Sage/ZZ/QQ jest osobnym cross-checkiem.

`CertificateSuffixSyntax.pinned_source` obejmuje wszystkie20 linii,
alias leaves=t3, scratch=leaves+n, literalne top call, initializer,
reverse destination expression, source div argument order, scan AST
odziedziczony z LeafScan i dokładny return AST z LeafCertificateSuffix.

`CertificateMemory` opisuje entry profile po prefixie: g00/roots768,
t3 backing1792 fpr, bad uint32. Leaves to pierwsze1536 fpr, scratch to
następne256. `alias_and_pointer_add` wiąże źródłowe pointer assignment
z PointerAdd1536 i byte offset12288; scratch end=14336 bajtów od t3.
Alignment, extents, writable regions i separation są jawne. Legal wymaga
reads tylko roots i bad, **bez initial leaves/scratch reads**. Nie ma
positivity roots, Grama, exact-leaf bounds ani delty w warunkach wejścia.

Stan końcowy jest snapshotem **na return edge** statement-suffixu,
z wynikiem return. Addressable bad należy do zastanej ramy funkcji i jest
obserwowalne w tym snapshotcie. Teardown całej enclosing frame i dowód
wywołania całej funkcji nie są częścią tego zakresu.

## 3. Reverse reciprocal:768 kroków i1535-u

`CertificateIndex` wiąże rzeczywisty C99 unsigned expression `n-1-u` z
1535-u. Dowodzi zakresu768…1535, braku underflow/overflow, injectivity,
coverage i guardu. `CertificateReverse.Step` wymaga niezależnych Load64,
source div, stable-positive/RMW, IndexEval i Store64. `Loop/Finished`
są indukcyjne, bez bounded evaluatora; true guards i false guard dają
dokładnie768 kroków przez `final_count`.

`loop_exists/finished_complete` zachowują wszystkie bajty, metadane,
trace i pierwszą połowę. Snapshot D jest **zbudowany z pamięci po top**,
nie założeniem wyniku KeyGen. `Written` dla każdego u<768 wiąże:

```text
source fpr_div(q_squared,D[u]) ⇒ raw
leaf[1535-u] = stableWord(raw)
Event.positive(raw) należy do rzeczywiście wykonanego śladu.
```

`initialized` wyprowadza czytelność całej drugiej połowy i wszystkich
1536 słów. `clear_written` wyprowadza raw positive i brak fallbacku przy
clear. Nie utożsamia żadnego wyniku FPEMU z idealnym realnym q²/D[u].

## 4. Scan i return: pełne byte-memory binding

`CertificateRange` dodaje poprawnie typowany Env dla bits/valid/bad oraz
obu źródłowych makr. Wcześniejszy LeafRange.initial miał macro values poza
type mapą; nowy Env jawnie rozlicza ich typy, zachowując te same wartości.
`ScalarExec` to niezależny C99 Exec sparsowanego LeafRange.tail; jego
exact/exists wyniki połączono z Load32/Store32 bad.

`CertificateScanStep` obejmuje initial Load64, stable-positive, rzeczywisty
Store64, **ponowny odczyt zapisanego leaves[u]**, private-object bitcast,
oba inclusive range expressions i RMW bad. `CertificateScan` dowodzi
1536 kroków i zgodności pamięci z listowym `KeygenLeafGate.scan`.
To projekcja rzeczywistej byte memory przez `Represents`, nie zastępstwo
byte execution samą listą.

`CertificateReturn.Exec` wykonuje niezależnie źródłowe `return bad==0`
przez C99ScalarReference; wynik bool w interfejsie odpowiada C int0/int1.
`CertificateAcceptedScan.accepted/accepted_bytes` konsumują
LeafCertificateSuffix i LeafWordBounds i wyprowadzają:
- bad0 przy wejściu scanu;
- zachowanie wszystkich1536 słów i ich reprezentacji bajtowej;
- positive-finite i literalny inclusive MIN…MAX każdego słowa;
- kernelowe1024≤positiveNormalValue(w)<332054.

To są granice **zapisanych słów**, nie exact LDL leaves.

## 5. Kompozycja i kolejność efektów

`CertificateTop` konsumuje ukończony top oraz jego loop/branch postconditions,
aby wyprowadzić Legal suffixu i czytelność pierwszych768 słów. Nie odtwarza
dowodów prymitywów/stable-binary/top. Później pierwszy snapshot D zasila
reverse; reverse inicjalizuje resztę; scan dostaje całą czytelną tablicę.

Ślad ma jawne konstruktory **positive, lower, upper**. Jest newest-first:
scan-step dopisuje `upper bits :: lower bits :: positive raw :: oldTrace`.
Top checks są mapowane na positive i dołączane z zachowaniem kolejności.
To obejmuje wszystkie rzeczywiście wykonane kontrolne miejsca suffixu,
także dwa range checks. Guardy/counters są osobno rozliczone w semantyce.

`CertificateOrders` dowodzi równoważności obu lhs/rhs orders reverse
assignment: IndexEval zależy od niemodyfikowanych by-value n/u, nie od
heap zmienianego przez RHS. Dotychczasowe checker argument-order rules
obejmują pure pointer bad. Operand div jest value-only po odczycie liścia.
Scan locals bits/valid są świeże w każdej iteracji i kończą scope;
macro globals są typowane i tylko czytane. Full expressions pozostają
w źródłowej kolejności. `CertificateExec` sprawdza rozpoznaną formę AST;
jej normalizacja jest syntaktyczna, nie jest filtrem oczekiwanego wyniku.

## 6. Dokładne końcowe typy

Namespace `FT1536.Source3.CertificateSuffix001Outcome`, z otwartymi
`CertificateMemory`, `CertificateEffects`, `CertificateAtoms`:

```lean
theorem reference_exists (l : Layout) (before : C99MemoryReference.Memory)
    (hl : WellFormed l) (legal : Legal l (C99MemoryBridge.encode before)) :
    ∃ after trace ret, CertificateExec.PinnedExec l before after trace ret

theorem complete (l : Layout) (before after : C99MemoryReference.Memory)
    (trace : List Event) (ret : Bool) (hl : WellFormed l)
    (legal : Legal l (C99MemoryBridge.encode before))
    (source : CertificateExec.PinnedExec l before after trace ret) :
    CertificateExec.run l (C99MemoryBridge.encode before) =
      some ⟨⟨C99MemoryBridge.encode after,trace⟩,ret⟩
```

`source_outcome` ma te same argumenty i przesłanki co complete, a wniosek:

```lean
after.size=before.size ∧ after.writable=before.writable ∧
(∀ i<768, ∀ b : Fin 8,
  after.bytes 0 (l.g00+8*i+b.val)=before.bytes 0 (l.g00+8*i+b.val)) ∧
(∀ block offset, ¬Allowed l ⟨block,offset⟩ →
  after.bytes block offset=before.bytes block offset) ∧
(∀ i<1536,
  (StableBinaryByteView.wordRead (C99MemoryBridge.encode after)
    (StableBinary.addr (leaves l) i)).isSome) ∧
(∀ old : BitVec 32,
  StableBinaryByteView.flagRead (C99MemoryBridge.encode before) l.bad=some old →
  old≠0 → ret=false) ∧
(ret=true →
  StableBinaryByteView.flagRead (C99MemoryBridge.encode before) l.bad=some 0 ∧
  (∀ e∈trace, Good e) ∧
  ∀ i<1536, ∀ w,
    StableBinaryByteView.wordRead (C99MemoryBridge.encode after)
      (StableBinary.addr (leaves l) i)=some w →
    Run2.KeygenLeafGate.positive w=true ∧
    Run2.KeygenLeafGate.lowerBits.toNat≤w.toNat ∧
    w.toNat≤Run2.KeygenLeafGate.upperBits.toNat ∧
    (1024 : ℝ)≤Run2.KeygenLeafGate.positiveNormalValue w ∧
    Run2.KeygenLeafGate.positiveNormalValue w<(332054 : ℝ))
```

`reverse_order` przy tym samym Legal/WellFormed i source ret=true daje
istnienie rzeczywistych topState/reverseState oraz D:Fin768→Word64,
z source judgments top/reverse/scan, Snapshot D przed i po reverse,
zachowaniem wszystkich1536 słów przez scan oraz dla każdego u:

```lean
read l (encode ⟨after,trace⟩) u.val=some (D u) ∧ ∃ raw,
  C99Frontend.primitiveCall "fpr_div".toList
    [.uint64 CertificateQSquared.word,.uint64 (D u)] (.uint64 raw) ∧
  read l (encode ⟨after,trace⟩) (1535-u.val)=some raw ∧
  Run2.KeygenLeafGate.positive raw=true
```

Pełny typ D:

```lean
theorem reverse_order (l : Layout) (before after : C99MemoryReference.Memory)
    (trace : List Event) (hl : WellFormed l)
    (legal : Legal l (C99MemoryBridge.encode before))
    (source : CertificateExec.PinnedExec l before after trace true) :
    ∃ (topState reverseState : State) (D : Fin 768 → BitVec 64),
      CertificateTop.Exec l ⟨before,[]⟩ (decode topState) ∧
      CertificateReverse.Finished l CertificateQSquared.word
        (decode topState) (decode reverseState) ∧
      CertificateScan.Exec l 0 (decode reverseState) ⟨after,trace⟩ ∧
      CertificateReverse.Snapshot l D topState ∧
      CertificateReverse.Snapshot l D reverseState ∧
      (∀ i<1536, read l (encode ⟨after,trace⟩) i=read l reverseState i) ∧
      (∀ i : Fin 768,
        read l (encode ⟨after,trace⟩) i.val=some (D i) ∧ ∃ raw,
          C99Frontend.primitiveCall "fpr_div".toList
            [.uint64 CertificateQSquared.word,.uint64 (D i)] (.uint64 raw) ∧
          read l (encode ⟨after,trace⟩) (1535-i.val)=some raw ∧
          Run2.KeygenLeafGate.positive raw=true)
```

Typy i termy są również w `formal/Source3/CertificateSuffix001Outcome.lean`
i raw audycie.
Nie ma przesłanek successful run, arbitralnego FprCalls ani brakującej
completeness. Niepustość dla każdego Legal nie jest bezwarunkowym return1.

## 7. Replay, mutacje i artefakty

Lean4.34.0/Mathlib z przypiętej closure; -j1/-M6144,
warningAsError, AS12GiB/RSS8GiB/wall1800s per step, network-off.
HOME/TMPDIR/cache/logi w trwałym `.build/`; wszystkie failed attempts,
snapshoty i receipty zachowane. Runner ma preflight; początkowy job
właściciela w run2 nie został zdublowany.

Fresh **certificate_suffix_fresh_001**: **20/20 modułów accepted/clean**,
113 typów/termów/transitive axiom reports z pp.proofs=true.
Czas kroków **137.946s**, maxRSS **5342740KiB**. Wszystkie exit0,
bez warning/error i forbidden proof markers. Aksjomaty: wyłącznie
propext/Classical.choice/Quot.sound albo brak; bez sorryAx/aksjomatu celu.

`tools/certificate_suffix_closure.py record certificate_suffix_fresh_001`
sprawdził source/products/receipts/raw logs i169 przypiętych zależności
oraz bibliotekową granicę importów. Closure:
`notes/run/CERTIFICATE_SUFFIX_001_CLOSURE.json`, SHA256
`657b907273f0bda6e9ecfc5bbeae24bf169cd1bc8e6965f8662b6501f97cfd56`.
Audit source `formal/Source3/CertificateSuffix001Exports.lean`, SHA256
`5051b76879f1564001029b938aed29049061c1d54dfd01977eae662e78ea15a4`.
Pełny stdout typów/termów/axioms:
`.build/jobs/certificate_suffix_fresh_001/logs/Source3_CertificateSuffix001Exports.stdout`.

Sage standard preparser:
- `certificate_q_sage_001`: ZZ/QQ source scaled/FPR, exact word/real constant,
  reverse endpoints i coverage jako cross-check;
- `certificate_c_mutations_002`: **168 wykonań C,26/26 mutantów wykrytych**
  (13 mutacji w normal i UBSan). Przypadki: uniform q, varying roots,
  zero roots, initial bad7, standalone scan MIN/MAX, positive ones/range reject.
  Baseline ma return1 dla uniform/varying, return0 dla zeros/bad7/ones;
  inclusive endpoints scan zwraca1. Full suffix:27648 eventów,
  scan-only:4608; roots i outside-buffer sentinels zachowane.

Mutacje:1535-u→768+u,767/769, błędne q, swap div arguments, first-half
overwrite, omitted reverse/scan/range update, reset bad między etapami,
strict MIN/MAX, błędny return. Porównano pełną reprezentację pamięci,
dokładny trace (kind+word), flagę i return, nie tylko isSome/return.
Syntetyczny C harness instrumentuje kontrolne miejsca i kopiuje bad na
return edge; nie generuje kluczy ani nie wykonuje prywatnego KeyGen.

`certificate_c_mutations_001` przerwano przed kompilacją: literalny
pattern mutatora miał złą liczbę tabulatorów w continuation line. `_002`
bierze dokładne dwie linie przypiętego C. To błąd harnessu, nie C ani
kontrprzykład do proofu. Pozostałe failed Lean attempts dotyczyły
elaboracji, nazw zastrzeżonych, simp/reducibility i standardowego maxRecDepth;
końcowe źródła nie wyciszają ostrzeżeń ani nie zwiększają limitów jobów.

Odtworzenie w komponencie z nowymi jednorazowymi etykietami:

```sh
python3 -B tools/job.py lean NOWY_REPLAY $(python3 -B tools/certificate_suffix_closure.py modules)
python3 -B tools/job.py sage NOWY_Q check_certificate_q.sage
python3 -B tools/job.py sage NOWE_MUTACJE check_certificate_suffix_mutations.sage
```

Raw produkty są ignorowanym runtime z pinami/generatorami; nie trafiają
do zwykłych commitów. Closure zawiera aktualny import graph i dokładne
piny poprzedników. Same hashe ani skończone testy nie zastępują proofu.

## 8. Ocena i dalsze ogniwa

Udało się powiązać cały wskazany suffix z niezależnymi regułami i
rzeczywistą byte memory. Reverse zachowuje odwróconą kolejność i actual
source div, scan zachowuje przy akceptacji wejściowe słowa i daje literalne
bounds oraz realne bounds ich odkodowania. Wszystkie kontrole i return
są częścią kompozycji. Snapshot D i czytelność liści zostały wyprowadzone
z top/reverse, a nie dodane do Legal całego suffixu.

Granica: **autorska semantyka tego statement-suffixu C99/GCC-LP64**,
z jawną normalizacją rozpoznanego AST, by-value locals, pointer views
i return-edge snapshotem. To nie mechaniczny dowód ISO C w całości,
kompilatora, libc albo enclosing frame teardown. Adekwatność tej
formalizacji wymaga niezależnego odbioru wraz z replayem kernela.

Gate00 przed suffixem, FFT/LDL prefix, cały certificate/KeyGen,
real-error FPEMU, exact Gram, T5, M6 i C Sign pozostają dalszymi obowiązkami.
Następny krok: niezależny odbiór tego zakresu i późniejsza kompozycja
z prefixem. Recenzenta wybiera właściciel; koordynator prowadzi review,
archive.py import, stages commit i tag. Nie nadano REVIEWED.
