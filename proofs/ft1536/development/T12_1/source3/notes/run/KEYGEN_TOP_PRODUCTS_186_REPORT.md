# Complete selected source make_fg_ternary_top186

Status: PROVED_KERNEL_SCOPED / PARTIAL_PROOF / NOT_REVIEWED.
Selected make_fg_ternary_top invocation: COMPLETE.
Nine lower-level make_fg_step calls and remaining root/encoding: OPEN.
Whole owner goal ACTIVE / NOT_COMPLETE.
Source commits: 2098e690, 30ded08a, c2df16f9.

TopProductProgram186 binds the original paired-product loop, initialization,
counter step and final !out_ntt tail to the existing parsed source remainder.
TopProductEval186 constructs the exact nested Montgomery expressions from
three actual input loads. Its word arguments are explicit, including every
intermediate product; no algebraic transform or native output oracle replaces
the source operations.

TopProductMemory186 confines writes to the two512-word output buffers,
block31 bytes [2680,6776). The invariant preserves the readable transformed
fs/gs inputs above that interval, actual output allocations, writability and
required scalar/pointer cells. TopProductBody186 executes the fd store first,
then derives the three gs reads from the resulting heap before the gd store.
It does not evaluate the second store against an unrelated old heap.
TopProductControl186 executes the actual u+=3/v++ source expressions, and
TopProductLoop186.full constructs all512 iterations and the final u=n false
guard, ending u1536/v512. The body is proved once parametrically and reused.

SelectedTopR3_186.source constructs the actual R3 assignment from the
preserved R2/p/p0i cells. Its fixed theorem discharges all concrete input
conditions, deriving fd/gd allocation from the same established scratch
object. SelectedTopProducts186.loop_source supplies the full product loop;
tail_source proves the actual !out_ntt guard false from out_ntt=int32(1).
The two source inverse calls remain in the program and are excluded on this
selected path by the proved guard, not by deleting them or assuming a return.

SelectedTopProducts186.body_source composes the new suffix with the complete
previous prefix, generator and both modular forward calls into the ENTIRE
original KeygenMakeFgTop.code at SelectedMakeFgTopEntry176.entry.
SelectedTopCall186.source is the actual KeygenMakeFgTop.Call with its proved
argument binding and ReturnValue.voidEnd; instruction embeds it in the
original make_fg caller. This is the selected ternary/logn10 helper call,
not the complete make_fg routine or whole KeyGen witness.

LevelInitialization186 proves byte-initialization preservation from actual
LevelExec derivations, including overlap-safe memmove and the source bodies
of modular callees. SelectedTopOutput186 derives both complete512-word
output read contracts using that theorem and the source-established input
initialization. It also preserves the canonical gm and readable transformed
inputs. Its full-call byte frame preserves all other blocks and scratch
bytes below2680; size/writability are unchanged. No output word is claimed
equal to its pre-transform or pre-product value.

SelectedTopContinuation186.continue_make exposes exactly the remaining
normal execution of SelectedMakeFgTopEntry176.tail. It retains the original
ternary branch and source top instruction. The restored caller has logn10,
depth10, ter1 and out_ntt=int32(0), unlike the top callee's out_ntt1. The
remaining d1..9 calls are recorded explicitly in NEXT_ROUTE and do not move
into the five-item do_sign slot.

All 13 mathematical modules / 91 named declarations passed full expression
DAG roundtrip and fresh safe kernel checking in audit327, in 13 sequential
processes. Only propext/Classical.choice/Quot.sound were allowed. Accepted
stdout/stderr are empty: 0 errors / 0 warnings. Source construction and
finite layout/count facts were proved directly in the kernel; no new external
numerical certificate was required. C/reference semantics and resource
limits are unchanged; no warning was suppressed. No independent review or
push occurred.

History322-327 has 6 jobs and one failed/mixed job323. The precise frame and
fixed-state transport accepted there; two definitionally constant store
widths mentioned a free index and required rfl instead of decide. The source
operations, pointers and bounds were unchanged. Its logs and cause remain
in the failure ledger. There were no controlled cancellations or relaxed
limits. A completed322 terminal handle was also mistakenly queried after
launching323; the correct live handle was then used, with no restart or
duplicate Lean process. This bookkeeping error is recorded in PLAN and was
not a proof-input integrity failure.

ENTRY186 verified 67318 inherited paths; SHA256:
614628a87893536251789db7c065cee1bbdc0deb77fbb2c53094076b0c64d3d0.
Audit collection SHA256: 7a7b19b581a8d4ff3455b336b5f7fb0948c968c97025760b18d2c08b08245272.
Receipt: KEYGEN_TOP_PRODUCTS_186.json.
Postseal: .build/topproducts186/POSTSEAL_186.json.

| Owner point | Current status | Exact boundary |
| --- | --- | --- |
| Full source seed witness and positive mass | PARTIAL | The entire selected ternary-top call is constructed. Nine make_fg_step calls and the remaining root/encoding path stay open; no complete emitted KeyGen witness or unconditional Z>0. |
| Numerical first-attempt acceptance bound | OPEN | No numerical p_accept bound, including1/4, follows from this checkpoint. |
| Conditional coding and quantitative p_K | OPEN | Source coding success and a concrete positive p_K remain unproved. |

The emitted-witness target remains corrected KeygenProbability134; old110
stays frozen. Existing package_of_witness and success_lower_of_witness
remain conditional on the complete source witness. No IID/D1/F04 or
empirical premise was introduced. Paper wording stays measured8192/23628
with the separate256/739 control. Exactly five do_sign items remain:
key/certificate transport; AttemptShape/ReplyShapeAt; PointwiseStageRoad's
four conditions; rounding/int16/syndrome; sampler loop and honest-signing
PRG hybrid.

The entire selected make_fg_ternary_top source call is now constructed and kernel checked.
Its two readable512-word outputs and explicit restored caller state provide the next recursive-level inputs.
The complete emitted KeyGen witness and all requested positive probability bounds remain open.
