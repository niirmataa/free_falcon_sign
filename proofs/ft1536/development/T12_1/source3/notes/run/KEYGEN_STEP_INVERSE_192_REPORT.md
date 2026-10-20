# KEYGEN STEP INVERSE 192 — first-prime inverse call s3 (window in progress)

2026-10-19. Stage 192 of the SEED9_R1 kernel witness track: the active
inverse-call branch s3 of the make_fg_step first-prime tail at the actual
selected seed9 product output. Status IN_PROGRESS / PARTIAL_PROOF /
NOT_REVIEWED. Checkpoint 192 is NOT sealed: the s3 statement execution is
open and no postseal is written. Whole owner goal ACTIVE / NOT_COMPLETE.

## Entry integrity (obligation fulfilled)

Fresh pin verification before any proof work: POSTSEAL_191.json checked
against `97d24fdeeb2bd7e443b1ec1a2982163e10b650926ff5002523235ca86f201087`
and the sealed receipt notes/run/KEYGEN_STEP_PRODUCT_191.json against
`cd2798f1139e5eb05d0724f11a4ebc8128cb8311ddd326d3220ddd9b5cb997ae`;
all 71052 inherited pins re-checked (0 missing, 0 changed); no active
owned job/Lean/Sage process. Receipt
`.build/stepinverse192/ENTRY_PINS.json` SHA256
`9842d9ffedece50b7b19787b8c77cafe9629edbaa7d245c5439e661bf44cc60d`.
Tool tools/keygen_stepinverse192_entry.py, commit 6cd11d9b.

## Proved in this window (accepted jobs, logs 0/0, standard axioms)

- MakeFgInverseShape192 (job keygen_publicforward159_377): the s3
  statement naming against the parser by decide: s3Yes is the
  `if (in_ntt)` block scope, its content is the `if (ter)` branch with the
  original call statement `modp_iNTT3_ext(fs + u, slen, igm, logn, 0, p,
  p0i)` transcribed as the KeygenLevelCalls .inverse call with the exact
  seven arguments (fs at index u, slen, igm at the parser zero index,
  logn, the original zero literal, p, p0i), and the false ter alternative
  kept as its projection only.
- NttInversePrograms192 (job keygen_publicforward159_384): the complete
  pinned modp_iNTT3_ext corpus (region 3147 98) split into prologue
  (size/word/pointer declarations, logn0 void return, MKN assignments),
  three passes (full-only divide-by-three, reverse intermediate doubling,
  degree-1 final) and the corrective 1/n scaling, each part
  source-bound by decide to the accepted KeygenLevelNtt.part projections,
  and body_source binding the whole chain to KeygenLevelNtt.inverse.
  This is the requested prologue/passes/correction split, one module per
  source part, with only type-compatible helpers reused.
- NttInversePrologue192 (job keygen_publicforward159_388): the prologue
  executes at the call entry state at logn 9 / full 0: false logn0 guard,
  n = MKN(9,0) = 512 and hn = 256 from the executed integer operations,
  the declared scalar cells (n hn u r m t w ni R) and cleared r1/r2
  pointers, with locals/arrays preservation outside the declared names.
- NttInverseTriple192 (job keygen_publicforward159_389): the divide-by-
  three pass is the original skipped branch at full 0 (false guard, state
  unchanged). No full=1 instance is claimed.
- NttInverseCorrection192 (job keygen_publicforward159_390): the exact
  word assignments of the corrective section execute at the ModCall
  stratum: R = modp_R(p) through the pinned KeygenModpR leaf body and
  ni = modp_div(R, (uint32_t)n, p, p0i, R) through the accepted
  ModpDivTotal178 composite body, giving the exact words
  KeygenModpR.word p and ModpDivTotal178.word (KeygenModpR.word p) 512 p
  p0i (KeygenModpR.word p) with the executed cast of n=512.

Values stay value-free: only executed integer/call operations, no
transform property, table law, twiddle or numerical premise.

- NttInverseCorrectionLoop192 (job keygen_publicforward159_401): the
  complete corrective Montgomery scaling loop: all 512 iterations of
  `*r1 = modp_montymul(*r1, ni, p, p0i)` through the walked r1 pointer,
  with the executed image as Montgomery words over the input words
  (scaled prefix, raw tail), the exact two-clause increment and the
  count-based loop induction. The final state exports the fully scaled
  array image and locals/arrays preservation outside u/r1.

## Retained failures and diagnostics

Failed/mixed jobs 378/379/380/382/385/386/387/391/392/393/394/395/396/
397/398/399/400/402/403/404/406/407/408/409/410/413/414/416/417/418/419
plus this window's 421/423/424/426 and the u1/rounds drafts
428/429/430/431/432/434/435/437 are retained with causes in
KEYGEN_STEP_INVERSE_192_FAILURES.json (45 entries); all were workshop/
elaboration errors, clean-log linter warnings or localization tools.
Two DIAGNOSTIC syntax probes (NttInverseShapeProbe192, jobs 381/383)
printed parser/transcription trees into retained job logs; they are
environment evidence, not proof evidence. No source-C counterexample
and no integrity event occurred. Record hygiene: the FAILURES.json file
carried a stray literal backslash-n after its closing brace (an earlier
append artifact); the 33 existing entries were rewritten verbatim and
the tail normalized during this window's append, with the anomaly
recorded here.

## Part 2 tail closed: the complete intermediate doubling pass (window 2026-10-20)

2026-10-20. Entry integrity re-verified before any proof work:
ENTRY_PINS.json checked against `9842d9ffedece50b7b19787b8c77cafe9629e
dba7d245c5439e661bf44cc60d`, POSTSEAL_191 against `97d24fde…` and the
sealed product receipt against `cd2798f1…`; all 71052 inherited pins
re-checked (0 missing, 0 changed); no active owned process. Retained
failure register was 45 entries on entry and is 48 on exit.

NttInverseMiddleRounds192 (job 441; drafts 439/440 retained) executes one
mInner round body end to end at the executed words: the ht/u1/v1
declarations of the block, the ht = t >> 1 assignment as the u64 shr word
(ShiftExec .right through the KeygenNttLoopSupport.convert_div_two
conversion with the cell identity tOf i / 2 = htOf i by pow_two_div_two),
the closed NttInverseMiddleU1Loop192.full instance at (tOf i, htOf i,
mOf i) with the roundTws twiddles and the fvAt fv0 tws p p0i i input
words (the cell transports through the declaration chain follow the
setup_locals pattern), the t <<= 1 body shift (tOf i * 2 = tOf (i+1) by
tOf_succ) and the trailing skip under the block scope. The export carries
the round-constant Fixed facts (n/stride/p/p0i cells, the a/igm bindings,
writability and the twiddle reads for all k < 512), the t/m cells at
(tOf (i+1), mOf i), the round_image transition to the fvAt (i+1) input at
index 0 and the load keeps for all positions separated from the 512
walked elements.

NttInverseMiddleRounds192 (job 443; draft 442 retained) closes the
m-loop and the tInit/mInit composition: the m >>= 1 increment (the cell
identity mOf i / 2 = mOf (i+1) by mOf_succ), the eight-iteration m loop
with the guard t < n (true for i < 8 through tOf_small, false at i = 8
where tOf 8 = 512 = n) and the count-based induction i+count = 8, then
t = 2 + (full << 2) = 2 and m = (u64)1 << ((logn-1) - full) = 256 at
logn 9 / full 0 (the shift evaluations mirroring
NttInversePrologue192.size_value), closing `Exec
NttInversePrograms192.intermediatePass` with the exported composed image
at (tOf 8, htOf 8, mOf 8) and the load keeps for all separated
positions. Accepted logs 0/0, standard three axioms, values stay
executed words only. Commits 1bd5fa4d/b7989b8a.

Retained failures 439/440/442 (register now 48 entries) were workshop
errors only: the scope-restore splitting over the Bool-coercion
condition, the String/Name mismatch in the cell keep lemmas (with the
needed 32-bit variants for p/p0i), the shr-word width bound and the
(u64 x).type unfolding before convert_div_two, the u1 instance handed the
bare fv0 instead of the composed fvAt input words, the guard
falsification needing the tOf reduction and the initial t/m cells derived
by conversion instead of the definitional equations. No source-C
counterexample and no integrity event.

## Open at this window boundary (exact resume obligations)

1. NttInverseWhole192: compose `Exec KeygenLevelNtt.inverse` from the
   prologue (NttInversePrologue192.source), the triple skip
   (NttInverseTriple192.source at full=0), the three passes and the chain
   trailing skip (NttInversePrograms192.body_source rewrites to the
   accepted corpus). Word bridges still to write: the round-8 image at
   index 0 gives exactly the final-pass pairs (j, j+256) for j < 256; the
   final-pass output image feeds the correction input through a
   finalWord case split at 256 (lowWord/highWord of the fvAt 8 words);
   the correction words are the scale/mont words over those, with the
   modp_R/modp_div words already exported by NttInverseCorrectionSource192.
   TRAP found and recorded: NttInverseCorrectionSource192.source takes
   `uDeclared : s.locals "u".toList=some (.uint64,none)` but the final
   pass leaves u = 256 at the correction entry; the whole composition
   needs a generalized correction init over any old value (mirror
   NttInverseCorrectionSource192.init_run with the uInit assignment at
   old := some (u64 256)).
2. SelectedStepInverse192: the KeygenLevelCalls.Bind of the actual s3
   arguments at the SelectedStepProduct191.source product output (u=0,
   slen=1, logn=9, full=0, p/p0i slots), the .inverse call execution with
   void return, and the s3 branch composition to `KeygenMakeFgSource.Exec
   MakeFgTailShape190.s3 productOutput out`.
3. Audit + seal 192: `.build/stepinverse192/AUDIT_MODULES.json`,
   `keygen_isolated_audit192.py` (one declaration per command, one module
   per process, unchanged checks), the final audit job,
   `keygen_audit192_collect.py`, `keygen_stepinverse192_seal.py seal` and
   `postseal RECEIPT_SHA256`, the _PINS.md external pins and the R1 tail
   register entry. Next unused proof job suffix 444.

## Open at the 2026-10-19 boundary (previous record, annotations updated)

1. (closed) Intermediate doubling pass (part 2) remainder at the u1
   level: NttInverseMiddleU1Loop192 (job 433; drafts 428-432 retained)
   runs one u1 group of a round end to end (the s = igm[m+u1] load as
   the u64 add word, the r1 = a + v1*stride and r1-relative
   r2 = r1 + ht*stride product binds, the group radix-2 loop as the
   NttInverseMiddleVLoop192.remaining instance in the vloop_keep
   strengthening that adds load persistence outside the walked pair
   region, the u1/v1 two-clause increment) and the full m-iteration u1
   loop with its exported image of transformed group words over the
   round input words and the loaded twiddle words.
2. (closed) The eight-round geometry and composition layer:
   NttInverseMiddleRounds192 (jobs 436/438; drafts 434/435/437
   retained) fixes tOf/htOf/mOf with the pow/div arithmetic (t*m = 512
   in every round), the nextWord round word composition with its two
   evaluation laws at the butterfly pair positions, the round-constant
   Fixed facts with the twiddle-table reads for all used indices, the
   per-round u1 instance (u1_fixed) and the round-to-round image
   transition (round_image).
3. (closed) NttInverseMiddleRounds192 remainder: the mInner round execution
   (the ht/u1/v1 declarations, ht = t >> 1 as the u64 shr word through
   KeygenNttLoopSupport.convert_div_two, the NttInverseMiddleU1Loop192
   full instance at (tOf i, htOf i, mOf i), the t <<= 1 body shift
   through convert_mul_two, the block scope), the m >>= 1 increment and
   the eight-iteration m loop (guard t < n, induction on the remaining
   count with i+count = 8), then the tInit/mInit composition (t = 2 +
   (full << 2) and m = (u64)1 << ((logn-1) - full) at logn 9 / full 0)
   closing `Exec NttInversePrograms192.intermediatePass` with the
   exported composed image (fvAt 8) at (tOf 8, htOf 8, mOf 8). The u1
   run needs the cell transports through the ht/u1/v1 declaration
   chain (the setup_locals pattern of NttInverseMiddleU1Loop192).
4. (closed) The degree-1 final pass: NttInverseFinalPass192 composes
   wAssign igm[0] + u/r1/r2 init + the 256-step loop + skip (job 422).
   The NttInverseCorrectionSource192 correction statement (job 405) was
   already complete: the exact modp_R/modp_div word assignments, the
   u/r1 initialization and the full 512-step scaling loop.
5. NttInverseWhole192: the composition Exec KeygenLevelNtt.inverse at the
   bound entry state (prologue + triple skip + the three passes).
6. SelectedStepInverse192: the KeygenLevelCalls.Bind of the actual s3
   arguments at the SelectedStepProduct191.source product output (u=0,
   slen=1, logn=9, full=0, p/p0i slots), the .inverse call execution with
   void return, and the s3 branch composition to
   `KeygenMakeFgSource.Exec MakeFgTailShape190.s3 productOutput out`.
   Then checkpoint 192 can be sealed (next unused proof job suffix 439).

## Degree-1 final pass: closed through the 256-step loop

NttInverseFinalBody192 (job 412) closes the butterfly state skeleton:
the exact modp_add/modp_sub/modp_montymul words of the a0/a1/b/c block
(bb/subA/mid/low/high), the declared/assigned intermediate states, the
two written positions and the scope restoration (after_locals/
after_arrays/body_state) with the state-preservation helper as the exact
reuse of StepProductBody191.put32_outside.

NttInverseFinalExec192 (job 415) executes one butterfly iteration and
its three-clause increment: the a0/a1 block declarations, the two r1/r2
loads, the exact b/c words, the two stores and the u/r1/r2 updates, all
value-free with the standard three axioms.

NttInverseFinalLoop192 (job 420) runs all 256 paired iterations: the
two-sided image of the a+u / a+hn+u walks (lowWord/highWord per pair),
the Fixed invariant (capacity, cells, pairwise separation of the 2*hn
walk positions), the guard, and the whole loop statement execution
(remaining, by induction). OPEN for part 3: only the finalPass
composition (wAssign igm[0] + u/r1/r2 init + loop + skip) which joins
this loop to the statement finalPass.

## Part 3 closed: the complete finalPass statement execution

NttInverseFinalPass192 (job 422; first draft job 421 retained) composes
the whole original finalPass chain in one execution: the w = igm[0]
assignment through the i32-literal zero index (zero_i32 Pointer), the
u = 0 / r1 = a / r2 = a + hn*stride initialization (the r2 bind index
evaluates as the u64 product word hn*stride through the word_mul
ArithmeticExec rule over the two counter cells), the complete 256-step
loop and the trailing skip. The exported state carries Fixed, the full
transformed Image, the u=256 counter and the walked r1/r2 endpoints.
Values stay executed words only. This closes the OPEN item 2 of the
previous boundary.

## Part 2 opened: the intermediate doubling pass

NttInverseMiddleBody192 (job 425; drafts 423/424 retained as linter
failures) executes one intermediate-pass butterfly iteration and its
three-clause increment at generic walked positions j/k: the x/y block
declarations, the two r1/r2 loads, the exact modp_add/modp_sub/
modp_montymul words over the s twiddle cell, the two stores and the
v/r1/r2 updates. Scope restoration mirrors the degree-1 skeleton.

NttInverseMiddleVLoop192 (job 427; first draft job 426 retained) runs
the complete radix-2 loop of one u1 group: ht paired iterations at the
v1 block offset, the two-sided Image (lowWord/highWord per pair over
the round input words), the Fixed invariant (capacity, cells, pairwise
separation of the walk positions), the guard and the whole loop
execution (remaining, by induction), exporting the transformed group
image and the walked r1/r2 endpoints.

The gs path s4-s7, false !out_ntt s8, outer loop tail, CRT/additional
prime part, remaining d-levels, root validation, certificate and encoding
to the complete emitted witness for corrected KeygenProbability134 all
remain OPEN, as do unconditional Z>0, numerical p_accept, conditional
coding and positive p_K. Old110 stays frozen; measured wording and the
five do_sign items remain unchanged. No IID/D1/F04 premise, no push, no
reviewer/worker, no new axiom.

## Part 2 closed at the u1 level and opened at the round level

NttInverseMiddleU1Loop192 (job 433; first drafts 428-432 retained as
workshop failures) closes the u1-group loop of one round end to end:
per group the executed s = igm[m+u1] load (the m+u1 index as the u64
add word through C99LoopScalar141.add, the pointer at the parser's
(m+u1) element of the igm table), the r1 = a + v1*stride bind (the
v1*stride product word through NttInverseFinalPass192.word_mul) and
the r1-relative r2 = r1 + ht*stride bind (the ht*stride product word),
the v = 0 initialization, the group radix-2 loop and the trailing skip
under the block scope, plus the u1/v1 two-clause increment (u1 += 1
through the counter cell, v1 += t through the t cell) and the full
m-iteration loop. The radix-2 execution is the closed
NttInverseMiddleVLoop192.remaining induction reused through vloop_keep,
the same instance with an added load-persistence component: the
twiddle-table reads of the remaining groups and the raw words of the
other groups must survive the writes of the current group, and the
closed export alone does not constrain those positions. The exported
image records the transformed group words as the executed butterfly
words (bb/high of NttInverseMiddleBody192) over the round input words
and the loaded twiddle words; the loop also exports the load keeps for
all positions separated from the m*t walked elements. Values stay
executed words only.

NttInverseMiddleRounds192 (jobs 436/438; drafts 434/435/437 retained)
fixes the eight-round geometry and the round word composition: tOf/
htOf/mOf with the pow/div arithmetic from the core lemmas (every round
keeps t*m = 512 and 2*ht = t), nextWord as the composed round output
word (bb word at low positions, mont word at high positions over the
group twiddle word) with its two evaluation laws at the butterfly pair
positions, the round-constant Fixed facts with the twiddle-table reads
for all used indices, the per-round u1 instance (u1_fixed) and the
round-to-round image transition (round_image) through the four-way
pair decomposition (low/high halves of the two consecutive groups).
The mInner round execution, the m >>= 1 increment, the eight-iteration
m loop and the tInit/mInit composition closing intermediatePass remain
OPEN with their exact obligations above; the window freezes at this
recoverable mid-point by the staged-roadmap context discipline. No
push, no reviewer/worker, no new axiom.
