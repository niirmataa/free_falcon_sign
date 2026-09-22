# Małe zadanie dla kolejnego modelu — T02.1

**Aktualny TASK_ID=FT1536_PRNG_LAYOUT_COUNTER_RUN_003**,ROADMAP_ID=T02.1.
Stan2026-09-22: **SUPPLEMENT_AWAITING_REVIEW**. Właściciel przekazał poprawki
F1–F5 do odbioru RUN_002. [Krótki niezależny odbiór](CURRENT_SMALL_REVIEW_TASK.md)
przygotowany;141/141 outputs i zewnętrzne piny zgodne.
REPORT `3b7c2b3bbc7f0b72b3a25d3f2cb32623294f1135acb61d8c65b905eefe1a6168`;
OUTPUTS `e37b1e97ebcfa65d698c52e175c09e826cdbafe565722cc017b5349c00d3f5dc`.
Source W: `proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_003`.
B20/P03 ma nadal pending input contract i pełną formalizację jako osobny cel.
Poniżej zachowane pierwotne zlecenie/bootstrap RUN_001; frozen W nie wznawiaj.

**Obowiązkowe uzupełnienie właściciela2026-09-22:**
[rachunek w `.sage` uruchamiany `sage lemma.sage`](documents/FT1536_ZASADA_RACHUNKU_SAGEMATH_2026-09-22.md),
SHA `b6afcdcabb811dd8bc31072455ed9a94a4c4773ec68d41d207ac1d7e98eae241`.
Ma pierwszeństwo w wyborze trybu rachunku nad pierwotnym TASK; dopnij je
do INPUTS nowego pakietu. TASK/bootstrap piny poniżej pozostają niezmienne.

- [Pełne zadanie](documents/FT1536_ZADANIE_T02_1_PRNG_LAYOUT_COUNTER_2026-09-22.md),
  SHA `7b0007c095c51b1fe4c5d94b0b1a0012227aba4df0d1c59cfa8fcd92589fe5f1`.
- W: `/home/footfalcon/free_falcon_sign/proofs/ft1536/work/FT1536_PRNG_LAYOUT_COUNTER_RUN_001`.
- BASE `c90233c171265e050930958fb29bafa9338f81ff`.
- [Bootstrap39 plików](background/T02_1_PRNG_LAYOUT_COUNTER_2026-09-22/README.md),
  SHA `03b0612cbe3b18e487bee6399c71c238e5ff3a0527818a7c4330d007b72abae2`.

Niewielki deterministyczny kontrakt init56→state/refill4096 w frng.c:
actual layout,XOR lanes,round/feed-forward/serialization,counter/frame i
przeliczenie odebranego budżetu T01 na block evaluations. Publiczne fixed
fixtures i kontrola original C; distribution/security SHAKE/ChaCha nadal OPEN.

Może być rozwijane niezależnie od S01 Family i T03 integer recovery, we
własnym W,bez wspólnego Git i bez uruchamiania innych modeli. Nie podczas
kampanii dudect. [Rodzic T02](../../docs/onboarding/ROADMAP.md) nie jest
domknięty przez ten lokalny kontrakt. Po zwrocie review/replay innego modelu.
