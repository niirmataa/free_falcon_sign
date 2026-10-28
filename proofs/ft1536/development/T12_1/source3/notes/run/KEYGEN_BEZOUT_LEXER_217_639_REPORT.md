# R1 Bezout part7 compositional lexer — checkpoint 639

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

Exact source lexer steps for the header, comment and guard are assembled into
a kernel proof that the pinned prefix from lines4015–4022 tokenizes correctly
for arbitrary following source text. The proof covers the actual fuel expression
and type normalization. The actual 185-line part7 input is decomposed into this
prefix and the remaining source; the existing nonvacuous parser audit then yields
an actual successful token stream beginning with the pinned normalized prefix.
This closes the arbitrary-tail tokenizer gap recorded in638, without expanding
the huge parsed loop or raising the limits.

The successful token stream is NOT yet linked to the precise part7 loop/branch
AST; execution of part7, either branch and termination remain unproved. Selected
guard truth and full Bezout outcome remain open.

Canonical keygen_lexer639_canonical accepted10/10, exit0, diagnostics0/0,
warningAsError; 33 axiom results use only propext/Classical.choice/Quot.sound.
Lean time 898.942s; maximum cumulative child RSS 2246080 KiB. One Lean job, -j1,
-M6144, unchanged AS/RSS/wall budgets and bwrap --unshare-net were maintained.
Some sources use maxRecDepth262144 as established; no memory limit raised.
Independent review: NOT_RUN.

Fourteen local attempts retain five elaboration failures (full-chunk reduction,
two take_add invocation errors, a reserved name, and a case equality mismatch).
Factoring into small lexer equations passed under unchanged limits. Raw snapshots,
logs and all earlier retained findings remain; no mathematical counterexample or
failed lane-cache artifact is claimed.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all202 predecessor638 bindings verified.
Python handles scaffolding/jobs/hashes; source execution and arithmetic are
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. Local source commit is not independent acceptance.

Next640: use generic parser-prefix lemmas and actual tokens to establish precise
part7 structure, then actual loop and branch execution, full Bezout and B1.
No mathematical NTT/CRT/root/table/centering/Montgomery/integer law, full
KeyGen/Sign/compiler/security or unconditional positivity/probability is claimed.
Old110/measured/five do_sign retain prior scope.
