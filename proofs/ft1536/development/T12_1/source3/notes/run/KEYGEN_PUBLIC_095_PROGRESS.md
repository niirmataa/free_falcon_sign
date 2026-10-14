# Checkpoint095 final reconciliation

All source components below have now passed individually, including generic
visible/full-result determinism, actual public call and caller-domain
transport. The earlier in-flight descriptions are chronological notes.
The coherent final job is keygen_public095_015; final status/pins are
reported by KEYGEN_PUBLIC_095.json and KEYGEN_PUBLIC_095_NOTES.md.
Whole owner task remains ACTIVE. No execution-family or IID shortcut.

# Active095 recovery notes — not sealed

Parent checkpoint094: postseal527dea7a71d61ae2352e57fae94bc88116498e12242a20f22271f18b9601d591,
23980 pins; source a7a10d4b, metadata67e2cb2d. Whole owner task ACTIVE.

Accepted095: C99ModularDeterminism095(001); closed public scalar strata
and public words(004); full public source block-renaming covariance(005);
actual TailArrays syntax check for all eight public functions(006).
KeygenPublicLive095 is being checked by keygen_public095_007.

Failures:002220.225s, heartbeat timeout on name injection/failed alternatives,
dependent Leaf inversion and disjunction issue;003unused simp argument;
004Scalar+Word accepted, Tail inverseT kernel-memory limit.006uses existing
pinned inverse source partitions to avoid reparsing the full body at once;
accepted107.705s at unchanged limits. Attempted termination of002 sent NO
signal because it finished before PID validation; evidence in
.build/key_law088/PUBLIC095_002_TERMINATION_RACE.json. Include in future seal.

Public lifetime route: arbitrary Exec is NOT asserted deterministic with
all local pointer slots equal. Arrays allocated at function tails can leave
local aliases to disposed blocks in internal returned states; actual Call
restores caller pointer environment. TailArrays proves actual local array
scopes enclose the remaining function tail: sequence heads/branch/loop
sub-bodies have no local arrays. Calls may allocate internally but restore
caller state slots. NoArrays/tailArrays syntax predicates are source checked.

Prove generic Exec under closed TailArrays program and Live input:
visible returned heap/locals/flow are unique; additionally full Result
uniqueness when noArrays(code). NoArrays prefix preserves Live, so seq
intermediates can be identified. In arrayScope, rename the second fresh
local to the first using PublicRename095; use child induction for visible
result and actual metadata/readonly frame to undo the swap after disposal.
Input arrays/tables live => fresh_state invariant (ResultantRename093).
Final Call restores caller slots, so visible heap identity suffices for full
public returned state and converted scalar identity. Derive Live after
actual public argument binding from caller Initial input+h/table facts.

Do not assume pointer nonescape, full generic ModCall determinism, source
termination or positive success. Do not edit sealed094 files or raise
resource limits. One Lean process; inspect latest receipts before running.
