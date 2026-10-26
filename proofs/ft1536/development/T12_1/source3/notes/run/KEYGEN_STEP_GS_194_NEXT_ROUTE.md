# R1 route 575 — one-block v-loop image accepted; u1-loop image next

2026-10-26. Consume `StepNttVImage195.u1_body_image` (source commit
`d4e1c26d`, lane job keygen_publicforward159_575, 2/2 accepted, logs
0/0), with `pairWords` / `vWords` / `blockWords`. The exact 512-word
image, execution, fixed domains and frame share the same output state;
the twiddle is the executed `gvs ⟨m+j,tableBound⟩` load. This closes the
v-loop of ONE u1 block, including setup and scope restoration. The
image is a source-order recurrence; no transform/table/root law.

Report: `KEYGEN_STEP_VIMAGE_195_575_REPORT.md`. Evidence:
`KEYGEN_STEP_VIMAGE_195_575.json` SHA256
`58119377abb6b0560079fd443bbeda00c4de31891ee8049c06d9cfaf0b04b77e`.
ENTRY_PINS remains `00f602e7…`; 74673/74673, 0 missing / 0 changed
before and after work. Legacy retained 65+58+4+finding preserved;
two local setup/environment failures are added in the separate
`KEYGEN_STEP_VIMAGE_195_FAILURES_575.json` supplement. No proof error,
no pinned-source edits, no use of the defective job-570 stepState.

Next unused suffix **576**. Next window composes `u1_body_image` across
u1 blocks, consumes `StepNttMiddle195.u1_step`, and transports the image
through the increment's unchanged heap. Keep the actual table index
m+j and block origin j*t explicit. Then compose mInner/rounds and
m-walk; only later bind productFd/productGd through tail_keep_words /
image_keep. The remaining false !out_ntt skip, section composition and
body_entry discharge stay in their existing order. No independent
review, push, stages import, migration or unconditional positivity
claim. Use tools/job111.py. The older route snapshots below are
retained history, not a request to repeat their closed steps.

# NTT3 engine route 571 — the first pass composed and exported at the entry frame; the intermediate doubling passes next

2026-10-23 (R1 engine window). OBLIGATION 1 (the NTT3 execution
engine) has its FIRST pass composed and exported (job
keygen_publicforward159_571, StepNttPrologue195 `f570ec96…`/olean
`53c01399…`, StepNttFirstLoop195 `6f9becf1…`/olean `af6afe2b…`, 2/2
accepted, logs 0/0, markers 0, standard three axioms on fifteen
exports). The prologue runs at the selected words logn = 9 / full = 0
(n = 512, hn = 256) with the kernel-checked false logn0 guard and the
executed MKN/halving words; the w = gm[1] assign binds the butterfly w
slot; firstInit walks u = 0, r1 = a, r2 = a + hn at the pinned stride =
1; the hn-step loop is composed (per-iteration run = block_run at the
walked pair + the u/r1/r2 increment; next_image/next_fixed; the
remaining induction) and exported at the StepNttEntry195 entry frame
(entry_run over the entryPrefix spine prefix, with prefix_continue
chaining continuation into tailT). COUNT NOTE (honest): hn = 256
degree-1 butterfly iterations over 512 marched words; "512 butterflies"
counts the words or both calls nttFs+nttGs at 2x256. Next unused proof
job suffix is **572**. Entry re-verified read-only at window start
(ENTRY_PINS `00f602e7…`, all 74673 inherited pins 0 missing / 0
changed, no active processes). Retained register 65 + 58 + 4 (no new
failed runs) plus one retained FINDING (below). Scoped proof,
NOT_REVIEWED; no push (6 earlier local commits wait plus this window's
for the owner's publication signal). Values stay executed words.

## RETAINED FINDING — the job-570 stepState is mis-composed (do not re-derive, do not patch silently)

StepNttFirst195.bodyHeap passes the OUTPUT words lowWordAt/highWordAt as
the a0/a1 arguments of StepNttBody195.highHeap, which expects the
butterfly INPUT words; its writes are therefore `lowWord (lowWordAt)
…` / `highWord (lowWordAt) …`, not the executed words the Image claims,
and next_image is FALSE at StepNttFirst195.stepState. The
execution-derived StepNttBody195.body_state (bodyOut at the input
words) is correct; this window composes at bodyAt/stepAt (defeq to
bodyOut and its increment closure) and records the defect instead of
editing pinned job-570 bytes. The job-570 keeps (step_*) never read the
heap and stay valid about its own stepState. Owner decision pending:
errata/refix of the 195 step layer or a permanent corrected supplement.

## Exact remaining obligations (in order)

1. The intermediate doubling passes (t = hn down; the
   KeygenNttForwardPrograms.mInner round body) and the full = 0 branch:
   the triple pass is NOT taken at full = 0 — kernel-check the branch,
   do not assume it. Continue from the entry_run/after state; the
   continuation hook is prefix_continue (entryPrefix + tailT).
2. productFd/productGd (the fd/gd pair-product loops; the product
   engines transfer from MakeFgProductShape191.productF /
   MakeFgGsShape194.productFGd verbatim).
3. The false !out_ntt skip (out_ntt = 1 at this step): the fd/gd
   modp_iNTT3_ext inverse pairs at logn-1/tlen (pairYes) and the
   modp_iNTT2_ext binary pair of the false ter alternative.
4. The loop composition and the section export: at that export the
   march exports consume the body_entry hypotheses directly (the row-1
   block-21 table-word keeps, the u/slen/tlen cells + primes binding,
   the StepU1Entry195.Input bundle). SelectedStepAddPrime195.body_entry
   and SelectedStepGenerate195.continue_inner chain into
   SelectedStepWalks195.walkFs_continue/walkGs_continue and then the
   NTT engine continuations.
5. Then the remaining d-levels and the root/certificate/codec path,
   before the complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers; the prospective bound remains
   Z>=2^-256 and is NOT established.

## Layer facts pinned this window (consume, do not re-derive)

- StepNttPrologue195: lognAt/fullAt at 9/0, nCell/hnCell at 512/256;
  value words guard_value/shl_zero_value/plus_one_value/
  minus_nine_value/mkn_value/half_value (inversion from Exec) and
  mkn_eval/plus_one_eval/minus_eval/half_eval/shl_full_eval
  (construction); statement results early_u/n_u/hn_u/prologue_result
  and locals_run/word_run/pointers_run/early_run/n_run/hn_run/
  prologue_run; ready-state exports ready_n/ready_hn/ready_hn_cell/
  ready_logn/ready_full/ready_p/ready_p0i/ready_stride/ready_a/ready_gm
  and the prologue keeps; gm_one_pointer/w_run (w = gm[1]); r2_pointer/
  initState/init_run/init_u/init_r1/init_r2/init_locals/init_arrays.
- StepNttFirstLoop195: fvLo/fvHi/bodyHeapAt/bodyAt/stepAt (the
  execution-derived iteration states) with bodyAt_*/stepAt_* keeps;
  load_allocated/load_width; body_run/increment_run/iteration_run; the
  two-write keeps two_write_keep/two_write_here_left/
  two_write_here_right; next_image/next_fixed; the guard helper;
  remaining; init_fixed/first_run; frame/firstTail/entryPrefix/
  firstNames with frame_logn/frame_full/frame_p/frame_p0i/
  frame_stride/frame_a/frame_gm, ready_w_free/ready_u_free/
  ready_locals_keep/ready_arrays_keep/w_set_locals_keep/w_set_arrays,
  wState/entry_fixed, and the exports entry_run + seq_parts/
  prefix_continue.

## Trap wall (księga additions — do not re-derive)

- `{src with f := v}` breaks on ANY parenthesized argument in a field
  value, not only `⟨x, by omega⟩` ("unexpected token '('"); precompute
  the entire value in a top-level def (fvLo/fvHi/bodyHeapAt pattern).
- C99LoopScalar141.less takes CLogic.EXPR arguments; pair it with
  C99LoopScalar141.read on the cells (guard helper pattern).
- simp normalizes `"hn".toList` to `['h','n']` in goals but not in
  hypothesis patterns: simp-based if-discharge through
  C99ScalarReference.set needs list-literal differences; term-level
  `exact` accepts the String form by defeq (probe kept in job logs).
- `prefix` is a Lean keyword; do not use it as a binder name.
- rw does not see through defs (wState): precede with `change` of the
  unfolded form; `have x : T := v` pins only T, so rfl lemmas must
  state the concrete terms or use `set`.
- branchFalse's constructor order is (condition)(yes no)(before)
  (result)(v)(guard)(zero)(body) — result before the guard value.

# NTT3 engine route 570 — the parse map + per-cell keeps + step layer accepted; the first-pass run next

2026-10-23 (R1 engine window). OBLIGATION 1 (the NTT3 execution
engine) has its parse/keep/step layer accepted (job
keygen_publicforward159_570, StepNttBody195 `b39a0b90…`/olean
`9c3120e7…`, StepNttFirst195 `928525ec…`/olean `cda17946…`, 2/2
accepted, logs 0/0, markers 0, standard three axioms on twelve
exports). The forward body is now a right spine of named run steps
(body_spine + splits), the butterfly words lowWord/highWord are the
executed leaf words tied to the KeygenNttButterflyCalls observations
(first_calls_words), the per-cell keeps are closed (load32_unique,
store32_unique/memory_ext, store_keep/here, the block frame), the
per-step engine runs (body_run/block_run/body_state at any r1/r2 pair),
and the first-pass layer (Image/Pending0, Fixed, stepState with keeps,
elem_step/elem_half/elem_double, times_word) is in place. COUNT NOTE
(honest): at the call instance logn = 9 / full = 0 (MKN = 512) the
first pass is hn = 256 degree-1 butterfly iterations over 512 marched
words; the shorthand "512 butterflies" counts words (or both calls
nttFs+nttGs at 2x256) — the kernel-checked loop bound is hn = 256.
Next unused proof job suffix is **571**. Entry re-verified read-only at
window start (ENTRY_PINS `00f602e7…`, all 74673 inherited pins 0
missing / 0 changed, no active processes). Retained register 65 + 58 +
4 (no new failures). Scoped proof, NOT_REVIEWED; no push (4 earlier
local commits wait plus this window's for the owner's publication
signal). Values stay executed words.

## Exact remaining obligations (in order)

1. The first-pass run (the engine milestone of the next window,
   possibly two): the prologue at the logn = 9 / full = 0 words
   (KeygenNttForwardExec's generic pieces transfer; the new mkn/half
   values are n = 512 / hn = 256 and the logn0 guard is kernel-checked
   false), the w = gm[1] assign (w_run), firstInit (init_run), the
   hn-step loop composition (the per-iteration run = block_run at the
   walked pair + the u/r1/r2 increment runs; next_image/next_fixed; the
   remaining induction) and the firstPass export at the
   StepNttEntry195 entry frame words. CONSUME the parse map, the
   per-cell keeps and the step layer of job 570; do not re-derive them.
2. The intermediate doubling passes (t = hn down; the KeygenNttForward-
   Programs.mInner round body) and the full = 0 branch: the triple pass
   is NOT taken at full = 0 — kernel-check the branch, do not assume
   it.
3. productFd/productGd (the fd/gd pair-product loops; the product
   engines transfer from MakeFgProductShape191.productF /
   MakeFgGsShape194.productFGd verbatim).
4. The false !out_ntt skip (out_ntt = 1 at this step): the fd/gd
   modp_iNTT3_ext inverse pairs at logn-1/tlen (pairYes) and the
   modp_iNTT2_ext binary pair of the false ter alternative.
5. The loop composition and the section export: at that export the
   march exports consume the body_entry hypotheses directly (the row-1
   block-21 table-word keeps, the u/slen/tlen cells + primes binding,
   the StepU1Entry195.Input bundle). SelectedStepAddPrime195.body_entry
   and SelectedStepGenerate195.continue_inner chain into
   SelectedStepWalks195.walkFs_continue/walkGs_continue and then the
   NTT engine continuations.
6. Then the remaining d-levels and the root/certificate/codec path,
   before the complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers; the prospective bound remains
   Z>=2^-256 and is NOT established.

## Layer facts pinned this window (consume, do not re-derive)

- StepNttBody195: the parse map (body_spine/locals_split/…/mHead_split,
  first_loop_split/init_split/step_split/advance_split, the butterfly
  chain body_shape/tail1_split..tail5_split); words montWord/sumWord/
  lowWord/highWord + first_calls_words; keeps load32_unique,
  memory_ext, store32_unique, store32_write, store_keep, store_here,
  write_allocated, write_writable, declared_outside/declared_keep,
  set_keep/slot_keep; the step engine body_run/block_run/block_keep/
  body_state with the states declared/withA0/withA1/withB/lowState/
  highState/bodyOut.
- StepNttFirst195: elem_step/elem_half/elem_double/elem_separate,
  times_word, Image/Pending0/pending_image, Fixed (a/gm bindings, cells,
  gmSeparate/gmLoads), bodyHeap/bodyState/stepState with
  step_locals/step_arrays/step_heap/step_u/step_r1/step_r2.

## Trap wall (księga additions — do not re-derive)

- `{src with f := v}` with a field value containing `⟨x, by …⟩`
  anonymous constructors breaks the structure-instance parser;
  precompute such words in top-level defs and keep record values plain
  (also mind the earlier one-line field-value trap).
- `Load32.load` has four case binders (h/p are indices); byte equality
  needs Option.some.inj; `cases` on a structure variable keeps
  dependent hypotheses readable through defeq and closes with `rfl`.
- `Pointer` is an inductive family: `show Pointer s …` does not see
  through record-update states; build zero_pointer at the exact state.
- Nat.add/mul: `x+(v+1)` ≡ `(x+v)+1` but `x*1`/`2*x` are not defeq —
  omega-cast congrArg lemmas (elem_half/elem_double).
- `StepCopyFixed190` and `StepProductBody191` need explicit imports
  outside the KeygenNtt* closure.

# Additional-prime route 568/569 — the marches closed (512 ms_call instances each, t1[v] stores), NTT3 call-shape binding pinned; the NTT3 engine next

2026-10-22/23 (R1 march window). OBLIGATION 1 OF THE REMAINING LIST IS
CLOSED: walkFs and walkGs (MakeFgAddPrimeShape194.walkF "fs"/"gs") run
in full at n = 512, slen = 1 (SelectedStepWalks195, job
keygen_publicforward159_568; sources `ee1d5f7f…`/`d9cb2531…`/
`20f5c7bf…`/`1028e8af…`, oleans `d79737df…`/`6240d233…`/`4567317f…`/
`5718d9e1…`, 4/4 accepted, logs 0/0, standard three axioms on eleven
key exports, markers 0, maxRSS 4147720 KiB). Each march is the walk
initialiser (v = 0, x = fs/gs + 0) plus exactly 512
ZintModSignedWord194.ms_call instances at the pinned walk shape
MakeFgAddPrimeShape194.modArgs — one per marched word, marched limb
Load32 (addr src 0 i 1) (fv i) — each returned executed word
modSignedWord (fv i) pw p0w r2w rxw stored to t1[i] through the
ReceiveC.store of modCall, with the two-clause increment composed over
the whole march. Exports: the executed image t1[i] = modSignedWord
(fv i) pw p0w r2w rxw (PrefixImage over Fin 512), the keeps outside
the t1 region (source words survive; fv carries only executed loads),
exit cells v = 512 / x = addr src 0 512 1, and the continuations
walkFs_continue (r1 = walkFs ; r2) / walkGs_continue (r4 = walkGs ;
r5). OBLIGATION 2 IS STARTED at its call-shape binding (job
keygen_publicforward159_569, StepNttEntry195 `15d44393…`, olean
`050a9b11…`, accepted/clean): the pinned seven-argument wrapper list
forwardArgs binds to KeygenLevelCalls.params .forward with the exact
fresh callee entry frame a := t1, stride := 1, gm := gm, logn := word,
full := 0, p := pw, p0i := p0w. NO execution engine yet. Next unused
proof job suffix is **570**. Entry re-verified read-only at window
start (ENTRY_PINS `00f602e7…`, all 74673 inherited pins 0 missing / 0
changed, no active processes). Retained register 65 + 58 + 4 (no new
failures). Scoped proof, NOT_REVIEWED; no push (2 earlier commits wait
plus this window's two). Values stay executed words.

## Exact remaining obligations (in order)

1. The NTT3 execution engine (nttFs/nttGs at ter = 1): the
   modp_NTT3_ext body run (KeygenNttForwardPrograms.forwardBody) from
   the StepNttEntry195 entry frame — the biggest item, now a clean
   multi-window engine start with the call binding in hand.
   Suggested order inside this item: the prologue at the u = 1 words
   (KeygenNttForwardExec has the prologue derivations to transfer),
   then the first pass (512 degree-1 butterflies,
   KeygenNttButterflyCalls supplies the per-butterfly call
   observations), the intermediate doubling passes and the full = 0
   branch (the triple pass is NOT taken at full = 0 — kernel-check the
   branch, do not assume it).
2. productFd/productGd (the fd/gd pair-product loops; the product
   engines transfer from MakeFgProductShape191.productF /
   MakeFgGsShape194.productFGd verbatim).
3. The false !out_ntt skip (out_ntt = 1 at this step): the fd/gd
   modp_iNTT3_ext inverse pairs at logn-1/tlen (pairYes) and the
   modp_iNTT2_ext binary pair of the false ter alternative.
4. The loop composition and the section export: at that export the
   march exports consume the body_entry hypotheses directly — the
   row-1 block-21 table-word keeps (SelectedStepCrtWord194 precedent;
   both .p and .g), the u/slen/tlen cells + primes binding from
   SelectedStepFsFd194.source through SelectedStepCrtRun194, and the
   StepU1Entry195.Input bundle. SelectedStepAddPrime195.body_entry and
   SelectedStepGenerate195.continue_inner chain into
   SelectedStepWalks195.walkFs_continue/walkGs_continue.
5. Then the remaining d-levels and the root/certificate/codec path,
   before the complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers; the prospective bound remains
   Z>=2^-256 and is NOT established.

## March facts pinned this window (consume, do not re-derive)

- StepWalkBody195.body_source is ONE march step: the ms_call instance
  at modArgs with the t1[v] store; the callee keeps every caller cell
  and the heap, the only state change is the store. inc_source is the
  copy-loop increment verbatim (StepCopyBody190.inc_source at u0 = 0,
  slen = 1).
- StepWalkFixed195.Fixed is the march invariant (srcName, source/t1
  pointers, n, fv : Fin n → BitVec 32, section words pw p0w r2w rxw);
  next_fixed/next_prefix preserve it through one step; the image word
  is modSignedWord (fv i) pw p0w r2w rxw.
- StepWalkLoop195.remaining is the n-step induction (the
  StepCopyLoop190 pattern), walk_run adds the initialiser over
  midState; walkOf/initOf are the Name-generic walk statements with
  init_shape/walk_shape rfl-binding them to walkInit/walkF.
- SelectedStepWalks195.walkFs_run/walkGs_run instantiate n = 512 at
  the named statements; the continuations close r1_split/r4_split.

## Trap wall (księga additions — do not re-derive)

- `simpa [rules] using e` fails with "Type mismatch: After
  simplification" when the goal names a DEFINED constant (walkGuard)
  defeq to the lemma's constant (copyCondition), although `rfl` proves
  the equality and plain `exact`/term mode accept the defeq. State
  such a `have` with the raw constant (or without an ascription) and
  let the later constructor application do the defeq step.
- `rw` does not see through the Cell/Slot definitions: precede it with
  `show (state).locals name = some (ty, some (value))` of the unfolded
  form.
- KeygenLevelCalls.Param is C99ArrayReference.Param (opened there);
  KeygenLevelCalls.Eval.modular and C99ModularReference.GenEval.scalar
  take (e v source) three arguments.
- KeygenLevelCalls.Bind binds the head parameter OUTERMOST: the nil
  frame is ⟨heap, globals, tables, globals, tables⟩ and the chain
  builds tail-first (entry defs in StepNttEntry195 follow this order).
- The stride/full arguments of forwardArgs are i32 literals (.literal
  .i32 1 / 0) evaluated to .int32 values and converted at bindValue;
  the entry cells show the converted words.

# Additional-prime route 567 — the u = 1 ter generator branch closed (mkgm3 body run at the u = 1 words), the marches next

2026-10-22 (R1 generate window). STEP 3 OF THE STEPS 1-7 ROUTE IS
CLOSED: the ter generator branch of the make_fg_step additional-prime
loop body at the u = 1 cell is executed in full
(SelectedStepGenerate195, job keygen_publicforward159_567; sources
`4043f71b…`/`1f1dea19…`/`cb65b2ea…`/`91c53ae8…`, oleans
`9b0f7307…`/`6773f91a…`/`99685a03…`/`24fad3ea…`, 4/4 accepted,
logs 0/0, standard three axioms on twelve key exports, markers 0,
maxRSS 4140504 KiB). The whole KeygenMkgm3Program.code body runs at the
u = 1 words p1/p0i1/r21/rx1(= r1)/g1 = 1119654270 (row-1 .g of the
block-21 ternary table), the wrapper call binds the pinned
seven-argument list generateArgs and the branch closes at ter = 1 with
the loop-body continuation. Next unused proof job suffix is **568**.
Entry re-verified read-only at window start (ENTRY_PINS `00f602e7…`,
all 74673 inherited pins 0 missing / 0 changed, no active processes).
Retained register 65 + 58 + 4 (566 = the runner-misuse refusal). Scoped
proof, NOT_REVIEWED; no push (6 waits); values stay executed words.

## Exact remaining obligations (in order)

1. The two marches walkFs and walkGs (MakeFgAddPrimeShape194.walkF
   "fs"/"gs"): each is the 512-step zint_mod_small_signed walk over the
   fs/gs source words at stride slen = 1 with the executed word stored
   to t1[v] (modCall = .call .modSigned modArgs (.store "t1" varV),
   modArgs = [pointer x 0, scalar slen, p, p0i, R2, Rx]). The per-word
   engine ZintModSignedWord194.ms_call is ready; the NEW work is the
   walk loop composition and the t1[v] stores — ZintNormWalk194.walk_run
   is the loop precedent (loop run + image + keeps + exit cells), and
   the Word32Memory176 keep discipline is the same as the fs/gs walks of
   the CRT layer.
2. nttFs/nttGs — the forward modp_NTT3 runs (nttBranch at ter = 1, the
   wrapper call modp_NTT3(t1, gm, logn, 0, p, p0i) over the expanded
   stride-1 argument list forwardArgs): NO execution engine exists yet —
   the biggest item; KeygenNttForwardPrograms pins the body and
   KeygenNttForwardExec has only the prologue derivations.
3. productFd/productGd (the fd/gd pair-product loops; the product
   engines transfer from MakeFgProductShape191.productF /
   MakeFgGsShape194.productFGd verbatim).
4. The false !out_ntt skip (out_ntt = 1 at this step): the fd/gd
   modp_iNTT3_ext inverse pairs at logn-1/tlen (pairYes) and the
   modp_iNTT2_ext binary pair of the false ter alternative.
5. The loop composition and the section export: at that export the
   prefix/generator entry facts are discharged — the row-1 block-21
   table-word keeps (SelectedStepCrtWord194 precedent; now both .p and
   .g), the u/slen/tlen cells + primes binding from
   SelectedStepFsFd194.source through SelectedStepCrtRun194, and the
   StepU1Entry195.Input bundle (p/p0i/logn/u/ter cells, gm/igm/primes/
   REV10 bindings, REV10 SourceTable, block-31 scratch allocations,
   writable 31, raw-initialized gm/igm spans). SelectedStepAddPrime195.
   body_entry and SelectedStepGenerate195.continue_inner consume
   exactly those hypotheses in sequence.
6. Then the remaining d-levels and the root/certificate/codec path,
   before the complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers; the prospective bound remains
   Z>=2^-256 and is NOT established.

## Generate facts pinned this window (consume, do not re-derive)

- The u = 1 run words are StepU1Entry195.{p1,p0i1,r21,g1,r1} with
  g1_word/fieldPointer_one_g/r1_word and g_object_word (the .g analog of
  SelectedStepAddPrime195.object_word). r1 = KeygenModpR.word p1 is the
  same word as SelectedStepAddPrime195.rx1 (r1_word).
- StepU1Entry195: the callee entry spine (empty/withI/withP/withG/
  withFull/withLogn/withIgm/entry over the caller state), the primes[1].g
  PrimeRead at MakeFgAddPrimeShape194.var "u" (PointerAdd.within primes
  1, fieldPointer_one_g), the Bind of generateArgs, source_call and the
  static-fact transports (entry_heap := rfl, rev_binding via the tables
  frame — the fresh callee frame sees tables, not caller arrays).
- StepU1Body195: the prelude spine and runs (rAssign/r2Assign/gConvert/
  kFromLogn0, ifNotFull at full = 0 with the g cube, whileK at logn = 9
  with one loop round, igAssign), append_source/continue_generator into
  KeygenMkgm3Program.code and the Ready-style cell/heap facts.
- StepU1Run195: the row prelude and 512-row loop instance
  (Gen0RowLoop189.full at the u = 1 words), rowSelect at logn = 9 ->
  elseRow, kFromLogn/ifFull, the squareLoop instance
  (GeneratorSquareLoop181.full) and the top elements
  (GeneratorTopSource181.source), composed in body_source. The
  engine-result states (rowLoopAfter/squareAfter/w/topAfter) are
  parameterized by the caller-state input proof; thread ONE input0 term
  through every use (defeq discipline).
- SelectedStepGenerate195: call_run/instruction/scoped_run/branch_source
  at ter = 1 and the continuation; afterGenerate changes only the heap,
  so every caller local/array cell keeps (locals_keep/arrays_keep).

## Trap wall (księga additions — do not re-derive)

- A naked `ModCall` in a fresh FT1536.Source3.* namespace is NOT
  `C99ModularReference.ModCall`: with autoImplicit it becomes a new fvar
  of type CallRelation and the theorem silently gains an implicit. The
  failure surfaces as a general "Type mismatch" whose expected type
  prints the fvar SHORT against the FULLY-QUALIFIED constant of the real
  term; the printed state difference (preAfter s vs the unfolded form) is
  defeq-fine and is NOT the cause. Open `C99ModularReference (… ModCall
  …)` or qualify the constant in every Run/ModularSequence178 statement.
- The acceptance runner of the key-law lane is tools/job111.py (its
  RUNNER_SOURCE is byte-identical to jobs 559-565); it merges the
  .build/key_law088/CACHE_INDEX.json lane cache. tools/job.py is the
  historical rebind runner and refuses the re-baselined rx-stratum
  source against its stale main-cache entry ("stale source cache
  (rebuild): Source3.C99ModularReference"). Label 566 was consumed by
  that refusal and retained in KEYGEN_STEP_GS_194_FAILURES.json.
- Entry-frame reminder: the fresh callee frame starts
  locals := globals, arrays := tables (KeygenLevelCalls.Bind.nil), so a
  callee-side REV10 binding comes from the CALLER TABLES
  (s.tables "REV10"), not from s.arrays.

# Additional-prime route 565 — the u = 1 prime prefix closed (assembly layer), the ter/walk/NTT chain next

2026-10-21 (R1 add-prime prefix window). STEP 2 OF THE STEPS 1-7 ROUTE
IS CLOSED: the seven-statement prime prefix at u = 1
(MakeFgAddPrimeShape194.prefixSteps) is executed at the part-4
loop-body scope entry, assembled from ready elements only
(SelectedStepAddPrime195, job keygen_publicforward159_565; source
`d1c0407c…`, olean `5cb290f6…`, 3.575 s, logs 0/0, standard three
axioms on twelve key exports, markers 0). The words are the executed
words p1 = BitVec.ofNat 32 2147346433 (the primes[1] row of the
block-21 ternary table, pinned by decide: 2147346433 / 1119654270 /
238827065), p0i1 = KeygenNinv31.word p1, r21 = KeygenModpR2Word.word p1
p0i1, rx1 = KeygenModpR.word p1 (the kernel-checked empty-loop modp_Rx
word at x = 1). Next unused proof job suffix is **566**. Entry
re-verified read-only at window start and after the job (ENTRY_PINS
`00f602e7…`, all 74673 inherited pins 0 missing / 0 changed, no active
processes). Scoped proof, NOT_REVIEWED; no push (4 waits); values stay
executed words.

## Exact remaining obligations (in order)

1. The eight-statement chain at the same u = 1 cell: the ter branch
   (the modp_mkgm3 wrapper call with the pinned seven-argument list,
   MakeFgAddPrimeShape194.generateArgs), walkFs and walkGs (each 512
   per-word zint_mod_small_signed calls — ZintModSignedWord194.ms_call is
   ready; the walk loop composition and the t1[v] stores are the new
   work), nttFs/nttGs (the forward modp_NTT3 runs — NO execution engine
   exists yet: the biggest item; KeygenNttForwardPrograms pins the
   body), productFd/productGd (the product engines transfer), the false
   !out_ntt skip (the fd/gd inverse pairs), then the loop composition
   and the section export. At that export the prefix entry facts are
   discharged: the row-1 block-21 table-word keep (SelectedStepCrtWord194
   keep precedent) and the u/slen/tlen cells + primes binding from
   SelectedStepFsFd194.source through SelectedStepCrtRun194 —
   SelectedStepAddPrime195.body_entry consumes exactly those
   hypotheses.
2. The remaining d-levels and the root/certificate/codec path, before
   the complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers; the prospective bound remains
   Z>=2^-256 and is NOT established.

## Prefix facts pinned this window (consume, do not re-derive)

- SelectedStepAddPrime195 exports: words p1/p0i1/r21/rx1 and the row-1
  pin row1/row1_value/object_word; the executed states withWords/withV/
  withX/withP/withI/withR/after and their cell equations (withP_p …
  after_rx, after_heap); statement runs words_run/v_run/x_run/decls_run/
  p_read/p_source/i_source/r_source/rx_source; the composed
  append_source/prefix_source/continue_inner; the result cells p_cell/
  i_cell/r2_cell/rx_cell; and the loop head init_source/guard1 over any
  exit state, composed in body_entry at u1.
- The PrimeRead at u = 1 is the same constructor shape as the
  first-prime p_read (SelectedStepPrime188), with the address
  PointerAdd.within primes 1 and the bridge fieldPointer_one
  (fieldPointer primes1 .p = primeField primes 1 .p).

## Trap wall (księga additions)

- An EMPTY namespace directory inside an earlier LEAN_PATH root swallows
  module search for the whole namespace (Lean binds the namespace to
  that root and reports missing object files there). The workshop root
  must be populated with the dependency oleans (symlinks) before use, or
  kept out of LEAN_PATH during compilation.
- Dotted constructor notation (.uint32/.uint64) is ambiguous in
  congrArg lambda types (many same-named constructors); use an explicit
  cell_pair helper. `if_neg` is deprecated in this toolchain
  (warningAsError) — use simp with the disequality instead.
- Scope boundary recorded in the module: the row-1 load at the entry
  heap is a hypothesis; the exact direction (uniqueness of the seven
  statement words) is not claimed, matching the first-prime layer.

# Additional-prime route 564 — the empty-loop modp_Rx engine closed, the prime prefix next

2026-10-21 (R1 rx window). STEP 1 OF THE STEPS 1-7 ROUTE IS CLOSED: the
modp_Rx engine at the empty-loop instance x = 1 (`KeygenModpRxExec`, job
keygen_publicforward159_564; source `20dc6330…`, olean `d69d1829…`,
5.125 s, logs 0/0, standard three axioms, markers 0). The pinned body
C99ModularReference.rxCode executes in full at x = 1 and the executed
word of the whole callee is the pinned leaf word `KeygenModpR.word p` —
PROVEN in both directions (body_exists/source_exists and
body_exact/source_exact), not assumed; the empty loop is kernel-checked
(guard `(1U << i) <= x` false at i = 0). The u64-argument variant
`SourceExec64`/`source64_exact`/`source64_exists` matches the parsed
call4 shape of MakeFgAddPrimeShape194.rxSet (slen = 1 u64 cell).
Next unused proof job suffix is **565**. Entry re-verified read-only at
window start (ENTRY_PINS `00f602e7…`, all 74673 inherited pins 0 missing
/ 0 changed, no active processes). Scoped proof, NOT_REVIEWED; no push
(2 waits); values stay executed words.

## Exact remaining obligations (in order)

1. STEP 2 — the seven-statement prime prefix at the u = 1 iteration
   (MakeFgAddPrimeShape194.prefixSteps, decide-bound shapes; NO
   reconnaissance): declP/declV/declX (C99DeclarationStatements.effect),
   pSet (KeygenZintCall.Exec.prime with a KeygenLevelCalls.PrimeRead of
   primes[1].p — the block-21 table word transport of
   SelectedStepCrtWord194 is the keep precedent), iSet (ModCall inverse
   at KeygenNinv31.word), rSet (ModCall r2 at KeygenModpR2Word.word via
   KeygenModpR2Exec) and rxSet (ModCall rx at KeygenModpR.word via
   KeygenModpRxExec.source64_exists / source64_exact — CLOSED this
   window). Entry state: the part-4 loop-body scope entry at u = 1 (the
   part-3 CRT exit state exported by SelectedStepCrtRun194).
2. Then the eight-statement chain: the ter branch (modp_mkgm3 wrapper
   call with the pinned seven-argument list), walkFs and walkGs (each
   512 per-word calls — ZintModSignedWord194.ms_call is ready; the walk
   loop composition and the t1[v] stores are the new work), nttFs/nttGs
   (the forward modp_NTT3 runs — NO execution engine exists yet: the
   biggest item; KeygenNttForwardPrograms pins the body),
   productFd/productGd (the product engines transfer), the false
   !out_ntt skip (fd/gd inverse pairs), then the loop composition and
   the section export.
3. The remaining d-levels and the root/certificate/codec path, before
   the complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers; the prospective bound remains
   Z>=2^-256 and is NOT established.

## Engine facts pinned this window (consume, do not re-derive)

- KeygenModpRxExec names the whole empty-loop run: statement pieces
  declI/declRZ/xDec/rSet/zSet/iInit/loopRun/retZ (code_split,
  loop_split by rfl), executed states entry/s1..s6, the cell facts
  entry_x/entry_p/entry_R2/s2_x/s3_r/s3_R2/s4_z/s4_p/s5_i/s5_x/s6_i/
  s6_x/s6_z (literal cells by rfl, variable cells through
  ZintSubWord194.convert_self32) and the statement runs declI_run/
  declRZ_run/xdec_run/rset_run/zset_run/iinit_run/loop_false/rxloop_run.
- The exact direction is the chain exact_t2..exact_t7 (one continuation
  step per statement, split for kernel locality) plus the export
  body_exact = congrArg Result.flow (return_exact …).
- Word-op bridges: minus_one32/dec_one32 (x -= 1 at u32),
  shift_one_zero (1U << 0), le_one_zero (1 <= 0 false) and the guard
  evaluation guard_exists/guard_value_exact over guardExpr.

## Trap wall (księga — see the report §Traps met for the full list)

`cases … with` alternative patterns need the FULL constructor arity and
names in index-determined slots do not bind; a defeq across two
ground-equal state-cell facts kernel-normalizes both giant states and
blows the memory limit (the s6_x-vs-s5_x trap). Make every crossing
syntactic. Build-order note stands: order modules by the REAL
transitive source-import graph.

# Additional-prime route — the section call shapes pinned, the modp_Rx stratum decision next

2026-10-21 (R1 additional-prime window). The NAJPIERW obligation of the
owner's route is closed: the parsed call shapes of the make_fg_step
additional-prime section (KeygenMakeFgSource.part .step 4, the
remaining-words loop `for (u = slen; u < tlen; u ++)` at the selected
instance slen = 1 / tlen = 2) are pinned by decide against the parse
record of the retained diagnostic probe AddPrimeParseProbe194 (job 553)
in MakeFgAddPrimeShape194 (job 557, drafts 554/555/556 retained), and
the modp_Rx callee body transcription plus its source binding are
pinned in KeygenModpRx (job 558). The section's steps are NOT started:
the canonical execution is blocked at statement 7 of the loop body by
the modp_Rx call-stratum wall recorded below. Next unused proof job
suffix is **559**. Entry re-verified read-only at window start
(ENTRY_PINS `99ac47a1…`, all 73564 inherited pins 0 missing / 0
changed, no active processes). Scoped proof, NOT_REVIEWED; no push
(batch 4 waits for the owner's signal); values stay executed words.

## Exact remaining obligations (in order)

1. THE OWNER DECISION on the modp_Rx wall: extend the pinned
   formal/Source3/C99ModularReference.lean ModCall stratum with the rx
   constructor (rxParams/rxCode/rxBody plus `| rx (args out) (body :
   rxBody args out) : ModCall "modp_Rx" args out`; the exact B1.03
   precedent of the r2/div constructors, commits 0e5a0b02/c3170530;
   the ready plug is KeygenModpRx and its binding moves verbatim) and
   document the pin-chain re-baseline, or route the section otherwise.
   Without it no statement of the additional-prime loop body past the
   prime prefix receives a canonical KeygenMakeFgSource.Exec
   derivation.
2. The additional-prime steps at slen = 1 / tlen = 2 (after the
   decision): the prologue words at the u = 1 iteration (p = primes[1].p,
   p0i = modp_ninv31(p), R2 = modp_R2(p, p0i), Rx = modp_Rx(1, p, p0i,
   R2); at x = 1 the body loop is empty and the intended executed word
   is modp_R(p) — paper analysis only, the value law needs the stratum
   constructor), the ter generator call modp_mkgm3(gm, igm, logn, 0,
   primes[1].g, p, p0i), the two 512-step zint_mod_small_signed walks
   over fs/gs — their per-word engine at dlen = 1 is NOT blocked by the
   wall and is the first engine to build: ZintModSignedWord194 over the
   pinned callee spine plus the zint_mod_small_unsigned leaf at dlen = 1
   — then the two forward modp_NTT3 runs (KeygenNttForwardPrograms pins
   the body; no execution engine exists yet — the biggest item), the
   fd/gd product loops at the u = 1 cell (tlen = 2 walk; the product
   engines transfer) and the false !out_ntt skip; then the loop
   composition and the section export.
3. The remaining d-levels and the root/certificate/codec path, before
   the complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness); the prospective bound
   remains Z>=2^-256 and is NOT established.

## WALL (księga pułapek — modp_Rx is outside the pinned ModCall stratum; do not re-derive)

The `Rx = modp_Rx(slen, p, p0i, R2)` statement of the additional-prime
loop body parses as a modular-layer `Expr.call4` assignment (probe 553).
The canonical modular execution relation is `C99ModularReference.Exec =
GenExec ModCall` and the closed ModCall stratum covers exactly
modp_montymul / modp_add / modp_sub / modp_ninv31 / modp_set / modp_R /
modp_R2 / modp_div; KeygenMakeFgSource.Exec, KeygenLevelExec.Exec and
KeygenWordExec.Exec all fix that relation, so NO KeygenMakeFgSource.Exec
derivation exists for the rxSet statement (statements 1-6 of the loop
body are executable under the pinned semantics, the seventh is not).
The fix is the precedented call-stratum extension in the PINNED source
C99ModularReference.lean; that file is inside the inherited
73564-path pin set, so the edit is an owner decision and needs a
documented pin-chain re-baseline. The same wall hits every later
modp_Rx call site (poly_sub_scaled_ntt falcon-keygen.c:4626,
solve_NTRU_intermediate :5906/:5985, solve_NTRU_binary_depth1 :6474) —
one extension closes them all. The wall is a coverage gap of the pinned
call whitelist, not a source-correctness result.

## Engine facts pinned this window (consume, do not re-derive)

- MakeFgAddPrimeShape194 names the whole additional-prime section:
  loop head (init u = slen, guard u < tlen, increment u += 1, body
  scope locals p/p0i/R2/Rx/v and pointer x), the seven-statement prime
  prefix (three declarations; pSet/iSet/rSet = StepPrimeShape188
  verbatim; the new rxSet call4), and the eight-statement chain with
  every call's exact parsed argument list: generateBranch (modp_mkgm3
  wrapper + modp_mkgm2 binary), walkFs/walkGs (the per-word
  zint_mod_small_signed call stored to t1[v], walked over fs/gs at
  stride slen; one walk shape, two instantiations), nttFs/nttGs (the
  modp_NTT3 wrapper at the expanded stride-1 argument list + the
  modp_NTT2 binary), productFd/productGd (= MakeFgProductShape191.
  productF / MakeFgGsShape194.productFGd verbatim) and outBranch (the
  false !out_ntt branch with the fd/gd modp_iNTT3_ext pair at
  logn-1/tlen and the modp_iNTT2_ext binary pair).
- The zint_mod_small_signed callee spine is pinned (z declaration, dlen
  = 0 early return, the zint_mod_small_unsigned leaf call into z, the
  modp_sub correction `z = modp_sub(z, Rx & -(d[dlen-1] >> 30), p)`,
  the z return) — the per-word walk engine consumes it directly.
- KeygenModpRx pins the modp_Rx body (region 2609 18, header line
  2607): `x--; r = R2; z = modp_R(p); for (i = 0; (1U << i) <= x; i ++)
  { if ((x & (1U << i)) != 0) z = modp_montymul(z, r, p, p0i); r =
  modp_montymul(r, r, p, p0i); } return z;` with rxParams (x/p/p0i/R2).
- Trap (register 556): a shape equality comparing two projections of
  two different whole-section parses blows the kernel memory limit;
  bind cross-section shapes as local transcriptions in split form
  (guard, then each side) instead.

Only executed-word semantics is in scope: no transform property, table
law, root law or positivity claim; unconditional Z>0, numerical
p_accept, conditional coding and positive p_K remain OPEN. Old110 stays
frozen; measured wording 8192/23628 with the separate 256/739 control
and the five do_sign items remain unchanged. Scoped proof,
NOT_REVIEWED; no IID/D1/F04 premise; no push (batch 4 waits for the
owner's signal). Retained failures: `KEYGEN_STEP_GS_194_FAILURES.json`
(61 records), the inherited checkpoint192 register (58) and
checkpoint193 register (4).

---

# CRT part-3 route — the part-3 composition closed, the additional-prime part next

2026-10-21 (R1 crt-run window). Obligation (c) is fully closed: the
make-level composition of both zint_rebuild_CRT call statements of part 3
(`SelectedStepCrtRun194.source`, job 551, commit of this window) runs the
exact Bind chain of MakeFgCrtShape194.crtArgs "fs"/"gs" over the named
arguments at the SelectedStepFsFd194.source loop exit state, executes
both ZintRebuildCrt194 bodies at xlen = 1 and composes
first3/second3/tail3; the export carries the executed-word images
`normWord p0 (fsWords i)` / `normWord p0 (gsWords i)` over the twin
512-word walks and the bystander keeps from `next.heap` to
`final.heap` for every cell separated from gm and both walks. The axiom
audit of the assembly (`SelectedStepCrtAudit194`, job 552) shows the
standard three axioms only; proj_heap/proj_arrays are axiom-free.
Next unused proof job suffix is **553**.

## Exact remaining obligations (in order)

1. The additional-prime part (slen 1 / tlen 2): NOT started in the
   crt-run window; before any engine, pin the parsed call shapes of the
   additional-prime section (the same decide-bound shape-module pattern
   as MakeFgCrtShape194 against a parse probe record). Then the
   remaining d-levels and the root/certificate/codec path, before the
   complete emitted witness can instantiate the corrected
   KeygenProbability134 consumers (KeygenModelUnlock134... see the
   report).
2. No assembly obligation remains: SelectedStepCrtRun194.source and its
   axiom audit are accepted (jobs 551/552, logs 0/0).

## Bridge recipe (validated end-to-end by job 551 — do not re-derive)

The concrete-Memory defeq trap (jobs 543-548) has a working discipline:
(a) never let the unifier compare two syntactically different concrete
Memory terms and never let it compare a projection of a concrete
record-update instance with its own field value — the unifier unfolds the
non-projection side first and explodes over the walkImage/write closures
(probe CrtBridgeProbe194); (b) project through abstract bridge lemmas
instantiated at the concrete memory (`proj_heap`/`proj_arrays`/
`proj_locals := rfl`), rewrite along CLOSED-pattern bridging equations,
or take a single delta step of a plain top-level definition into its own
body; (c) plain top-level noncomputable defs for intermediate
states/heaps (fsHeapOf/midFs/gsHeapOf/midGs), never set-bindings, and
witness states chosen equal to the engine result states so the whole
composition is syntactic; (d) NEW parse trap: in `{src with f := v}` a
field value on the NEXT line parses as a new elided field — keep
structure-instance values on one line.

## Engine facts to consume (do not re-derive)

- `SelectedStepCrtRun194.call_run` is the per-call engine over the named
  arguments (Bind chain `bind_crt`/`entryOf`, body run at xlen = 1,
  flat walkImage result state, per-word image); `keep_through` crosses
  one call's heap image for any separated cell.
- `SelectedStepCrtRun194.source` exports the part-2/part-3 runs at
  `SelectedStepMove187.after`, the fs/gs normWord images at the final
  state and the bystander keeps; midFs/midGs are the two call result
  states and midFs_heap/midGs_heap are their only heap bridges.

# CRT part-3 route — the 512-step walk and the rebuildCrt engine closed, the part-3 assembly next

2026-10-21 (R1 walk/body window). Obligation (c) is half closed: the
512-step normalize walk (ZintNormWalk194, job 529 + audit 530) and the
full zint_rebuild_CRT body run at xlen = 1 (ZintRebuildCrt194, job 534)
are accepted, commits cab5bf85/df6c67ac, standard three axioms. The
walk export is the executed-word image `fun i => normWord p0 (words i)`
over the walk with the Word32Memory176 keeps (the twin fs/gs
instantiation at the 512-word separation); the body engine covers the
storePrime/PrimeRead of the block-21 table word, the u = 1 init, the
EMPTY co-reduction loop at xlen = 1, the normalize branch and the void
end flow, with the body-end heap `walkImage (write entry.heap pp p0) px
p0 words 512`. Next unused proof job suffix is **549**.

## Exact remaining obligations (in order)

1. `SelectedStepCrtRun194.source` (drafts 535-548, source present):
   the Bind chain of MakeFgCrtShape194.crtArgs "fs"/"gs" (entryOf/
   bind_crt — the first parameter binds outermost), the two
   ZintRebuildCrt194 body runs instantiated at the loop exit state of
   SelectedStepFsFd194.source, and the make-level composition of
   first3/second3/tail3 over the named arguments with the exit-state
   export (the fs/gs normWord images and the keeps). The blockage and
   its fix recipe are recorded below. Then an axiom audit of the
   assembly modules.
2. The additional-prime part (slen 1 / tlen 2), the remaining d-levels
   and the root/certificate/codec path, before the complete emitted
   witness can instantiate the corrected KeygenProbability134 consumers
   (KeygenModelUnlock134... see the report).

## Trap recorded (do not re-derive) — concrete-Memory defeq explodes

Unification across `Memory`-valued terms that differ syntactically
dives into the nested `Word32Memory176.write` closures and the
walkImage recursion and blows up (recursion cap at 4M -> stack overflow
-> std::bad_alloc/out of memory; jobs 543-548). The isolated probe
CrtBridgeProbe194 (job 547) localized it: the record-update projection
`({s with heap := H}).heap = H` is trivial with ABSTRACT H but explodes
with the CONCRETE heapFsOf next. Rules for every module from here on:
(a) never let the unifier compare concrete memory terms — project
through abstract bridge lemmas (proj_heap applied at the concrete
memory) and make every remaining crossing syntactic (unfold the defs on
both sides, or rw along a bridging equation); (b) set-tactic bindings
are fvar+equation and NOT defeq-safe — use plain top-level
noncomputable definitions for intermediate states/heaps; (c) a
noncomputable def rejected by the compiler stays a stub and poisons all
later unification with bogus recursion-depth errors.

## Engine facts to consume (do not re-derive)

- `ZintNormWalk194.walk_run` over the walk entry state exports the loop
  run, the normWord image, the keeps, and the u = 512 / x exit cells;
  `walkImage_keep`/`walkImage_pending` give arbitrary-cell keeps.
- `ZintRebuildCrt194.body_run` over an abstract entry state (cell
  hypotheses xx/primes/tmp/xlen/xstride/num/normalize_signed plus the
  table-word load and the walk loads) exports the full rebuildCrt run
  at xlen = 1 with the body-end heap and image; `bind_crt`/
  `entryOf` of SelectedStepCrtRun194 give the exact Bind of the named
  arguments and its entry-state cells.
- `keep_through` crosses one call's heap image for any separated cell;
  gm/table separations are gm_offset0/fs_offset/gs_offset and the block
  facts 31 vs 21.

# CRT part-3 route — obligation (b) closed, the 512-step normalize loop next

2026-10-21 (R1 normZero window). The len = 1 engines are closed:
`ZintSubWord194` (job 520) executes the pinned zint_sub leaf body at
len = 1 and exports the single limb write `subWord x p = (x - p) &&&
2147483647` (the parsed store is `w & 0x7FFFFFFF`; the old route
shorthand "the unconditional word x-p0" drops the 31-bit mask and is
WRONG at bit 31 — always compose `ZintSubWord194.subWord`, never a bare
`x - p0`) plus the borrow word `(x - p) >>> 31`; `ZintNormWord194`
(job 524) executes the pinned zint_norm_zero body at len = 1 with the
two comparison branches resolved by decidable case splits and exports
`normWord p0 x = if x < p0>>>1 then x else if p0>>>1 < x then subWord x
p0 else x`, `normImage` (the heap image), `normFlow` (`.returned none`
on both comparison returns, `.normal` on the tie path whose trailing
`u -= 1` wraps), the heap-keeps-except-x[0] frame and the void return
flow of both reached end flows. `norm_call` is the per-step engine for
the consumer call `zint_norm_zero(x, tmp, xlen)` (consumerArgs,
`normEntry`/`bind_norm`); `call_len1`/`bind_leaf` cover the inner leaf
call. Commits and the window report record the details; jobs 520/524
logs 0/0, standard three axioms (audit job 525). Next unused proof job
suffix is **526**.

## Exact remaining obligations (in order)

1. The 512-step normalize loop induction over the x walk (obligation
   (c) of the previous route): the loop of
   `zint_rebuild_CRT`'s normalize branch is `for (u = 0, x = xx; u < num;
   u ++, x += xstride) zint_norm_zero(x, tmp, xlen)` with num = 512 (the
   n cell), xstride = slen = 1 and xlen = 1, so exactly 512 iterations,
   each one `norm_call` at the walked word with the SAME p0 = tmp[0]
   (the gm scratch word stored by the `tmp[0] = primes[0].p` storePrime
   — its load is a `storePrime`/`PrimeRead` image, already transported
   by SelectedStepCrtWord194 for the table word). The caller's `x` is
   rebind per iteration by `bindPtr x xx (var xstride)`; the induction
   threads the `normImage` writes through `Word32Memory176` keeps over
   the twin fs/gs walks (512-word separation, the same per-cell
   bystander shape as StepCopyKeepCell194/StepGsCopyKeepCell194). The
   exported image is `fun i => normWord p0 (word i)` over the fs walk
   (first call) and the gs walk (second call), with the flow of the
   composed loop.
2. The `zint_rebuild_CRT` body run at xlen = 1 (the body spine is
   decide-bound by `MakeFgCrtShape194.crtBody`): the u/x declarations,
   the `tmp[0] = primes[0].p` storePrime (the `KeygenLevelCalls.PrimeRead`
   of block 21), the u = 1 init, the EMPTY co-reduction loop at xlen = 1
   (one false guard), the normalize branch (the 512-step loop above) and
   the void return flow; then both call statements of part 3
   (`MakeFgCrtShape194.first3`/`second3`, args `crtArgs "fs"/"gs"`)
   composed at the loop exit state over the named arguments.
3. Then the additional-prime part (slen 1 / tlen 2), the remaining
   d-levels and the root/certificate/codec path, before the complete
   emitted witness can instantiate the corrected KeygenProbability134
   consumers (KeygenModelUnlock194... see the report).

## Engine facts to consume (do not re-derive)

- The len = 1 step engine is `ZintNormWord194.norm_call` over
  `consumerArgs = [pointer "x" 0, pointer "tmp" 0, scalar (var xlen)]`
  with hypotheses: `before.arrays "x" = some px`,
  `before.arrays "tmp" = some pp`, `before.locals "xlen" =
  some (.uint64, some (.uint64 1#64))`, `Load32 before.heap px xw`,
  `Load32 before.heap pp pw`, `Allocated before.heap px`,
  `px.elementBytes = 4`, `before.heap.writable px.block = true` and the
  two `index+0 <= count` bounds. The result state is
  `{before with heap := normImage before px pw xw}` with value `none`.
- The tie path (x = p0>>>1) ends `.normal` with u wrapped; both strict
  comparison paths end `.returned none`. `void_flow`/`flow_shape` give
  `ReturnValue none (normFlow pw xw) none`.
- `ZintSubWord194.subWord` is the ONLY correct name for the zint_sub
  limb write at len = 1 (masked); `borrowWord` is the discarded return.
- The parse shapes are decide-bound (`sub_shape`, `norm_shape`) against
  the pinned probe-510 record; no parse probe is needed again.

---
# CRT part-3 route — obligation (a) closed, the normZero engine next

2026-10-21 (restart window after the provider failure). The table-word
transport is closed: SelectedStepCrtWord194 (job 516) carries the
block-21 ternary table word primes[0].p (SelectedTopInit178.p) from the
body input state through the whole s0-s7 chain and the heap-free tail to
the make_fg_step loop exit state, and entry_keep delivers it to the
zint_rebuild_CRT callee entry state (the storePrime consumer). The s0/s2
per-cell bystander keeps StepCopyKeepCell194/StepProductKeepCell194
(job 512) closed the keep-arity gap of the copy/product loops. Commits
543f751d/6016c4f3. The interrupted job 512 consumed the 512 suffix;
next unused proof job suffix is **517**.

## Exact remaining obligations (in order)

1. The zint_norm_zero / zint_sub body runs at len = 1: the two comparison
   branches of zint_norm_zero are data-dependent, so the honest export is
   the executed-word image `normWord p0 x = if x < p0>>>1 then x else if
   p0>>>1 < x then x-p0 else x` (decidable case splits; the zint_sub
   write at len = 1 is the unconditional word x-p0).
2. The 512-step normalize loop induction over the x walk, the rebuildCrt
   body run (the tmp[0] = primes[0].p storePrime, the empty co-reduction
   loop at xlen = 1, the normalize branch), then both call statements of
   part 3 composed at the exit state.
3. Then the additional-prime part (slen 1 / tlen 2), the remaining
   d-levels and the root/certificate/codec path, before the complete
   emitted witness can instantiate the corrected KeygenProbability134
   consumers (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness).

## normZero body shape — read this before writing the engine (do not re-derive)

From the retained ZintCrtParseProbe194 record (job 510 stdout), the
parsed `KeygenZintCall.calleeBody .normZero` is:

- `normBody = seq normDeclC (seq normDeclU (seq normCC0 (seq normSetU
  (seq normLoopDec normFinalSkip))))` with `normDeclC` = declare u32
  [cc], `normDeclU` = declare u64 [u], `normCC0` = assign cc 0,
  `normSetU` = assign u (var len), `normFinalSkip` = word skip.
- `normLoopDec = seq (loop (u>0) loopBody (word skip)) (word (u-=1))` —
  the C post-decrement `u -- > 0` is modeled as the guard `u > 0` plus a
  `u-=1` at the body head, and the final false-guard decrement is the
  trailing `word (u-=1)` AFTER the loop (do not look for the decrement
  in the guard or the increment slot).
- `loopBody = seq (word (u-=1)) (scope [w] [] (seq decl(w:u32) (seq
  (w = (p[u]>>1)|(cc<<30)) (seq (cc = p[u]&1) (seq branch1 (seq branch2
  (word skip)))))))` with `branch1 = branch (x[u] < w) (scope [] []
  (seq retVoid (word skip))) (word skip)` and `branch2 = branch (x[u] > w)
  (scope [] [] (seq (call (leaf sub) [ptr x 0, ptr p 0, scalar (var len)]
  .discard) (seq retVoid (word skip)))) (word skip)`.
- At len = 1 the loop runs exactly one iteration (u: 1 -> 0 at the body
  head, word index u = 0), the `w` variable holds `p[0]>>>1` because
  `cc = 0` on the only iteration, and the two `retVoid` paths exit
  through `Exec.loopReturn` while the tie path falls out through the
  false guard into the trailing `u-=1`. The zint_sub leaf call at
  len = 1 is the unconditional word `x[0] = x[0]-p[0]` (the leaf body
  run is part of the engine work).
- The honest export (obligation (b)) is the executed-word image
  `normWord p0 x = if x < p0>>>1 then x else if p0>>>1 < x then x-p0
  else x` with decidable case splits on the two branch guards; the three
  cases must each carry the same heap-keeps-except-x[0] frame and the
  void return flow of the callee (check the exact
  `C99ProcedureReference.ReturnValue (result .normZero)` shape for both
  the `.returned` and `.normal` end flows against `KeygenZintCall.Call`).

---

# Continuation after the discharge — s0-s7 unconditional, the tail open

The discharge window (this stage's previous route) closed all three
discharge obligations: the per-cell bystander keep through the final
pass, the correction and the whole inverse (jobs 480/481/482/483), the
s0/s2 keep arity gap with two- and three-image keep modules (job 485),
the keep-threaded s3/s7 call statements (job 487), the s0-s3 re-assembly
with the gs/igm/fd keeps and the v = 256 cell (job 498), and the
unconditional full first-prime assembly with the gd written image at the
final assembled state (job 501). At resume verify the entry receipt
`.build/stepgs194/ENTRY_PINS.json` (SHA256
`99ac47a1d981ebfc3afe3c54aac98c02773816faa489682d205682fd31c475b8`)
against the pins in `KEYGEN_STEP_GS_194_REPORT.md`, re-check the
inherited pin chain and confirm no active owned job/Lean/Sage process
before any new proof work. Next unused proof job suffix is **502**. Keep
one Lean process (`tools/job111.py`, `-j1 -M6144`), logs 0/0, standard
axioms. Never edit sealed 187-193 sources; the 194 modules of this stage
stay byte-stable too (edit-by-new-module only).

## Exact remaining obligations (in order)

1. The outer u++/final guard tail of the make_fg_step prime loop (the
   `SelectedStepGsChain194.fullPrefix` export now closes the first-prime
   body; the loop's u increment, the false-guard exit and the state
   transport to the second prime remain), then both `zint_rebuild_CRT`
   calls, the additional-prime part (slen 1 / tlen 2), the remaining
   d-levels and the root/certificate/codec path, before the complete
   emitted witness can instantiate the corrected KeygenProbability134
   consumers (KeygenModelUnlock134.package_of_witness,
   KeygenSuccessMass134.success_lower_of_witness).
2. The fd written image at the assembled s0-s3 state and the gd written
   image at the final state are now exported as executed words (jobs
   498/501) and feed the CRT/additional-prime consumers; their
   consumption is part of obligation 1. The gs source words `gvs` are
   the actual executed loads of `SelectedGen0Frame189.g_read`; no table
   law is assumed for them.

## Traps met (do not re-derive)

- The parser leaf `modp_iNTT2_ext` of the false-ter branches is a
  make-level binary call (`Stmt.binary`, bound through `KeygenBinaryNtt`),
  not a `KeygenLevelCalls` call; its rule returns the caller state with
  the callee heap (probe records `NttInverseTerProbe194` /
  `NttInverseLocalSafeProbe194`). The generic caller-local extraction
  `SelectedStepChainKeep194.localSafe_result` covers it.
- `=` binds tighter than `&&` in Lean annotations: `(x && y) = true`
  must be parenthesized or the right operand is coerced through `decide`.
- The sealed `SelectedStepGsChain194.source` exports s4/s5/s6/s7, the
  gsPrefix run, the composed fullPrefix run, the gs image, the gd image
  and the two caller frames (13 components after the existentials).
- The keep shape for the bystander is per-cell in the
  `NttInverseMiddleRounds192.source` form; `KeygenLevelCalls.call_frame`
  and `KeygenMakeFgSource.frame` exist but their `Outside` notion covers
  only cells before the named region's start (the walked pointers inherit
  the scratch block count), which is not enough for the gs/igm keeps.

Only executed-word semantics is in scope: no transform property, table
law, root law or positivity claim; unconditional Z>0, numerical
p_accept, conditional coding and positive p_K remain OPEN. Old110 stays
frozen; measured wording 8192/23628 with the separate 256/739 control
and the five do_sign items remain unchanged. Scoped proof, NOT_REVIEWED;
no IID/D1/F04 premise; no push (batch 4 waits for the owner's signal).
Retained failures: `KEYGEN_STEP_GS_194_FAILURES.json` (18 workshop jobs),
the inherited checkpoint192 register (58) and checkpoint193 register (4).

## Engine window route (2026-10-21): the additional-prime steps 1-7

(After job 563 = ZintModSignedWord194 accepted; next unused proof job
suffix 564. The modp_Rx wall is CLOSED (previous window: the rx
stratum constructor + KeygenModpRx + the documented pin-chain
re-baseline); the seven-statement prime prefix shapes are pinned and
decide-bound in MakeFgAddPrimeShape194; the per-march-word engine is
accepted. This route is the steps 1-7 plan; execute, do not
reconnoitre.)

1. The empty-loop rx lemma first: `rxBody [.uint32 1, .uint32 p,
   .uint32 p0i, .uint32 r2] (.uint32 (KeygenModpR.word p))` — at
   x = 1 the body decrements x to 0, sets r = R2, z = modp_R(p), the
   loop guard (1U << i) <= x is false already at i = 0, and the return
   is z. Build it as GenExec LeafCall over C99ModularReference.rxCode
   in the KeygenModpR2Exec body_exists pattern (r2Code precedent);
   then `ModCall.rx` gives the executed word of the rxSet statement.
   (This replaces the earlier paper note "the intended word is
   modp_R(p)" by a kernel-checked statement.)
2. The seven-statement prime prefix at the u = 1 iteration, in the
   MakeFgAddPrimeShape194.prefixSteps order (decide-bound shapes; no
   reconnaissance): declP/declV/declX (C99DeclarationStatements.effect
   via ZintSubWord194.declare_run), pSet (KeygenZintCall.Exec.prime
   with a KeygenLevelCalls.PrimeRead of primes[1].p — the block-21
   table word transport of SelectedStepCrtWord194 is the keep
   precedent), iSet (ModCall inverse at KeygenNinv31.word), rSet
   (ModCall r2 at KeygenModpR2Word.word via KeygenModpR2Exec), rxSet
   (ModCall rx at KeygenModpR.word via step 1). Entry state: the
   part-4 loop-body scope entry at u = 1 (the part-3 CRT exit state
   exported by SelectedStepCrtRun194); values as executed words only.
3. Then the eight-statement chain: the ter branch (modp_mkgm3 wrapper
   call with the pinned seven-argument list), walkFs and walkGs (each
   512 per-word calls — ZintModSignedWord194.ms_call is ready; the
   walk loop composition and the t1[v] stores are the new work),
   nttFs/nttGs (the forward modp_NTT3 runs — NO execution engine
   exists yet: the biggest item; KeygenNttForwardPrograms pins the
   body), productFd/productGd (the product engines transfer), the
   false !out_ntt skip (fd/gd inverse pairs), then the loop
   composition and the section export.
4. The same modp_Rx decision opens the four later call sites
   (poly_sub_scaled_ntt falcon-keygen.c:4626, solve_NTRU_intermediate
   :5906/:5985, solve_NTRU_binary_depth1 :6474) — execution only, no
   further stratum extensions.

Build-order note (księga): for any multi-module run order by the REAL
transitive source-import graph, transitively through cached modules;
the cached `imports` maps record only bindings present at build time
(job-560 trap).
