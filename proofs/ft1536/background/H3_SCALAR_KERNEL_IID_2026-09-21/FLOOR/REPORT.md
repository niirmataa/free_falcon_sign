# FT1536 FPEMU_FLOOR_CT — raport końcowy

2026-09-20. Autor projektu: **Niirmata**.

## Wynik

**FLOOR_CT_CANDIDATE_VALIDATED_FOR_PINNED_BUILD**.

Przygotowano minimalny, bit-preserving kandydat `fpr_floor`. Równoważność
obejmuje wszystkie **2^64 surowe słowa**, przy jawnym source bindingu
C99/GCC14.2.0-19/Linux x86_64 LP64. Kernel Lean dowodzi relacji modeli
i potrzebnych zakresów. Analiza pięciu konkretnych regionów maszynowych
potwierdza usunięcie operand-dependent control flow i adresowania w floor.
Prespecified A/B spełnił kryteria wszystkich trzech rund. Świeży replay
odtworzył **235/235 plików znaczeniowych**.

Status jest kwalifikowaną walidacją jednego buildu. Pomiary mają zakres
**EXPLORATORY_SHARED_HOST_NOT_EXCLUSIVELY_RESERVED**. Nie jest to dowód
czasów instrukcji na wszystkich mikroarchitekturach, całego FPEMU lub Sign.

## Baza i dokładny patch

Baza źródeł: `20ed84a86d9374b026e2ea9ab78f7656a6650a8c`.
Wejściem jest dokładne `inputs/bootstrap/source`, zweryfikowane wraz z całym
bootstrapem:382 członków,381 origins,59892355 bytes. INPUTS obejmuje386
publicznych rekordów, także TASK/AGENTS/manifest. Nie użyto bieżącego indeksu
lub zastanego Extra/c jako bazy. MANIFEST bootstrapu:
`2caffdcc7d805d880e22be683a4529f933d1a1cb59485a3728ae8cf24fdc3c9c`.

Zmiana dotyczy tylko ciała `candidate/source/fpr-emulated.h:fpr_floor`:
lokalny `uint64_t mask` oraz zamiana końcowego signed XOR-select na:

```c
/* FT1536: preserve the raw-word result with an unsigned selection. */
mask = -(uint64_t)((uint32_t)(63 - cc) >> 31);
xi = (int64_t)(((uint64_t)xi & ~mask) | ((-t) & mask));
```

Pełny unified diff jest w PATCH.diff. Prefix, sygnatura, pozostałe bajty
headera i16 innych plików są identyczne. Nie zmieniono flags/Makefile,
parametrów, tablic, half, fpr_lt lub samplera. Zachowano atrybucję źródła;
wkład oznaczono FT1536. Portable C wystarczył: bez asm/barrier/helpera,
attributes, LTO/march lub test-only obejścia. To jedyny mierzony kandydat.

| Pin | SHA-256 |
|---|---|
| Baseline17-file manifest | `2553358fbb1144acdb577e1ad371a017ac325306dd901af745295dd17b03bd5a` |
| Baseline header | `242a7027d854e1317a3382f198271c69d40f4b34e80192ff896a42a65c83edfa` |
| Candidate17-file manifest | `56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985` |
| Candidate header | `6b897d6c217ef25a322e3b5c3d9488b9d6b8d0e369a710d8fce2259f24e6d84f` |
| PATCH.diff | `c95b22821dd54d86f32454ba04774f2c8bb9077fe344c91acc33c72a27b7c684` |

## Równoważność i definedness

`FloorCT.candidate_bit_equivalence` i `FloorCT.all_word64_equivalence`
w formal/FloorWord.lean wiążą rzeczywiste unsigned AND/OR z literalnym
`ZeroScalar.floorC`. Kandydat nie jest aliasem starego modelu. Przebudowano
byte-identical Floor/ValueDomain/SourceFloor z ZERO; nie rozszerzono domeny
floorParts/Nat subtraction przez zmianę nazwy.

`FloorCT.all_word64_defined` daje zakresy xi, cc, counts, flag i wyników.
SEMANTICS/SOURCE_MODEL_BINDING rozliczają także source casts, unsigned wrap,
signed XOR/helper, arithmetic right shift i końcowe uint64→int64 decode
wybranego GCC. cc∈[-962,1085], masked count0..63, helper shifts32 i0..31,
flag0/1. Wspólny signed prefix nie przepełnia int64; nowy selector jest
unsigned. To kernelowy integer/bit proof z jawnym C/ABI bindingiem, **nie
formalnie zweryfikowany front-end/optymalizator GCC**.

NaN/Inf są w tezie surowymi bitami; nie ogłoszono dla nich matematycznej
funkcji floor. Zachowano **floor(+0)=0, floor(-0)=-1**, subnormals i wszystkie
exponent/shift boundaries. FloorConsumers transportuje FLOOR_ZERO oraz
C_INT_BRIDGE przy dokładnie starym NumericCenter
`-2147483283 ≤ val(x) < 2147483282` i pozostałych przesłankach ZERO.

Audit: **8 modułów,41 twierdzeń,15 nowych**, czyste pełne final logs,
types/terms nowych deklaracji i axioms wszystkich konsumowanych twierdzeń.
Tylko standardowe propext/Classical.choice/Quot.sound; bez sorry/admit,
native_decide/Lean.ofReduceBool, aksjomatu wniosku lub wyciszania ostrzeżeń.
EquivAudit.stdout SHA:
`6724257763ae73bb0e41c7a6df3c18c3480c73ae1553eff7e6dd40ee2db2a25f`.
EquivTypes.stdout SHA:
`33f3b50756ea448b4ce1610e79165b3f6e2e6261caf41ac6579a38b813365927`.

## Niezależne kontrole

- **1 065 562** wspólne przypadki baseline/candidate/oracle, normal C oraz
  ASan/UBSan: PASS. Wszystkie2048 exponents, oba znaki,16 mantissa patterns,
  endpoints i1 000 000 publicznych raw words; seed `465431353336464c`.
- Oracle używa exact quotient/ceil pól, bez C XOR/helpera lub hardware FP
  conversion dla NaN/Inf. Dodatkowo33741 dyadic NumericCenter crosschecks.
- **12 288** Lean model values zgodne; oryginalny fpemu_smoke po12 checks
  dla obu wariantów, normal i sanitizers: PASS. LSan nie jest deklarowany.
- Konkretne mutacje równań -0, mask boundary i shift boundary wykryto;
  no-op zachowuje wynik. MUTATION_CONTROLS jawnie odróżnia te kontrole od
  kompilowania zmienionych źródeł. Nie modyfikowano badanego kandydata.

Corpus SHA `72a98cca38cd7345f8b05c863d075bb1f6f2bd2feb2aa5505e668c7f5bbdb663`;
zgodny native output SHA `b96a2cdeb0af6accdf62a825c8bbe9426d11aa92e2c0e99b7959ce244bd29842`.
Testy są kontrolą niezależną od uniwersalnej tezy kernelowej.

## Wyemitowane instrukcje

Oba warianty zbudowano z literalnym `-W -Wall -O` i makrami Makefile,
C99/GCC14.2.0-19, bez sanitizerów w timing build. Wszystkie argv, .s/.i/.d,
disassembly i object/binary hashes zachowano. Binaria są odtwarzane.

Trzy aktywne production calls: falcon-sign.c:2481 BerExp,2542 sampler,
2864 sampler_large. Pozostałe wystąpienia nazwy w17 źródłach to definicja
FPEMU, nieaktywny fpr-double i komentarz kontraktu internal.h.
Sprawdzono te trzy oryginalne inline sites, scalar wrapper i oficjalny
target_floor. Baseline w każdym regionie ma gałąź dla exponent<1022.
Candidate ma tylko rozliczone register operations/data-select cmov, bez
operand-dependent jump/indirect target, load/store/index lub integer div.
Pełny code/taint ledger: artifacts/assembly_ledger.json; nie sam grep `js`.
Baseline falcon-sign.o odtwarza wcześniejszy pin96c71199….

Claim obejmuje samą operację floor. Caller guards, PRNG/refill, rejection
loops, aborts i osiągalność operandów nie stały się przez to CT/proved.

## Prespecified A/B

Kandydat i gotowe semantyczne/assemblerowe kontrole zamrożono przed planem.
TIMING_PLAN SHA:
`733401b207afedae6ae32e559a1599b608c9afed1eca452905899c923e59c676`.
Oficjalny engine commit dc269651fb2567e46755cfb2a13d3875592968b5;
vendor/harness/targets są byte-identical wejściom. Binaries:

- baseline `ee37482efd4b5ca230747a3afb9f2bbaa03b8e4b728cc10e1b03e30e945c2736`;
- candidate `7d25c5f02efc2d8df1980856424eb0ca29d074ae0d18a63300b656d3fbf9472b`.

Trzy rundy, cases1,0,2,3,4. r0/r2 baseline→candidate, r1 odwrotnie;
identyczny order_for(r,case) w parze. Warmup10000/chunk64/batch100000,
generator, callbacks, sink i progi pozostawiono.30 trials ukończono w
**454.495 s**, budżet silnika30 s/trial, każda próba<60 s, globalny limit1800 s.
Jeden worker; własne kompilacje/Lean/replaye zakończono przed pomiarami.

| Kontrola | Wynik |
|---|---|
| Baseline floor,3 kontrasty×3 rundy | **9/9 LEAKAGE_FOUND** |
| Candidate floor,3 kontrasty×3 rundy | **9/9 NO_LEAKAGE_EVIDENCE_YET** |
| Positive controls obu wariantów | **6/6**, sygnał wykryty |
| Negative controls obu wariantów | **6/6**, brak sygnału i wymagane n |
| Minimalne candidate n/class | **31 946 427** (wymagane10^6) |
| Candidate final max(abs(t)) | **1.38734–3.90581** |
| Baseline floor final max(abs(t)) | **115.09395–149.90586** |

Pełne30 wierszy i peak batch values są w TIMING_REPORT. Nie wykonano
retuningu, retry lub wyboru korzystnej rundy. Wszystkie raw/states/percentiles,
orders, stop reasons i snapshots zachowano.9771 batches przeliczono ponownie
przypiętym silnikiem: wszystkie102 stany dokładnie zgodne.

CPU11 potwierdzony non-SMT; Intel Core5 210H, microcode0x6133,
kernel6.12.107+deb13-amd64. Governor powersave, turbo włączone, zmienna
częstotliwość, zasilanie AC. Host współdzielony, bez exclusive reservation;
affinity ani ps w PID namespace nie dowodzą braku cudzych obciążeń.
Kontrole nie wykazały problemu wykonania/sensitivity; interference nie można
wykluczyć. Wynik zachowuje jawny **exploratory timing scope** z TASK.

Dane A/B to90 strumieni/105 części/948531594 bytes, każda część≤32MiB;
pełne hashes i bezstratny reassembler/checker opisuje RAW_FORMAT.
Historyczny kontekst to wyłącznie dostarczona projekcja: własny replay12 raw
(9 floor+3 positive)/24 batches. Maintainer wcześniej przeliczył15 trials,
ale3 negative raw i27 other raw nie są członkami bootstrapu i nie były czytane.
Żaden replay statystyk nie jest drugim statistical oracle lub nowym pomiarem.

## Wpływ i zakres pozostający

IMPACT_MATRIX rozlicza L_RHO/L_NTT/L_V, M0, ZERO, ROOT/NODE3/NODE2/TOWER,
loader/normalization/targets/Reach i Sign-law. Total pure replacement daje
identyczne wyniki i dalsze source states/guards/aborts/pobór coins na tych
samych defined executions. Nie transportuje UB callerów ani nie dowodzi
Reach. Aktywny KeyGen nie ma floor call; K_seed conditioning/p_K pozostają.
Same wartości nie oznaczają identycznego runtime/instruction cost lub tej
samej instancji budżetu t. M0 wyłącza timing; nie dodano epsilon.
Stare certyfikaty zachowują swoje piny; transport jest jawnym nowym bridge.
Known fpr_lt(-0,+0)=1 oraz odrębne half/sampler questions pozostają.

RESULT zapisuje oddzielne osie dowodu i kontroli oraz false:
production_source_changed, new_source_patch_integrated, owner_accepted,
full_backend_ct_proved, full_sign_ct_proved, H3_range_proved,
global_reachability_proved, sampler_law_proved, security_reduction_proved.

## Replay, historia i freeze

Świeży pre-freeze replay: **FRESH_REPLAY_PASS,235/235**,210.484 s,
bez cached binaries/olean. Przebudował kernel, C normal/sanitizers,
assembler i engine oraz ponownie przeliczył wszystkie dostępne42 raw trials.
Pełne receipts/streams są w artifacts/rehearsal; artifacts/fresh_replay.json
zawiera path/SHA każdego odtworzonego pliku. Osobna kotwica bez cyklu:
`c50a1738493314720588b0b94fbc47aedf5a5ffc59fd3d8bd8cc0c85cb1b2661`.
Receipt SHA: `b2ff1cfe74b4acabdfbb29b3ea6d1e62274ea4d9e057ffbbb8eba7991279b9e6`.

Zachowano pierwszą odmowę probe bootstrapu(EACCES zamiast EROFS), pierwotną
nieudaną elaborację FloorWord i wszystkie command/kernel logs. Poprawiony
probe dodatkowo sprawdza RO covering mount; final Lean log jest czysty.
W-only/network-off sandbox, bootstrap/baseline RO; po candidate freeze
także candidate/source RO. Nie użyto Git, sieci, instalacji, kluczy/secrets,
KeyGen/private loader/Sign lub innych wykonawców. Nie pozostał timing worker.

OUTPUT_SCOPE definiuje autorytatywny zakres z pełnymi próbami i raw parts;
zamrożony completed prefix COMMANDS jest członkiem manifestu. Standard
`scripts/replay.py ABSENT_DEST EXPECTED_OUTPUTS_SHA256` najpierw sprawdza
zewnętrzny pin i wszystkie bajty, potem odbudowuje i porównuje235 outputs.
Fizyczny timing jest wyłącznie odrębnym jawnym trybem. Po freeze kontrola
readonly-pakietu zapisuje wyniki tylko do nowego tmp DEST; rezultat i
zewnętrzne SHA REPORT/OUTPUTS są przekazywane w handoffie, bez hash cycle.
Odbiór i decyzja o integracji należą do prowadzącego.
