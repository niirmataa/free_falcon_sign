# BATCH_031 — sampled material through raw/GS/public

2026-10-08. GPT-6 Astra Ultrafast (`openai/gpt-6-astra-ultrafast`).
**PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
**CLOSED_AT_RECOVERABLE_MIDPOINT; B1.05 Acceptance NOT MET.**
The context-discipline checkpoint closes this window. B1.06 was not entered.

## 1. Entry and preservation of history

Before any source edit or proof job, the committed BATCH_030 verifier checked
the complete BATCH_015–030 closure:4510 distinct pins,539 current inputs,
no supersession and no active proof job. Entry receipt:
`.build/levels_031/ENTRY_PINS_031.json`, SHA256
`094e3bc10bc90f51b66cfd984a344e93b7d4a717bb59e07bbe7af51fd7b43a0f`.
The identical predecessor closure passed again in
`.build/levels_031/PRESEAL_PREDECESSOR.json`, SHA256
`349b1eadf02e35d6543f1fb7c4cb9350fdc4740e234b70903f4bb23aec19368e`.
The batch sealer also compares all4510 original bytes. No old source,
receipt, frozen object or historical pair was superseded.

Source commits on main as niirmataa, under the shared archive.lock:
`a776a183` (raw/GS), `4322e2df` (embedded RNG frame), `2661ee1c` (public
closure and exact controls), `08cf8002` (same-material gate composition).
The audit/recovery tools and final pair/checkpoint have separate local
commits. Exact owned pathspecs preserve the foreign worktree changes/index.
There was no push, independent review, migration, stages import, worker,
subagent or relay.

## 2. Kernel-checked additions

### 2.1 Raw and GS

`KeygenAttemptFft` source-binds internal.h646's mulconst alias and the full
1119–1128 `falcon_poly_mulconst3` body, its parameter conversions and byte
frame. `KeygenAttemptNorm` binds active7958–7964 bound initialization,
raw norm/gate via the existing complete source, and all7995–8019 GS
operations/gate. It retains both continue edges and executes the actual
object-copy `fpr_lt`. Scalar FPEMU calls use their existing fixed bodies.
The signed `73732L` token is lowered to an LP64 signed-long cast, with its
conversion checked; it is not replaced by an unsigned literal.

`material` transports the same incoming vector; `stable` preserves
allocation metadata and immutable bytes. No real-norm inequality, accepted
gate or supplied heap frame is a premise of these execution relations.

### 2.2 Actual embedded RNG context

`ShakePointFrame` strengthens the prior whole-block frame to protected
points in the same allocation. It follows every SHAKE field store,
process_block, byte encode, memcpy, local uint64 allocation and disposal.
`KeygenSamplerContext.Resolve` consumes the actual fk pointer and legal
448-byte LP64 object. `rng ctx` locates the embedded object at fk+8;
dbuf/dptr/rate/A are at8/208/216/224 and the RNG ends at424. The tmp pointer
is at432. `context` preserves adjacent bytes; `profile` transports logn10
and ternary1 through all sampler refill/rejection/store iterations.
`two_calls` reuses the complete MODE1/refill proof and derives both Bound1
vectors in the same final heap. No distribution or termination is assumed.
The caller's earlier dimension initialization and initial static environment
are still part of the remaining enclosing entry obligation.

### 2.3 Complete operational public helper

The nine full scalar bodies are mq_conv_small, mq_add, mq_sub, mq_rshift1,
mq_montymul, mq_montysqr, mq_div_12289, mq_div_18433 and rev10. Headers,
closing braces, macro values and call-stratum coverage are checked in
`KeygenPublicScalar`. Its execution is actual uint32 C arithmetic, not a
mathematical modular-division oracle.

The eight array procedures are mq_mkgm3, binary/ternary forward and inverse
NTT, both NTT dispatch wrappers, and falcon_compute_public. The new
Word/Exec/Parser/Frame/Source modules bind every complete body, signed f/g
reads versus unsigned16 array reads, actual stores/narrowing, the terminal
post-increment of mkgm3, both runtime branches, fresh t/gm/igm allocations
and their disposal on every return. All seventeen bodies are available;
the binary bodies remain in the fixed graph even though M0 selects ternary.

`KeygenPublicSource.material` derives the disjoint input frame on either
defined public return. `KeygenPublicStability` separately proves metadata
and all read-only bytes are retained, including source tables in the same
global environment. No assumed public-call frame or arbitrary callee is
used. Public/inverse algebra and canonical h remain B1.06 obligations.

### 2.4 One sampled-material prefix

`KeygenAttemptSlots` derives the actual pointer/table preservation through
bound/raw/GS execution. `KeygenAttemptMaterial` derives resultant metadata
through its automatic object, all helper writes and disposal. Its Exec
composes the SAME two resolved sampler calls, both resultant gates, complete
bound/raw/GS execution and the actual public gate8083–8092. Rejected
resultant/raw/GS/public paths remain constructors, rather than being erased.

The complete exported boundary is:

```text
ctx : KeygenSearchContext.Context
before : C99ArrayReference.State; out : C99ProcedureReference.Result
f, g : C99MemoryReference.ArrayPointer
entry : KeygenAttemptMaterial.Entry ctx before f g
source : KeygenAttemptMaterial.Exec ctx before out
-------------------------------------------------------------------
exists fv gv : Geometry.Vec,
  Represents out.state.heap f fv and Bound fv 1 and
  Represents out.state.heap g gv and Bound gv 1
```

Entry contains live/disjoint f/g/context objects, width2, actual f/g slots,
the n1536 caller slot and initial rt/h/table separation. It contains **no
incoming f/g vector, representation or coefficient-bound premise**. The
proof transports the exact witnesses produced by the first two calls.

This is the full sampled-material transport from those sampler calls to
the public gate. It has not yet derived Entry from preceding actual caller
initialization, nor constructed RootCaller.Legal at its normal output.
Consequently it is not yet the final sampled-attempt NTRU composition.

## 3. Exact checks and full audit

Fifteen current accepted Lean modules, all0/0 streams. Maximum accepted
cumulative RSS5882828KiB; process, kernel and print limits are unchanged.
`keygen_attempt_audit_031_002` checks268 entries:242 new declarations plus26
inherited interfaces,232 full terms and36 kernel inductives/structures with
complete constructor types. Standard axioms only; zero elisions. Exact
final audit closure:554 current inputs.

- Full audit: `.build/jobs/keygen_attempt_audit_031_002/ATTEMPT_AUDIT.json`,
  713364 bytes, SHA256
  `43d10fe1079e170f23819a7820801d118dbff9895cb0fe3d3bef5f19f5d07618`.
- Audit receipt SHA256:
  `ab1eae82dfcd0eba8b427042b5f45164bb9268ae91926f3334395e2e484f1bbc`.
- Material source SHA256:
  `63b9f4ef32d99898ac58aab0faa212effe9dadf04e2eacfdcc0caa0737a3e525`.
- Exact controls: `.build/jobs/keygen_attempt_checks_031_001/ATTEMPT_CHECK.json`,
  SHA256 `a088ef03ea8b682bd749a745d99ce93f389afded658e8d18742684e3fbfd9961`.
- Controls receipt SHA256:
  `60077fa7fad70ec7863696baf64ed1bad949f5d21285ebbc7c70f8f0d6f6115c`.

Sage standard preparser/ZZ,10 normal/UBSan runs ×24 public deterministic
fixtures. Independently reconstructs both1536-value sampler calls from
public SHAKE labels, including discarded draw3, 64-bit refills, discarded
residual bits between calls and the byte cursor. Checks actual LP64 offsets,
coefficient/context/sentinel frames, raw/GS word results and public return.
All four mutations were detected in both modes: sampler+2, altered raw
bound scale, omitted GS scaling, and overwritten public input.

The public helper is deliberately exercised independently even after an
earlier rejected gate. The controls are finite helper diagnostics, not a
successful complete attempt, public algebra, compiler or security proof.
No unchanged broad replay was run. The first smaller audit is retained as
an accepted earlier-interface artifact, not the final audit.

## 4. Retained failure history and traps151–158

All29 attempts/32 steps remain with snapshots, receipts and raw streams:
13 wholly current accepted attempts,14 failed attempts,2 accepted earlier
interfaces. The accepted Pin and Word steps inside failed multi-step jobs
are individually valid and explicitly selected by current cache receipts.

| Attempt | Actual result and resolution |
|---|---|
| fft_031_001 | Pin accepted; FFT audit proof needed explicit unfolding and the dependent case's reflexive parsed equality |
| norm_031_001/002 | Missing signed L literal support, indentation, then a redundant-parenthesis call-parser ambiguity; fixed signed cast with original precedence |
| shake_031_001 | Single-occurrence rw left a variable-width product; simp normalized all width occurrences before arithmetic |
| context_031_001 | Fixed result index is not a constructor binder; offset sum normalization corrected |
| public_scalar_031_001 | `t!` tokenization from missing whitespace before `!=` |
| public_word_031_001 | Incorrect theorem application for BitVec.ofNat_toNat width; corrected to checked simplification |
| public_exec_031_001 | signed-name environment must be an inductive index, not a uniform parameter when a callee changes it; Word step accepted |
| public_frame_031_001 | Projected memory equality before rewriting a wrapped Frame |
| public_source_031_001 | `public` is reserved syntax; constructor renamed compute |
| public_source_031_002 | Both ternary source audits correctly rejected the too-strong pointer checker; missing material import also corrected |
| slots_031_001 | Receive preserves arrays of the heap-updated caller; explicit State supplied |
| material_031_001/002 | Reserved `protected` binder, then Result.state table equality needed an explicit normalized type |

151. Signed L constants must keep their C signedness and precedence.
152. Pointwise subobject frames are necessary when RNG and profile fields
share a block; a whole-block disjointness assumption is false there.
153. Uint16 public arrays use unsigned promotion, unlike signed f/g input.
154. Automatic t/gm/igm lifetimes must close on early return as well as success.
155. Fixed call closure cannot reuse the unrelated closed modp evaluator.
156. Pointer assignments to untracked read-only aliases need no writable
capability; assignments to tracked names must derive source membership.
The revised checker proves this distinction in its frame theorem. It does
not assume a frame or weaken the source audit to accept an unknown callee.
157. Source slots and allocation/static frames must be composed, not assumed
anew at each gate or inferred merely from unchanged source hashes.
158. Helper fixtures executed after earlier rejection are diagnostic paths,
not evidence for whole-attempt acceptance or a success probability.

## 5. Remaining ordered obligations and restart

1. Bind actual caller dimensions7824–7826 and the local declarations/tmp/rt
   aliases7876–7881. Derive the above Entry at the first sampler call from
   legal caller memory/profile, rather than supplying n/rt alias facts anew.
2. Transport the original legal M0 context, source prime/REV10 objects,
   scratch metadata and material separation through this SAME Exec. Derive
   `KeygenRootCaller.Legal ctx rootEntry input primes rev` at its normal
   output. Reuse sampler subobject frames, resultant stable/slots, norm
   stable/slots and public stable/frame. No arbitrary heap-frame or root-entry
   Legal premise may replace this missing composition.
3. Consume `KeygenAttemptMaterial.material` and that derived Legal with the
   existing `KeygenRootCaller.success` for the actual root Call/return1.
   Root Validation, F/G bounds and exact integer NTRU are already proved.
   Only this composition closes Acceptance; do not redo those dependencies.

Resume through checkpoint§11R with the BATCH_031 pair's external pins.
One guarded job, unique `keygen_attempt_*_032_*` labels, unchanged limits,
zero streams, small local commits. No unresolved Lean draft or active job
remains at handoff. B1.06 waits for B1.05 Acceptance.
