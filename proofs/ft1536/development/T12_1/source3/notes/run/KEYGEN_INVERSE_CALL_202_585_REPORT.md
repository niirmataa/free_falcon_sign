# R1 generic inverse call and separated-read keeps — checkpoint 585

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED; overall owner goal IN_PROGRESS.
This is an intermediate local checkpoint followed by continued proof work.

The complete inverse execution/image from584 now preserves every Load32
whose four bytes are separated from all transformed stride positions.
Intermediate rounds, the final pass and corrective scaling compose those
keeps on the same execution output as the exact word image. This supports
successive columns without replacing the memory state by an unrelated run.

The call adapter binds the original seven arguments
`fs + u, slen, igm, logn, 0, p, p0i` for every logn1..9/full0 and valid
u/stride. Pointer bounds, uint64 integer-to-index conversion and symbolic
parameter conversions are discharged from the stated input domains. The
original level instruction returns the composed scaled words and separated
reads on one caller output, preserving caller locals and array bindings.
Its premises are actual caller scalar/pointer cells, memory domains,
twiddle/data loads and separation. Desired output words, a completed body
execution or preserved reads are not supplied as premises.

Canonical job keygen_inversecall202_585:5/5 accepted, exit0, diagnostics0/0,
warningAsError, markers/suppressions0; six standard-only axiom results and
original-type checks. Lean time23.687s; maximum cumulative child RSS4128084
KiB. Limits unchanged; independent review NOT_RUN.

Five local attempts retain three failures: a parameter adapter touched an
open list; PointerAdd lacked explicit u64 integer.toNat normalization and
a broad stride simplification left a modulus/unused simp argument; a tactic
used a structure field tag after refine-generated holes. Repairs use explicit
opens, u64_toNat, set64_slot and the structure constructor. No mathematical
counterexample, linter suppression or limit increase; no failed product was
used in the lane cache. Logs/snapshots/receipts remain pinned.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after, zero missing/changed. All506 predecessor584
evidence bindings verified before/after. No re-baseline, production C change,
migration, stages import, review claim or push.

Next586: generator bystander keeps and concrete d=2 copy/product/input-domain
composition before the inverse call, preserving original source order. The
full d=2 prime iteration/step, lower-size forward engine, multi-limb CRT,
later d levels and enclosing root/certificate/codec remain open. This does
not establish a closed-form transform/root law or full KeyGen/Sign/compiler/
security/positivity/probability statement. Old110/measured/five do_sign
obligations retain their previous scope.
