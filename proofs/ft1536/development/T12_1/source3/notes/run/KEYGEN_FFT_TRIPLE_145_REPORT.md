#145 — reusable source MUL/SQR for the tripling body

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Whole owner program ACTIVE /
NOT COMPLETE. This checkpoint closes seven macro sites, not the tripling
body or loop. Actual endpoint remains SelectedFftMiddle144.after.

## Proven result

FpcMulClosed145.source proves the local complex multiplication code for
all four64-bit operand words, arbitrary legal caller names and distinct
output names. Caller inputs may alias output names; their values are copied
before output writes. Entry requires ordinary typed input cells, declared
uint64 destinations and absence of collisions with the six macro locals.
The result is the exact original mul/sub/mul/add word formula, two ordered
local-cell writes and restoration of all macro-local cells. Heap and other
caller cells are unchanged. Existing140 arithmetic stages8/9 are reused
because their actual states coincide; no unproved renaming is used.

FftTripleShape145.mul_shape directly identifies all six original tripling
MUL sites with this code, using the already source-bound FFT body. Locations
12/13/14 and16/17/18 cover B0/B1/B2 and C0/C1/C2. FftTripleCalls145.names
proves all static name/scope/distinctness conditions; its mul theorem needs
only the incoming typed caller cells and destination declarations.

FpcSqrClosed145.source proves the original in-place square for arbitrary
words and legal distinct names, with all original temporaries restored.
It retains sqr/sub/mul/double in the original order. It is NOT replaced with
complex multiplication or real-number algebra that could alter rounding.
source_shape/in_tripling binds the actual xr/xi statement at position15;
FftTripleCalls145.square derives its static guards from the actual names.

No tripling loads, six ADD sites, whole body or256-iteration source loop
are claimed closed. The macro theorems are reusable ingredients whose
ordinary caller-cell conditions will be derived while composing that body.
No concrete KeyGen packet witness or positive probability follows yet.

## Failed optional route, retained explicitly

An optional equality for the generic FpcSourceExpansion expander on arbitrary
names was NOT accepted. Direct reduction exhausted memory; isolated and
staged attempts also failed, including a thread-resource abort in008.
The last candidate and its hash are retained under
.build/ffttriple145/rejected_source/, alongside all immutable job snapshots.
It is not imported, audited as accepted, or used as a premise. The six actual
source-site equalities passed directly in007 (4.024s), and independently
supply every MUL source binding needed here. C99MapMIndex145 and
C99MacroExpand145 are accepted generic composition helpers, but they do not
establish the rejected concrete expander equality. No limits were raised.

## Evidence

ENTRY145 3a5048446b2e87f86027e767d74ccc46725ef5b2e2bd3731fc8457588bda5a51
verified42937 inherited pins from144postseal
2c3460b9e636de4dac800cc95fe992322a37cac231e7e66760b76a2bc7c0cee0.
Local source commits84d44b68 and7542dddd; no push or independent review.

Final audit013 covers12 mathematical modules plus12 isolated audit modules,
93 named declarations, accepted0/0 logs, full expression DAG roundtrip and
fresh safe kernel definitions at original types/options. Only
propext/Classical.choice/Quot.sound are allowed. This is self-audit.

Standard-preparser Sage012 compares40 raw-word cases against the pinned C
macros: distinct-output MUL, in-place MUL, in-place SQR and preservation of
pre-existing caller cells named like macro temporaries. Exact ZZ operations
are reused verbatim from the pinned140 control; compiler/job logs are0/0.
Native word output is retained as expected control data. This finite control
is not a premise of the universal kernel theorems or a probability claim.

All13jobs are retained. Failed/mixed001/002/003/005/006/008/009 have detailed
causes: reserved helper name; allocation failure; kernel memory limit;
missing list lemma name; premature list unification plus memory limit;
thread-resource abort; and unary constructor arity. An attempted TERM after
006 found no process because that job had already failed; no cancellation
is falsely recorded. Failed sources and inconvenient outcomes remain pinned.

## Continuation

Complete local and pair-store ADD macros, bind cubic loads and six input
slots, compose one generic tripling body, then its256-iteration invariant.
Keep logn10/full1 and u0/v1024 actual entry. rt2 FFT and later KeyGen also
remain open, including all concrete positive Z/p_accept/coding/p_K bounds.
No C/reference/law134 changes, IID/D1/F04 shortcut or empirical premise.
Frozen110zero, measured wording and exactly five do_sign items unchanged.
