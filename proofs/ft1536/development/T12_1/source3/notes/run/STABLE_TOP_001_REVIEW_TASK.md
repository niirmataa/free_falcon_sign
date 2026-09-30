# STABLE_TOP_001 — materiał do niezależnego odbioru

Status: **PREPARED_OWNER_START**. Wykonawca/autor: GPT-6 Astra,
sesja `ses_f12636605ffeL1FZg4teLUwUf5`. Recenzenta nie uruchomiono.
Model i osobny W recenzenta wybiera właściciel; koordynator prowadzi
odbiór, późniejszy import przez archive.py, commit stages i tag.

## Kotwice

Katalog autora: `proofs/ft1536/development/T12_1/source3/`.
Wszystkie poniższe ścieżki są względem tego komponentu:

| Artefakt | SHA256 |
|---|---|
| `notes/run/STABLE_TOP_001_REPORT.md` | `bff687ddd52b828223a7ee904fe9e0510cbd20eb60c93fcea48e19daa92ba66f` |
| `notes/run/STABLE_TOP_001_CLOSURE.json` | `1447448efc172809c76c56e2f0cfa6ab73054cf5b47003b57994c447e451e33a` |
| `formal/Source3/StableTop001Outcome.lean` | `ac314e958b39ec3b3d339b075a67f89d876f5f6d64eba5cc21863a1dc6079b3b` |
| `.build/jobs/stable_top_fresh_001/RECEIPTS.json` | `1083be120fba201c138d3f727dd3a2bb92e4c42a88c04e83d838e4f42f053f8c` |
| `.build/jobs/stable_top_c_mutations_002/STABLE_TOP_MUTATIONS.json` | `0f5485f6f90e23bd4be8a623de2e505e708bcc6cbfb11a2e3102f8c1da68e142` |

Zależność `_004` zachowuje osobny status PROVED_KERNEL_SCOPED / NOT_REVIEWED:
REPORT `3bc800efe63cc0b829b44d10d19d7d54dfc72678366a7f71c60e27b4b4378f96`,
CLOSURE `d62d6eb1104879c4b920b9e5a0324d0e2ee78cfcf41f9b8edf434a22d7a1a5e2`.
Odbiór top nie zastępuje odbioru poprzednika przez milczący awans statusu.

## Zadanie

Niezależnie oceń:

1. Source binding wszystkich27 linii keygen7516–7542 do sterującego AST:
   parametry/const roots, deklaracje, initializer, comma u/v, bound768,
   kroki3/1, dokładne drzewa add/mul/div,12 kontroli i offsety stores/calls.
2. fpr_of(3): C M0 scaled150–204, norm block, FPR; AST emitter jest
   niezaufany, Binding musi być sprawdzony kernelowo. Obejrzyj konwersję
   C int3 do int64, exact reference result i istnienie, bez przesłanki słowa3.
3. Niezależność reference Step/Body/Loop/Branches/Exec od operational run.
   Szczególnie oceń wyspecjalizowaną normalizację locals do Env/SSA,
   size_t views, source declarations/lifetime i `StableTopControl`.
   Normalizacja dozwolonych argument/lhs/rhs orders wymaga pure adresów
   i pure value operands; nie uznawaj jej automatycznie za dowód ISO C.
4. Legal/WellFormed: roots768 read-only, leaves768 writes, scratch256,
   bad32; alignment/extent/separation/LP64. Brak initial leaves/scratch
   reads i brak positivity/Gram/exact-leaf/delta założeń. Sprawdź invariant
   u=3*v, final false guard256 i Filled256→czytelność wszystkich leaves.
5. Każda binary256 na swoim przesunięciu, wspólne scratch/bad, Legal i
   czytelność następnej gałęzi. Obejrzyj source frame i nowy metatheorem
   zachowania metadanych `C99HelperShape`, cały caller heap, nie tylko bufory.
6. Trace12/iterację oraz `branchChecks ++ previousChecks` we wszystkich
   trzech calls. Z `Safe` ma wynikać roots/frame/sticky i final bad0→initial
   bad0 oraz positive-finite/no-fallback wszystkich faktycznych kontroli.
7. Dokładne końcowe typy `reference_exists`, `StableTopCore.complete`,
   `source_outcome`: bez arbitralnych FprCalls, completeness hypothesis lub
   success evaluatora jako przesłanki. Niepustość dla wszystkich legalnych
   pamięci musi być rzeczywistym twierdzeniem.

## Replay i próby negatywne

Użyj osobnego trwałego runtime W; źródła autora, archiwa i stary W są RO.
Odtwórz23 nowe moduły w kolejności z `tools/stable_top_closure.py modules`
z przypiętymi zależnościami/library roots. Nie wymagaj pustego pending wobec
historycznego BASELINE; handoff5/5 jest rozliczony osobnym receiptem.
Nie zamieniaj nagłówka na nowszy P02. Nie uruchamiaj innych modeli.

Autor fresh:23/23 accepted/clean,119 typów/termów/axiom sets,
110.151s,maxRSS4224628KiB. Aksjomaty wyłącznie propext/choice/Quot.sound.
Sprawdź sam raw logs i termy, w tym `pp.proofs=true`; hashes i kompilacja
nie zastępują oceny adekwatności semantyki do źródła.

Sage z preparserem: exact3 oraz compiled C normal/UBSan —18 wykonań,
16/16 wykrytych mutantów: u/v step, swapped offsets, omitted check,
association, callee, bad reset, wrong binary address. Pierwszy probe `_001`
przegapił mul→add przy c1 i dużym ab; wynik jest zachowany. `_002` używa
c1/2/3 i wykrywa zmianę. Testy są skończoną diagnostyką, nie proofem.

Podaj oddzielnie A (istnienie), B (pełny most), C (source outcome),
source-adequacy i ogólny werdykt z dokładnym scope. Przy braku dowodu lub
kontrprzebiegu wskaż typ/regułę, nie maskuj go nową przesłanką.
Odbiór nie obejmuje kompilatora/całego ISO C, real-error FPEMU, FFT/exact
Gram, reverse reciprocal, całego certificate/KeyGen, T5, M6 lub C Sign.
Bez samodzielnego Git/push, stages import/tag i freeze całego RUN_003.
