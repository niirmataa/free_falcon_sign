# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_060 exact types, pins and traps

2026-10-11, BATCH_060, MiMo V2.6 Pro (`xiaomi-token-plan-ams`), B1.07
whole-invocation statement-machine midpoint. Status: **PARTIAL_PROOF /
Acceptance NOT MET / NOT_REVIEWED / IN_PROGRESS / WORKING_NOT_FROZEN.**
One close this window. B1.05/032, B1.06/046 and the 059 statement-machine
extraction unchanged; B1.08/B4/B5 NOT entered. This package supplies rung
B1 to B4/B5 under `END_TO_END_SCOPE.md`; it is not a review, not a codec
claim and not a law claim.

## 1. What this window proved (NEW module `Source3.KeygenMakeInvocation`)

THE whole-invocation statement-machine execution of the encoding tail to
the ACTUAL encoder call sites, with the output-capacity events and the
complete teardown. Exact exports (58 declarations, all full terms or
kernel inductives, standard axioms, zero elisions):

- `Env`/`inputOf`/`publicOf`/`skePtr`/`skeElem`/`skeName` — the fixed data
  of one invocation (external arguments, six automatic-object blocks, the
  fk context, the LP64 virtual map); `assign` (typed scalar assignment at
  the declared width), `byteOff` (the `unsigned char *` byte views),
  `StoreByte` (the one-byte object store of the header lvalues).
- `wordOf`/`VirtualLegal`/`Canonical`/`WritePointer`/`ReadPointer` — LP64
  pointer words in the legal allocation environment (input-memory facts,
  like `PointerLegal`; the physical layout is checked by the pinned C
  controls). `load64_after_store`/`load64_of_store` (store/load transport),
  `canonical_word_eq`/`read_unique` (write-then-read pointer uniqueness
  under the injective virtual map), `input_canonical`/`skeElem_offset`.
- `SmallSite`/`PublicSite` — THE `falcon_encode_small` call site of segment
  `i` and the `falcon_encode_18433`/`falcon_encode_12289` dispatch sites:
  the evaluated argument cells at the call boundary (skbuf/klen/skoff/
  comp/ter/logn, the `ske[i]` pointer read, the `h` cell) and the OPEN
  codec effect (return value + resulting heap); `small_site_material` ties
  the segment source argument to the material array whenever the stored
  pointer word is readable at the boundary.
- `Segments` — the executed four-segment loop body (`secretLoop`):
  iterations `i..3` with their actual `falcon_encode_small` call site, the
  `elen==0` output-capacity event and the `skoff += elen` update;
  `segments_flow`/`segments_tables`/`segments_arrays` (the loop touches
  neither tables nor pointer cells).
- `tail_source` — THE kernel pin of the 18 statements of
  `KeygenMakeProgram.encoding` as one list equality (privkeyLenRead,
  skbufAssign, capacityReturn, skHeader, skoffOne, skeBind 0..3,
  secretLoop, privkeyLenWrite, pubkeyLenRead, capacityReturn, pkHeader,
  publicDispatch, zeroCapacity, pubkeyLenWrite, retOne) with `lastStmt`
  reaching `retOne`; `Head` executes each statement form on the caller
  state (typed assignments, the byte stores of the two headers, the `ske`
  pointer-array stores, the segment loop, both dispatch arms, the two
  pre-check and two post-call capacity branches, the two length stores,
  `return 1`); `Encoding` sequences them in source order with the
  non-normal exit edges. `head_flow`/`head_tables`/`head_cells` and
  `encoding_exit`/`tail_exit`: EVERY tail execution ends in `return 1` or
  one of the four named output-capacity `return 0` edges.
- `TailCells` — the named explicit input class of the tail entry state
  (the accepted-break state): the parameter cells, the M0 scalar cells and
  the six automatic-object cells. `Invocation` — THE whole-invocation
  statement-machine execution: argument binding, readiness prefix, capped
  attempt loop (the accepted break consumed by the loop statement, or the
  attempt-cap edge), the 18-statement tail and the COMPLETE outer teardown
  (`KeygenMakeLifetime.close`) on every return edge. `invocation_flow`
  (every return edge is `return 1`/`return 0`), `invocation_teardown` (all
  six automatic blocks disposed on every edge), `invocation_gate` (the
  accepted mandatory leaf-certificate gate of the final attempt; the
  profile-false skip is impossible under the gate profile).
- `CertPackage`/`cert_package`/`invocation_certificate` — the complete
  certificate package (pinned globals, prefix/reverse source snapshots,
  bad-flag lifetime, shared call material) instantiated at the accepted
  gate call of THIS invocation — the derivation reading of the PLAN phrase
  "identyfikator tej samej inwokacji".

## 2. Retained attempts (all bytes preserved, causes sealed in the batch)

- `keygen_make_invocation_060_001` — first rejected elaboration (Prop-
  valued call-site structures cannot project data fields; the `skeBind`
  shape missed its assignment operator; `ReadPointer` elimination arity;
  deprecated `if_neg` simp arguments; offset simp/omega slips; the
  `public`/`prefix` keyword clashes cascading over the invocation).
- `keygen_make_invocation_060_002` — parse rejection at the unspaced
  `4≤i` binder (the imported `≤i` token; a local probe isolates `≤i`
  adjacency as the only failing form — spaced `4 ≤ i` parses).
- `keygen_make_invocation_060_003` — elaboration rejections (segment
  `Head` frames need the Segments tables/arrays lemmas; `ite_false` after
  the cell condition reduced; the single-statement case refuted the flow
  disjunction instead of eliminating the impossible `Head retOne`; the
  `Invocation` case patterns counted the index-determined binder).
- `keygen_make_invocation_060_004` — `case` alternative names do not reach
  index-determined constructor binders (three slots for the segment
  constructors); the accepted-attempt pattern renamed the gate result.
- `keygen_make_invocation_060_005` — `cases`-with slot mismatches on
  `AttemptExec` (earlyRejected/throughCertificate); fixed by
  `induction ... with`, which names the full binder telescope.
- `keygen_make_invocation_audit_060_001` — guard rejection at PREFLIGHT
  (the parallel S05 lane's active Lean process; environment race, no
  source bytes); the audit re-ran as `..._audit_060_002`.
- `keygen_make_invocation_sage_060_001` — scripted controls rejected
  (exit 1): two control-logic defects found by the run itself (the
  transcription order check matched the first `return 1;` in the file;
  the truncated-address variant was invisible under modulo word
  equality); both fixed in the accepted run.

Accepted jobs: `keygen_make_invocation_060_006` (module),
`keygen_make_invocation_audit_060_002` (audit),
`keygen_make_invocation_sage_060_002` (controls).

## 3. Pins

- Entry: `.build/levels_060/ENTRY_PINS_060.json` `10df0c1d…` (11950
  pinned files, BATCH_015-059, no supersession, no active job), verified
  BEFORE edits against the sealed 059 pair `dc9210e9…`/`36e8c469…`.
- Module source `formal/Source3/KeygenMakeInvocation.lean`; audit
  `formal/Source3/KeygenMakeInvocationAudit.lean` reproduced byte-exact by
  `tools/keygen_make_invocation_audit.py` (GENERATOR_CHECK).
- Audit: 122 entries = 58 new declarations + 64 inherited interfaces,
  87 full terms + 35 kernel inductives, standard axioms
  (propext/Classical.choice/Quot.sound), zero elisions.
- Sage: `sage/check_keygen_make_invocation.sage`, 5 families × 4
  mutations (20 mutation kinds), all detected, baseline pass; **EXPLICIT
  MOCK SEMANTICS** — scripted encoding-tail-shape/output-capacity/
  complete-teardown/pointer-roundtrip records and a transcription check
  of the encoding-tail region against the pinned reference C
  (`Extra/c/falcon-keygen.c`); no real KeyGen/solver/certificate/codec,
  no private key, no law claim.
- Own commits: proof (module + audit module), tools (audit producer,
  batch tool, Sage controls) + the closing pair. Foreign S05 working tree
  preserved untouched. NO push / review / delegation / relay / migration
  / import this window.

## 4. Traps met and exact remaining obligations

Traps: Prop-valued structures cannot project non-Prop fields (the call-
site records need Type-valued structures); `public` and `prefix` are
parser keywords (use `publicCell`/`readyPrefix`); the unspaced `≤i`
tokenizes as one imported token under the pinned notation table (space
comparison operators after numerals); `case` alternative names do not
reach index-determined constructor binders while `induction ... with`
names the full binder telescope; constructor arguments occurring in the
result indices drop out of `cases`-with slot lists; `if_neg` as a simp
argument is deprecated (pass the negated condition hypothesis); an
unused existential binder in a stated type is a linter error (use a
conjunction); guard rejections at PREFLIGHT retain the directory with
only `PREFLIGHT.json` and burn the label (class PRESTEP_ABORTED_RETAINED).

Remaining B1.07 (in unchanged plan order):

1. **Loop-trace chronology composition** of the per-retry transport
   (item (b) of 39.1): still at gate level. The `TailCells` entry facts of
   the encoding tail are the named explicit input class of this step;
   their derivation across rejected attempts belongs to that item.
2. **Codec bodies and write frames (B1.08/09)**: the exact encoded
   lengths, the persistence of the stored length words (`*privkey_len`,
   `*pubkey_len`) and of the source arrays through later encoder calls,
   and the bytewise round-trips. The invocation execution reaches the
   call sites with the argument cells bound; the final-state length facts
   close with those frames.
3. **Residue pin of the plan phrase "globals/common call ID/snapshots"**:
   the instantiated package `cert_package_of_call` carries the concrete
   pinned globals, the prefix/reverse source snapshots, the bad-flag
   lifetime and the shared call material; `invocation_certificate` ties
   that package to the SAME whole invocation through the accepted gate
   call of its final attempt (the derivation reading of "identyfikator
   tej samej inwokacji"). If the phrase intends an EXPLICIT identifier
   value beyond the shared derivation — a call-ID field identifying the
   certificate's internal prefix/Gate00/suffix snapshots as one body
   execution independent of the derivation — that composition is PINNED
   as OPEN here, with that intended shape; no such field is derived or
   assumed in the module.

These are missing source composition proofs, NOT C/numerical
counterexamples. Acceptance NOT met; Codecs B1.08/09 and B4/B5 laws stay
outside.
