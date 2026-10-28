# R1 selected d=7 entry, layout and move — checkpoint 613

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The actual seventh make_fg_step entry and source parts0/1 are linked to the
constructed d1..d6 source calls and d7 true guard. Its original declaration
and assignments establish n8/hn4. Source reads of MAX_BL_SMALL3 bind
depth7/depth8 to slen42/tlen82. The real source pointer layout has fd670,
gd998, fs1326, gs1662, gm1998, igm2006 and t12014; the new output arrays
have328 words apiece. The previous d6 source gd is1006, distinct from the
new gd998; the proof explicitly reads the previous root.

The original overlapping2688-byte move copies both contiguous336-word input
arrays into the new fs/gs and supplies their exact word images on the same
source execution witness. No desired source run or output is a premise of
the concrete selected export. This proves executed-word source behavior,
not a mathematical NTT or CRT law.

Canonical keygen_seventh613_canonical accepted7/7, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and68 axiom results use only
propext/Classical.choice/Quot.sound. Lean time30.88s; maximum cumulative child
RSS4353604 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets and
bwrap --unshare-net were maintained. Independent review: NOT_RUN.

Eight local attempts include one retained elaboration failure: attempt006
omitted two witnesses and shifted later binders; corrected in007. Raw
source snapshot and log remain preserved. This is no mathematical
counterexample. Earlier retained findings remain; no new memory/resource
failure, linter suppression or failed lane-cache artifact occurred.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all234 predecessor612 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next614: actual d7 first-prime loop u0..41, then CRT and extra-prime
u42..81. Later d8..9, root/certificate/codec and full B1 remain open. No
mathematical CRT/centering/Montgomery/NTT/root/table/integer law, broad
KeyGen/Sign/compiler/security or unconditional positivity/probability is
claimed. Old110/measured/five do_sign retain their prior scope.
