# R1 complete smaller forward image and call frame — checkpoint 594

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber work
remains IN_PROGRESS; continue after this intermediate local checkpoint.

The full original modp_NTT3_ext body now executes at every logn1..9,
full0 and stride1. The actual prologue/early guard/MKN size, corrected
first pass, per-block table loads, binary butterflies, u1 loops, counted
dyadic m/t rounds, terminal guard and false triple-pass branch are all
constructed. One output witnesses the complete executed word image and
the full before→after actual-size write frame. All read/write extents use
the actual size. Legal scalar arithmetic uses the explicit≤512 bound.

The original seven-argument forward call and actual ternary branch are
bound to that body. Caller locals/arrays are restored, the full word
image is retained at the caller, and arbitrary Load32 reads whose bytes
are outside the actual write span survive. This permits preserving prior
products and input arrays in the concrete scratch layout. No desired
output, successful source execution, transform or table law is a premise.
Ordinary source scalar/data/table/capacity/separation domains remain.

The permanent195 bodyHeap/stepState defect remains recorded and unused.
The source foundation is the corrected bodyAt/stepAt. Its generic first-pass
witness was strengthened with a complete write frame. All dependent211
modules were rebuilt after that unsealed interface change; old snapshots
and every sealed195/201 source remain unchanged. Existing source-shape
equations compose the final body without repeating the large parse.

Executed: fifteen source modules and complete generic body/call/branch.
Validated: canonical keygen_forward211_594 accepted15/15, exit0,
diagnostics0/0, warningAsError, markers/suppressions0; five interfaces and67
standard-only axiom results. Lean time77.740s; maximum cumulative child
RSS4206044 KiB. Original limits and inner network isolation unchanged.
Independent review: NOT_RUN.

Thirteen local attempts retain two elaboration failures.002 used ordinary
if equations for a dependent word selector and tried to unfold count in
an already-expanded bound.010 exposed a Cell/USlot alias mismatch under
simpa; the explicit bridge repaired it. No mathematical counterexample,
resource failure, suppression or failed cache product occurred. All raw
snapshots/logs and inherited findings remain pinned.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all132 predecessor593 bindings verified.
Python handles source scaffolding/jobs/hashes; all load-bearing arithmetic
and source execution are kernel checked. No re-baseline, production C
change, migration, stages, reviewer start or push.

Next595: actual u2 extra-prime prologue/generator/signed conversion,
forward/products, terminal loop and complete d2 return. Later d levels,
root/certificate/codec and full B1 remain open. No mathematical NTT/root/
table/convolution law is claimed. Full1 and arbitrary forward stride are
outside this new engine's scope. Full KeyGen/Sign/compiler/security and
unconditional positivity/probability remain open; Old110/measured/five
do_sign retain their previous scope.
