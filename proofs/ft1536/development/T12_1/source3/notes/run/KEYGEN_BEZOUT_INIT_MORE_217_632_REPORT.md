# R1 conditional selected bezout further initialization — checkpoint 632

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Under the explicit condition that the selected initial guard is false, the
original Bezout initialization continues after631: memcpy(u1,y,ylen*4),
memcpy(v1,x,xlen*4) and the actual v1[0] &= ~(uint32_t)1 store execute on the
same selected witness. Exact u1 copied words and v1 words with the first word
masked are exported. Earlier x/y and a/b images, u0/v0 zero ranges and
u0[0]=1 remain intact. Bounds, initialized bytes, nonoverlap and writable
memory follow from the source state and symbolic lengths.

The selected guard condition has not been evaluated. This result does not
assert unconditional reachability, completion of the entire initialization,
the Bezout return or root-solve success. It is a source-word execution
result, not a mathematical Bezout or CRT law.

Canonical keygen_init632_canonical accepted7/7, exit0, diagnostics0/0,
warningAsError. Five checked interfaces and19 axiom results use only
propext/Classical.choice/Quot.sound. Lean time29.675s; maximum cumulative child
RSS4464388 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Some source modules use maxRecDepth262144
as in602; no memory limit was raised. Independent review: NOT_RUN.

Ten local attempts include three retained failures:002 and006 had elaboration
issues, and008 hit the unchanged -M6144 memory limit when specializing
symbolic length cells. An abstract-state frame fixed it in009 without raising
limits. Raw snapshots/logs and earlier findings remain. No mathematical
counterexample, linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all260 predecessor631 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next633: compose original Bezout part4 and execute part5 upper-word zeroing
and mlen selection, then the full algorithm and actual return. Root/
certificate/codec/full B1 remain open. No mathematical NTT/CRT/root/table/
centering/Montgomery/integer law, full KeyGen/Sign/compiler/security or
unconditional positivity/probability is claimed. Old110/measured/five do_sign
retain prior scope.
