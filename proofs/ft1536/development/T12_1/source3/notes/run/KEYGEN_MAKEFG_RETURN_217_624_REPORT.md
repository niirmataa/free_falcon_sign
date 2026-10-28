# R1 selected make_fg return into deepest — checkpoint 624

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The original selected complete make_fg body is constructed from the
composed d1..d9 loop in623, and its actual call returns to
solve_NTRU_deepest on the same execution witness. The original deepest
part2 workspace sequence and call execute; the two exact335-word fd/gd
sections survive at the caller and their roots and array bindings are
proved equal to the actual fp/gp buffers. No desired source run or output
is a premise. The next source part performs CRT reconstruction followed by
zint_bezout, which is not yet executed by this result.

Canonical keygen_top624_canonical accepted2/2, exit0, diagnostics0/0,
warningAsError. One main interface and five axiom results use only
propext/Classical.choice/Quot.sound. Lean time11.555s; maximum cumulative child
RSS4002916 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Source uses maxRecDepth262144 inherited
from602; no memory limit was raised. Independent review: NOT_RUN.

Four local attempts accepted without failure; earlier retained findings
remain. No new mathematical counterexample, resource failure, linter
suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all53 predecessor623 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. A local source commit is not independent acceptance.

Next625: actual deepest CRT reconstruction of these two selected buffers,
then actual zint_bezout branch and further root solve. Certificate/codec and
full B1 remain open. No mathematical NTT/CRT/root/table/centering/Montgomery/
integer law, full KeyGen/Sign/compiler/security or unconditional positivity/
probability is claimed. Old110/measured/five do_sign retain prior scope.
