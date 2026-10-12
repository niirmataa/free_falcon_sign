# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_067 notes

2026-10-12, Codex. Owner-started B1.07 window from checkpoint46R.
**PARTIAL_PROOF / B1.07 Acceptance NOT MET / NOT_REVIEWED.**
**IN_PROGRESS / WORKING_NOT_FROZEN.** Exactly one expanded recoverable
midpoint at the final close. B1.05/032 and B1.06/046 unchanged; no B4/B5
advance. Complete NONE source result/window is closed. STATIC low-suffix
algebra and two local source seams advance; its whole invariant, lengths,
decoders, emitted material and public codec remain open.

## 1. Entry and fixed source/model boundary

BEFORE edits/jobs, sealed066 verified **13748 distinct pins** into
`.build/levels_067/ENTRY_PINS_067.json`, SHA256
`6027195436c398be9fb25ceef17eb6890275770fa55f788839b6f43872cd543c`.
JSON066 `97ef526756b4c8890d5f9797f765b2456088e20d6c8d1c0cefe65e999b670985`;
notes066 `f928dfea9ec649ce890a37e0907ac25844459d207a0e5dd8ac9ea3df8c2e4ae6`.
Only recorded061/063 supersessions; no new correction, repair or supersession.
Base HEAD `3209aa5b45af3d8d93a12243b94985b5b174e855` in TARGET.json.
Host namespace process inventory was empty before proof work. Serial
job_when_available.py retained/waited on the occupied host slot when needed.

Reference source is live pinned `Extra/c/falcon-enc.c`, SHA256
`0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05`,
with unchanged `falcon-keygen.c` and header. No production C, historical
proof/binding/audit bytes, stages or foreign W were changed. The existing
ordered C99/GCC LP64 reference semantics remains the source/model boundary;
these are not compiler/OS or full ISO-C adequacy theorems.

## 2. Complete NONE, rather than only the old RHS expression

`KeygenCodecCellFrame` derives arbitrary protected scalar-cell preservation
from the actual statement/expression syntax. It covers evaluated updates,
all three switch arms, scopes and finite for/while paths; calls are rejected.
`KeygenCodecControl` derives no-return and length-return control facts.
`KeygenCodecStateFrame` derives heap/buffer preservation for checked forms.
No frame or target result is in their execution constructors.

`KeygenCodecNoneResult` obtains q/logn from initial parameter cells, actual
len/u declarations and the false q==12289 branch. That branch really assigns
len3072. Its suffix transports the derived initialized length and initially
classifies observed returns0/3072.

`KeygenCodecNoneCursor` proves exact int32/uint64 conversions, actual u+0,
u+1/u+=2 and initialized u0, with representability/no-wrap bounds proved.
`KeygenCodecNonePair` handles the REAL two StoreByte legs and scopes. At
u<3072, parity u%2=0 implies u+1<3072. This is the missing condition that
fails in the retained out-of-profile odd-length NONE counterexample.
`KeygenCodecNoneLoop` folds arbitrary finite defined while paths, deriving
parity, no wrap and final u3072. No loop count/cursor/length outcome is a
premise. It proves properties of defined finite executions, not existence
or unbounded termination of arbitrary source computations.

`KeygenCodecNoneWhole` executes the full declarations/prefix, excludes
scalar shadowing of out/NULL at the actual pointer test, and derives the
capacity bound from the real max_out_len<len branch. Rejection has no write.
`KeygenCodecNoneReturn` derives the precise source result on all flows:

```lean
def result (args : Args) : BitVec 64 :=
  if args.out=none then 3072 else if args.capacity.toNat<3072 then 0 else 3072

args.q=18433 → args.logn=10 →
  Exec args NoneBinding.code (initial args before) after flow →
  flow=.returned (result args)

args.q=18433 → args.logn=10 → args.out=some dst →
  Exec args NoneBinding.code (initial args before) after flow →
  Window dst args.capacity.toNat before after.heap
```

These universal source types have NO desired result, returned length,
capacity bound, loop result or heap frame premise. They include NULL
length queries, short non-NULL buffers and exact/extra capacities. The
capacity window is derived for every observed return. The theorem does not
yet describe packed coefficient bytes or decoding them.

## 3. Fixed dispatcher and the same four NONE sites

`KeygenCodecNoneDispatch` extracts the complete bound NONE call from the
actual comp0 switch, deriving the passed out/capacity/q/logn from CallArgs
and initial cells. It proves dispatcher result/window on the SAME heaps.

`segments_nonzero` derives every returned codec length is nonzero in a
successful secret segment trace. `invocation_none` combines this with the
existing four-call extraction and derived profile at every actual site:

```lean
Invocation env caller events out calls → out.flow=returned(int32 1) →
  env.args.comp=0 → privateKeySkeSeparation → existingVirtualLegal →
  calls.length=4 ∧ Consecutive 0 calls ∧ ∀ c∈calls,
    c.site.src=inputOf env c.index ∧ c.ret=3072 ∧
    3072≤(arguments ...).capacity.toNat ∧ Window ... c.before.heap c.after
```

The full exact type and term are in final028 SEARCH_AUDIT.json. The actual
Invocation retains the existing binding/readiness/loop/TailCells/legal-memory/
teardown domain. Source-profile q18433/logn10 is DERIVED at the sites, not
assumed as a new invocation premise. Success is the observed whole-call
return1; no expected codec return or length is supplied.

The input relation is still POINTER identity. It does not establish every
coefficient word, final aggregate cursor/length, emitted bytes, decoding or
the still-open public body. Window frames alone cannot supply these results.

## 4. STATIC low suffix: exact progress and remaining local premises

`KeygenCodecStaticSuffix.low acc k := acc.toNat % 2^k` has universal kernel
proofs for uint32 shift and shift/OR append when k+shift<=32, and suffix
preservation on removing an emitted byte. Old emitted high bits can remain
and overflow; the proof never assumes acc<2^acc_len. The literal inequality
1025<2^4 is kernel-refuted, consistent with066's retained arithmetic-model
counterexample after two zero coefficients. This is not C instrumentation
or a source/security bug.

`KeygenCodecStaticAppend` executes the REAL bound node040 assignment
`acc=(acc<<(j+1))|lo`. Its append_low quantifies over arbitrary old uint32
accumulators and actual Eval/Exec derivations. It derives the output word
and low suffix, with VISIBLE LOCAL premises: j=int32 8, lo:uint32<512,
pending+9<=32 and the initialized acc/lo cells. The full source body must
still derive and transport these premises; this is not a whole STATIC
length/output theorem.

`KeygenCodecStaticTerminal` proves the actual postdecrement/comparison rule:
a failing guard087 entered with ne=int32 -1 leaves ne=int32 -2. Its local
terminal_exit consumes the actual node087 Exec and that OLD ne=-1 cell.
Deriving old ne=-1 from a full unary loop starting at a coefficient's ne,
interpreting every unary zero/final-one bit and composing acc_len/u/padding
remain open. No terminal outcome was assumed as a result of the whole codec.

## 5. Verification and preserved failed routes

Final028 rebuilt all13 new modules plus the new audit: **14/14 clean0/0**.
Audit **117 entries=102 new+15 inherited**, **111 full terms+6 kernel
inductives**, only propext/Classical.choice/Quot.sound, zero elisions.
Audit SHA256 `7826d9549b19ad65f5e8df775eea9eeb90fd4e91a035e4ab44b571513519ffd3`.
Generator reproduces byte-exactly; GENERATOR_CHECK SHA256
`b97dffcc880e1a3f9700de2372406ea63170103f115942ec386d385af2509fc8`.
All13748 predecessor pins unchanged at PRESEAL SHA256
`c3fc735b995c8bea6041efa91816d8ea65ec6524ee7f99b47623d9d3bb920926`.

All28 jobs retained:14 accepted/14 failed,41 command steps/27 accepted.
Max recorded child RSS3003772KiB; unchanged j1/-M6144,AS12GiB/RSS8GiB/
wall1800s/maxHeartbeats2000000. CAUSES.json and pair JSON pin every raw
stream, failed source snapshot, preflight, input manifest and wait receipt.

- 001: ambiguous imported `body` identifier invalidated the statement
  checker elaboration. Renamed loopBody;002 clean.
- 004–005: dependent cell/index inversion, redundant constructor alternative,
  eliminated before/last binders and C signedness/width normalization.
  Explicit real indices and q_eval closed006.
- 008–011: namespace aliases do not re-export constructors/projections;
  absent proposed signed-conversion lemma, unresolved explicit widths and
  modulo/test simplifications. Existing exact conversion lemma with explicit
  widths, qualified names and branch proofs closed012, without suppression.
- 013: transport of the evaluated Int.toNat index and eliminated low-state
  binder. Explicit equality and actual t closed014.
- 016–017: source declaration eliminated a named state; initial/initialLocals
  needed exact unfolding. Correct real index closed018.
- 020–021: broad simp expanded actual capacity subtraction before applying
  the typed fact; unsuitable Option simp arguments. Typed formula and direct
  constructor disjointness closed022.
- 023: already-closed append goal and wrong nested-modulus rewrite order.
  Correct order closed024 with the same universal statement.
- 025: explicit signed representability, setWidth identity and impossible
  Assign.set compound alternative. Correct source rule proof closed026.

No new Sage/C campaign was necessary for these universal kernel proofs.
066's finite C/Sage controls and both earlier counterexamples remain pinned;
no finite check was promoted to a source theorem. No new mathematical
counterexample or production-code bug was found in this window.

Author self-review uses mathbox:proof-audit and proofread-math. Primary
verdict for the requested continuation: **incomplete, with the smallest
missing implication**. SELF_REVIEW.md identifies all exact local premises
and the next full STATIC implication. This is not independent review,
REVIEWED, owner acceptance, probability/security or compiler verification.

Own source/tool commits1838879d/28328c9b/eee83ef2/7a73163e, followed by the
closing pair/checkpoint commit. Foreign S05 commit35484c4b/history and foreign
working-tree changes were preserved. No push, delegation/reviewer, relay,
migration or archive import. Historical runner labels remain provenance.

## 6. Single midpoint and executable next order

1. Complete the actual STATIC low-suffix invariant from its prologue and
   coefficient/unary loops: derive j8, lo<512, pending<8, all append bits,
   byte extraction/counter/cursor/padding, and old ne=-1 at the final test.
   Reuse local append_low/terminal_exit only AFTER deriving their premises.
2. Exact source STATIC encoded/consumed lengths and complete decoder bindings;
   round-trip encodedSegment++tail with independent padding. Compose four
   segments, actual final length store and coefficient-WORD preservation.
3. Public codec last: source15-bit packing/unpacking, same h and2881, respecting
   the decoder's supplied-length return. No invented trailing rejection.
4. Inherited common call ID/snapshots, all-state LegalWorkspace refutation
   status and full B1.07/B1.10 remain. B4/B5 laws/availability/PRG/security
   and compiler/OS stay outside this source checkpoint.

Next owner-started window FIRST verifies this sealed067 pair using
`tools/keygen_codec_none_batch.py verify` into
`.build/levels_068/ENTRY_PINS_068.json`. Exact external pair hashes and
postseal count are in checkpoint47R. Mismatch is stop-and-report, never
silent repair. NEW modules; preserve015–067, both063 versions/supplement,
all failed artifacts and both counterexamples. One final Acceptance or
expanded midpoint per window; no automatic restart or push.
