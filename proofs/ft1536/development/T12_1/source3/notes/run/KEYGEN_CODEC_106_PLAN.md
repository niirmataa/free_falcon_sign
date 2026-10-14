# 106 — full codec and caller-tail closure (active)

2026-10-14. Continuation of the same whole-KeyGen owner task after105.
No acceptance claim, new assumption, frozen-source edit or scope change.

1. Prove actual typed private/public codec expression and execution
   determinism for fixed evaluated arguments, including return0 and all
   partial writes; discharge fixed callees and preserve full heap state.
2. Bind those arguments to the actual caller cells and pointer reads.
   The fixed-body leaf theorem alone is insufficient for site determinism.
3. Cover the entire 18-statement encoding tail, private capacity failure,
   public failure and successful packets, followed by actual lifetime close.
4. Compose with the actual seeded prefix and stopped loop, then build the
   complete probability law and SAME model pushforward. No arbitrary
   execution family or assumed law equality closes this step.

Inspection item requiring resolution before whole-tail uniqueness:
`KeygenMakeInvocation.ReadPointer` admits a canonical descriptor whose
loaded word equals `wordOf vb`; its decoder uniqueness theorem requires
VirtualLegal over both pointer blocks. The current successful Source adds
Addresses for actual private calls. The old tailRejected branch retains
only the public-refined Encoding relation. Inspect whether its failure
paths derive sufficient live-block/address legality, or whether the actual
fixed caller/operational pointer semantics need a new explicit construction.
This is a suspected underdetermined interface from code inspection, not a
proved counterexample to actual C or a kernel refutation. Do not silently
assume uniqueness, strengthen the frozen relation, identify its all-path
law by fiat, or move this obligation into do_sign. Preserve any obstruction
and distinguish source-model insufficiency from an implementation bug.

Cheap next discriminator: inspect typed codec early exits and read rules;
prove fixed-argument determinism independently. Then test the exact pointer
boundary under the actual declared input domain. A generic raw-pointer
ambiguity alone does not prove two full KeyGen outcomes exist.

Additional source interfaces seen on inspection: Eval.scalar can overlap
pointer-reserved identifiers on arbitrary Locals; derive absence of scalar
out/NULL/x/buf bindings from actual activation/declaration execution.
The private terminal CallArgs binds out/capacity/q/x/logn but omits comp,
which is not a parameter of none/static callees. Their initial activation
still contains a synthetic comp slot. Prove non-observation/independence for
those actual bodies and unique heap/return; do not assert arbitrary full
activation equality across different unused comp metadata.
