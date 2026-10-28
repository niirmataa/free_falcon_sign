# R1 selected deepest unsigned CRT call — checkpoint 625

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The actual first source statement of solve_NTRU_deepest part3 executes the
unsigned zint_rebuild_CRT call on the selected fp/gp outputs of make_fg. The
callee runs its original num2, xlen=xstride335 source co-loop and the false
normalize_signed branch. The two caller sections are joined into one670-word
input; source-bound prime rows, readonly prime object, scratch allocation,
writability and separation are established from the actual selected state.
The same execution witness exports the exact reconstructed670-word image,
with caller locals/arrays/tables preserved; a checked split maps it back to
fp/gp. No desired source run/output is assumed. No mathematical CRT or
resultant identity is claimed.

Canonical keygen_deepcrt625_canonical accepted5/5, exit0, diagnostics0/0,
warningAsError. Four checked interfaces and20 axiom results use only
propext/Classical.choice/Quot.sound. Lean time50.0s; maximum cumulative child
RSS5310916 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Source uses maxRecDepth262144 inherited
from602; no memory limit was raised. Independent review: NOT_RUN.

Seven local Lean attempts were accepted. One additional runner preflight007
failed before Lean because a diagnostic source was moved while the lane
cache referenced it; the byte-identical source was restored and its record
and preflight metadata retained. No rebaseline. Supplement
KEYGEN_CRT_DEPTH_LABEL_618_622_SUPPLEMENT_625.md corrects copied comments in
sealed618/622; earlier source and evidence remain unchanged. No new
mathematical counterexample, resource failure, linter suppression or failed
lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all74 predecessor624 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next626: execute the original zint_bezout call and success/failure source
branch on the reconstructed inputs, without assuming the desired outcome.
Remaining root/certificate/codec and full B1 stay open. No mathematical
NTT/CRT/root/table/centering/Montgomery/integer law, full KeyGen/Sign/
compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain prior scope.
