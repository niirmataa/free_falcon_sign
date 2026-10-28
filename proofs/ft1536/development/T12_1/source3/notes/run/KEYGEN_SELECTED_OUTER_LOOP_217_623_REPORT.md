# R1 selected original make_fg outer loop — checkpoint 623

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The original outer d loop is constructed from its actual selected caller:
all nine d1..d9 source call bodies, caller returns, increments and guards
are composed on the same execution witnesses. At d9 the actual true
!out_ntt branch executes fd/gd inverse calls at logn0. The d9-to10 increment
and false d<depth10 terminal guard close the loop. The original make_fg top
tail executes from its selected before state, and both final335-word fd/gd
sections are exported with their exact executed-word images on that same
final witness. There is no desired run/output premise.

Canonical keygen_outer623_canonical accepted2/2, exit0, diagnostics0/0,
warningAsError. One checked interface and one axiom result use only
propext/Classical.choice/Quot.sound. Lean time23.383s; maximum cumulative child
RSS4176388 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Source uses maxRecDepth262144 inherited
from602; no memory limit was raised. Independent review: NOT_RUN.

Two local attempts accepted without failure; earlier retained findings
remain. No new mathematical counterexample, resource failure, linter
suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all255 predecessor622 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. A local source commit is not independent acceptance.

Next624: continue the selected source top beyond make_fg into root solve,
then connect its results to certificate/codec and full B1. No mathematical
NTT/CRT/root/table/centering/Montgomery/integer law, full KeyGen/Sign/
compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain their prior scope.
