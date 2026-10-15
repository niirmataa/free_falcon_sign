# KeyGen FFT first pass 149

Status: IN_PROGRESS / NOT_REVIEWED.

Entry: stage 148 postseal, 45019 inherited pins checked in
`.build/fftfirst149/ENTRY_PINS.json`. The first actual FFT call is complete;
the actual second call has a source-derived buffer and parameter binding.

Prove the original first-pass body once for arbitrary word operands and
legal pointers, then derive the whole original first-pass loop using the
word-buffer invariant. Preserve the original ordered stores and local scope.
Use existing source-exact FPR operations; no host float premise or sampled
probability. Reuse the middle and tripling lemmas for the later second-call
composition. Full KeyGen witness and the three probability goals remain open.

One guarded Lean process, unchanged resource limits, full kernel/DAG audit
partitioned into small sequential processes, Sage auxiliary controls, 0/0
accepted logs, failed jobs retained, local commits only, postseal. The revised
whole-law target remains 134; frozen 110 and its zero-mass diagnostic remain
unchanged. Five do_sign obligations and measured wording stay unchanged.
