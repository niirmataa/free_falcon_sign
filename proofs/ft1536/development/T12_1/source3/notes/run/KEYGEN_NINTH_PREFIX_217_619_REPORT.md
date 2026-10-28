# R1 selected d=9 entry, layout and move — checkpoint 619

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The actual ninth make_fg_step entry and source parts0/1 are linked to the
constructed d1..d8 source calls and d9 true guard. Its argument out_ntt=0 is
constructed from the actual selected caller: d+1=10 makes d+1<depth10 false,
and outer out_ntt0 is preserved. The later true !out_ntt branch requires
actual inverse-output execution and is not proved by this checkpoint.

Original declarations and assignments establish n2/hn1. Source reads of
MAX_BL_SMALL3 bind depth9/depth10 to slen166/tlen335. The actual pointer
layout has fd670, gd1005, fs1340, gs1672, gm2004, igm2006 and t12008;
new output arrays have335 words apiece. Previous d8 source gd1002 differs
from new gd1005; the proof explicitly reads the previous root.

The original overlapping2656-byte move copies both contiguous332-word input
arrays into new fs/gs and supplies exact word images on the same source
execution witness. No desired source run or output is a premise of the
concrete selected export. This proves executed-word source behavior, not a
mathematical NTT or CRT law.

Canonical keygen_ninth619_canonical accepted7/7, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and68 axiom results use only
propext/Classical.choice/Quot.sound. Lean time44.763s; maximum cumulative child
RSS4266712 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Independent review: NOT_RUN.

Seven local attempts accepted without failures. Earlier retained findings
remain; no new mathematical counterexample, memory/resource failure,
linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all251 predecessor618 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next620: actual d9 computational body and true !out_ntt inverse-output
branch. Root/certificate/codec and full B1 remain open. No mathematical
CRT/centering/Montgomery/NTT/root/table/integer law, broad KeyGen/Sign/
compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain their prior scope.
