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

## Correction scaling loop: drafted, not accepted

The 512-iteration Montgomery scaling loop module
(NttInverseCorrectionLoop192) is drafted with the Image/Fixed invariant,
one scaling iteration, the two-clause increment, the guard and the
count-based loop induction, but a single unsolved transport goal at the
empty-scope restore step of the iteration body blocks acceptance (jobs
391-396 retained with causes). The draft source stays uncommitted as the
exact starting point of the next window; no partial module is committed.

## Retained failures and diagnostics

Failed/mixed jobs 378/379/380/382/385/386/387/391/392/393/394/395/396
are retained with causes in
KEYGEN_STEP_INVERSE_192_FAILURES.json; all were workshop/elaboration
errors or localization tools. Two DIAGNOSTIC syntax probes
(NttInverseShapeProbe192, jobs 381/383) printed parser/transcription
trees into retained job logs; they are environment evidence, not proof
evidence. No source-C counterexample and no integrity event occurred.

## Open at this window boundary (exact resume obligations)

1. Intermediate doubling pass (part 2) at the prologue output: t/m
   initialization, the eight reverse rounds with their nested u1 and v
   loops (2048 executed butterfly iterations), each iteration the two
   loads `x=*r1, y=*r2`, the `*r1=modp_add(x,y,p)` store and the
   `*r2=modp_montymul(modp_sub(x,y,p),s,p,p0i)` store through the walked
   r1/r2 pointers.
2. Final degree-1 pass (part 3): w=igm[0] and the 256-iteration final
   butterfly loop.
3. Correction (part 4) continuation: the 512-iteration Montgomery
   scaling loop `*r1 = modp_montymul(*r1, ni, p, p0i)` at the setNi state
   (the modp_R/modp_div word assignments are closed, see above).
4. NttInverseWhole192: the composition Exec KeygenLevelNtt.inverse at the
   bound entry state.
5. SelectedStepInverse192: the KeygenLevelCalls.Bind of the actual s3
   arguments at the SelectedStepProduct191.source product output (u=0,
   slen=1, logn=9, full=0, p/p0i slots), the .inverse call execution with
   void return, and the s3 branch composition to
   `KeygenMakeFgSource.Exec MakeFgTailShape190.s3 productOutput out`.
   Then checkpoint 192 can be sealed (next unused proof job suffix 391).

The gs path s4-s7, false !out_ntt s8, outer loop tail, CRT/additional
prime part, remaining d-levels, root validation, certificate and encoding
to the complete emitted witness for corrected KeygenProbability134 all
remain OPEN, as do unconditional Z>0, numerical p_accept, conditional
coding and positive p_K. Old110 stays frozen; measured wording and the
five do_sign items remain unchanged. No IID/D1/F04 premise, no push, no
reviewer/worker, no new axiom.
