#147 — complete original degree-tripling body

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Whole success-mass task ACTIVE /
NOT COMPLETE. This checkpoint proves one generic complete body, not its256-
iteration loop. Actual selected execution endpoint remains144. No production
C/reference/law134 changes; frozen110zero unchanged.

## Proven source result

FftTripleInputs147.source derives all original20 local declarations and eight
loads. Six buffer values come from Represents and original pointer arithmetic;
the cubic pair comes from the pinned source table with v=2*q,q<2048. It
preserves heap, arrays/globals/tables and every caller cell outside the body
scope. Source initialization and unread-cell facts are proved, not assumed.

FftTripleArithmetic147.source composes the ten original local macros in
source order: B0/B1/B2 multiplication, exact source square of xr/xi, C0/C1/C2
multiplication, then B0+=C0,B1+=C2,B2+=C1. Every operand cell and destination
declaration is derived through the preceding updates. FftTripleWords147 is
an exact symbolic word model. The small Python generator emits proof syntax
and register data flow only; it performs no numerical word arithmetic. Its
source replay was byte-identical and is pinned. Lean checks every emitted
step, formula, cell fact and source location.

FftTripleLocal147.source joins the original input prefix with that arithmetic.
FftTripleWrites147.source_and_image composes all three final pair stores,
retaining exact six-slot vector updates and the full memory frame. It keeps
cached local A operands unchanged even after earlier buffer stores.
C99ScopeFrame147.restored identifies the complete scope-restored state.

FftTripleBody147.source_and_image therefore executes the ENTIRE ORIGINAL
tripling loop body:25 statements in its original20-local scope. Output
restores all caller locals, arrays, globals and tables, preserves object
sizes/write permissions and outside-buffer bytes, and represents exactly
FftTripleBody147.values. Source read/write judgments and allocation are
constructed from ordinary typed control/buffer/table facts; no execution
or successful-outcome premise closes the body. FPR order is literal,
including sqr/sub/mul/double and the B1+C2 / B2+C1 pairing.

This remains a generic context theorem. The actual branch initialization,
256 source iterations, final guard and enclosing v scope are next. No new
actual tripling iteration, full FFT, KeyGen packet witness or positive mass
is claimed here. The resulting vector is symbolic, not an assumed native
numeric snapshot.

## Evidence and audit

ENTRY147 8bf7197ea220a36c909cfc34f51ed1606ea4541f4551f6b7c941d74f768bf1ad
verified43500 inherited pins from146postseal
7769e5bd4d4815ea76f051c68f450710b2f17ee7e882e0724dd0ccaaacd12461.
Own source commits4c2b987b,fb766036,022ced85,1bc77f6c. Shared main also
received unrelated S05 commitsf246feae,e6c5678f,b0a1784a; their S05-only
scope was inspected and preserved. No foreign changes were staged by us,
no second Lean was observed at the process checks, and no push occurred.

Final audit uses19 mathematical modules and30 isolated processes for222
named declarations. It retains the exact original DAG roundtrip, term
comparison, fresh safe kernel definition at the original type, allowed
propext/Classical.choice/Quot.sound and fixed options/limits. The cubic module
is split per declaration; the collector verifies its exact ordered name
union, every declaration exactly once, and all current source/artifact hashes.
All accepted records require0/0 logs. This is self-audit, not review.

Earlier module-wide audit commands015/017/019/021/022/024 exhausted a
cumulative200000-heartbeat run_cmd budget at real_cell. Diagnostic022
confirmed the comparison phase; single-declaration025 passed the identical
checks in2.871s. Thus the stopping name was not an individually uncheckable
theorem. The final partition changes only process granularity, not any check
or limit. Unnecessary source-proof packaging/reduction experiments were
archived with hashes and the prior source proofs restored. The old audit
plan, generated files, partial rows and diagnostics remain intact. See
KEYGEN_FFT_INPUTS_147_AUDIT_REPAIR.md for the successive evidence and corrected
hypotheses; none of the unsuccessful experiments is promoted to a premise.

Source compilation repairs included reserved-token/identifier mistakes,
index aliases, unused premises/tactics, expensive whole-state metadata rfl,
and a missed generator replacement. An abstract Entry factory with explicit
arguments resolved the local-prefix memory failure; metadata heap/frame
lemmas resolved arithmetic reduction without raising limits. All27jobs are
retained;16 failed/mixed jobs have explicit causes in FAILURES.json.

Standard-preparser Sage014 compares40 raw-word cases with the extracted
ORIGINAL C body, using actual cubic table words and header constants. It
checks six outputs, unchanged u/v, shadowed caller locals and all1530 other
buffer words. Exact ZZ definitions are reused from pinned controls;
compiler/job logs are0/0. This finite control is auxiliary, never a kernel
or probability premise. It does not execute the full256-step loop.

## Remaining work

Instantiate the original full branch, u0/v1024 setup and a256-step invariant
using u=3*k,v=2*(512+k),hn768. Then close the first FFT call, rt2 and later
KeyGen. Full emitted-packet witness and concrete positive Z/p_accept/coding/
p_K bounds remain open. No IID/D1/F04 or empirical premise, no hidden do_sign
obligation; measured wording and exactly five do_sign items remain unchanged.
