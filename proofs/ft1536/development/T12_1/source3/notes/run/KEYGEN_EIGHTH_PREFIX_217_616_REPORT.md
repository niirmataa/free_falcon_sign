# R1 selected d=8 entry, layout and move — checkpoint 616

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The actual eighth make_fg_step entry and source parts0/1 are linked to the
constructed d1..d7 source calls and d8 true guard. Original declaration
and assignments establish n4/hn2. Source reads of MAX_BL_SMALL3 bind
depth8/depth9 to slen82/tlen166. The real source pointer layout has fd670,
gd1002, fs1334, gs1662, gm1990, igm1994 and t11998; new output arrays have
332 words apiece. Previous d7 source gd998 differs from new gd1002; the
proof explicitly reads the previous root.

The original overlapping2624-byte move copies both contiguous328-word input
arrays into new fs/gs and supplies exact word images on the same source
execution witness. No desired source run or output is a premise of the
concrete selected export. This proves executed-word source behavior, not a
mathematical NTT or CRT law.

Canonical keygen_eighth616_canonical accepted7/7, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and68 axiom results use only
propext/Classical.choice/Quot.sound. Lean time48.323s; maximum cumulative child
RSS4438932 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Independent review: NOT_RUN.

Seven local attempts accepted without failures. Earlier retained findings
remain; no new mathematical counterexample, memory/resource failure,
linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all260 predecessor615 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next617: actual d8 first-prime loop u0..81, then CRT and extra-prime
u82..165. Later d9, root/certificate/codec and full B1 remain open. No
mathematical CRT/centering/Montgomery/NTT/root/table/integer law, broad
KeyGen/Sign/compiler/security or unconditional positivity/probability is
claimed. Old110/measured/five do_sign retain their prior scope.
