# BATCH_032 — initialized sampled caller to exact integer NTRU

2026-10-09. **B1.05 Acceptance MET / PROVED_KERNEL_SCOPED.** Window
**CLOSED_AT_ACCEPTANCE**; B1.06 was not entered. The overall package remains
**IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN**.

Actual harness: GPT-6.1 Sol Fast (`openai/gpt-6.1-sol-fast`). Inherited
runner model/session constants are historical labels, not this window's
attribution. No worker, subagent, review, relay or new session was started.
Small local commits on main as niirmataa under the shared archive.lock;
exact owned paths only. Foreign changes and staging were left intact.

## 1. Entry pins checked before proof work

The committed BATCH_031 verifier checked the full BATCH_015–031 closure:
**4824 distinct pins,554 current inputs,no supersession,no active job**.

- `.build/levels_032/ENTRY_PINS_032.json`, SHA256
  `779f1403f1685e14465540932ae3d3bedae7e58f06dc293b2cb734861eb6093e`.
- BATCH_031 JSON external pin:
  `0c9a115662976366fde92ae515aa372663674dc3d3988718e3e1532f26facb74`.
- BATCH_031 notes external pin:
  `7c7a5131d2fa6003a5d85c2b0621240c77b26f6b7a0537ee0c0622aa40faaec7`.
- Preseal repeated the identical predecessor closure, with no changed pin:
  `.build/levels_032/PRESEAL_PREDECESSOR.json`, SHA256
  `f9b35d8b91af467249d5fcf093c69cf205561ec33a759702a9ab91e224169a68`.

The new sealer independently rechecks every predecessor entry. It does not
weaken or silently supersede old source/artifact/failed-history pins.

## 2. What closed

### 2.1 Original initialization to Entry

`KeygenCallerInit` binds scalar declarations7805–7806, dimension reads and
MKN7824–7826, and the complete local declaration/tmp/rt fragment7876–7881.
The actual typed member reads derive logn10/ter1, the existing checked MKN
evaluation derives n1536, and pointer cast/addition derives rt1 at tmp,
rt2 at tmp+12288 bytes and rt3 at tmp+24576 bytes. The source setup parses
to the checked complete syntax tree. `KeygenCallerInitExecution` embeds
the specialized constructor in that inherited parsed-body execution,
including all pointer and scalar declarations.

`KeygenCallerEntry.Initial` contains only ORIGINAL caller memory: fk and
f/g/F/G/h slots, M0 member bytes, static prime/REV10 objects, scratch legality,
allocated coefficient objects and physical separation/live-table facts.
There is no vector, bound, equation, final Legal or arbitrary transition/frame.
`entry` derives `KeygenAttemptMaterial.Entry` after initialization; `root_entry`
derives initial RootCaller.Legal there, for later transport, not as a new
input at the final root boundary. Source commit `5213a67f`.

### 2.2 Legal transport through the SAME actual prefix

`KeygenCallerTransport` composes sampler subobject/profile frames, metadata
and actual table-block frames with resultant bytes/stability, raw/GS
stability and context bytes, and public-call stability/material footprints.
The source prime and REV10 tables are preserved in their own blocks using
read-only-byte stability. No impossible "disjoint from all tables, including
this table" hypothesis is used. Scratch extents/writability and required
physical separation are transported, not re-assumed at validation entry.

`KeygenCallerPrefix` uses the SAME two resolved sampler calls, resultant
gates and complete raw/GS execution. It explicitly restores rt1/rt2/rt3 and
norm/bound scope **BEFORE** the public call, matching the end of the active
ternary arm. Public and earlier rejection edges remain. `root_legal` derives
RootCaller.Legal from Initial and that execution; `material` derives the
same retained f/g and Bound1. Neither conclusion is supplied as a premise.

### 2.3 Acceptance composition

`KeygenCallerSuccess` binds the actual root caller gate8097–8106. The complete
source root may return only0 or1; a nonzero gate result is therefore proved
to be return1, rather than supplied externally as solver correctness.
`success` and `exact_integer_ntru` feed the derived Legal/material/Bound1 to
the already checked `KeygenRootCaller.success`, which derives Validation,
F/G bounds2047 and the exact integer lift with residual37748737.

The readable full final boundary is:

```text
ctx : KeygenSearchContext.Context
before : C99ArrayReference.State; out : C99ProcedureReference.Result
input : Fin 4 → C99MemoryReference.ArrayPointer
h, primes, rev : C99MemoryReference.ArrayPointer
initial : KeygenCallerEntry.Initial ctx before input h primes rev
source : KeygenCallerSuccess.Exec ctx before out
normal : out.flow = C99ProcedureReference.Flow.normal
-----------------------------------------------------------------------
exists f g F G : Geometry.Vec,
  Bounds(material f g F G) and
  multiply f G - multiply g F = constantCoeffs (18433 : Int) and
  forall slot,
    Represents out.state.heap (input slot) (material f g F G slot)
```

Bounds is exactly1/1/2047/2047, in f/g/F/G order. The same sampled material
and the same final heap are used throughout. Final Legal, incoming f/g
Represents/Bound1, Validation, canonical/image/table-generation conclusions,
NTRU, arbitrary callee/frame and solver_correct are absent from this type.
Source composition commit `9bd058a5`.

## 3. Honest source/model boundary

This closes **B1.05** in the explicit source-fragment/object-reference model.
The initialization relation is the selected dimension and ternary-local
fragments; it is **not** a fabricated contiguous execution of every line
between them. Automatic coefficient allocation, intervening RNG readiness,
cap increment/tests and chronological whole-loop/caller composition remain
**B1.07**, as specified by the execution plan. Original legal caller memory
is the allowed B1.05 input boundary. There is no arbitrary transition bridging
those future whole-caller obligations.

Public/inverse algebra and canonical h remain B1.06. Codecs, same emitted
bytes, the complete mandatory certificate, emitted-to-fiber, final fresh
replay and independent review remain later stages. No full KeyGen,
termination, acceptance probability, PRG, compiler, CT or security theorem
is claimed. Acceptance here is the stage's kernel/source result, not owner
acceptance, REVIEWED or an archive import.

## 4. Checks and full audit

Seven current accepted Lean modules, all0/0 streams; maximum accepted
cumulative RSS3046576KiB. All process/kernel/print limits are unchanged.
The final audit covers **116 entries =84 new declarations +32 inherited
interfaces**, **88 complete terms +28 inductives/structures with full
constructor types**, standard axioms only and zero elisions. Initial,
execution constructors, full success type and inherited source boundaries
are included. Final closure: **561 current inputs**.

- `.build/jobs/keygen_attempt_audit_032_001/CALLER_AUDIT.json`,385699 bytes,
  SHA256 `719b13b9a0a8bac433a23d8f170f75432206f824cbf13370bdaf00c1bc954b1f`.
- Audit receipt SHA256:
  `ddcabc57485f652d62f4b8733951862c1d2fc5747395b6318c77c40dc0b4dd3d`.
- Final success source SHA256:
  `430dc1cc910eb4162f52f31294bc2a74894e1407e9c1ee5af49c45c766e78f74`.
- `.build/jobs/keygen_attempt_checks_032_001/CALLER_CHECK.json`, SHA256
  `08168c1a7ae8b05d9720cc6509e0f8ab31b78dd1fc696e1d3d15d5ea2220c457`.
- Controls receipt SHA256:
  `21317d41e8c494fbb8c7916f5ef1c38071db80fcf32789c3da77088c9a7074eb`.

Sage standard preparser/ZZ:10 normal/UBSan runs ×24 PUBLIC deterministic
fixtures. Independent exact two-call MODE1 values and discarded-draw/refill
cursor, actual dimension/rt offsets, same material/context/sentinel frames,
and polynomial NTRU modulo Phi are checked. The root helper succeeds on21
of these MODE1-range fixtures per baseline. **Root controls deliberately run
independently also after earlier rejection; these21 are NOT21 accepted
full attempts or production keys.** Four mutations are detected in both
modes: wrong MKN dimension, off-by-one rt alias, root context overwrite,
and wrong NTRU target. No private KeyGen or serialized key generation.

No unchanged broad replay or independent review was run. The audit artifact
has a tracked generator/producer and complete closure pins. Raw C sources,
streams, result JSONs and public fixtures remain under the durable job.

## 5. All failed attempts retained; traps159–165

All17 attempts/17 steps remain:8 accepted,9 failed. Each has its source
snapshot, SOURCE_INPUTS, PREFLIGHT, receipt and raw streams; no receipt-less
attempt, earlier-interface acceptance or unresolved Lean draft remains.

| Failed attempt | Actual result and resolution |
|---|---|
| init_032_001 | Limit inference needed explicit State/tactic normalization; missing list-contains lemma and unused simp argument corrected |
| transport_032_001 | Reserved protected/meta identifiers; fixed-word Load32 dependent elimination generalized before projecting liveness |
| transport_032_002 | Output-block unification inferred ctx.object instead of the actual member field; explicit field pointer supplied |
| prefix_032_001 | initialize is reserved syntax; binder renamed init |
| prefix_032_002 | Saved scope State cannot be inferred from an unconstrained placeholder; actual dimensioned saved State supplied |
| prefix_032_003 | Heap/Result projections needed explicit change before size rewriting; no limit change |
| success_032_001 | prefix is reserved syntax; binder renamed preceding |
| initexec_032_001 | Missing chain import and state-constructor normalization for pointer declarations |
| initexec_032_002 | Boolean contains nested under OR did not simplify via propositional beq_iff_eq; proved exact absence, no linter suppression |

159. Original legal input memory may be supplied; final Entry/Legal must be
constructed from execution. Renaming a final premise is not closure.
160. Static table preservation must use its immutable bytes; requiring a
table to be outside its own block makes the boundary unusable.
161. Ternary local scope ends BEFORE public. Scope restoration is a real
source operation, not a frame or a delayed after-public cleanup.
162. Actual caller nonzero must derive return1 from the root's boolean-flow
and return-conversion facts; an assumed solver equation is not equivalent.
163. Fixed-word Load32 cannot be naively eliminated as if the byte encoder
were injective by constructor reduction; generalize the word first.
164. Lean reserved words and inference under reducible Result/state/heap
projections can cause local failures. Preserve streams and correct the type;
do not suppress warnings or raise limits.
165. Selected source fragments are not the whole caller. Initial automatic
arrays, intervening RNG readiness/cap and complete chronological loop binding
remain explicit B1.07 obligations, not an implicit arbitrary transition.

## 6. Next ordered work

**No B1.05 obligation remains at this explicit stage boundary.** This window
closes at Acceptance. The next owner-started window is B1.06: source public
and inverse equations for the SAME f/g/h, after exact-type inspection of
possible B3 exports. Then B1.07–B1.11 remain in execution-plan order.

Resume from checkpoint§12R and verify the BATCH_032 pair plus the whole
predecessor closure before edits/jobs. One guarded job, unique labels,
unchanged limits and0/0 logs. No automatic push, review, stages import,
migration, worker/subagent/session or relay.
