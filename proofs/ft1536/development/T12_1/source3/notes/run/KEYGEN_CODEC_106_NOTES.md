# 106 — codec leaves and the caller pointer boundary

2026-10-14. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**; whole owner task
**ACTIVE / NOT COMPLETE**. Parent POSTSEAL105:
`01621abf53d2c728893b7b798169517971c2628e298e461dfadd5e1b41c391e5`.

Private signed/public unsigned expression results and local effects are
unique under absence of scalar shadows for out/NULL/x/buf. Initial source
activations satisfy that invariant, and actual checked declarations,
assignments, updates and scopes preserve it. Both concrete private leaf
bodies pass the call-free syntax check and have unique full state/flow
for the same evaluated arguments. The complete public source Call has
unique full heap and return length, with exact partial encode/spec.
Return0 and partial writes remain actual source outcomes.

The private dispatcher is NOT yet closed: its terminal CallArgs leaves
the synthetic comp activation field unconstrained, although comp is not a
C parameter of either leaf. The next stage proves unused-field independence
and observable heap/return equality; full activation equality would be too
strong. Actual Extra/c/falcon-enc.c was read and its SHA256 matches the
pinned source:0f7085fa975d41ebbeb96d5db4cb68482c344ef2d602ca8853e20a4d4f04fb05.

The local kernel theorem incomplete_live_set exhibits two distinct
allocated canonical descriptors for one stored pointer word while
VirtualLegal holds on [0,2]; the second descriptor belongs to block1,
outside that declared set. The heap has only three allocated blocks.
This refutes generic raw ReadPointer uniqueness from an incomplete live
set. It does NOT exhibit two complete KeyGen outcomes or lawful C pointer
executions. Full caller-tail binding must resolve the actual memory/read
domain on failed paths too; successful Addresses cannot be silently used
there. No frozen relation or production C was changed.

Final keygen_codec106_011:8/8, seven mathematical modules and full audit
of50declarations, logs0/0, standard axioms only. Eleven jobs include eight
failed/mixed elaborations, all retained with causes. They concern tactic
matching, constructor indices and unused simplifier entries; warnings
were fixed, not suppressed. Global limits unchanged. Author self-review,
no independent acceptance. Source expression commit5c746a08.

Next:107 private dispatcher/comp independence, then complete caller tail
including pointer domain and encoding failures, seeded whole producer and
actual law/SAME-model binding. Caller/entropy boundary, nonreturn and
normalization/positive success where required remain open. Five do_sign
items unchanged; no push, migration, stages import or actual-C e2 claim.
