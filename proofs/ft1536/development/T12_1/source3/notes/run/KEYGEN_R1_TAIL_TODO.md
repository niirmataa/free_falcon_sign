# Current continuation — composed first/middle NTT prefix164 sealed

2026-10-18. Two modules/12 declarations audited (job131,2 sequential
processes, logs0/0); source47b9efc1. PublicInitializedFrame164 preserves
readability under supported source statements, including overlapping
stores; PublicTailPrefix164.source composes the first and eight middle
passes with generated-table and caller-slot transport. Postseal passed
with56685 pins; no failures in130/131. See KEYGEN_PUBLIC_PREFIX_164_REPORT.md
/ _PINS.md / _NEXT_ROUTE.md. Next165: final triple body and512 iterations,
then actual caller composition. Full witness and positive numeric bounds
remain OPEN; corrected134, measured wording and five do_sign unchanged.
No push.

# Current continuation — eight middle NTT rounds163 sealed

2026-10-18. Six modules/35 declarations audited in six sequential
processes (job129, logs0/0); sources41138d1d/65963ace. The full original
middle section now executes eight rounds from t768/m2 to t3/m512,
including t=hn/m=2 initialization. Postseal passed with56600 pins;
mixed126/127 retained. See KEYGEN_PUBLIC_ROUNDS_163_REPORT.md / _PINS.md /
_NEXT_ROUTE.md. Next164: preserve initialized tables across prefix,
compose first+middle passes, then execute tripling512 and actual caller.
Full public call, solver/certificate/codecs, G(seed*) and positive numeric
bounds remain OPEN; corrected134, measured wording and five do_sign
obligations unchanged. No push.

# Current continuation — public NTT group loop162 sealed

2026-10-18. Five modules/24 declarations audited in five sequential
processes (job125, logs0/0); sources1b4cb08a/51294a1e. The group prologue
loads the actual generated twiddle, then GroupBody consumes the161 inner
loop; GroupLoop162.source proves all groups and transports the table
through data writes. Postseal passed with56374 pins; mixed121/122 and
failed123 retained. See KEYGEN_PUBLIC_GROUPS_162_REPORT.md / _PINS.md /
_NEXT_ROUTE.md. Next prepared163: exact eight-round setup/body/loop,
then tripling and actual caller composition. Full witness and all concrete
positive bounds remain OPEN; corrected134, measured wording and five
do_sign obligations unchanged. No push.

# Current continuation — middle NTT inner loop161 sealed

2026-10-18. Five modules/32 declarations accepted and audited (job120,
five sequential processes, logs0/0); source commits12878be1/80405a4a.
PublicMiddleBody161.source executes one modular butterfly with all locals
restored; PublicMiddleLoop161.source executes the complete inner loop
with its endpoint and byte frame. Explicit caller domains remain.
Postseal161 passed with56188 pins; failed116/117 and mixed118 retained.
See KEYGEN_PUBLIC_MIDDLE_161_REPORT.md / _PINS.md / _NEXT_ROUTE.md.
Next prepared162: generated twiddle load and group-body composition,
then group/outer loops, tripling, actual calls, solver/certificate/codecs.
G(seed*) and concrete positive probability bounds remain OPEN; corrected134,
measured wording and five do_sign unchanged. No push.

# Current continuation — first public NTT pass160 sealed

2026-10-18. Owner-approved historical-pin reconciliation completed;
old159 manifests and document versions preserved (a121ee46). Accepted108
invariant transports committed unchanged (d70e6c9d). New source commit
b50e8b56 proves the body-to-invariant implication and the full768-step
first pass, including r load/u initialization from explicit TailEntry.
Three modules/38 declarations fully audited in job112, all accepted logs0/0;
failed110 preserved. Postseal55965 pins passed. See
KEYGEN_PUBLIC_TAIL_160_REPORT.md / _PINS.md / _NEXT_ROUTE.md.
This is a generic source-domain theorem: actual caller composition,
middle/triple passes, public suffix, solver/certificate/codecs and G(seed*)
remain OPEN, as do all concrete positive acceptance/coding bounds.
Next: public uint16 modular middle-body adapter (PublicWordSteps161);
the old FFT140-148 theorems have a different execution/word type and cannot
be directly instantiated. Reuse the induction pattern and proved modular
helpers. Corrected134, measured wording and five do_sign unchanged.

# KEYGEN R1 / TAIL — duże TODO (regiony 2–5 i ogon success)

2026-10-17. Okno R1 (świadok kernelowy seed9) w toku. Region 1d zamknięty
(WrittenRange 0 1024, commity 3632a30d/560fe129/c8591c9d/f3d83e43).
Region 2 (tail, fragment 1001 61) otwarty; kształt kernelowo vs parser
przyjęty. To jest żywy rejestr zadań do domknięcia R1 i odblokowania
Z > 0 przez `KeygenModelUnlock134.package_of_witness`.

Zasady niezmienne: jeden proces Lean (`tools/job111.py`, `-j1 -M6144`),
logi 0/0, standardowe aksjomaty, wartościowo wolne (bez założeń
semantycznych / własności NTT / twiddle), małe commity bez push,
porażki z przyczynami w aktach, meldunek po regionie.

---

## Status regionów (kolejność właściciela)

| Region | Treść | Status | Dowody / commity |
|---|---|---|---|
| 1d | mq_mkgm3 suffix (pętle 256/256/255 + gm0/w/igm0) | **CLOSED** | Table159/Index159/Row159/Upper159/Remaining159 |
| 2 | tail: first 768 + 8 rund + tripling 512 | **IN_PROGRESS** | shape+`rSet`+infra; ciało w rozbiórce |
| 3 | suffix 1537 10: t[u]==0, mq_div_18433, mq_iNTT, return 1 | OPEN | — |
| 4 | root solver + certificate gate + codec tails | OPEN | — |
| 5 | G(seed*) + `package_of_witness` ⇒ Z ≥ 2⁻²⁵⁶ | OPEN | wymaga 2+3+4 |

---

## Region 2 — tail (fragment 1001 61)

### 2.A Kształt i infrastruktura — ZROBIONE

- [x] `PublicTailShape159` — rSet / firstPass / midPasses / tripling vs parser
      (`tail_shape`, job 051, 0/0)
- [x] `rSet_exec` — `r = gm_square[1]` z Written gm (job 054, 0/0)
- [x] `u64_add_exec`, `scalar_u_plus_hn`, `address_u_plus_hn` (job 058, 0/0)
- [x] `store_a` — legalny zapis 16-bitowy do `a` (job 058, 0/0)
- [x] `firstBody_chain` — składanie 6 instrukcji ciała w scope (job 070, 0/0)
- [x] `FirstInv` — obraz a[0..1536) Written + liczniki + dims

Commity: `f9cdb691` `171a0838` `9ca4ffa7` `dc6b6ea1`

### 2.B firstBody_exec — ROZBIÓRKA (następne okno)

Cel: jedna iteracja butterflya X²−X+1 na `a[u]`, `a[u+hn]`.

- [ ] `firstBody_reads` — declare a0/a1/b + load a0 + load a1 + `b=montymul(a1,r)`
      Stan pośredni s4: Slot a0/a1/b, USlot u/hn, Written a[u] i a[u+768]
- [ ] `firstBody_writes` — store `a[u]=add(a0,b)` + store `a[u+hn]=sub(add(a0,a1),b)`
      Stan s7 = restoreScope s s6 [a0,a1,b]; FirstInv s7 + nowe Written
- [ ] `firstBody_exec` = `firstBody_chain` na powyższych (bez składania w jednym
      terminie — kernel memory limit; patrz job 068/069)
- [ ] Przyjąć job `keygen_publicforward159_071` (lub kolejny) na 0/0

Uwaga techniczna: pełny montaż w jednym twierdzeniu przekroczył limit
pamięci kernela. Trzymać osobne twierdzenia na reads/writes; chain
już jest wydzielony.

### 2.C firstLoop — indukcja 768

- [ ] `firstGuard_eval` — `u < hn` true/false przy USlot u i hn=768
      (wzorzec `Row159.guard_row`)
- [ ] `firstInc_exec` — `u := u+1` z `USlot u i → USlot u (i+1)`
- [ ] `firstLoop_source` — indukcja po `count` z `i+count=768`:
      `∃ after, Exec … firstLoop s ⟨after⟩ ∧ FirstInv after a gm 768`
      (wzorzec `Row159.loop_source`, `loopNormal`/`loopFalse`)
- [ ] `firstPass_done` — `uInit; firstLoop` ⇒ FirstInv … 768
- [ ] Job na 0/0 + commit

### 2.D Rundy pośrednie (8 doublings) — instancjonuj 140–143

C (1015–1037): `t=768; m=2; while t>3 { ht=t>>1; for u1,v1 … for v … }; t=ht`
t: 768→384→192→96→48→24→12→6 (8 rund). To jest dokładnie middle FFT.

- [ ] `midShape` — already in `PublicTailShape159.midPasses` (OK)
- [ ] **NIE odtwarzać algebra motyli.** Instancjonować:
  - `FftLoopInduction141.source` na pętli `v` (inner)
  - `FftGroupsInduction143.source` na pętli `u1` (groups)
  - `FftOuterInduction144.source` na pętli `m/t` (outer)
  - Wzorce: `SelectedFftMiddle144` (context 1536 768), `SelectedTripling148`
- [ ] `midInv` — wartościowo: Written/Represents, Fixed, Frame; bez evaluate
- [ ] `midLoop_source` — 8 rund z `t=768` do `t=3` (guard `t>3`)
- [ ] Job + commit

### 2.E Tripling 512 — instancjonuj 145–148

C (1039–1061): `w=montysqr(gm[1]); for u=0,v=512; u<n; u+=3,v++`
512 trójek (fA,fB,fC) z cubic twiddles.

- [ ] `wSet_exec` — `w = montymul(gm_square[1], gm_square[1])`
- [ ] `tripleInit_exec` — `u=0; v=1<<(logn-1)=512`
- [ ] **Instancjować** `FftTriplingInduction148.source` (u=3k, v=512+k)
      + `FftTripleBody147.source_and_image` na ciele
- [ ] `tripleLoop_source` — 512 iteracji, `u→1536`, `v→1024`
- [ ] `tail_done` — firstPass + midPasses + tripling ⇒ Written a[0..1536)
      po ogonie (obraz wyjściowy t[])
- [ ] Job + commit + **meldunek regionu 2**

### 2.F Przekazanie do regionu 3

- [ ] `tail_handoff` — stan po `KeygenPublicForwardProgram.tail`
      z `Written a[0..1536)`, `Written gm/igm 0..1024`, wymiary n/hn/logn
- [ ] Związać z `PublicForwardBody159.aliasesBound` (wejście taila)

---

## Region 3 — suffix 1537 10 (fragment 1537 10)

- [ ] Kształt vs parser (probe → `tail_shape` wzorzec)
- [ ] Testy `t[u]==0` (branch, nie assume)
- [ ] Zapisy `mq_div_18433` na niezerowych
- [ ] Wywołanie `mq_iNTT` (warstwy inverse już są:
      `KeygenPublicInverseCalls` / `KeygenPublicReverseCalls`)
- [ ] `return 1` — wynik ≠ 0
- [ ] Job + commit + meldunek

## Region 4 — solver + certificate + codec

- [ ] `SelectedAttemptPrefix156.continue_search` — konstruktywnie
- [ ] Certificate gate
- [ ] Codec encoding tails
- [ ] Jawne granice: to NIE jest jeszcze G(seed*)

## Region 5 — G(seed*) i Z > 0

- [ ] `KeygenByteGame134.evaluate` na seed9 = sukces
- [ ] `KeygenModelUnlock134.package_of_witness` ⇒ `Z ≥ 2⁻²⁵⁶`
- [ ] Zgodność z `KeygenSuccessMass134` / `KeygenModelBinding134.package`
- [ ] **Meldunek końcowy R1** + postseal

---

## Tory równoległe (poza R1)

| Tor | Status | Następny krok |
|---|---|---|
| Paper R2 | manuscript ~54 s. w Pobrane | review Daybreak (prompt gotów) |
| QROM S05 | swoim torem (Codex) | — |
| NXMS | dashboard + ceremonia | po stronie właściciela |
| SOL61 audit | PREPARED_OWNER_START | start właściciela |
| F04/F05 residual | PASS_SCOPED SCOPE_002 | ReplyShape, most bajtowy, hzero, F06 OPEN |
| MIGRATION_HOLD | aktywny | migracja dopiero po zakończeniu prac |

---

## Rejestr porażek / ścian (zachować)

- Joby 016–043 (region 1d): elaboration/construction; brak kontrprzykładu C
- Joby 046–069 (region 2): shape mismatches (`chain` podwójny `.skip`),
  `ArithmeticExec` uint64 `safe`, `declareCells` parse, kernel memory
  na montażu `firstBody_exec`
- Z_LOWER_134: STOP_AND_REPORT — brak ε>0 z prawa SHAKE (to dlatego R1)
- Diagnostyczne sondy (`PublicTailProbe159`, `PublicTailShapeProbe159`)
  — evidence środowiska, nie proof evidence

---

## Kolejność w następnym oknie (propozycja)

1. `firstBody_reads` + `firstBody_writes` + `firstBody_exec` (2.B)
2. `firstLoop_source` (2.C)
3. Start 2.D (instancjowanie 141–143) — tu wchodzi „uniwersalne motyle
   z 140–148 instancjonuj, nie odtwarzaj"
4. Meldunek gdy region 2 domknięty (2.E/2.F)

Cel strategiczny niezmienny: **Z > 0 przez świadek G(seed*)**, nie przez
analityczny bound (ten się refutował w 134). Budżet głębokości: forma
wystarczająca dla tezy, bez interpreterów premium poza regionem 5.
