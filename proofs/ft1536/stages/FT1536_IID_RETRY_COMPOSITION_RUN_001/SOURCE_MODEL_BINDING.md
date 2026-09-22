# Źródła, modele, formalizacja i granice zaufania

Candidate17-file pin56974571b46e8257bdd3b4097c8c70fded6bb4b94c64805f6e35ec80929a0985.
Bootstrap exact sets/piny/origins są sprawdzane na wejściu i każdym fresh replay.

| source / obowiązek | consumer / dowód | kontrola |
|---|---|---|
| sign3327–3421 | SCHEDULER, RetryState | exact retry_region.inc, source/checked22 fixtures |
| sign3356–3359, frng281–338 | FILTRATION, REENTRY | original init slice, state56 stub, reset6 cases |
| frng214,215,264,277,338 | deterministic counter64/type/ptr projection | wrap/repeated state56, fresh global block labels |
| internal.h getters | BYTE_SCHEDULE + RESOURCE_BOUND, RetryResources | cutoff4087, ptr0, u8 rollover, conservation |
| sign1874–1892 | TARGETS + REENTRY_AND_FRAME, RetryState.target_overwrite | actual fill/FFT/mul prefix,3072 independent target words |
| root1897 | pinned LEFT/NORMALIZED/JOINT/H6P | consumed contracts; no full do_sign executed |
| sign1902–1934 | pinned POST, RetryCoupling.preservation_before_norm | scripted wide/store controls; inherited post theorem |
| norm3388 / falcon-enc.c | POST SourceBytes, inherited M0/LV | actual norm, threshold equality rejected |
| codec3411–3421 | POST/M0 exact bytes/capacity, OBSERVATIONS | actual STATIC body/header/cap64/canaries |
| WholeRegionBad | STOPPED_COMPOSITION/FILTRATION | exact adaptive toy law, Sage QQ |
| checked/public coupling | CHECKED_PRECAST_COUPLING, RetryCoupling | first bad guard before cast, exact source/checked traces |

checks/retry.c jest standalone driver z original loop/includes i JAWNYMI
stubami. `scripted_root` zastępuje do_sign (nie wykonuje go w całości),
public_state56 zastępuje SHAKE output, ideal_refill zastępuje ChaCha output.
Ten ostatni implementuje rzeczywiste state/type/counter effects, ale publiczne
pattern bytes nie są probabilistyczną próbą uniform RNG. Przy modelu IID
uniformity jest definicją FILTRATION, nie cechą tych fixtures.

Oryginalny target prefix jest wykonywany każdej próby; tmp po root stub jest
brudzony, sk/hm zachowane i sprawdzane. Actual source codec/norm i FPEMU FFT
są kompilowane z GCC14.2/C99/LP64/literal -O. Normal i ASan/UBSan zgodne z
independent Python literal model dla22 fixtures i6 reset cases/build.
ASan shadow bez8GiB AS cap; LSan nie jest deklarowany. H2P/shake_extract
z enc TU ma forbidden stub, aby przypadkowo nie wykonywać prefixu.

All selected114 inherited Lean source modules są byte-identical.4 nowe
Retry* plus2 audit modules dają120 clean builds.922 theorem declarations,
26 nowych, pełne typy/termy i axioms audit w logs/final. Generic Int/scaled
sum lemmas nie są formalizacją całego measure theory; source instantiation
oraz probability integrals są mixed-proof boundary opisanym w CLAIM.

Nie wykonano pełnego Sign/do_sign, KeyGen/private loadera, real seeded PRNG.
Public synthetic basis/wide arrays nie mają automatycznej Emitted membership.
Dane mutations nie są patchami source/ ani integrated production candidate.
