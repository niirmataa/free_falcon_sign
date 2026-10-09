# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_038 public forward canonical-range midpoint

**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
**CLOSED_AT_RECOVERABLE_MIDPOINT. B1.06 Acceptance NOT MET.**
2026-10-09, GPT-6.1 Sol Fast (`openai/gpt-6.1-sol-fast`), owner-started
window per checkpoint17R. One midpoint only. B1.05 stays closed at
BATCH_032; B1.07 is not entered. Resume: checkpoint18R.

## Exact checked boundary

`KeygenPublicForwardWrapper.source_forward_canonical`:

```text
s : C99ArrayReference.State; out : C99ProcedureReference.Result
a : C99MemoryReference.ArrayPointer
profile : KeygenPublicTableAtoms.Slot s "logn" (10#32)
ternary : s.locals "ternary".toList = some (int32,some (int32 (1#32)))
input : s.arrays "a".toList = some a
globals : KeygenPublicRangeExpr.Locals residueNames s.globals
range : KeygenPublicRangeMemory.Domain s.heap a
initialized : KeygenPublicRangeMemory.Initialized s.heap a 1536
source : KeygenPublicExec.Exec KeygenPublicSource.program []
  (KeygenPublicSource.code forward) s out
-----------------------------------------------------------------------
out.flow = normal AND
Domain out.state.heap a AND
Image out.state.heap a 1536
```

Definitions are separately audited, including all fields/constructors:

- `Domain heap a`: every **defined** `Load16 heap (element a i) w`, for any
  forward-addressable offset i, has `w.toNat<18433`. Allocation bounds are
  in Load16. It does NOT assert uninitialized holes are initialized.
- `Initialized heap a 1536`: each i<1536 has an actual Load16 word.
- `Image heap a 1536`: each i<1536 has an actual Load16 word with
  `w.toNat<18433`. This is an unsigned16 range/initialization statement,
  **not** a polynomial-evaluation statement.
- `Locals residueNames env`: initialized values at the17 residue names
  have integer value in[0,18433). The actual callee Bind uses the caller's
  **globals**, not its saved locals. Declarations and all conversions preserve
  this invariant. The enclosing public caller must still derive this domain.
- `source_forward_image` is a second, checked interface: an input Image of
  the1536 cells plus the **actual descriptor extent**
  `a.count <= a.index+1536` derives Domain/Initialized. This extent is a local
  caller premise, not an invented bound for an arbitrary caller object.

No generated table image, transform correctness, nonzero, inverse round-trip,
division outcome, public equation, arbitrary callee or assumed output range
is a premise. Input/global domains and their binding to the SAME original
f/g are explicit remaining obligations. The module does not claim that these
domains have already been derived from the complete public caller.

## Closed this window

1. **Entry closure:** BEFORE proof edits/jobs, the unchanged dedicated036
   verifier checked6120 predecessor/ceremony pins; a separate full re-hash of
   the committed037 pair, entry, module source/snapshot/products/receipt/
   streams and source inputs extended this to **6141 pins,596 current
   inputs**, no supersession or active job. Entry receipt SHA256
   `528cb839354dcae245061f90acdbc72070b49161e442d8c4fc38112a12c0f8cb`;
   chain `865babeb7c571e5f15c07a60c93b6c88b295e5bff702e6da2aada567b91080d9`.
   The owner approved the correct036 pair arguments after the inconsistent
   17R example was reported. Historical17R bytes are retained; the checkpoint
   has an append-only errata. No verifier or pin was weakened.
2. **Unsigned16 range/storage:** aligned two-byte writes preserve every
   previous defined canonical read and every initialized input cell,
   including physically overlapping aligned views. Partial initialization
   remains separate. Signed int32 promotion, UINT32 parameter conversion,
   narrowing and q18433 word ranges are proved, not conflated.
3. **Actual source expression/statement range:** checked add/sub/Montgomery/
   square calls with exact Qt/Q0It literals derive their result ranges.
   The structural fold handles all stores, nested loops and scope restoration.
   It admits no arbitrary scalar-call relation and assumes no loop output.
4. **Complete forward source partition:** all of mq_NTT_ternary979–1062 is
   partitioned, with its actual declarations, dynamic/static branch and both
  2048-cell automatic arrays. The whole1001–1061 suffix is checked: first
   pass, every radix-2 pass and degree tripling. No shortened NTT is substituted.
5. **Table inputs derived IN the forward caller:** the actual logn10 branch,
   generator Call's real pointer/scalar Bind and `source_complete_tables`
   yield gm inputs. Both `gm_square`/`gm_cubic` aliases are executed. The
   generator's1024..2047 holes remain uninitialized, by UpperFrame and actual
   allocation bytes; a defined read there is impossible. No final image is
   passed as a caller premise. The inherited exceptional igm[0] remains intact.
6. **Complete execution and lifetimes:** input liveness derives separation
   from the actual Fresh allocations. Both automatic arrays are entered and
   disposed. Block-local transport preserves input/output reads without
   falsely asserting equality of the whole allocation-size map during entry.
7. **Real mq_NTT dispatch:** ternary selection, complete forwardT body,
   parameter conversion and call/scope return composition conclude all1536
   canonical initialized output cells for the SAME complete execution.
   `source_forward_canonical`/`source_forward_image` are the checked exports.

## Full internal audit and focused finite controls

- Nine current proof modules plus the generated audit producer have accepted
  module records with **0/0 streams**. The accepted ForwardMemory record is
  the first step of `_forward_038_004`; that job's subsequent Control step
  failed and was fixed in `_005`. This is not labeled a wholly accepted job.
- Audit `_forward_audit_038_001`: **245 entries =118 named declarations +127
  exact inherited interfaces;216 complete terms +29 kernel inductives with
  constructor types;standard axioms only;zero elisions**. JSON2516205 bytes,
  SHA256 `42d52f6c7ff9d5dc93d83d5a1db7312f0a2a31763c5d63861724f48303f132f1`.
  Receipt `7a0571eafef0da6da141ed3badf363a288a348d8766d294cc33ef5b8cddc3759`.
  Tracked generator/producer: `tools/keygen_public_forward_audit_source.py`
  and `formal/Source3/KeygenPublicForwardAudit.lean`.
- Sage `_forward_checks_038_002`, standard preparser/ZZ: **12 normal/UBSan
  runs**, baseline plus **five mutations per mode, all detected**. Each run
  has10 public synthetic input cases,100 complete pass snapshots, ten dynamic
  gm/igm images/holes and ten metric rows. Per case:15360 watched store sites,
 1025 watched table reads and subobject sentinels. Baseline has no range/index/
  sentinel or exact-value difference. The exact ZZ stage model's final values
  also match physical-point polynomial evaluations on these ten fixtures.
  **Those evaluation matches are finite diagnostics, NOT the missing
  universal original-f/g source evaluation proof.** No inverse or full public
  call/KeyGen is run by these controls. Fixtures are public and synthetic.
  Source `24f07f6e883012d7b78f1cfbb1afe2090c33976ca731e8e6684cd94c1e3f6fc5`;
  result `a3026601eb9643b5cdcb4ce6cb41f3a927e4d42e89b86183047ba25a77c6ee89`;
  receipt `53cdfd7fbb182366cd40caa480f3b69457f8e0ae87da654dddef8deeb40a58ba`.
- All **22 job directories/23 steps** are retained:10 wholly accepted,
 12 with a failed step (one has an accepted first module). No receipt-less
  attempt, unresolved current source or active owned job. Maximum cumulative
  RSS **5572456KiB**; process/kernel/print limits are unchanged.
- Preseal rechecked the identical6141 predecessor pins, receipt
  `e6c6d3d8e3fdf00506659ee9955449c0d368375c296fe8fa13653fa18467982c`.
  The dedicated038 seal/verify tool includes all failed histories, accepted
  products, the audit/control artifacts and full current source bindings.
  Pair/POSTSEAL/FINAL_VERIFY hashes are in checkpoint18/18R (outside this
  pair's own notes pin, avoiding a circular manifest).

## Module source pins

| Module | SHA256 |
|---|---|
| KeygenPublicRangeMemory | `67d004e08c200b27b4a486bcefc9f644c52007595d89ee3618140304b5368c7d` |
| KeygenPublicRangeExpr | `bfb1e1d09807bb78b08de0543a8aba4d02481b31a467a9e712efa08fb09bb600` |
| KeygenPublicRangeExec | `188ba1a636968b53d4cdc5c97064ce714438da2cd13a00d683ffcd3438b1fc39` |
| KeygenPublicForwardProgram | `5185bb8fa2dcc7ee70fc5b313e35f60a65ba9f0d6615a37c8c83c2e6726aaf50` |
| KeygenPublicForwardMemory | `3af7b3c185e60f8e7de4bc1a0ab9dd3ba2bc9e1011a5bb69a7a6e753d0ffd509` |
| KeygenPublicForwardControl | `662f303d383a901af91666c2c63eb8118897182dc71473eead5e7ceaeddd400d` |
| KeygenPublicForwardCall | `36e8a699885f12bc155f89dc3fbff809e2d4a0099017959bdb8fa0e33b25773b` |
| KeygenPublicForwardRange | `54f54ccf9354c9b306061b28e3df6c05e38d9e7e8a4966f919cda36dab43ec56` |
| KeygenPublicForwardWrapper | `450be7b4baa3779418e07c41c1db790156873c95b4dfccc805c66085a731925c` |
| KeygenPublicForwardAudit | `62b7fc2c5b35f7e30ef42372c7edfb0096a8d579cf3538e139576f132c62c287` |

## Failed attempts and traps (197–205)

- **197. Entry command pairing:** the036 verifier has fixed BASE036;
  17R's037 JSON/notes arguments were inconsistent. Reported before work;
  owner-approved correct036 hashes + separate037 re-hash; no failed engine
  exit or verifier receipt was invented for the unexecuted wrong command.
- **198. Nat alignment / projections:** `_range_038_001` had an incomplete
  modulo simplification. `_forward_038_002` needed the actual loaded width2
  before omega could see liveness; offsets needed unfolding. `_forward_038_003`
  needed `Fin.val_zero` before reducing the read-at-byte-zero expression.
- **199. Conversion simplification:** `_range_038_003` exposed recursive
  reverse rewrites of integer.toNat, and Value.integer unfolding that hid the
  arithmetic atoms from omega. Use bounded Nat conversion lemmas and one-way
  calc steps, not recursive simp with the reverse cast. That attempt also
  exposed the Address constructor's seven-field cases pattern and automatically
  eliminated impossible Call alternatives. Failed raw logs stay intact.
- **200. Syntax / indices:** `_range_038_005` used reserved `scoped` and tried
  induction on Exec with a constant[] index. Use a generic signed index and
  explicit equality to[]. `_forward_038_004` accepted Memory but rejected the
  reserved declaration name `prefix`; the later Control uses `pure_result`.
  `_range_038_006` needed the actual Boolean-not/list simplifier, not a
  mismatched simp-only lemma.
- **201. Actual argument zero / Call relation:** `_forward_038_006` exposed
  that `C99ProcedureParser.zero` is **uint64 zero**, not the int32 table-store
  literal. `KeygenPublicWord.scalar` uses the fixed public Call relation, not
  C99ArrayReference.scalar's other calls. Explicit zero/public-variable
  inversions resolve these; no oracle relation is substituted.
- **202. Constructor arity / nil membership:** `_forward_038_008` retained
  the11-versus10 arrayScope pattern and a trailing membership-in-nil goal.
- **203. State inference / rewrite shape:** `_forward_038_009` could not
  rewrite a localEntry projection before unfolding it. An underscore state
  plus the profile proof also made the unifier choose s2 instead of the actual
  nested localEntry; pass the exact state explicitly.
- **204. Dependent scope elimination:** `_forward_038_011` could not cases a
  scope at an already constrained normal Result. A separate general-result
  `ternary_body_canonical` lemma composes that scope without weakening types.
- **205. Targeted mutation occurrence:** `_forward_checks_038_001` completed
  its exact ZZ fixture/stage checks but stopped before C compilation because
  the generator-call mutation matched **both forward and inverse** bodies.
  Restrict it to the extracted forward body. The source/fixture/raw traceback
  and receipt remain byte-exact; `_002` is the successful control run.

Accepted attempt labels: `_range_038_002/_004/_007`,
`_forward_038_001/_005/_007/_010/_012`,
`_forward_audit_038_001`, `_forward_checks_038_002`, plus the accepted Memory
step of the otherwise failed `_forward_038_004`. All failed labels above
are explicitly in the038 JSON history. Labels have the full
`keygen_public_` prefix; pair038⇒jobs038, numbering from001.

## Remaining in16.1 plan order — exact source seams

1. **Item2 remains PARTIAL.** Derive the input/global range domains (or the
   image+actual extent interface) from the SAME original f/g conversion and
   full public-call Bind/lifetime/frame. Prove first-pass, radix-2 and triple
   **evaluation** invariants, physical ordering and the final statement:
   for every i:Fin1536, the loaded forward word's value in ZMod18433 equals
   `(CoefficientQuotient.polynomial originalReducedCoefficients).eval
   (KeygenPublicRoots.point i)` for the SAME original retained f or g.
   Input and evaluation association must be source-derived, not supplied as
   a transform-correctness premise. Existing canonical range exports may be
   consumed only with their actual caller domains established.
2. **Item3 OPEN, not entered:** SAME successful public execution⇒all1536
   nonzero tests⇒actual division; source inverse/normalization⇒canonical h.
   Do not assume forward/inverse round-trip.
3. **Item4 OPEN, not entered:** construct fInv from the nonzero evaluations
   and proven evaluation isomorphism; derive BOTH SAME-material equations
   `mulRq h (reduceVec f)=reduceVec g` and
   `mulRq fInv (reduceVec f)=constantCoeffs (1 : ZMod18433)`.
4. **Item5 inherited DONE:** BATCH_036 seal ceremony stays pinned and was
   verified before this work. This midpoint adds its own full audit, Sage
   controls and dedicated038 closure verification; it is not a new review.

The missing evaluation/caller composition is a **missing proof**, not a
numerical/code counterexample or an insufficient probabilistic estimate.
Canonical range alone does not determine a polynomial value: the deliberate
triples-swapped mutation remains canonical but is detected by finite value
controls. Complete KeyGen, emitted-to-fiber, compiler, laws/PRG/security and
independent review are outside this result.

## Git / execution discipline

Own small main commits as niirmataa: `be2f0dc1`, `09fa063b`, `3f82120a`,
plus the audit/control/tooling and final pair/checkpoint commits. Exact paths
under `proofs/ft1536/work/archive.lock`; pre-existing foreign changes/staging
preserved. The interleaved foreign archive-shield commit `0142497f` is not
this worker's proof result. No changes to production C, historical pin
sources, old accepted modules, frozen W/stages or existing verifiers.
No push, subagent/reviewer/worker/session/relay, migration, stages import or
unchanged broad replay. One guarded serial proof job, durable HOME/TMPDIR/
cache, unchanged j1/-M6144/AS12GiB/RSS8GiB/wall1800s/kernel/print limits.
