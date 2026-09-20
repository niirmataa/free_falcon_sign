# Niezależny odbiór H3_BINARY_TOWER — 2026-09-20

**PASS: H3_BINARY_TOWER_PROVED_FOR_PINNED_MODEL**, w zakresie pełnych
warstw A i B: levels7–1 oraz actual defined terminating execution 12 raw
inner7 subtrees. Pełna source numeric/memory instancja jest analityczna,
wsparta exact certificates i kernelowymi lematami.

Baza odbioru: `8bbab819563908275c26a72ba5ec5123ba3d81f9`.
REPORT: `d93d9ccebf28a7212276aa48922201734d2eec4c1f7c7243fb5517d7323b5847`.
OUTPUTS: `48dadc20e00750dd4389fb49652a651cedc1645601fb1a1295cf44f57a75c26a`.
Import: 807 członków OUTPUTS, 141 publicznych records INPUTS.

```sh
python3 -B proofs/ft1536/tools/archive.py replay FT1536_H3_BINARY_TOWER_RUN_001 --run maintainer-replay-001 --timeout 1200 --hide-originals
```

Świeża kopia bez wcześniejszych olean/bin/cache, ukryte Dokumenty/H,
sieć odłączona, zapis tylko w kopii roboczej. Exit0, 39.052 s,
**175/175 plików znaczeniowych zgodnych** z zamrożonym receipt.

- 30 modułów Lean, 147 twierdzeń (16 nowych), czyste logs; 24 odziedziczone
  źródła identyczne z NODE2, przebudowane.
- Exact QQ: mocniejszy INIT, STEP z utratą I²/m, outward grid2^-40,
  1524 node records i 768 positions na każdy level7–1; wszystkie margins dodatnie.
- RBF i niezależny oracle: wszystkie 5376 positions, 127 square twiddle pairs.
- C normal/ASan/UBSan: 12 pełnych original inner7 outputs, 12288 raw tree
  words, local inputs/outputs i actual source-order events, base stores,
  alias/frame/canaries; 98 half words i 30 divisor pairs.

Przejrzano INDUCTION, LEVEL7, ASSEMBLY_INTERFACE, SOURCE_MODEL_BINDING,
certificate.py i TowerExecution.lean. Abstract partial-execution theorem
ma jawne base/step premises; source instancja rozlicza je w kolejności
first child → frame → local LDL → second child, z base inner1 i literalnymi
real leaf stores. Nie przyjęto zakończonego subtree jako założenia totalności.
Strukturalny rank maleje; rozmiary tree(k+1)2^k i scratch≤2*2^k są rozliczone.

Uniform summaries wszystkich outputs levels7–1:

| Wielkość | Branch0 | Branch1 |
|---|---|---|
| Re lower | >49/100 | >27 |
| Re upper | <8388610 | <2147483650 |
| abs imaginary | <1/32768 | <9/8 |
| complex reference error | <32768 | <4294967296 |
| norm L / error L | <2 / <3 | <2 / <3 |

[Execution](execution.json), [review checks](review_checks.json),
[TOWER_CERTIFICATE](TOWER_CERTIFICATE.json). Wszystkie streams wskazane
receipts sprawdzono hashami i zachowano. [VALIDATION.sha256](VALIDATION.sha256)
obejmuje 194 pliki, SHA-256:
`ccfcfb0e401c76536a0b3c1afcedea2e6543046193f9523b88041c380f88de72`.

binary_tower_proved, remaining_binary_subtrees_proved i
source_inner7_totality_proved są true w zadanym zakresie. Pełna kernelizacja
source C, pełny loader/raw-tree assembly, stable rebuild/normalization,
initial targets, global Reach i sampler law pozostają osobnymi obowiązkami.
full_internal_tree_proved, H3_range_proved i security_reduction_proved są false.
Finite controls oraz byte replay tekstu nie zastępują uniwersalnego argumentu.

Ustalenia odrębnego audytu FPEMU nie zostały użyte jako nowe założenia CT
lub whole-backend correctness. Źródła pozostają przypięte; ten odbiór nie
integruje poprawki. Historyczne kopie/slices/logi są zachowane bajtowo,
a nowa dokumentacja sprawdzana osobno.
