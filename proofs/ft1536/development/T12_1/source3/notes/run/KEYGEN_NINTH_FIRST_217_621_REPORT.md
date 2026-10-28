# R1 selected d=9 first-prime loop — checkpoint 621

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The original selected ninth make_fg_step first-prime loop u0..165 executes
from constructed d1..d8 calls and ninth entry/prefix. Each source row is
selected from the pinned PRIMES3 table using IndexedPrimeRows217 from611.
Actual generator, copy, product and inverse source branches operate at
n2/hn1, slen166/tlen335 and gd1005. In each iteration the true !out_ntt
branch executes actual fd/gd inverse calls at logn0, whose source early
returns preserve caller state, by the bound620 theorem. An inductive
invariant retains every table, earlier product column and source row on the
same execution witness, including the false terminal guard.

All166 fd and166 gd first-loop product columns and both332-word inverse-data
images are exported on that witness. No desired source run or output is a
premise of the concrete selected export. This proves executed-word source
behavior, not a mathematical NTT or CRT law.

Canonical keygen_ninth621_canonical accepted16/16, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and97 axiom results use only
propext/Classical.choice/Quot.sound. Lean time51.014s; maximum cumulative child
RSS3680756 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Some modules inherit maxRecDepth262144
from602; no memory limit was raised. Independent review: NOT_RUN.

Twelve local attempts include two retained elaboration failures:004 and005
had incorrect data-length multipliers in copy and inverse capacity expressions
after byte-width protection. Corrected in006; raw snapshots/logs remain.
These are no mathematical counterexamples. Earlier retained findings remain;
no new resource failure, linter suppression or failed lane-cache artifact.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all98 predecessor620 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next622: actual d9 CRT pair, extra-prime loop u166..334 including true output
branch, full d9 return and terminal loop guard. Root/certificate/codec and
full B1 remain open. No mathematical NTT/CRT/root/table/centering/Montgomery/
integer law, broad KeyGen/Sign/compiler/security or unconditional positivity/
probability is claimed. Old110/measured/five do_sign retain their scope.
