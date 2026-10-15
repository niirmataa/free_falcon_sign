#131 — norm source frontier and missing sqrt investigation

Continue the original three-point owner program after sealed130. Entry
postseal verified before any new job. Exact caller remains NormalizedSamples129.after;
SelectedResultantGate130.source proves both actual checks pass with unchanged state.

Source C next calls fpr_sqrt inside the mandatory bound initialization.
Inspection of FprPrefixCalls and C99Frontend.lookup finds no sqrt case, while
KeygenSearchExec.ScalarCall only separately handles fpr_rint. FIRST verify
this potential REFERENCE-RELATION coverage gap in the kernel, including the
actual parsed bound expression/path. Do not treat it as a C bug or silently
change the frozen law110/semantics. Determine exact impact and prepare a
concrete source-bound extension/migration plan if confirmed. Keep old proofs,
pins and all failure history; no new assumptions or do_sign-slot movement.

One job at a time,0/0,small local commits without push,postseal. The full KeyGen
success witness and all quantitative goals remain open; final report only at
whole-program completion or required stop-and-report.
