# T12.1/source3 — żywy stan

## B1.05b-c — extraction continuation — 2026-10-08

Owner resumed checkpoint 7R with GPT-6 Astra Ultrafast. BATCH_028 is
IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN; B1.05 Acceptance NOT MET.
ENTRY_PINS_028_002 verified all BATCH_015-027 pairs, 2917 distinct pins,
459 inherited current inputs, three exact documented supersessions and
14 BATCH_027 receipts; no active proof job at entry. Receipt SHA256
`b9cec873c9440265d16347bfcb13104630dfeee33a14bf907699a13d87f1ce60`.
The first receipt is retained; _002 only corrects the verifier's descriptive
count of superseded sources (including the diagnostic probe). Entry-pin
source commit: `8ca34465`.

`keygen_zint_extract_028_002` accepted KeygenZintCall, KeygenZintExtract
and KeygenZintCore with 0/0 streams. Complete bitlength and
zint_signed_bit_length are bound in 3/5 statement-boundary pieces with
non-vacuous audits and pure-rewrite composition. The unsized static vv[]
declaration infers 32 words, resolves `bitlength.vv` in the table environment,
checks the actual read-only object/initializer bytes and binds the local vv.
The returned sum has its own value-call rule executing the fixed bitlength
body with uint32 argument/return conversion and the actual C addition.
All previous core body audits rebuilt. No bitlength arithmetic or full
solver claim. First failed attempt retained: incorrect storage spelling in
the expected header and the parser's `return (`/generic-call precedence.
Next: get_top division/return pun, polynomial conversion/subtraction,
make_fg and deepest/intermediate/root closure in the owner's order.

The next accepted sources are KeygenZintTop (`keygen_zint_top_028_002`)
and KeygenZintPoly (`keygen_zint_poly_028_002`), all 0/0. get_top is bound
in four pieces, including unsigned sc/31 and the same-width int64 return
pun. Both polynomial helpers are complete (4/3 pieces): max_bitlength
executes the signed helper and pointer advance; big_to_fp executes the
nested get_top/fpr_scaled calls and Store64. Non-vacuous piece audits,
line partitions, exact special statements, call counts and byte frames
are checked. No real-number approximation or solver claim. The new grammar
strata reuse the fixed core without expanding its largest Bezout reduction.
The first top attempt's two proof elaboration errors are retained. Next:
scaled subtraction, make_fg and deepest/intermediate/root closure.

Scaled subtraction and the make_fg closure are now kernel-checked:
KeygenZintScaled (both bigint leaves, 3 pieces each), KeygenPolySubScaled
(both polynomial branches, 3 pieces), KeygenBinaryNtt (complete binary
generator/forward/inverse, 4/3/4 pieces), KeygenMakeFgSource (complete
make_fg_step/make_fg, 5/4 pieces). Jobs `keygen_zint_scaled_028_001`,
`keygen_zint_polysub_028_001`, `keygen_zint_binary_028_001`,
`keygen_zint_makefg_028_001`: accepted 0/0. Source call counts exclude
silent modular-call fallbacks. Backward pointers retain (F+j)-off order
and intermediate bounds; k[u] is read as signed32. Binary REV10 reads
are unsigned16, chained assignment and the inverse's empty statement
are retained. make_fg size tables load64, f/g load16 and mixed declaration/
pointer conditional are explicit. Static table initialization remains a
root-caller obligation. Next: deepest's context members and actual gates.

`KeygenDeepestSource` now binds all 48 body lines of solve_NTRU_deepest
in five pieces (`keygen_zint_deepest_028_001`, accepted 0/0): actual LP64
member reads, value-bound fk->ternary argument to complete make_fg,
CRT, negated Bezout gate, short-circuit multiply OR and both returns.
`material` derives retention of the same incoming vector on either return
from scratch/static separation; `slots` restores caller locals/pointers.
The root/intermediate call and initialization of full static tables remain
open. This is the complete local deepest operational/frame closure.

Full audit `keygen_zint_audit_028_001`: 546 entries, 528 covered module
declarations plus 18 inherited interfaces; 509 full terms, 37 inductives
with full constructor types, standard axioms only, zero elisions, 0/0.
Sage `keygen_zint_checks_028_003`: exact ZZ/QQ expectations, 16 normal/
UBSan runs with 266 rows each, all seven mutations detected in both modes.
Two failed control attempts retained: auxiliary n=1 inverse harness path
and an unused-parameter warning in a mutation; final baseline is clean.
Preparing BATCH_028's recoverable checkpoint after the owner's listed
deepest closure; B1.05 Acceptance still NOT MET. Next: full intermediate,
remaining active dependencies, static/global/root binding and material
transport into the already checked depth0/output/validation suffix.

## B1.05b — CLOSED at complete zint_bezout midpoint — 2026-10-08

**B1.05 Acceptance NOT MET. CLOSED_AT_RECOVERABLE_MIDPOINT.**
The complete `zint_bezout` body (3908-4200) is now kernel-checked under
the new grammar: ternary `?:` lowering, memcpy/Memzero with `sizeof
*element` width-4 limbs, `for (;;)` with continue/break loop flow,
statement-position pointer binds separate from for-clause binds, the
six-pointer walk declaration, `size_t` scalars and the `&=` store. Bound
in eight statement-boundary pieces with non-vacuous `map ... = some`
audits and pure-rewrite composition: only=true, callShape (28,2,0,0),
bitcastCount 6, code_checked fed. All ten earlier body pins re-verified.
Operational/frame only — no Bezout/GCD claim. `Call .bezout`/`call_frame`/
`material` ready for B1.05c's deepest caller.

BATCH_027 pair; entry pins BATCH_015-026 verified before work
(`.build/levels_027/ENTRY_PINS_027.json` sha `86aee101...`, 2900 pins,
two explicit supersessions). 15 retained attempts (14 receipted incl. 7
DIAGNOSTIC probes, 1 receipt-less stale-cache refusal). Traps 116-122.
Commits `32f2f1ee`, `f7952a2a` + docs commit. Open: bitlength (static
table), zint_signed_bit_length (expression-position call), zint_get_top
(division, bitcast-in-return), poly_max_bitlength/poly_big_to_fp
(fpr_scaled), poly_sub_scaled, make_fg and the binary family. No
push/review/import/worker/relay.


## B1.05 — CLOSED at signed/reduction CRT midpoint — 2026-10-08

**B1.05 Acceptance NOT MET. CLOSED_AT_RECOVERABLE_MIDPOINT.**
New call-capable word layer `KeygenZintCall` (accepted) embeds the sealed word
grammar and source-binds zint inter-calls to real bodies (leaf calls share
KeygenZintLeaves). `KeygenZintCore` (accepted) binds five complete bodies:
zint_mod_small_signed, zint_norm_zero, zint_exact_length, zint_rshift1_mod,
zint_sub_mod, with header/close pins, parse/only/callShape audits, frames and
generic material. `zint_rebuild_CRT` remains OPEN: its body parse is the
checked fact `none` (dot member access defeats C99ProcedureParser.tokens);
`Call .rebuildCrt` is a skip placeholder, not a CRT execution. Next: close
rebuild_CRT parse, then co-reduce/reduce/Bezout, make_fg_step (binary mkgm2/
NTT2 family), make_fg, deepest/intermediate/root and material transport.
BATCH_025 pair; entry pins BATCH_015-024 verified (2847 files). Traps 106-110.
No push/review/import/worker/relay.


## B1.05 — CLOSED at search-dependency / early-material midpoint — 2026-10-08

**B1.05 Acceptance NOT MET. CLOSED_AT_RECOVERABLE_MIDPOINT.**
Complete inverse NTT, all-depth modular calls/frames, make_fg_ternary_top
and seven bigint leaves are checked. Complete mod2_res_ternary and both
actual gates now transport the sampled f/g Bound1 into their same final
heap, including rejection. The active raw FFT/FPEMU norm gate has its
separate source frame and actual object-copy comparator. **Complete
deepest/intermediate/root and later GS/public/search material transport
remain open.** B1.06 has not been entered.

BATCH_024 JSON `fbfe3b1c6c297b20b31d92370963c89aa1a0fe3cedfbfb5b0b799f1b3a72d365`;
notes `804a5d9ea7abc0b438e70cbe14d32bdb793f7a934b318d3b4e60727e8c57e344`.
14 current accepted modules,236 full audit entries,459 final inputs and
2595 predecessor pins checked at sealing.0/0 logs, max accepted cumulative
RSS5102368KiB.14 attempts:9 wholly accepted,3 failed retained and2 explicitly
superseded scope routes.14 normal/UBSan controls; six mutations detected
in both modes. No current source consumes the discarded norm routes.

Source commits `4f787baf`, `60eb842b`, `dfff8cd4`, `3663e509`, plus final
documentation commit. Main as niirmataa, exact owned paths/archive.lock.
Postseal verified2847 distinct pins and459 current inputs, no active job:
`.build/levels_024/POSTSEAL.json` SHA256
`4db7e5c366fe190798fc2b497308558b3cc63e9ab1acac8cdef4b84bcd708703`.
No owned job or unfinished Lean draft remains. Expanded checkpoint
`notes/run/KEYGEN_RESIDUE_CHECKPOINT.md` section6 is the resume entry.
No push, review, stages import, migration, worker or relay was started.

## B1.05 — deepest/intermediate continuation — 2026-10-08

Owner resumed checkpoint section6 for a BIG recoverable midpoint with
GPT-6 Astra Ultrafast. BATCH_015–023 verified:2595 distinct pinned files,
445 current inputs,2317 predecessor pins; no active proof job at entry.
`.build/levels_024/PREFLIGHT.json` SHA256
`baa5c4d6a850a2f4ae13977212614c2628678884753468544b46a3859aa994e8`.
Physical shared main, ownership, foreign changes, staging and log checked.
The next source dependency is complete inverse NTT execution and the
all-depth modular write frame, followed by the remaining search closure.
B1.05 Acceptance NOT MET; window IN_PROGRESS.

`KeygenLevelNtt` now binds the complete inverse ternary NTT3143–3245,
including its mixed declaration, all branches, loops and corrective factor.
The modular byte frame applies to forward/inverse/generator execution at
all defined dimensions, without canonical/evaluation premises. Fixed calls
restore caller slots and execute actual bodies; prime struct fields read
real memory. Accepted `_level_ntt_024_001` and `_level_calls_024_001`
(prefix `keygen`), four modules,0/0 logs. The enclosing static table and
search caller remain to be instantiated; no deepest/intermediate claim yet.

`KeygenMakeFgTop` binds the entire make_fg_ternary_top5579–5668 body and
derives preservation of any original material separated from its data/static
objects. It executes memmove, actual prime-member loads, complete generator,
forward/inverse NTT and all stores. Both out_ntt paths are retained.
Accepted `keygen_makefg_top_024_001`, two modules,0/0 logs. This is the
shared ternary-top dependency; make_fg_step/CRT/Bezout remain open.

`KeygenZintLeaves` source-binds seven complete bigint helpers: add, sub,
mul_small, add_mul_small, rshift1, mod_small_unsigned and ucmp. Word reads
inside arithmetic/casts, return control and post-decrement on the failed
test are explicit; derived frames follow actual Store32 destinations.
`keygen_word_language_024_002`, `_zint_leaves_024_001` and the rebuilt word
parser/zint steps of `_resultant_024_001` are clean. Initial nested-list
DecidableEq derivation failed; fixed-arity call syntax resolved it, with
the original failed snapshot retained. No bigint arithmetic correctness
or full deepest execution is claimed.

`KeygenResultantSource` executes complete mod2_res_ternary: b[96] allocation,
literal memset, packing, all switch labels/fallthroughs and actual return.
Disposal restores its private object; all caller bytes are preserved.
`KeygenResultantGate.sampled_material` composes both real gates (including
continue outcomes) with MODE1 two_calls and retains the same f/g Bound1.
`KeygenNormFrame` covers the active7969–7990 raw FFT/FPEMU norm computation
and gate, with its explicit local scratch/static separation and incoming
bound. It uses C99CompareObjects.Exec for the real object-copy comparator.

Two scope corrections are retained: the first NormFrame snapshot covered
binary-only poly_small_sqnorm, so it did not address M0; the next parsed
ternary gate lacked fpr_lt in the generic scalar table. Neither is current
evidence for complete active-gate execution. Final `_active_norm_024_002`
uses the inherited inhabited comparator. `_resultant_024_001` first failed
to compose a byte equality across memset; `_002` explicitly transports it.
All snapshots/raw logs remain, with unchanged limits and no assumed frame.

Final audit `keygen_levels_audit_024_001`:236 entries, all216 new named
declarations plus20 inherited interfaces,206 complete terms and30
inductives/structures with constructor types; standard axioms, no elisions.
459 final inputs; audit SHA256
`c58f8974f6aff9583775aedd804428ab7d4f20f64bbba5ed056af6185e20d5c5`.
`keygen_levels_checks_024_002` passed14 normal/UBSan runs, each with35
bigint cases,38 NTT dimension/stride cases,5 GF(2) resultant pairs,10 exact
ZZ ternary-top norm pairs and15 raw-norm gate/frame cases. Six mutations
detected in both modes. Its first failed build retained a C harness
misleading-indentation warning; braces fixed it without suppressing warnings.
No owned job remains. Preparing BATCH_024's recoverable checkpoint;
full deepest/intermediate/root/GS/public transport remain open.

## B1.05 — CLOSED at complete depth0/search-frame midpoint — 2026-10-08

**B1.05 Acceptance NOT MET.** Complete local `solve_NTRU_ternary_depth0`
execution now derives f/g byte preservation and int32 return1. Its composition
with the actual F/G gate derives Bounds2047 and passes the same four vectors
to exact NTRU/retained-material validation. **Deepest/intermediate, full root
caller and sampled f/g transport through all preceding gates/search remain
open.** The incoming f/g Bounds1 and inherited caller/Validation seams are
explicit; no arbitrary callee, frame or source-completeness premise fills them.

BATCH_023 JSON `b39218519e349795bad183b6ccc234c89c1aa11c7102d2ff57005a0344274a95`;
notes `d21ed7413e216eaee69afdbae2abdfc621ec3e04203491328c067af707859592`.
12 current accepted Lean modules,180 complete audit entries,445 final inputs
and2317 predecessor file pins verified at sealing;0/0 current logs, maximum
accepted cumulative RSS5251876KiB.19 attempts:7 wholly accepted,11 failed and
one non-proof lexer diagnostic, all retained.14 normal/UBSan controls ×7 exact
ZZ public cases; all six mutations detected in both modes.

Source commits `409c3ae9`, `633c6200`, `f8195a0c`, plus final documentation
commit; main as niirmataa under archive.lock with exact owned paths.
Postseal verified2595 distinct file pins and445 current inputs, no active
job: `.build/search_023/POSTSEAL.json` SHA256
`3b5680be3317752ba8910996adf1d84e08bcb771cf63ce394d2eb4fd03da152e`.
No owned job or unresolved Lean draft remains. Expanded
`notes/run/KEYGEN_RESIDUE_CHECKPOINT.md` section6 is the resume entry.
**CLOSED_AT_RECOVERABLE_MIDPOINT**; next window resumes B1.05. B1.06 was not
entered. No push, review, import, migration, subagent or relay.

## B1.05 — search continuation — 2026-10-08

Owner resumed checkpoint section6 for another BIG recoverable midpoint.
GPT-6 Astra Ultrafast verified BATCH_015–022,2317 distinct pinned files,
433 current inputs and1840 predecessor pins; all45 BATCH_022 attempts remain.
`.build/search_023/PREFLIGHT.json` SHA256
`c43284c6a1d1f0672eb6f2ed54bab2be7b18d2c60c7d53ffc2a6fa51e6393e1d`.
Shared physical main, foreign changes/staging and ownership checked; no live
proof job at entry. Source3 remains the active lane.

`KeygenSearchFft` adds complete source-parsed iFFT3, polynomial multiply and
inverse-norm bodies to the fixed FFT procedure closure, with kernel-checked
closed write footprints. Execution uses actual FPEMU word callees and source
tables. This supplies operational/frame dependencies of ternary_depth0; it
is not a real-arithmetic FFT theorem or full solver execution. Accepted job
`keygen_search_fft_023_002`,0/0 logs. The first monolithic inherited audit
exceeded the unchanged kernel memory budget; separate checked declarations
resolved it. The failed source snapshot and raw streams are retained.
B1.05 Acceptance remains NOT_MET. Window IN_PROGRESS.

The search memory layer now executes the full align_fpr scaffold, including
byte-pointer casts/subtraction, uint64 remainder and k/km branch, followed
by the real return cast. It derives the write frame for overlapping memmove
from pre-call bytes. The full poly_small_to_fp body and FPEMU fpr_rint body
are source-bound; no real-rounding premise is used. The typed LP64 context
reads logn/ternary/tmp bytes at offsets0/4/432 and checks its pointer encoding.
`KeygenSearchExec`/`KeygenSearchFrame` supply fixed operational rules and
syntax-checked preservation for the extra search constructs. Accepted current
dependencies: `_leaves_023_002`, `_exec_023_002` and `_parser_023_001`
(only the accepted steps of each job), prefix `keygen_search`.
The remainder lexer refusal is retained as a checked fact in
`KeygenSearchProbe`; its initial `none` diagnostic is historical, not a
current proof log. Final sources have no diagnostic output.

`KeygenDepth0Source` now covers the COMPLETE7051–7273 ternary_depth0
function:218 body lines, five parsed pieces sharing state, checked local
FPC_MUL definition/undef, real member reads, alignment/casts, memmove,
small-to-fpr, FFT/iFFT and final rint/stores. `KeygenDepth0Call.frame` and
`material` derive f/g byte preservation from that execution and legal
scratch/static-object separation. `call_gate_validated` consumes the actual
output gate and derives F/G Bound2047 before inherited exact NTRU validation.
Incoming f/g representations/bounds, typed caller/globals and Validation
bindings remain explicit: deepest/intermediate and full root transport are
still missing. `KeygenDepth0Return.return_one` derives int32 return1 from
the same completed call, rather than assuming its success.

Accepted `_depth0_source_023_002` (source step), `_depth0_call_023_002` and
`_depth0_return_023_003`, prefix `keygen`, all0/0 current logs.
`keygen_search_checks_023_001`:14 normal/UBSan runs, each with seven public
constant-f/g fixtures and independent exact ZZ P(X^3) outputs. All six
mutations detected in both modes, including input corruption, G alias/store/
rounding errors and the 2048 output gate. Full C context layout and retained
arrays/context fields checked. These controls do not execute the missing
deepest/intermediate calls or supply a compiler/probability theorem.

## B1.05 — CLOSED at sampler/refill and validation midpoint — 2026-10-07

**B1.05 Acceptance NOT MET.** The complete local MODE1 loops and real SHAKE
refill now give Bound1 for the whole1536-coefficient material; both calls
retain f/g on the same final heap. The actual F/G gate derives Bound2047 and
connects to BATCH_020's exact NTRU/retained-material validation. **Full active
solver/search/root-caller execution and sampled f/g transport through that
code remain open**, including concrete context/member/global/profile binds.
No arbitrary transition/frame replaces that gap. Next owner window resumes
B1.05; B1.06 has not been entered.

BATCH_022 JSON `e891df0f07b936c594130ec258afc31e2d18a0af1d30b63833d2b1b1481a52a8`;
notes `89d81f521e582421c8c62ad7f9f5fc140772f3b4fae8f5dd34cde252868196c3`.
18 current accepted modules,423 complete audit entries,433 current inputs
and1840 predecessor pins verified at sealing;0/0 accepted logs, maximum
accepted RSS3850748KiB.45 attempts:21 wholly accepted,23 failed and one
preflight refusal without receipt, all retained.14 normal/UBSan controls,
8 independent ZZ Keccak cases and24 two-call sampler cases each; six
mutations detected in both modes. Source commits `7a1d5bc2`, `e617e098`,
`9f0e5ef8`, plus final documentation commit. No owned job or unresolved
Lean draft remains. Expanded `notes/run/KEYGEN_RESIDUE_CHECKPOINT.md` §6
is the resume entry. **CLOSED_AT_RECOVERABLE_MIDPOINT**, as requested for
the BIG stage. No push, independent review, import, migration or new worker.
Postseal:2317 distinct pinned files and433 current inputs match, no active
job; `.build/execution_022/POSTSEAL.json` SHA256
`98f8b5df9acd2d8bd24a80d9cdb7d14e376e5d58de71c8ce6aa65341e016bf17`.

## B1.05 — execution continuation — 2026-10-07

Owner resumed section6 with GPT-6 Astra Ultrafast. BATCH_015–021 and1840
distinct files,415 current inputs and1594 predecessor pins verified.
`.build/execution_022/PREFLIGHT.json` SHA256
`5947df262145b87a5cbb2c8ccbf79b6a7b2938965c13bb255dd40771be0fa3fc`.
Shared main, staging and ownership checked; no live proof job at entry.

`KeygenOutputGateSource` parses the actual7342–7346 short-circuit gate,
including fk->tmp, fk->tmp+n and fk->ternary. Fixed calls execute the full
small-output body. `KeygenOutputGateBounds` derives both successful Bind
environments, source indices0/1536, F/G bounded write traces and same-byte
Bound2047 material, preserving disjoint f/g through both calls. The typed
read-only Context and caller logn/n/F/G bindings are local entry premises;
the enclosing full solver must derive them. No full solver claim is made.
Accepted jobs `keygen_output_gate_source_022_002` and
`keygen_output_gate_bounds_022_002`,0/0 logs. Two failed attempts retained.
B1.05 Acceptance NOT MET; full search execution, sampler/refill and final
same-material composition remain open. Window IN_PROGRESS.

The deterministic refill closure is now source-bound locally:
`ShakeBlock`/`ShakeBlockProgram` execute the complete process_block body
and preserve memory outside A;49 checked chunks retain all388 physical
loop-body lines. `ShakeEncode` executes all eight actual byte stores.
`ShakeExtractSource`/`ShakeExtractBinding` retain the complete extraction
loop, cursor/length updates, complemented lanes, memcpy and final dptr write.
`ShakeRcBinding` binds all24 constant words in12 kernel-checked pairs.
`ShakeExtractFrame` derives a protected-object frame from actual pointer
provenance and those closed calls. `KeygenRngSource` supplies the M0 LE
get_rng_u64 path with a fresh local8-byte object, actual extract8, Load64
and teardown; it preserves other live objects and caller slots. Latest jobs:
`keygen_shake_rc_binding_022_004`, `keygen_shake_extract_frame_022_003`,
`keygen_rng_source_022_001`, all clean. The concrete caller fk->rng binding
and sampler loops remain next. The LP64 typed context layout is explicit.

Failed monolithic source reductions and aggregate RC reductions exhausted
the existing recursion/memory budgets; limits stayed unchanged. Source
chunk equalities and small source/token/initializer equalities composed by
congrArg resolved those failures. Raw failed jobs and snapshots are retained,
including one stale-cache preflight refusal without a receipt. No source
oracle, probability premise or independent review was introduced.

`KeygenSamplerBounds.source_material` now proves Bound1 for the complete
finite MODE1 execution, including both loops, all rejected draws, actual
refills and1536 stores. The write trace permits RNG-memory changes between
stores and proves retention of every earlier coefficient. Entry premises:
the typed rng Layout, n1536, actual destination binding/width, a live output
object and separation from the context object. No random-word or Bound1
premise occurs. `KeygenSamplerCalls.two_calls` binds n/v parameters and
derives same-final-heap f/g vectors with Bound1, preserving f through g.
The concrete fk pointer-to-Layout resolution remains the enclosing caller's
obligation; this is not yet the entire KeyGen attempt.

`KeygenOutputGateValidation.gate_validated` now feeds the actual short-circuit
F/G gate into BATCH_020. F/G bounds are derived; the final exact integer NTRU
equation and retained four-array material follow. Its explicit local inputs
still include incoming f/g Represents/Bound1, the typed caller fields, legal
validation entry and executed source fragments on the same heaps. The missing
search/caller derivation must transport the sampled f/g into this suffix;
there is no arbitrary search relation or assumed search frame in its place.

Accepted sampler jobs `keygen_sampler_{source,inner,bounds}_022_002`,
`keygen_sampler_{frame,calls}_022_001` and
`keygen_output_gate_validation_022_001`, all0/0 logs. Internal audit
`keygen_execution_audit_022_001`:423 entries (all409 new named declarations
and14 inherited interfaces),393 full terms/30 inductives, standard axioms
only, no elisions;433 final inputs. Audit SHA256
`6a28556d3881f75e3a2f5ba6d9642f1a2aed4e95bf13d64cfb0256da3d7ef878`.
`keygen_sampler_checks_022_002`:14 normal/UBSan executions,8 independent
ZZ/FIPS202 Keccak cases and24 two-call sampler cases each; six mutations
detected in both modes. Actual pinned full falcon_keygen struct, context
offsets, public SHAKE fixtures, counters and protected fields/arrays checked.
Sage's `~ZZ` denotes inversion, so the failed first control used the wrong
operator; the retained correction uses mask xor for a64-bit complement.
No owned job remains. Preparing the requested BIG recoverable midpoint;
B1.05 Acceptance NOT MET and B1.06 not entered.

## B1.05 — CLOSED at recoverable source-bounds midpoint — 2026-10-07

**B1.05 Acceptance NOT MET.** Complete parsed poly_big_to_small now yields
same-byte Represents/Bound2047; source MODE1 post-refill stores yield bound1.
Full solver/caller execution and full sampler/refill/f-g material remain
open. The existing BATCH_020 validation theorem still requires their bounds
and actual caller bindings. Graph census99/92/6 is inventory, not a proof
of full operational coverage. Next owner window resumes B1.05.

BATCH_021 JSON `ed560886f8cacfe513cea222b46552cf3abc717a1232172a1da197753393395a`;
notes `a08b583aae3dc02996e21717eeab54085470b662b4854eb2dc5fa250b0701b55`.
Six accepted new modules,107 complete audit entries,415 current inputs and
1594 predecessor pins verified at sealing;0/0 accepted logs.18 attempts,
9 failed, all retained. Source commits `f17fe9b2`, `8b55f52f`, `20d4e524`,
plus final documentation commit. No owned job or unresolved Lean draft.
Expanded `notes/run/KEYGEN_RESIDUE_CHECKPOINT.md` section6 is the resume
entry. Window CLOSED_AT_RECOVERABLE_MIDPOINT; no push/review/import/migration.

## B1.05 — source bounds continuation — 2026-10-07

Owner resumed section6 in source3, GPT-6 Astra Ultrafast. Preflight verified
BATCH_015–020,1594 distinct files, all409 final BATCH_020 inputs and1336
predecessor pins. `.build/bounds_021/PREFLIGHT.json` SHA256
`f5826bbb7d8b277751330e6edb717b2a0d9419b653168a46a115ec5c06347303`.
No proof job was active. Shared main and the foreign working changes were checked.

First checked step: `KeygenSmallSource`, complete parsed poly_big_to_small
body, explicit int16 stores, and a fixed zint_one_to_plain callee executing
its parsed load/update prefix and signed32 local-object byte read. No range
postcondition occurs in the execution rules. Accepted job
`keygen_small_source_021_007`,0/0 logs. Six failed attempts (including an
unavailable optional tactic import and parser diagnostics) remain in .build;
the checked proof uses the existing byte round-trip export. Remaining:
derive the bounds from these executions, the full sampler/caller bindings
and full solver graph. B1.05 Acceptance NOT MET; window IN_PROGRESS.

`KeygenSmallStep` extracts signed guard results and actual accepted stores;
`KeygenSmallBounds.source_material` now derives Represents and Bound2047
from the complete parsed function execution, M0 logn10/ter1 and destination
binding/width. n1536, counter initialization/increments, all1536 writes and
return control are derived. `KeygenSmallCalls.bound_call` adds actual Bind
and nonzero-return conversion; its two-output/frame exports retain F through
G conversion. Accepted `_small_step_021_002`, `_small_bounds_021_002`,
`_small_calls_021_001` (prefix `keygen`), all0/0 logs. Actual enclosing
struct-member arguments and source short-circuit gate remain open.

`KeygenTernaryStore.accepted_store` now covers the actual MODE1 post-refill
draw/shift/decrement/guard/store/break tail, returning the Store16 witness
and Bound1 scalar facts. Rejected draws preserve the heap. Full refill,
SHAKE body binding and outer/inner-loop material composition remain open.
Accepted `_ternary_store_021_001`,0/0 logs. Internal `_small_audit_021_001`:
107 entries including all98 new declarations,97 full terms/10 inductives,
standard axioms only, no elisions, all415 current inputs bound. Audit SHA256
`1cb4f42e0da7ff629f0832c529c071a69c68efdc5a3116f47ad6dd36b3384825`.

`keygen_small_checks_021_001`:14 normal/UBSan executions,36 small-output
edge cases and24 two-call sampler cases each; six mutations detected in both
modes. Real pinned shake.c, public fixture labels, exact ZZ reference;
no private KeyGen or probability claim. `_solver_graph_021_003`:99-node
unpruned/92-node top-M0-selected solver census and6-node real sampler graph.
See `notes/run/KEYGEN_SOLVER_GRAPH_021.md`; census does not prove operational
coverage. No owned job remains; preparing the recoverable BATCH_021 midpoint.

## B1.05 — CLOSED at recoverable validation midpoint — 2026-10-07

`KeygenSolverValidation.generated_converted_checked` now composes the
source table generator, coefficient conversion, the four actual NTT calls
and target/check through common heaps. It concludes the exact integer NTRU
equation AND preservation of the same original four16-bit material arrays
in the final memory. Canonical inputs, initialized gm, NTT Images, final
check bindings and modular residual are derived rather than new premises.
Original `Bounds(1,1,2047,2047)`, legal/source entry and caller bindings
remain explicit. **B1.05 Acceptance NOT met**: the enclosing full solver
graph, source sampler/small-output bounds and their common caller remain open.

Latest accepted closure: `keygen_solver_audit_020_005`, six affected modules
rebuilt with0/0 logs; unchanged Equation module remains `_equation_020_003`.
Internal audit:88 exports, all69 new declarations included,85 complete flat
terms and3 inductives/structures with constructor types, standard axioms
only, zero elisions. Audit SHA256
`c7d037950b751c0287e9dbd15a189aadaa9ef133bf9ea66a862ef424ddbd6abc`;
receipt `fa26d87d7c85dd5e7d45773dd4a2ea0f36f0fba3523b2f3f828ce67cf1538674`.
The first audit rejected a truncated binding proof; the second rejected
metadata unsupported by the inherited lossless DAG exporter. A direct
conversion-identity proof replaced the bulky simplification without changing
the theorem statement. All affected descendants were rebuilt. Failures remain.

`keygen_solver_checks_020_001`: Sage standard preparser, exact QQ inverse
and ZZ quotient checks generated a public synthetic valid NTRU fixture
(maxima f/g/F/G=1/1/41/168).14 normal/UBSan runs ×6 cases passed; six
mutations detected in both modes. Material, gm and scratch guards preserved.
The large-G case passes validation but fails the actual small-output gate,
showing why validation success is distinct from the complete solver path.
Controls SHA256 `2e69ed931116fcc622ae9c006502d2594ece9e77ea2d94eb7093314bf1223d28`.
This is finite supporting evidence, not the missing universal bounds proof.

No owned job or unresolved Lean draft remains.19 new attempts include10
failures and one interrupted outer-shell launch; raw logs/snapshots retained.
**Window CLOSED_AT_RECOVERABLE_MIDPOINT** under staged-roadmap rule3.
Expanded `notes/run/KEYGEN_RESIDUE_CHECKPOINT.md` section6 is the resume entry.
BATCH_020 JSON `6b8a839151d8d174eb1b6a8b09e1b2f02a8f6c20b8c9055d40e687e951602dff`;
notes `b402d5035667835182f539ed8ee8a812ad00a75687bd0662950373a098e26c6d`.
At sealing409 current final-audit inputs and1336 predecessor files matched;
all7 modules have accepted current bindings, max RSS3004140KiB. Source
commits: `b4c2e87f`, `e92271d2`, `ed98536b`, plus final documentation commit.
**B1.05 Acceptance remains NOT MET**; resume the missing source bounds and
complete active solver/caller graph. B1.06 not entered. No push/review/import.

External Git observation after sealing: during final documentation checks,
origin/main had advanced to `ed98536b41de7c1d18455d5e482d622a259dcdb4`.
Its reflog records `update by push` at2026-10-07T17:17:31Z. This worker
issued no push command; the observation is recorded separately from the
local checkpoint operations above.

## B1.05 — source solver composition in progress — 2026-10-07

Owner assigned B1.05 only, under the staged-roadmap window discipline.
Harness: GPT-6 Astra Ultrafast. Resume section6 verified BATCH_015–019,
1336 distinct files and all402 final BATCH_019 audit inputs; no active job.
Preflight `.build/solver_020/PREFLIGHT.json`, SHA256
`5f0e6d6e1829fd93b5a4c0e1b728351e16b731bec9b0bfec68baa06bf187501a`.

`KeygenSolverEquation` now connects the SAME loaded words of the successful
parsed final check to the four NTT Images, derives the coefficient equation
over ZMod2147355649, and applies the existing integer lift. Images and
Bounds remain explicit local inputs pending the enclosing source composition.
This is not B1.05 Acceptance or a complete solve_NTRU theorem.
Accepted `keygen_solver_equation_020_003`,0/0 logs. Initial shell timeout
before a receipt and the subsequent two elaboration errors are retained in
the distinct `_001`/`_002` job directories. Runner limits are unchanged;
subsequent shell waits have no outer timeout. No owned proof job is live.
`KeygenSolverNttCalls` binds the four parsed call statements, the stride1
macro and actual parameter environments to the complete NTT body. Its fixed
execution stratum has no callee oracle or mathematical postconditions.
`KeygenSolverTransforms` composes all four calls on common heaps, preserving
both previous Images and the exact canonical words of later input arrays.
`KeygenSolverTarget` derives the actual Montgomery target call (including
signed literal to uint32 parameter conversion), check pointer/local bindings
and the integer equation. Accepted `_calls_020_002`, `_transforms_020_001`,
`_target_020_003` (prefix `keygen_solver`), all0/0 logs.

`KeygenNttMemoryFrame` separately derives arbitrary outside-scratch byte
preservation from pointer provenance and actual stores. It transports
the original16-bit material representation without a canonical-cell premise.
Accepted `keygen_ntt_memory_frame_020_002`,0/0 logs; first elaboration failure
retained. The four-transform theorem still takes converted inputs, table
and Bounds locally; next is the preceding-generation/conversion composition,
sampler/conversion bounds and complete active solver call graph. No job live.
Small exact-path local commits use
the shared writer lock; package remains IN_PROGRESS / NOT_REVIEWED.

## B1.04 — ACCEPTANCE / complete source NTT — 2026-10-07

**Window CLOSED AT ACCEPTANCE / PROVED_KERNEL_SCOPED.** Enclosing package:
PARTIAL_PROOF / IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.
Recovery entry: `notes/run/KEYGEN_RESIDUE_CHECKPOINT.md` section6.

Owner resumed section6 with GPT-6 Astra Ultrafast. BATCH_015–018 pairs,
their pinned evidence and all393 final-audit inputs match:1204 distinct
file checks, no active proof job. Preflight:
`.build/ntt_composition_019/PREFLIGHT.json`, SHA256
`37dfa7eff55c01b8fa269825943301b1d114d52f4f8275956d3b22467647dda1`.

`KeygenNttControl` derives normal flow and scalar/pointer frames, including
the actual block-local restoration. `KeygenNttMiddleValues.inner_values`
re-inverts the declarations, gm[m+u1] read, both pointer binds and vLoop;
`u1_values`, `round_values` and `intermediate_values` compose every block
and all eight source m rounds. Canonical cells, the source-ordered array
`rounds a 8`, preserved initialized gm and the disjoint-cell frame are
conclusions about the same heaps. No nested-trace heap equality is assumed.
Accepted `keygen_ntt_control_019_004` / `keygen_ntt_middle_values_019_003`,
both0/0 logs; earlier elaboration failures retained. Middle-values source
`ee0942b2cf5a61ff98e810795a60329c3551939a1fda2265b94e0ceaa0638e1c`,
receipt `7a883437489bf0bb6298861d12f808a84574252e27035b334482f265431c56e1`.

`KeygenNttTripleValues` now derives wSquared from the two actual gm[1]
reads/Montgomery call and composes all512 executed triples. Each output is
the corresponding quadratic evaluation in physical source order; gm and
disjoint cells survive. `KeygenNttExecution.source_values` splits the
existing parsed forwardBody into the four actual passes through common
States, derives all required local slots and concludes canonical cells
equal to the complete source-ordered butterfly array `transform a`.
Accepted `keygen_ntt_triple_values_019_003` and `keygen_ntt_execution_019_001`
with0/0 logs. Source pins `3b363707…` / `32a89307…`; receipts
`d9d2418f34a2daadcc8a7f728a9523f24e09d64e7406663b72898de15af15e3c` /
`8bf082c1597a361b990f3943c724713d2be7cc5a59399b36f2f0bf2536c3781f`.

`KeygenNttTwiddleCert` now checks all512 bounded parent candidates in32
kernel chunks;510 non-top parents have the exact odd-child signed laws.
Sage generation is byte-identical to the tracked certificate.
`KeygenNttTwiddleTree` proves the field laws, h^2304=-1, the separate top
complement and final cube transports. `KeygenNttRoundPolynomial` proves
every sequential block's polynomial identity and propagates evaluation
of the original CoefficientQuotient polynomial through all eight rounds.

**B1.04 proof Acceptance is met.**
`KeygenNttTransform.source_transform` concludes all1536 canonical physical
output words equal to the original Vec polynomial evaluations.
`generated_converted_transform` consumes table generation, actual conversion
and the complete forwardBody, deriving canonical inputs and gm from those
source executions. Legal caller memory, original bounded material, source
execution and cross-call scalar/pointer/heap bindings remain explicit.
No transform evaluation, initialized-table or canonical-result premise is
present in that final composition. Full solver/caller/codec/fiber remains
later work; the NTT frame preserves disjoint canonical32-bit cells, not yet
an arbitrary16-bit original-material byte-frame theorem.

Accepted `keygen_ntt_transform_019_001` / `_transform_audit_019_002`,0/0 logs.
Internal audit:131 entries,128 complete terms and3 kernel structures with
constructor types, standard axioms only, zero elisions. Audit SHA256
`b0c28ef18d7adac420967897725867f5e8bc59ab980f0500b4c16558d68e50de`.
Final transform source `0f60483e60ec1f37664d8fc788894144e8cc7e96f504845f786c4c4ec4f3d68a`.
The unchanged prime-proof DAG and prior finite C controls remain BATCH_018
dependencies. No full-project replay was repeated. Small local commits use
the shared writer lock; no owned proof job is live. B1.05 has not been entered.

BATCH_019 JSON `983a481a10293c01bf80250a9dd4ad2797e351db0a3c5d41825845d80fde6098`;
notes `289d85f0ec1f25fe5950ad6b182363afe9ede0484c3053cf0c915d9cd52b1c01`.
At sealing all402 final-audit inputs,9 accepted module bindings and1204
predecessor file pins matched.19 attempts/8 failures retained; maximum
accepted new-module RSS2864452KiB. Proof commits: `e58e2a51`, `6e6b98d0`,
`7665543b`. Fresh expanded checkpoint and this pair have a final local
documentation commit. Next owner stage: B1.05, source solver success to
the exact integer NTRU equation. No push, independent review or import.

## B1.04 — recoverable midpoint, first pass and radix-2 blocks — 2026-10-07

Owner-scoped B1.04 window, GPT-6 Astra Ultrafast. B1.03 Acceptance is
recorded by `0a72596b` in `run2/notes/B4_SYNTHESIS.md`. Resume preflight
verified the BATCH_015/016/017 pairs, their module/evidence pins and all
382 current inputs of `keygen_mkgm3_contract_002`: 1031 distinct file checks,
no active proof job. `.build/ntt_values_018/PREFLIGHT.json`, SHA256
`cffb1bdd4684ffe06da48b4bf98d1c6c83ade8faf1879eef786de83ac88cc18f`.
The checkpoint's resume protocol is now section 5 (formerly section 6).

`KeygenNttCells` now derives canonical ordinary-residue cells, the exact
first/binary/triple formulas in physical store order, and preservation of
disjoint cells from the existing source butterfly executions. Accepted
`keygen_ntt_cells_002` (1.568s, 0/0 logs); the first failed elaboration is
retained. Twiddle values/ranges and input cells are explicit local inputs,
to be supplied by table/conversion and pass invariants.

`KeygenNttFirstValues.pass_values` now consumes the actual `gm[1]` read
and all 768 executed butterflies, concluding canonical cells in the low
and high physical halves and a disjoint-cell frame. `KeygenNttPolynomial`
transports the conversion's original Vec representation into these cells,
proves the exact two degree-<768 polynomial remainders, and checks the
source root relation `w^2-w+1=0` and the corresponding factorization of Phi.
Accepted `keygen_ntt_first_values_003` and `keygen_ntt_polynomial_007`,
both with 0/0 logs. Input material/table interfaces remain explicit until
the caller composition consumes the preceding source executions.

`KeygenNttFirstComposition.generated_converted_prefix` consumes the table
generator, actual coefficient conversion, NTT prologue and first-pass
executions, retaining the same original Vec and preserving gm. Canonical
entry cells and initialized gm are derived from preceding source executions;
same-Vec first-pass cells/remainders and gm preservation are conclusions.
Checked `keygen_ntt_first_composition_002` (0/0 logs).

`KeygenNttGeometry` checks `t*m=1536` at headers 0..8, the distinct
`ht*m=768` update seam, all binary-cell/twiddle bounds and source exit
`m=512,t=3` (`keygen_ntt_geometry_002`). `KeygenNttRoots` proves primality,
the exact physical triple point formula from row9/REV10, 1536 distinct
roots of Phi and degree-<1536 polynomial/coefficient injectivity
(`keygen_ntt_roots_003`). Both have clean 0/0 logs. These mathematical
points still require the complete source-transform evaluation refinement.

`KeygenNttBinaryValues.loop_values` and
`KeygenNttSubpolynomial.source_remainders` now consume the complete actual
radix-2 v-loop, returning canonical memory cells and the two exact
degree-<ht remainders, with the remaining cells preserved. The actual
`gm[m+u1]` load has a scaled-value export. Checked `binary_values_001` and
`subpolynomial_002`. `KeygenNttEvaluation.equation_of_pointwise` transports
pointwise equalities through the existing quotient multiply/subtract into
the coefficient equation over ZMod2147355649; source pointwise equations
and the integer lift still need the remaining transform/solver composition.

Final internal audit `keygen_ntt_values_audit_005`: **85 exports**, 81 full
pretty-printed terms, 3 kernel structures with complete constructor types,
and the full prime-proof DAG (277341 nodes) with serialized JSON/Expr.equal
round-trip. Flat printing that shared term exhausted memory in two retained
attempts; the DAG retains every node without changing limits. All11 current
modules have accepted source/artifact bindings and 0/0 logs. Sage/C
`keygen_ntt_values_checks_002` checks first/eight middle/final snapshots of
three public arrays, direct polynomial evaluation at all1536 physical
points, normal/UBSan and six detected mutations in each mode (14 runs).

**Window CLOSED at a recoverable midpoint under staged-roadmap rule3.
B1.04 Acceptance is NOT met.** No owned job or unresolved Lean draft
remains. Next window resumes B1.04 at u1Inner/u1/m memory/value composition,
twiddle-child polynomial propagation, all512 triple iterations and the
complete source-transform theorem. The expanded checkpoint section6 is
the resume protocol; BATCH_018 is the new evidence pair. `t*m=n` occurs
only in this stage's new geometry module. Local exact-path commits use
the shared writer lock. Status: IN_PROGRESS / NOT_REVIEWED /
WORKING_NOT_FROZEN; no review, stage import or publication.

BATCH_018 JSON `f4e28b724e588b7e91cdb429646dfefe5939332f307f0ae15dc282369edc72cf`;
notes `c19d5c9cb893793dd6ff23fa232271fcfe704f0821160de1a1e2065551bd546d`.
All393 current final-audit inputs matched at sealing;29 attempts/17 failed
retained. Proof commits: `bb2ca842`, `cd23c3f1`, `6f7cde92`, `1a9f4ef3`.

## B1.03 stage (c) — source row laws CLOSED — 2026-10-06

**KEYGEN_SOURCE_TO_FIBER_001 IN_PROGRESS / NOT_REVIEWED / WORKING_NOT_FROZEN.**
The owner-scoped (c) implementation is complete. `KeygenMkgm3.source_contract`
and `parsed_contract` derive every initialized gm word's canonical range,
explicit Montgomery factor and exact root order from the complete existing
source execution. The 1024-entry certificate covers physical indices;
source generator conversion consumes BATCH_016, REV10 consumes BATCH_015.
All three row loops and the final gm[0]=gm[1] copy are composed.

`source_then_overwrite` preserves the same gm table and original four-Vec
material through the actual igm=ft coefficient-conversion overwrite.
Caller aliases, the 7168-word/28672-byte required extent, 4096-byte table
extents, all pairwise output/table separations, original-object footprint
and read-only REV10 discipline have checked exports. Entry is legal caller
memory, M0 scalar/pointer bindings, static REV10 bytes and the executed
p0i initializer; the enclosing allocator/call-frame remains B1.07.

Final contract and audit job: `keygen_mkgm3_contract_002`, both modules
accepted with 0/0 logs. Audit: **57 definitions/exports, complete types and
terms, zero elisions, standard axioms only**. All 18 new modules have
matching accepted source/artifact/receipt bindings. This was incremental
dependency-ordered checking, not a new whole-project replay.
`keygen_mkgm3_checks_002`: normal/UBSan baselines agree on all 1024 words
before and after overwrite; six mutations detected in both modes (14
executions), original synthetic material and scratch guards preserved.

Source commits: `9c9f75fe`, `8e132c16`, `fa938836`, plus the final assembly
commit identified in BATCH_017. The BATCH_017 pair and expanded checkpoint
carry the final pins, retained failures and exact premise boundary.
**No owned job remains; the (c) window closes here. Next owner step:
Acceptance B1.03.** B1.04 and t*m=n were not entered. No independent review,
stage import, owner acceptance or push is implied.

## B1.03 stage (c) — row laws and layout in progress — 2026-10-06

Owner-scoped window: stage (c) only; BATCH_015/016 and 364 current inputs
of the final R2 audit match. Preflight: `.build/mkgm3_rows_017/PREFLIGHT.json`
(`40445fdd9597426d93a942030f6f6e2abe6a8cf5e1ca415933d9529e3af125c6`).
Harness: GPT-6 Astra Ultrafast; runner labels remain historical.

First checked components: `KeygenMkgm3Rows` (job `keygen_mkgm3_rows_004`)
transports the earlier generator certificates into actual ZMod orders
9216/4608 and proves scaled product/square/cube and last-pair laws from
source calls, with the initial root conversion consuming BATCH_016.
`KeygenMkgm3Layout` (job `keygen_mkgm3_layout_004`) binds and executes the
four caller pointer aliases, derives the 7168-word/28672-byte required
extent, table/output separation and preservation of gm and original input
bytes through the actual coefficient-conversion loop (`igm=ft`). Both
jobs have clean 0/0 logs. The allocation predicate is legal caller memory,
not a proof of the enclosing allocator; B1.07 supplies that caller frame.

Second checked step: the generated 64x16 kernel certificate covers all
1024 physical exponents, exact row orders and REV10 address permutation.
Jobs `keygen_mkgm3_indices_002`, `table_002`, `control_002`, `atoms_004`,
`upward_004` and `revmem_002` (the latter five share prefix
`keygen_mkgm3_`) are accepted with 0/0 logs. `cube_body` and `square_body`
derive their row updates from the actual parsed bodies, including reads,
nested calls and preservation across the inverse-table store. The read-only
REV10 memory predicate is tied to BATCH_015's parsed data and transported
through actual primitive memory transitions. Generator/checker:
`sage/generate_keygen_row_certificate.sage`, accepted `_index_gen_002`;
the first run's JSON serialization failure is retained.

Third checked step: `LastRow`, `Counters`, `Loops`, `Prelude` and `RowInit`
(all with prefix `KeygenMkgm3`) close the source last-pair writes, all three
loop invariants and counters, the once-squared source generator initialization,
and the complete last-row branch. Latest job `keygen_mkgm3_rowinit_002`
checks RowInit; `_rowinit_001` checked the changed Loops/Prelude closure.
All current artifacts and sources matched at the interruption/resume check;
no proof job remained active. The loop exits retain u=512/512/0 explicitly.

Still in progress: composition through the full-case row, square-loop entry
and top copy, the final initialized table contract and BATCH_017 audit.
The final table theorem is not yet claimed. No review or push.

## B1.03 stage (b) — source modp_R2 value law CLOSED — 2026-10-06

**ACTIVE / KEYGEN_SOURCE_TO_FIBER_001 IN_PROGRESS / NOT_REVIEWED.**
Owner assigned this window exclusively to stage (b), after BATCH_015 and
`keygen_rev10_cert_004`. Harness: GPT-6 Astra Ultrafast
(`openai/gpt-6-astra-ultrafast`); historical runner model/session labels
remain provenance. All 360 current source inputs of the pinned REV10 job
match; the seven changes since `keygen_mkgm3_frontend_011` are the recorded
BATCH_014 repairs. Preflight: `.build/modp_r2_016/PREFLIGHT.json`.

`KeygenModpR2Word`, `KeygenModpR2Exec`, and `KeygenModpR2` now close the
source-call law: canonical `2^62 mod p`, with explicit `R*R` representation,
for every odd `2^30 < p < 2^31` and valid Montgomery inverse. The proof
consumes the declaration, `modp_R`, doubling, all five Montgomery squares,
overflow-free parity halving, assignment and return of the existing parsed
`r2Code`; executions also exist for every parameter pair. The M0 export
`initialized_value_law` derives inverse validity from executed `modp_ninv31`.
`initialized_to_montgomery` exposes the scalar conversion `a -> R*a`.

Accepted jobs: `keygen_modp_r2_word_002` (1.618s), `_exec_004` (14.598s),
`_contract_001` (2.720s), `_audit_005` (1.167s), `_checks_001` (2.521s).
All five have empty stdout/stderr and unchanged proof limits. Internal
audit: 20 definitions/exports with actual types, non-elided proof terms
and only standard axioms; output SHA256
`ab90b96085180b7d1868e405a9456f6b75528d4db491bbc178b8f0ac06af6ade`.
Sage/C finite controls: seven public odd moduli, both halving parities,
normal/UBSan baseline and three detected mutations in both modes.
Retained failures and the superseded truncated audit are recorded in
BATCH_016. Source commits: `b3941188` (generic word law) and `1856d911`
(source composition/exports/audit/controls). The BATCH_016 pair and expanded
`notes/run/KEYGEN_RESIDUE_CHECKPOINT.md` record the final handoff and pins.

No owned job remains running. This owner window closes at stage (b).
Next owner window: **(c) row exponent/order laws and canonical ranges**,
then the planned overwrite/layout obligations. B1.03 as a whole and the
final emitted-to-fiber theorem remain open; no review or publication status
is granted by these source commits.

## B1.03 phase 1 — frontend/callees/REV10/order closed, freeze at mid-point — 2026-10-06

**ACTIVE / KEYGEN_SOURCE_TO_FIBER_001 IN_PROGRESS / NOT_REVIEWED.**
Owner-scoped window (EXCLUSIVELY B1.03) frozen at a staged-roadmap-3
recoverable mid-point (context soft ceiling). CLOSED and green (job
`keygen_mkgm3_frontend_011`, 17/34 accepted/clean): the modular frontend
gains `call5`, `storeRev` (exact `base + REV10[idx]` stores), the
state-exact `while (k ++ < 11)` desugaring and `++`/`--` support; the
non-mutual call strata `LeafCall`/`GenEval`/`GenExec`/`ModCall` (trap 33:
never a `mutual` block — `induction` refuses it); `modp_R` bound with its
`2^31 mod p` value law; **generator order 9216/4608 kernel-CHECKED**
(plan proof obligation, not an assumption); REV10 data model; and
`r2_source_bound` (the hand-built `r2Code` equals the pinned parse).
OPEN at the exact boundary: `div_source_bound` (one statement of `divCode`
differs from the parser output), `KeygenMkgm3Program.source_bound`, the
17 remaining closure modules, the chunked REV10 certificate, and the
whole row-law/Montgomery-scale/memory-layout part of B1.03. Traps 32-39
in `notes/run/KEYGEN_RESIDUE_CHECKPOINT.md`; receipt pair
`KEYGEN_SOURCE_TO_FIBER_001_BATCH_013.*`. No push (owner signal absent).
Next window: continue B1.03 only from the checkpoint section 2.


## 2.1.1-second part 2 closed — B1.02 CLOSED at Acceptance — 2026-10-06

**ACTIVE / KEYGEN_SOURCE_TO_FIBER_001 IN_PROGRESS / NOT_REVIEWED.**
Owner-scoped window (EXCLUSIVELY 2.1.1-bullet2 part 2) closed at the
stage Acceptance (staged-roadmap iron rule 3 clean close).
`KeygenNttMiddleRounds` (new, commit pair this window, job
`keygen_ntt_middle_rounds_002` accepted/clean, 3.071s) proves the u1
counter composition `u1 ↦ j`, `v1 ↦ j*t`, `j ≤ m` (from `u1Step`), the
doubling outer rounds `m ↦ 2^(i+1)`, `t ↦ 768/2^i` with the executed
`t = ht = t >> 1` halving, guards `u1 < m` and `mGuard : t > 1+(full<<1)`
(as `3 < t` on the M0 path), and the derived bounds from the ROUND
COUNT OF THE T HALVING (`3 < 768/2^i ⇒ i ≤ 7 ⇒ m ≤ 2^8`, `t ≤ 768`,
`v1`, `ht ≤ 2^18`) so ONE premise `2^18*σ < 2^64` discharges the two
executed-product fits. `u1_result`/`round_result`/`intermediate_result`
carry the nested v-runs per round. `t*m=n` NOT used (B1.04 boundary).
With 2.1.1 + 2.1.2 closed, **B1.02's Acceptance is fully met**.
Exact obligations/traps 26-31 in `notes/run/KEYGEN_RESIDUE_CHECKPOINT.md`;
receipt pair `KEYGEN_SOURCE_TO_FIBER_001_BATCH_012.*`. No push (owner
signal absent). Next window: **B1.03** only (twiddle-table generation
and memory layout).

## 2.1.2 closed; 2.1.1-second part 1 frozen — 2026-10-02

**ACTIVE / KEYGEN_SOURCE_TO_FIBER_001 IN_PROGRESS / NOT_REVIEWED.**
Owner-scoped window (EXCLUSIVELY 2.1.2 + 2.1.1-second) closed at a
staged-roadmap-3 recoverable mid-point. **2.1.2 CLOSED**:
`KeygenNttButterflyCalls` extracts `FirstCalls`/`BinaryCalls`/
`TripleCalls` from executions of the parsed butterfly bodies with
Load32/Store32 witnesses at the pinned r1/r2/gm positions (commit
`aa86ba27`, job `keygen_ntt_butterfly_calls_009` accepted/clean).
**2.1.1-second PARTIAL**: `KeygenNttMiddleLoops` gives the v-loop trace
and the u1Inner bindPtr-chain positions `r1 = a + v1*stride + v*stride`,
`r2 = r1 + ht*stride + v*stride` (r2 re-derived via htBind) with explicit
non-overflow premises (commit `d81c257c`, job
`keygen_ntt_middle_loops_006` accepted/clean). OPEN in 2.1.1-second: the
u1/m/t counter composition (`u1 ↦ j`, `v1 ↦ j*t`, `m ↦ 2^(i+1)`,
`t ↦ 768/2^i`) and the `2^18` bound derivation (not `t*m=n`). Exact
obligations and traps 19-25 in `notes/run/KEYGEN_RESIDUE_CHECKPOINT.md`;
receipt pair `KEYGEN_SOURCE_TO_FIBER_001_BATCH_011.*`. No push (owner
signal absent). Next window: finish 2.1.1-second part 2 only.

## NTT word adapter and source butterfly bodies — 2026-10-01

`keygen_ntt_frontend_002` passed23/23 clean (59.973s,maxRSS3114516KiB),
including the changed pointer-dereference grammar's complete cached
descendant closure. RECEIPTS SHA256
`2103761326376591a723f89addd92a3fb1e3c6e07bc2d0d5499d55846f78f5d6`;
SOURCE_INPUTS SHA256
`314649f3121a3ffed190f2db9907b71e151c5124c71e155e67e2813fd9eb6f51`.

KeygenNttWordAlgebra derives source addition/subtraction and Montgomery
operations in ZMod2147355649, explicitly retaining/cancelling the radix
factor. KeygenFirstPrime parses the actual first PRIMES3 record. Generator
order and table-generation laws remain open. The three forward butterfly
inner bodies and the stride1 wrapper are parsed in KeygenNttButterflyPrograms;
the full forward function/control and extraction of their primitive-call
observations are still required. The butterfly call-algebra module is a
separate current check; do not promote its call premises to whole-NTT facts.

Save the checked word adapter and grammar/body bindings as separate local
commits. Continue B1.02--B1.04 according to the detailed execution plan.

## Complete remaining plan saved — 2026-10-01

The owner requested a durable implementation plan through the end of B1.
`notes/run/KEYGEN_SOURCE_TO_FIBER_001_EXECUTION_PLAN.md` now records the
checked baseline, B1.01--B1.11, exact source/premise obligations, commit
boundaries, mutations, final artifacts and restart protocol. Proposed names
are explicitly targets, not existing exports. It develops the current T12.1
PLAN and preserves END_TO_END_SCOPE, including the B4/B5 law boundary.

Latest completed source checkpoint: `cdc1edb7` (original Vec preservation
through coefficient conversion), following `0d29f339` (source grammar).
No owned job is running. Next bounded implementation step: B1.01, the NTT
word/field algebra adapter, starting with source addition congruence and
explicit Montgomery representation scale. Save its own local commit after
checking, then continue the source transform rather than stopping at helpers.

## Owner resumed work with recoverable step commits — 2026-10-01

The owner explicitly instructed continuation and commits after logical
steps, so an interrupted run can resume from saved work. Status is again
**ACTIVE / IN_PROGRESS / NOT_REVIEWED**. Keep commits small and local;
publication still requires the separate owner signal. Save the actual
checked/draft status and next command at every checkpoint.

First resumed actions: checkpoint the previously checked modular-memory
extension and coefficient-conversion bridge, then retry the corrected
public Sage helper check as `keygen_modular_suffix_checks_002`. Retain the
failed `_001` job. The next mathematical work is the source NTT range/
evaluation link; the complete caller/attempt/encoding chain is still open.

Completed recovery commit: `0d29f339` records the checked modular-memory
extension and source conversion program. Fourteen current source/cache/log
bindings were rechecked byte-exact before committing. The corrected Sage
job `_002` passed (1.918s); result SHA256
`ed336129760e5178d482150f8f4d34556663b7ac637fa053811867a2ba00327b`,
receipt SHA256 `e8262316089ab4418721d2ea16033a2363189ac8b45391f78dae890c370c866c`.
Both normal/UBSan baselines matched; all four synthetic mutations were
detected in each mode. The separate internal20-export audit passed as
`keygen_residue_audit_017` (1.526s, standard axioms or none); this is not an
independent review or fresh replay of every module. Exact audit/evidence
pins and the resume boundary are in `notes/run/KEYGEN_RESIDUE_CHECKPOINT.md`.

## Budget checkpoint — 2026-10-01

The owner reported a60-percent allowance decrease over roughly90 minutes.
This worker paused further launches to clarify an affordable continuation;
the full B1 task is incomplete. No owned proof job remains running.

Latest committed checkpoints: `49ad5794` (parsed solver-check suffix) and
`ac8c985e` (signed modular conversion and fresh batch008). Subsequent saved,
uncommitted work extends the modular reference with signed16 reads,
modp_set calls and uint32 stores. The changed descendant closure passed15/15
in `keygen_modular_memory_closure_009`. KeygenResidueStore/Trace/Loop/Ranges/
Frame/Material/Vectors all passed individual jobs010--016. They derive
canonical converted words and their relation to the same original Vec
material, under explicit input/output non-aliasing and source entry bindings.
Batch009 and its audit/receipt have not been prepared or claimed.

The public synthetic Sage/C suffix check completed its assertions but job
`keygen_modular_suffix_checks_001` failed when serializing Sage integers to
JSON. Its raw outputs remain retained. The serialization line is corrected
in the saved `.sage` source; no retry has been launched. No new push/review.
Before spending further allowance, agree the next bounded scope with the
owner. NTT polynomial binding, the complete caller/attempt/codec chain,
public/inverse equations and the final emitted-to-fiber theorem remain open.

## Parsed final solver check passed — 2026-10-01

Fresh batch008 passed14/14 clean with20 audits:29.379s,maxRSS2731312KiB.
Receipt SHA256 `64198d2e86af3f48c650cde4868f4db3bad73ae3494233f03a8f70fdd9cf455a`.
KeygenCheckOutcome.accepted now derives the1536-coordinate Loop and the
pointwise modular equations from the entire parsed check suffix, actual
uint32 reads and primitive source calls, plus observed return1. The same
heap/pointers survive the suffix. Expression existence and3 source mutation
rejections also passed. The source modp_set contract now derives canonical
range/congruence; the missing int32_t frontend spelling is handled by an
explicit M0 typedef-token normalization, with the failed raw-parser probe
retained separately.

Source NTT range/evaluation and earlier initializer/entry bindings remain
explicit enclosing obligations. Next is the conversion/NTT source-memory
connection, alongside the still-required full KeyGen attempt/caller and
encoding chain. B1 remains ACTIVE / IN_PROGRESS / NOT_REVIEWED.
Batch007 and its modular sources were saved locally as `6004ad89`; no push
was performed by this worker. Foreign work and publication activity are
preserved. Continue in this same source3 workspace and session.

## Static environment and modular-check continuation — 2026-10-01

The complete FFT square/cubic tables are now parsed in checked32-row
chunks (all3072 pairs), assembled into source words and installed as
read-only memory blocks. CertificateM0Environment fixes the scalar/table
environment and derives its initialized-word predicate. Fresh batch007
passed as `keygen_fiber_batch7_fresh_001`, with the same limits and serial
execution; the receipt details are below.

KeygenM0Preprocess/KeygenMakePreprocess now bind all407 lines of the make
function's conditional-directive selection. The original monolithic proof
exhausted memory;13 source-contiguous pieces and a proved append law passed
in `keygen_attempt_cap_007` (64.456s for the make module). No limits changed.
The actual cap increment/branch, MODE1 scalar bound, modp_add/sub and final
coordinate algebra also passed individual checks. `keygen_final_check_loop_004`
passed the1536-coordinate local check model. The old loop model still needs
its source-control refinement, rather than being assumed by the solver.

The C99ModularReference/Parser and KeygenCheckProgram,
Expression/Gate/Iteration/LoopBridge continuation parses the entire final
solver-check suffix, including uint32 loads, fixed source callees, local z,
comparison, loop control and return. `keygen_check_program_001` waited for
batch007 and then passed the first three modules. The expression/gate/
iteration/loop bridge also passed subsequent jobs. Supporting expression
existence, frame, source mutations and the combined Outcome are in checking.
KeygenModpSet is a separate drafted source conversion/range/congruence lemma.

Batch007 subsequently passed19/19 clean with25 export audits:1334.532s,
maxRSS4893672KiB; receipt SHA256
`6ad9a6b64b5d149bfa3a8c5481549a2b4f4acd3c89fb026dfd3a7110531232c1`.
The parsed check-suffix continuation started with `keygen_check_refinement_002`;
failed elaborations are retained and later jobs advance its checked scope.
These new modules are not covered by batch007. The static environment and
preprocessor/cap sources are local commits `73d42e14` and `f256b438`.

Full B1 remains **ACTIVE / IN_PROGRESS / NOT_REVIEWED**. Pending enclosing
links include source NTT range/evaluation, final-attempt material identity,
all attempt gates/cap, public/inverse computation and both source codecs.
Do not turn the suffix's explicit canonical/input/initializer premises into
premises of the final emitted-to-fiber theorem. Continue after the queued
jobs, retain failures and checkpoint only the owned files locally.

## Certificate composition checked; static tables and KeyGen continue — 2026-10-01

**ACTIVE / KEYGEN_SOURCE_TO_FIBER_001 IN_PROGRESS / NOT_REVIEWED**.
Batch006 passed25/25 clean with25 export audits,83.823s,
maxRSS3821804KiB. Receipt SHA256
`95acae9a82ba554624b33d2a6dd15f231feec9c234b5c0138421ff027b24fcb6`.
`CertificateFunctionOutcome.accepted/reverse_source` compose the full
certificate reference execution, derive suffix Legal and actual pointers,
retain pre-return snapshots, preserve caller bytes outside the workspace,
and forbid reading bad after its extent is removed. This supersedes the
earlier standalone-prefix composition gap in the reference environment.

The environment still carries global scalar/table bindings. Thirteen scalar
constants are source-bound; full static-table parsing/initialization is in
progress. `keygen_fft_table_chunks_004` checks32-row chunks serially without
higher limits. A restricted M0 conditional-directive preprocessor for the
KeyGen body is also drafted. Do not treat these drafts or this internal batch
as the final KeyGen/encoding/NTRU/fiber theorem. Keep waiting for proof slots
and continue the full owner task, without new agents or an automatic review.

The complete signed16 conversion checkpoint is local commit `2c12c0c4`.
New certificate-composition sources and batch006 evidence are being saved
in further local logical commits. Push still requires an explicit signal.

## Active source entry and signed16 conversion work — 2026-10-01

The source prologue7695--7702, inner declarations7705--7708 and all eight
aliases7709--7716 now have kernel source bindings and execution/result
theorems. The current prologue/declaration consumer uses an explicit scalar
entry environment; general call-entry composition is still being completed.

C99ArrayReference now has a typed16-bit load with the C integer promotion.
All26 cached descendants were rebuilt clean in
`keygen_narrow_array_closure_001`:323.425s, maxRSS4997112KiB, RECEIPTS SHA256
`1a2fad6fbb559d23c930ad91c3667c8e760076e6336f2e07184adad288bba8fc`;
SOURCE_INPUTS SHA256
`1b8476cf6a193dee59bc6161e389d37ac9e89e383c4eec15857e543630ae9410`.
Earlier batch receipts retain their original source/artifact pins.

SmallintsProgram parses the actual conversion body with signed16 reads.
SmallintsIteration/Counter/LoopBridge and SmallintsPrelude now derive the
1536 executed stores and initialization from that body's execution; the
counter and n are derived from declarations/MKN/initial assignment. This
removes the former local-loop premise at this callee boundary. MknReference
uses read-set transport, so unrelated global/local bindings are retained.
Checked entry job: `keygen_smallints_entry_009` (all3 clean). Closed caller
binding and the four-call certificate sequence are the current next steps.

The final emitted-KeyGen theorem remains open. There is no final REPORT,
CLOSURE or REVIEW_TASK for the whole package yet, and no new review or push.

Fresh batch005 subsequently passed19/19 with32 audits,38.071s,
maxRSS2873544KiB. Receipt SHA256
`225b5b435dc2606431fd5ecf2ed61a68b4cde6686958cc03a3c9cf20f92f613d`.
SmallintsInvocation and CertificateConversions now bind all four actual
callee bodies/caller frames and compose their initialization. The general
entry prologue/declaration modules also passed individual checks; their
whole-function composition and metadata after the Gram/LDL prefix remain
the next steps. The fixed-entry source fragment checkpoint is `373ab0a3`.

## Owner continuation and waiting rule — 2026-10-01

**ACTIVE / IN_PROGRESS / NOT_REVIEWED.** The owner explicitly directed
continuation of the entire package and waiting when the shared proof slot
is occupied. Do not end work because a helper or commit batch is complete.
The first resumed preflight found the slot free and started
`keygen_fiber_batch4_fresh_001`. `tools/job_when_available.py` adds event-based
waiting before the unchanged runner, preserving all preflights and limits.
The earlier waiting checkpoint below is historical, not an owner pause.

Fresh `keygen_fiber_batch4_fresh_002` now passed11/11 modules and24 audits,
225.799s, maxRSS3708420KiB. Receipt
`notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_004.json`, SHA256
`a599fcf380359383f6fa32b29d953812282e352ad6c964b5207ff9c06f1c6704`.
The five earlier drafts are individually and jointly checked. The automatic
frame still needs binding into the full source function; the generic loop
trace still needs the actual KeyGen body/gates/cap. Current work is the
source prologue and pointer-layout execution, followed by full certificate
composition. Package completion and review status are unchanged.

## Prefix continuation and shared proof slot — 2026-10-01

**IN_PROGRESS / NOT_REVIEWED — waiting for the shared proof slot.**
The source3 runner stopped at preflight, without launching Lean, when the
owner-started `FT1536_SOL61_DEVELOPMENT_T03_AUDIT_002` fresh replay was active.
Blocked preflights: `keygen_prefix_connection_012` and `_013`; `_008` earlier
found the independent T03 replay. No processes were stopped, no limits were
raised, and no parallel proof job or additional agent was started here.

Six continuation modules have matching successful individual checks:
C99NarrowReads, SmallintsConversion, C99ProcedureSequence,
CertificateAfterConversion, Gate00Initialization and CertificatePrefixToSuffix.
In particular, the actual line7727 root copy and all subsequent primitive
memory transitions now come from execution of the parsed7721--7745 segment.
Together with byte Gate00 this derives suffix-entry Legal without a supplied
g00 snapshot or arbitrary tail trace. An accepted suffix also yields all768
Gate00 checks for that same segment execution.

Five further modules are **drafts awaiting checking**: C99Automatic32,
CertificateFrameEntry, CertificatePrefixFrame, C99LoopTrace and the combined
KeygenFiber004Audit. The draft automatic object has actual allocation and
extent removal; its intended post-return theorem forbids even a stale raw
pointer load. The generic loop trace draft observes the existing Exec and
retains the final break attempt. It is not yet the complete KeyGen attempt
interface: source gates, cap, full body and serializer tail must instantiate it.

Progress pin (NOT a clean-batch receipt):
`notes/run/KEYGEN_SOURCE_TO_FIBER_001_PROGRESS_004.json`, SHA256
`471b58aa02043e416a19de262fe3014d3e84765e81ffc7422e8fdad9144e8409`.
It records all13 prefix attempts, raw streams, source hashes and6/11 matching
checked modules. The remaining current sources are saved as drafts. Previous
syntax/elaboration failures are retained; they are not counted as passes.

Local commits so far: `60c47028` (B1 scope), `e00ef2fa` (procedure source
closure), `e5966d39` (recursive frames and batch003), `5a252dc4` (six checked
prefix-connection modules). Publication still needs the owner's explicit
signal. The current unfinished continuation is saved by a further local
draft checkpoint; obtain its hash from Git.

Next test after the shared slot is free:
`python3 -B tools/job.py lean UNIQUE_LABEL $(python3 -B tools/keygen_fiber_batch.py modules 004)`.
The runner performs its normal preflight. Repair any draft failures, then
record a fresh batch004 only after all11 modules and24 audits pass. Continue
the source prologue/layout/conversion/Gate00/suffix/teardown composition;
the whole KEYGEN_SOURCE_TO_FIBER_001 theorem remains the acceptance criterion.

## B1 continuation — 2026-10-01

**ACTIVE / KEYGEN_SOURCE_TO_FIBER_001 IN_PROGRESS / NOT_REVIEWED**.
The adapted owner prompt is current: local commits, push only after an
explicit signal, no new subagents/reviewers/sessions. B1 consumers and the
additional named attempt-interface targets are recorded in the live plan.
Scope read through D1 refinement commit 1ec29f7b; no edits to run2/t5 or
the shared end-to-end target. Preflight: no active proof job, empty Git
index; /home/footfalcon/free_falcon_sign resolves to this NVMe checkout.
Five foreign unpublished main ancestors and other worktree changes remain.
The B1 plan/ROADMAP update is local commit `60c47028`; only the owned ROADMAP
hunk was staged, preserving the foreign audit addition.

Continuation before the adapted prompt added C99ProcedureReference/Parser,
source complex-macro expansion and FftProcedurePrograms (FFT3, split/muladj,
five raw-LDL bodies, seven leaf signatures). Checked table job
`keygen_procedure_programs_004`: clean, 124.591s. Previous failed attempts
remain in .build/jobs; monolithic signature/macro reductions were factored
without raising limits. The memcpy subobject-bound change and complete
recursive pointer/call frames now passed fresh batch003:15/15 clean,
20 audits,309.128s, peak5049120KiB. Receipt SHA256
`0cd3002b2d9e25b4ba967381a8034d2c2ce3cb26265db9f0a575cad1382fae21`.
Sage checked nine source regions/three aliases; three kernel footprint
mutations were rejected. Full prefix execution, lifetime, KeyGen loop and
emitted-to-fiber composition remain open. The next drafts connect the
actual root-copy trace and byte Gate00 to suffix-entry Legal.

The previous read-only codec research subagent completed without edits,
proof jobs, Git or a review verdict. It identified the STATIC low-suffix
invariant, final encoder ne=-2, independently padded f/g/F/G segments, and
the public decoder's return of supplied length. These are implementation
guidance, not kernel results. No delegation remains running.

## Resumed by the owner

**ACTIVE / KEYGEN_SOURCE_TO_FIBER_001 IN_PROGRESS / NOT_REVIEWED**.
The owner explicitly resumed this session. The pause checkpoint is
`08abdeafaba60d014fe80484d25bf6d90650c124` (first own commit of batch002).
Resume preflight found no active Lean/Sage job and no source3 working-tree
changes. Shared main also contains four later commits from the other
workstream; preserve them and check the outgoing range before any push.
First step: repair the recorded CertificateWorkspace elaboration failures
and compile FprPrefixCalls. The historical pause record below is retained.

### Checked continuation after resume

- CertificateWorkspace now compiles: the local pointer/Option elaboration
  errors are fixed. FprPrefixCalls also compiles with the pinned header
  bodies and fixed source call strata.
- C99ArrayReference supplies natural array/control execution and derives
  primitive memory transitions from executed bodies. C99ArrayParser rejects
  unsupported syntax and normalizes the M0 LP64 `size_t` typedef explicitly.
- FftLeafPrograms parses seven complete source bodies: add3, sub3, neg3,
  adj_fft3, mulselfadj_fft3, mul_autoadj_fft3 and div_autoadj_fft3.
  FftLeafFrames derives their checked write footprints from the parsed code.
  These results do not yet cover FFT3 itself, complex macros or raw LDL.
- Checked jobs: keygen_prefix_workspace_003 (workspace),
  keygen_array_reference_001 (FprPrefixCalls), keygen_fft_leaf_sources_002
  (reference), keygen_fft_leaf_sources_004 (parser and leaf programs),
  keygen_fft_leaf_frames_002 (both frame modules). Subsequent failed steps
  in those jobs remain recorded and are not reported as successful jobs.
- KeygenModpWord and KeygenMontgomery now give the source Montgomery
  residue/range contract, including the low31-bit projection of a wrapped
  64-bit product. MontgomeryArithmetic is a separate exact-integer proof.
  Checked jobs: keygen_modp_word_001, keygen_montgomery_arithmetic_002 and
  keygen_montgomery_source_002. Source modp_ninv31 binding subsequently passed
  in keygen_ninv31_004. The initialized_montgomery_contract derives the p0i
  condition from the actual initialization call at p=2147355649. Earlier
  monolithic simplification attempts failed and are retained; limits were
  not increased.

Fresh `keygen_fiber_batch2_fresh_001`:14/14 accepted/clean,20 internal export
audits,67.551s,maxRSS2936928KiB. Receipt
`notes/run/KEYGEN_SOURCE_TO_FIBER_001_BATCH_002.json`, SHA256
`adc2f490a1e683d812941da4bac54179c4b78c0460ba72549be84fce477acb18`.
`keygen_montgomery_checks_001` checked72 public operand pairs per variant
and detected12 mutations across normal/UBSan builds. Source p0i=1869483007.
The checks and proofs are scalar contracts, not an NTT or KeyGen theorem.
Own batch002 consists of pause checkpoint `08abdeaf`, array/source-frame
commit `8a58c578`, and the following Montgomery/evidence commit. Record its
hash from Git; check the actual remote range before publishing this batch.

No full source certificate or successful-KeyGen theorem has been exported.
The next source connections remain complex FFT operations, complete raw LDL,
the enclosing certificate frame and caller/encoding/NTT composition.

## Paused at the owner's request — 2026-09-30

**PAUSED_OWNER_REQUEST / KEYGEN_SOURCE_TO_FIBER_001 IN_PROGRESS / NOT_REVIEWED**.
The owner paused work because of reported API problems and possible reduced
performance. Resume only on the owner's instruction, in the same session/W.
Resume record: `notes/run/KEYGEN_SOURCE_TO_FIBER_001_RESUME.md`.

Batch001 is published: own commits `72483533`, `10d8c17c`, `89e7b885`.
After checking the actual remote tip, this worker pushed only `89e7b885`;
the other commits were already reachable from origin/main. At pause preflight,
main=origin/main=`89e7b88566811dcceaec2e6a2b9ccdf47e16b444`, index empty.

The last owned job, `keygen_prefix_workspace_002`, completed at
2026-09-30T19:21:44.982489Z. C99InitializationTrace passed; CertificateWorkspace
failed elaboration at lines50/53; FprPrefixCalls was not reached. No proof
job remains running from this worker. The read-only NTT research subagent
also completed; its unverified development formulas are saved in the resume
record. No reviewer was started. Preserve all failed-attempt snapshots/logs.

The pause checkpoint saves the three new sources unchanged, including the
failed draft. It is the first local commit of the next three-own-commit batch;
publication waits for that batch. The complete source bridge remains open.

## Current work and publication rule — 2026-09-30

KEYGEN_SOURCE_TO_FIBER_001 remains **IN_PROGRESS / NOT_REVIEWED**.
The owner authorizes a push after each three-own-commit batch. The latest
clarification reserves review decisions to the owner for this worker;
automatic batch review applies to another agent. Work subagents are permitted
under the single-writer/single-proof-job constraints. No reviewer
has been started by this worker. New text uses English and
standard terminology. Earlier Polish entries below are retained as history.
Clarification: each worker pushes only their own commits. Foreign unpublished
ancestors block a source3 push until their author or the owner publishes them.
Communicate with the owner in Polish. No shared mixed-author batch is authorized.

The planning commit `c7003724` is already reachable from origin/main after
updates by the other workstream. Internal batch001 has two own commits:
`724835338f83b2a77b5f97507281fc29ec16412e` (integer lift, conversion and fiber)
and `10d8c17caa73d73a5eaa58427f4ba07031b1b89c` (Gate00 and return snapshot).
The third commit records replay, diagnostics and the current obligations.
The last local remote-tracking check also had three unpublished run2 ancestors:
`1488522f`, `9b113e7e`, `f38d1665`. Do not push them. Check the actual remote
tip before an own-only push; wait for their author or owner if necessary.

Internal results checked in this continuation:
- `KeygenIntegerLift`: exact reduction modulo X^1536-X^768+1, residual bound
  37748737 from coefficient bounds 1/2047, and modular-to-integer recovery
  with p=2147355649. The source NTT check must still establish the congruence.
- `KeygenSmallOutput` and `KeygenMaterial`: accepted conversion-loop stores
  yield bounded coefficients in the existing Geometry.Vec representation.
- `KeygenFiberAssembly.from_modular_check`: consumes those algebraic
  obligations and the existing ActualNTRUFiber exports. Public/inverse and
  source binding remain explicit obligations, not proved KeyGen facts.
- `C99CompareObjects`, `Gate00Scalar`, `Gate00Memory`: byte-copy comparison,
  independent scalar execution, 768-iteration Gate00 checks and accepted
  root stores. The source prefix and its memory invariant remain open.
- `CertificateReturnLifetime`: retains a pre-return snapshot and removes
  the local-object handle. Full-function allocation and lifetime refinement
  remain open; this is an adapter for the completed suffix.

Successful jobs: keygen_fiber_imports_001, keygen_algebra_and_small_005
(integer lift only), keygen_small_fiber_lifetime_007 (first two modules),
keygen_lifetime_compare_008 (lifetime only), keygen_compare_009,
keygen_gate_memory_004 (scalar only), keygen_gate_material_006.
The named multi-module jobs also retain their subsequent failed steps.

Sage: `keygen_helpers_002` checked six public synthetic helper cases and ten
encoding mutations in normal/UBSan builds; it exercised the full certificate,
the actual encoding tail, public computation and final modular check, without
executing private KeyGen or the solver. `keygen_callgraph_002` records a
preprocessed call inventory (163 functions reachable from make, 42 from the
certificate). This inventory includes unspecialized runtime branches and is
not a source-execution proof. All failed attempts and raw logs are retained.

Owner-started review, source prefix/KeyGen control flow, source NTT/public/inverse
contracts and source serializer round-trip proofs remain pending. The requested
emitted_to_actual_fiber theorem has not been proved.

Fresh internal replay `keygen_fiber_batch1_fresh_001` subsequently completed:
all 16 modules accepted with clean logs, including the pinned mathematical
imports and the internal export audit. This does not close the source KeyGen
theorem or constitute an independent review. The source execution and
composition obligations listed above remain active.
Receipt SHA256: `6efc894f0002e24d4c596e03b1dc0811c90a3fba97b6013c367d2177ddaa2527`.
Elapsed82.581s, maxRSS2928416KiB; 20 internal export type/term/axiom audits.

Development-only delegation: one read-only subagent derives the actual NTT3
evaluation invariant and Montgomery/index conventions for the missing solver
check contract. It may not edit files, run jobs, touch Git or issue a review
verdict. The main worker continues the non-overlapping certificate prefix.
At continuation preflight, an owner-started Lean audit job was active in
FT1536_SOL61_DEVELOPMENT_T03_AUDIT_001; no concurrent proof job was launched.

Status: **ACTIVE / KEYGEN_SOURCE_TO_FIBER_001 IN_PROGRESS / NOT_REVIEWED**.
Wykonawca: GPT-6 Astra / openai/gpt-6-astra.
Sesja: `ses_f12636605ffeL1FZg4teLUwUf5` (bez nowej sesji/workera).

**Aktualne polecenie właściciela: KEYGEN_SOURCE_TO_FIBER_001.**
Jeden pakiet integracyjny, nie seria kończonych osobno helperów. Dokładny
typ końcowy przed rozpoczęciem implementacji oraz zależności zapisano w
`notes/run/KEYGEN_SOURCE_TO_FIBER_001_PLAN.md`. Commity lokalne, bez push.
Źródła i runtime nadal source3; run2/t5 mają własnego wykonawcę.
Piny suffix REPORT/CLOSURE oraz wszystkie17 źródeł PROFILE sprawdzone.
Preflight: bez aktywnego joba Lean/Sage i bez obcego stagingu; main na b35d08f3.
Zastane zmiany AGENTS/STATE/WORK_COMMITS/CURRENT_DEVELOPMENT i run2/ConvStruct
pozostają cudzą pracą. Poprzednie trzy pakiety zachowują
PROVED_KERNEL_SCOPED / NOT_REVIEWED. Zgoda „Trzy commity i push” została
wykorzystana przez commity3939e25e/ad72a2d5/b35d08f3 suffixu.

## CERTIFICATE_SUFFIX_001 — bieżący zakres

Pozostajemy w source3, bez migracji/scalania/SOURCE_MAP/duplikatów.
Piny top REPORT `bff687ddd52b828223a7ee904fe9e0510cbd20eb60c93fcea48e19daa92ba66f`
i CLOSURE `1447448efc172809c76c56e2f0cfa6ab73054cf5b47003b57994c447e451e33a`
sprawdzone. Baza nadal NOT_REVIEWED.

Trzy logiczne commity:
1. q_squared z source fpr_of/scaled, parser suffixu i wejściowy layout/profil:
   PROVED_KERNEL_SCOPED, `CertificateQSquared.source_exists/source_exact`,
   `exact_real_value`, `CertificateSuffixSyntax.pinned_source`,
   `CertificateMemory.alias_and_pointer_add/top_legal`.
   Word `0x41b4409001000000`, decoded339775489, scratch=t3+12288 bajtów.
   Jobs `certificate_q_sage_001`, `certificate_q_002`,
   `certificate_syntax_memory_002` (syntax), `certificate_memory_003` clean.
2. Reverse reciprocal768: `CertificateIndex.index_exact/bounds/injective/covers`,
   `CertificateReverse.loop_exists/finished_complete/initialized/clear_written`.
   Snapshot pierwszej połowy zachowany, druga inicjalizowana pod1535-u;
   każdy div witness ma odpowiadający event w rzeczywistym śladzie.
   Jobs effects002/atoms001/index002/reverse004 accepted/clean.
3. Byte-memory scan1536/return, pełna kompozycja, source outcomes/reverse_order,
   mutacje i fresh closure **domknięte kernelowo**; raport/handoff i trzeci
   commit przygotowywane, następnie uzgodniony push.

Na początku wykryto job Lean właściciela w run2; nie uruchamiano drugiego
joba. Edycje źródeł i przygotowanie są niezależne, każde wykonanie ma preflight.
Zastane AGENTS/STATE/WORK_COMMITS/CURRENT i run2 pozostają cudzą pracą.

Commit1/3: `3939e25e` (q_squared/parser/layout), lokalny; push po trzecim.
Commit2/3: `ad72a2d5` (reverse768/1535-u), lokalny; push po trzecim.
Końcowa kompozycja wyprowadza Snapshot D z top, nie dodaje go do Legal.

## CERTIFICATE_SUFFIX_001 — wynik do niezależnego odbioru

Eksporty `CertificateSuffix001Outcome.reference_exists/complete/source_outcome/reverse_order`
domykają wszystkie A–D dla statement-suffixu7757–7776 na return edge,
n1536/hn768. Frame/roots/metadata i trace positive/lower/upper, sticky
dowolnego bad≠0, return1→initial bad0/good controls/inclusive1536 bounds
i realne1024≤value<332054. Reverse zachowuje1535-u i actual source div.
Return edge jest granicą; enclosing frame teardown/prefix/certificate
w całości nie są objęte tym source theorem.

Fresh `certificate_suffix_fresh_001`:20/20 accepted/clean,113 audytowanych
twierdzeń,137.946s,maxRSS5342740KiB. Aksjomaty tylko standardowe lub brak.
Closure `657b907273f0bda6e9ecfc5bbeae24bf169cd1bc8e6965f8662b6501f97cfd56`.
Raport/closure/review task: `notes/run/CERTIFICATE_SUFFIX_001_*`.
REPORT SHA256 `7b36b9c4a01056b577e6b60c329646ba5fdee31266b836a42f6d592cc21ed898`.
Sage ZZ/QQ q-word cross-check i168 syntetycznych wykonań C normal/UBSan;
26/26 mutantów wykrytych, przypadki return0/return1. Pierwszy mutator C
nie dopasował tabulatorów i został zachowany jako nieudana próba harnessu.

Brak otwartego typu A–D w tym zakresie. Niezależny odbiór oczekuje;
recenzenta nie uruchomiono. Gate00/FFT/LDL prefix, cały certificate/KeyGen,
real-error FPEMU, exact Gram, T5, M6 i C Sign pozostają dalszymi obowiązkami.

## Przejęcie2026-09-30

Zweryfikowano5/5 source/target hashes według
`HANDOFF_RECONCILIATION_20260930_001.json`, SHA256
`d6e460b94b858dfbb65bb2d6c725a477d932e3fcbfeb9903bc4ea36524518eb2`.
Rozliczenie: commit `c358871ab99f4aabfefc78d0b6be873852f2678e`, main=origin/main.
Pięć historycznych różnic `pending source3` jest rozliczonych, BASELINE
pozostaje niezmieniony. Stan run2/t5 nie jest przejmowany.
Zastana zmiana `docs/onboarding/STATE.md` należy do innej pracy.

Źródła: `proofs/ft1536/development/T12_1/source3/{formal,sage,tools}`.
Runtime: ten komponent `.build/{jobs,cache,preflight}`.
Stary RUN_003 W oraz `tools/original/` i wcześniejsze notatki są read-only
proweniencją. STABLE_BINARY_004: PROVED_KERNEL_SCOPED / NOT_REVIEWED,
REPORT `3bc800efe63cc0b829b44d10d19d7d54dfc72678366a7f71c60e27b4b4378f96`,
CLOSURE `d62d6eb1104879c4b920b9e5a0324d0e2ee78cfcf41f9b8edf434a22d7a1a5e2`.

## Bieżąca kolejność

1. Rebinding runnera zakończony: `tools/job.py`,
   `.build/jobs/stable_top_bootstrap_001` accepted/clean,1.016s.
   Sprawdzono import pinowanych eksportów `_004`; nie odtwarzano ich dowodów.
2. Source fpr_of(3)→fpr_scaled(3,0), norm/FPR **PROVED_KERNEL_SCOPED**:
   `FprOfThree.source_exists` i `source_exact`, słowo `0x4008000000000000`.
   `FprScaledBinding` wiąże parser C/headera/makra; `FprScaledBridge`
   dowodzi obu kierunków zgodności reference i modelu.
3. Parser całego top `StableTopSyntax.pinned_source`, reference i dokładny
   most pętli `StableTopBodyBridge.loop_complete`: accepted/clean.
   `StableTopLoop.loop_exists/filled_all/counters` dowodzą256 iteracji,
   u=3*v i inicjalizacji768 leaves bez initial leaves/scratch reads.
4. Legalność następnych gałęzi i wspólny scratch: domknięte przez
   `StableTopBranchLayout`, `StableTopBinaryBridge`, `StableTopBranches`.
5. Istnienie/reference→operational/source outcome: `StableTop001Outcome`.
   Fresh23/23 moduły,119 twierdzeń accepted/clean; pełna pamięć/metadata/trace.

Małe lokalne commity własnych plików po logicznych krokach; push wyłącznie
po nowym sygnale właściciela. Okno Git przekazane przez właściciela/koordynatora.
Bez przyjmowania cudzych zmian,
bez amend/force, innych modeli, samodzielnego REVIEWED lub zmian C.

Uruchamianie z katalogu komponentu:
`python3 -B tools/job.py lean <jednorazowa_etykieta> Source3.Modul ...`
lub `python3 -B tools/job.py sage <jednorazowa_etykieta> nazwa.sage`.
Runner sprawdza source/product piny konsumowanych zależności, zapisuje
snapshot źródła, SOURCE_INPUTS i RECEIPTS, izoluje sieć i zapis do jobu,
utrzymuje -j1/-M6144, AS12GiB/RSS8GiB/wall1800s oraz warningAsError.

## Zapisane kroki

- `d3e50a19`: przejęcie+runner+bootstrap, wypchnięty na origin/main.
- `c679746c`: fpr_of3, wypchnięty przed późniejszym zakazem push.
  Jobs `stable_top_scaled_binding_001`, `stable_top_scaled_bridge_001`,
  `stable_top_of_three_003`, `stable_top_of_three_audit_001` accepted/clean;
  raw failed `_001/_002` zachowane. Typy/termy/aksjomaty w audycie.
- `stable_top_inputs_sage_001`: `sage check_stable_top_inputs.sage`,
  ZZ/QQ exact fpr_scaled/FPR cross-check daje3; kontrola indeksów768 i
  dwóch mutantów harmonogramu. To diagnostyka, nie dowód całej pętli.

Pętla: `stable_top_syntax_001`, `stable_top_expr_memory_002` (Expr),
`stable_top_memory_003`, `stable_top_effects_001`, `stable_top_reference_001`,
`stable_top_atoms_001`, `stable_top_body_bridge_002`, `stable_top_body_total_002`,
`stable_top_loop_002` accepted/clean. Źródłowe12 kontroli/iterację, pełne
nawiasowanie, Legal oraz przenoszony invariant frame/sticky/clear.
## Wynik STABLE_TOP_001 — do niezależnego odbioru

- `StableTop001Outcome.reference_exists`: każdy legalny before ma
  niezależne source execution, dowolne roots/bad, bez initial leaves/scratch.
- `StableTop001Outcome.source_outcome`: exact operational heap/metadata/
  trace, roots i frame, sticky dowolnego bad≠0, clear→initial clear oraz
  positive-finite/no-fallback wszystkich kontroli top i trzech binary.
- Scope: autorska semantyka fragmentu C99/GCC-LP64 i source binding,
  nie dowód całego ISO/kompilatora ani pełnego M6/KeyGen/Sign.
- `.build/jobs/stable_top_fresh_001`:23/23 accepted/clean,119 audytowanych
  twierdzeń,110.151s,maxRSS4224628KiB; standardowe aksjomaty albo brak.
- `notes/run/STABLE_TOP_001_CLOSURE.json`, SHA256
  `1447448efc172809c76c56e2f0cfa6ab73054cf5b47003b57994c447e451e33a`.
  Raport: `notes/run/STABLE_TOP_001_REPORT.md`; materiał odbiorczy:
  `notes/run/STABLE_TOP_001_REVIEW_TASK.md`.
  REPORT SHA256 `bff687ddd52b828223a7ee904fe9e0510cbd20eb60c93fcea48e19daa92ba66f`.
- Sage C probes:18 wykonań normal/UBSan,16/16 wykrytych mutantów,
  baseline22272 kontroli. Pierwszy probe `_001` nie wykrył mul→add przy
  c=1/dużym ab (zaokrąglenie); zachowany, dane w `_002` poprawione.
- `24ef6865`: lokalny commit parser/pętla. Kolejny końcowy commit jest
  zgłaszany hashem w handoffie. Żadnego push po poleceniu wstrzymania.

Następny krok: właściciel/koordynator organizuje niezależny odbiór;
recenzenta nie uruchomiono. Brak otwartego typu wymaganego dla tego
scoped stable-top; reverse reciprocal, pełny certificate, real-error,
FFT/exact Gram, KeyGen, T5, M6 i C Sign pozostają kolejnymi obowiązkami.
