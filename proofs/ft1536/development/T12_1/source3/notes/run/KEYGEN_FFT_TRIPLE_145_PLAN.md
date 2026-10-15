#145 — source-general local complex macros for degree tripling

Previous goal turn made verified progress: sealed144 closes all eight actual
middle passes of the first FFT. Base HEAD97224dc9,42937 inherited pins to
ENTRY145; no active Lean at entry. Actual continuation is
SelectedFftMiddle144.after, logn10/full1, tripling starts u0/v1024.

Retain the owner compression principle. Generalize the local complex macro
execution needed by the original tripling body, keeping exact source AST,
temporary scope restoration, caller cell declarations, alias conditions and
bit-level FPR words. Existing140 arithmetic stages can be reused when their
states coincide; their fixed middle-loop variable names are not silently
renamed. Bind actual tripling macro sites, then compose a generic body and
its256-iteration invariant as the continuation permits. If a recoverable
checkpoint is needed, state exactly which macro/body/loop obligations remain.

No native numeric snapshot premise or per-iteration C replay. Corrected134
is the active whole law; frozen110zero unchanged. Whole three-point goal
ACTIVE, no push/workers/schedules/IID/F04/D1/newaxioms, fixed limits,0/0,
all failures retained, small commits and postseal. Measured paper and exactly
five do_sign items remain unchanged.
