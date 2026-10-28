# R1 selected d4 complete first-prime loop — checkpoint 605

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

From the actual completed d1/d2/d3 executions, the fourth call binding and
original part0/part1 prefix, the original part2 first-prime loop executes
all six PRIMES3 rows u0..5 at n64/hn32, slen6/tlen12. Each iteration binds
the real p/g table words, executes the p0i/R2 and ternary generator source,
copies both64-word columns at stride6, runs both32-word product marches
at stride12 and both inverse NTT3 source columns at Level5. Both actual
conditional skips and the loop exit u=6 are constructed.

A bounded inductive invariant connects pending source rows, written fd/gd
product columns and inverse fs/gs rows, with the chosen per-row generator
tables on one common output witness. All six columns on each product array
and both complete384-word inverse images are exported together, with the
readonly prime and REV10 objects. No successful source run, desired word
image or transform property is assumed by the selected concrete export.

Canonical keygen_fourth605_canonical02 accepted16/16, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and109 axiom results use only
propext/Classical.choice/Quot.sound. Lean time52.820s; maximum cumulative
child RSS3669548 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall budgets
and internal bwrap --unshare-net were maintained. Independent review: NOT_RUN.

Fourteen local attempts retain two failures:004 accepted the per-side column
but the pair exceeded the -M6144 kernel memory ceiling while redundantly
rewriting the s8 source shape; using the already checked s8 theorem fixed
it with no limit change.010 required explicit addr/elem pointer-association
bridges; no mathematical counterexample or failed lane-cache artifact
occurred. The initial canonical replay accepted16/16, but a source review
found six copied d3/logn7 comment labels; these were corrected in the
unsealed605 sources and the entire selected closure was freshly replayed
in canonical02. The original replay and all raw attempts remain retained.

A separate supplement corrects the docstring immediately preceding the
sealed604 FourthStepPrefix216.part1 theorem, which says d3 although its
code and proof bind actual d4. Sealed604 bytes/evidence are unchanged.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after canonical02; all120 predecessor604
bindings verified. Python handles scaffolding/jobs/hashes; source execution
and arithmetic are kernel checked. No re-baseline, production C change,
migration, stages, reviewer start or push. A local source commit is not
independent acceptance.

Next606: actual d4 CRT pair, extra-prime loop u6..11 and complete d4 body/
caller return; then later d5..9, root/certificate/codec and full B1. These
are exact executed-word images, not a mathematical NTT/root/table/CRT/
centering/Montgomery/integer law or a full KeyGen/Sign/compiler/security or
unconditional positivity/probability claim. Old110/measured/five do_sign
retain their prior scope.
