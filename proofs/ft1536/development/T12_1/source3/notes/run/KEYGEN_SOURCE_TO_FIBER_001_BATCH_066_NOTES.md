# KEYGEN_SOURCE_TO_FIBER_001 — BATCH_066 notes

2026-10-12, Codex. Owner-started B1.07 window from checkpoint45R.
**PARTIAL_PROOF / B1.07 Acceptance NOT MET / NOT_REVIEWED.**
**IN_PROGRESS / WORKING_NOT_FROZEN.** Exactly one expanded recoverable
midpoint, at this window's final close. B1.05/032 and B1.06/046 unchanged.
No B4/B5 advance. This window closes the typed whole-invocation secret
seam and full STATIC capacity-window fold; source lengths/decoders remain
open. The finite length/round-trip controls below are not kernel proofs.

## 1. Entry and fixed boundary

BEFORE edits/jobs, sealed065 verified **13000 distinct pins** into
`.build/levels_066/ENTRY_PINS_066.json`, SHA256
`d6f02133e0d4723c4e63410462495f961d290af13356735c918faa647755fbdf`.
JSON065 `04c387265046aea6222589d105e1bb12f193e3c54c9f3ba733ee09df16cf0ad0`;
notes065 `87f5a2f5c25d198af842e18bff5c46fb1a4f9dc4b3dca3d1f83b14ed83caa756`.
Only the recorded061/063 supersessions; no new repair or supersession.
Base HEAD `ded2b9ac4b8ae47d85c901428ea6c6f40a21bcca`, recorded in TARGET.json.
Host proof-process inventory was empty before jobs; all proof/Sage jobs
used the host-guarded serial job_when_available.py with unchanged limits.

Reference sources are the pinned live `Extra/c/falcon-enc.c`
`0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05`
and `Extra/c/falcon-keygen.c`. No production C or historical proof/audit
bytes were changed. The ordered C99/GCC LP64 reference semantics remains
the source/model boundary; no compiler/OS or full ISO-C equivalence claim.

## 2. Whole-invocation integration of segments0–3

`KeygenCodecInvocation` defines the stronger secret-codec Head, Encoding
and Invocation. The inherited non-secret statement rule explicitly requires
`stmt≠secretLoop`; there is no unrestricted legacy secret-loop bypass.
The secret edge carries actual065 typed body executions and observed
returns. Encoding concatenates their chronological call lists. Invocation
retains the external binding, readiness, capped loop, TailCells/legal-memory
domain and complete teardown of the existing statement machine.

`head_erase`/`encoding_erase`/`invocation_erase` go ONE WAY to the old
machine. Old arbitrary after heaps are never converted into body executions.
`split_success` and `tail_trace` extract the actual nine pre-loop statements
and the same successful secret-loop execution from the enclosing tail.
Early return0 cannot masquerade as a later successful tail.

The final extraction type, with names shortened only for readability, is:

```lean
Invocation env caller events out calls → out.flow = returned (int32 1) →
  ∃ entry middle final,
    TailCells env entry ∧
    Old.Encoding env SkeChain.chain entry ⟨middle, normal⟩ ∧
    Typed.Segments env 0 (initCounter middle) ⟨final, normal⟩ calls ∧
    Projected.Segments env 0 (initCounter middle) ⟨final, normal⟩
      (calls.map Typed.projectedSite)
```

`invocation_four_calls` additionally derives `calls.length=4` and
`Consecutive 0 calls`: all segment indices0,1,2,3 in source order.
`invocation_calls` instantiates065's executed-store histories and profile
transport at EVERY member of that list. It derives the same material INPUT
POINTER and q18433/logn10 at all four sites, under explicit privkey/ske
block separation and the existing finite virtual-map extension. The pointer
tie is not yet preservation/decoding of every coefficient word or final
output byte. The public-codec heads retain their old open body seam.

## 3. Full STATIC capacity-window fold, including rejection

`KeygenCodecLocalFacts.Valid` records the actual capacity parameter cell,
type correctness of initialized scalars and the unsigned64 declared type
of u. u may initially be absent/uninitialized. Source declarations,
converted assignments, scalar/pointer updates and evaluated expression
effects preserve these facts. The rejecting expression/object checker
forbids changing/redeclaring max_out_len; it does not assume test purity.

`KeygenCodecStaticWindow` tracks buf as absent or the actual nullable out
argument. Actual `buf=out`, declarations and scope restoration derive and
transport it. At a guarded write, the evaluated test requires initialized
u; its declared type and typed value are obtained from Valid. The existing
guard theorem derives u<capacity. `guarded_fold` covers the full guard/store
block, including return0 with no write. No bound, return or frame is supplied.

`static_checked` kernel-checks the COMPLETE bound STATIC syntax, recognizing
all three exact guarded blocks. `exec_fold` composes them through sequences,
both branch paths, arbitrary finite while paths, expression side effects,
scope entry/exit and early returns. Unsupported calls/for forms are rejected;
STATIC contains no for loop. This is not a claim about the NONE for loop.
`window_trans` keeps the exact lower/upper requested-window boundaries.

The whole-body export has this actual premise boundary:

```lean
args.out = some dst →
  Exec args StaticBinding.code (initial args before) after flow →
  Window dst args.capacity.toNat before after.heap
```

flow is UNIVERSALLY quantified; no success or length condition. This
STATIC result needs no q/logn restriction. The065 out-of-profile NONE
counterexample does not apply to it and remains preserved unchanged.

`KeygenCodecStaticDispatch.dispatch_window` extracts the actual STATIC
call from the fixed dispatcher when comp=1. `CallArgs` reads the SAME
capacity cell; the complete body theorem supplies its window. There is
no desired result/length/frame predicate in Call. `site_window` and
`invocation_windows` compose this with the enclosing invocation and ALL
four calls. Capacity is each site's evaluated klen-skoff word, not a newly
assumed returned length, no-wrap cursor or aggregate secret-buffer bound.

## 4. Length/round-trip controls and retained counterexample

`check_keygen_codec_roundtrips.sage` runs via native Sage with ZZ. It compares
actual live C against an independent MSB-first bit-list encoder and a
uint32 source-arithmetic STATIC model. PUBLIC synthetic families cover
zero, boundaries, alternating extremes and deterministic formulas, with
f/g ternary, F/G bounded2047 and canonical h<18433. No private KeyGen run.

Accepted015 has normal/UBSan **16 baseline sets**, **256 capacity probes**,
and all **6 mutation kinds detected per mode**. These include four encoded
segments with independent padding, exact consumed lengths from segment++tail,
same decoded vectors, NULL length queries, short/exact/extra capacities,
partial-write prefixes and canaries. Exact STATIC reference bit counts are
`sum(10+abs(w)//256)` with separate byte rounding per segment. NONE3072 and
public2880 payload/header2881 are checked in these finite cases only.
Public decoding is also checked with11 trailing bytes: its returned supplied
length is2891, without inventing trailing-byte rejection. These experiments
do NOT discharge the universal source length/decoder/emitted-byte theorems.

Mutation kinds: NONE byte order, STATIC padding, terminal unary1, secret
decoder consumed length, public15-bit width and public returned supplied
length. Every generated C variant, compile/run stream and failing outcome
remains in the job directory. Compiler argv and before/after hashes of the
direct source/internal.h/falcon.h inputs are recorded. The computation
manifest validates as legacy v1: it does not assert full compiler-input
closure, compiler verification or a machine-checkable v2 resource manifest.

The false whole-accumulator bound has a retained source-ARITHMETIC-MODEL
counterexample: after two zero coefficients, acc=1025 and acc_len=4, so
1025≥2^4. Old emitted bits remain; only a LOW-SUFFIX invariant is viable.
The model agrees with the independent bit-list bytes across the recorded
families and checks terminal ne=-2. This is not instrumentation of C locals
or a source-code/security bug. The065 defined q18433/logn0/NONE cap3/write4
counterexample remains pinned; no KeyGen-profile failure is claimed.

## 5. Validation, failures and author self-review

Final016 rebuilt all5 new proof modules plus audit: **6/6 clean0/0**.
Full audit **65 entries =50 new+15 inherited**, **54 full terms+11 kernel
inductives**, standard propext/Classical.choice/Quot.sound only, no elisions.
The audit producer reproduces byte-exactly. Entry13000 predecessor files
remain unchanged at PRESEAL `1cd7f1257aafb8d75781be9f410829fe48df479497350dc44137908b67c7ab43`.
Recorded generator check `f6ae53cfaa6e3c5e2acfdcff9ba28f39852ea4035ad318bfe41991529fac2ff7`.

All16 jobs retained:8 accepted/8 failed,21 command steps/13 accepted.
Max recorded child RSS3004164KiB; unchanged j1/-M6144,AS12GiB/RSS8GiB/
wall1800s and maxHeartbeats2000000. No broad unchanged predecessor replay.
Accepted final source hashes, full terms, raw streams and snapshots are
pinned by the pair JSON. CAUSES.json records every rejected run:

- 001–002: dependent Result/State/index elimination, reserved `prefix`
  binder, constructor event indices and split-success induction arguments.
  Explicit correct middle-state/index forms closed003; count/order004 clean.
- 005: exact scalar-set frame, pointer-local structure preservation,
  conjunction rewrite usage and unused simp argument. 006: deprecated
  if_neg rejected. Explicit split closed007, without warning suppression.
- 008: ambiguous body binder/invalid proposed for checker and extra tactic
  after all goals solved. STATIC checker rejects for; NONE remains open.
  009: parser/predicate name collision only. Qualified predicate closed010.
- 011: dispatcher initial-state/return dependent binders and evaluated
  capacity equality. Explicit indexed forms closed012; composition013 clean.
- 014: mathematical/C controls passed, exit0, but deprecated Sage version()
  emitted a warning. Metadata now uses SAGE_VERSION;015 clean. Original014
  remains FAILED_RETAINED with all artifacts, never promoted to accepted.

Author `mathbox:proof-audit` self-review is pinned in SELF_REVIEW.md, with
primary verdict **incomplete, with the smallest missing implication**.
The changed theorem-heavy prose/types were re-read in context; no independent
reviewer, REVIEWED status, probability/security claim or owner acceptance.

Own local commits: `18e63200` (Invocation), `7cd4d063` (full STATIC fold),
`d2b821ca` (controls/audit/tooling), plus the separate closing pair/checkpoint
commit. The intervening foreign S05 commit/history and foreign working-tree
changes are preserved. No push, delegation, relay, migration or archive import.

## 6. Exact remaining obligations and next entry

1. NONE: derive3072 from the actual q18433 branch through the complete body;
   initial capacity test, even pair-write loop, cursor/no-wrap, returned
   length and whole capacity window.065 still proves ONLY the RHS3072.
2. STATIC: uint32 LOW-SUFFIX invariant, source terminal ne=-2 and padding,
   exact encoded/consumed lengths, bound source decoder bodies/round-trips
   of segment++tail; compose four-segment bytes/final length store and
   material-word preservation. Complete window does not imply these facts.
3. B1.09: source public bodies, canonical15-bit packing/unpacking, SAME h,
   actual2881 and supplied-length decoder behavior. Current C evidence
   is finite only; no source kernel theorem has been substituted for it.
4. Inherited explicit common call ID/snapshots, all-state LegalWorkspace
   refutation status and full B1.07/B1.10 source target. B4/B5 laws,
   availability/PRG/security and compiler/OS remain outside.

Next owner-started window: FIRST verify the sealed066 pair using
`tools/keygen_codec_invocation_batch.py verify` into
`.build/levels_067/ENTRY_PINS_067.json`, with the exact two hashes and
postseal pin count in checkpoint46R. A mismatch is stop-and-report, not a
repair authorization. New modules for further composition; preserve015–066,
both063 versions/supplement and every failure/counterexample. One final
Acceptance or expanded midpoint per window; no automatic restart.
