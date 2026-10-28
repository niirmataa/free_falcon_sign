# R1 conditional Bezout parser factoring — checkpoint 638

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The kernel checks three structural parser facts for arbitrary unparsed token
suffixes: the source guard parses to (alen>=3 || blen>=3), successful for(;;)
parsing constructs a loop with constant true guard, and successful if parsing
constructs a branch with the exact guard, including optional else. Separately,
the pinned source lines4015–4022 and their finite normalized token stream are
checked. These results avoid re-expanding the full part7 proof term.

The finite lexer prefix has NOT been connected to lexing arbitrary subsequent
text; therefore these facts do not yet prove the projection or execution of the
whole parsed part7. The attempted arbitrary-tail tokenizer proof encountered
an unavailable generated simplification equation for overlapping lexer patterns;
a structural proof remains necessary. No branch outcome or loop termination is
asserted. The fuel-count experiment is diagnostic only.

Canonical keygen_parser638_canonical accepted5/5, exit0, diagnostics0/0,
warningAsError; 5 axiom results use only propext/Classical.choice/Quot.sound.
Lean time 317.941s; maximum cumulative child RSS 2406636 KiB. One Lean job, -j1,
-M6144, unchanged AS/RSS/wall budgets and bwrap --unshare-net were maintained.
Some sources use maxRecDepth262144 as established; no memory limit raised.
Independent review: NOT_RUN.

Fifteen local attempts retain ten elaboration failures, including two on the
arbitrary-tail tokenizer; successful generic parser facts and finite prefix use
unchanged limits. Raw snapshots/logs and earlier retained findings remain; no
mathematical counterexample or failed lane-cache artifact is claimed.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all183 predecessor637 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next639: structural lexer-prefix compositionality and linkage to actual part7;
then original loop execution and complete Bezout. Root/certificate/codec/full
B1 remain open. No mathematical NTT/CRT/root/table/centering/Montgomery/
integer law, full KeyGen/Sign/compiler/security or unconditional positivity/
probability is claimed. Old110/measured/five do_sign retain prior scope.
