# R1 intermediate checkpoint 581: generic generator row engine

2026-10-26. **PROVED_KERNEL_SCOPED / NOT_REVIEWED**. Overall owner goal
IN_PROGRESS; continue immediately after this local checkpoint, no handoff,
context freeze, push or subagent. WYKONANE: seven proof modules and one
type/axiom audit. PRZETESTOWANE: canonical8/8, diagnostics0/0,
warningAsError, markers/suppressions0. NIEZALEZNIE ODEBRANE: NOT_RUN.

MkgmParams198 covers every remaining full=0 generator level logn1..9:
Level=Fin9, logn=l+1, half=2^l, count=2*half, shift=10-l. The REV10
row permutation is reverse9(2^(shift-1)*u). Kernel decisions prove its
bounds and involution over ALL510 indices across this finite level family;
surjectivity follows with an explicit inverse. This is a kernel proof of
the entire stated finite domain, not a sample or external test.

MkgmRowIndex198 proves the actual uint64 shifted-index evaluation,
REV10 pointer/read and destination index half+reverse(u). The shift count
and all pointer bounds are derived. MkgmRowFixed198/Store198/Body198 execute
the same original row stores, Montgomery assignments and scoped body for
arbitrary level/prime words, with allocation restricted to count cells.
No alternate arithmetic or transform property replaces those operations.

MkgmRowInit198 proves initialization at the four actual row-write cells.
MkgmRowLoop198.full constructs the original complete lastRowLoop for
logn2..9 (the logn1 branch is separate): initialize u=0, run half/2 source
iterations with increment2, and prove the final guard false. The same
output has the fixed fields, final u=half and ALL gm/igm cells in
[half,count) initialized. Coverage is derived from the proved REV10
permutation and executed stores. No pre-existing initialized upper-half
or target loop execution is assumed. The result is initialization and
executed words, not a root/table law or a complete generator yet.

Command:

```sh
python3 -B tools/job111.py lean keygen_mkgmrows198_581 \
  Source3.MkgmParams198 Source3.MkgmRowIndex198 Source3.MkgmRowFixed198 \
  Source3.MkgmRowStore198 Source3.MkgmRowBody198 Source3.MkgmRowInit198 \
  Source3.MkgmRowLoop198 Source3.MkgmRowAudit198
```

8/8 accepted; elapsed sum44.879s, cumulative child maxRSS3530976 KiB.
Seven proof stdout/stderr and audit stderr are empty; audit stdout keeps
9 original types and12 axiom results. Three reversal declarations use
propext only, covered uses propext/Quot.sound; all other lists stay within
propext/Classical.choice/Quot.sound. No linter disabled, limit increased
or failed product imported into the lane cache. -j1/-M6144,
maxHeartbeats2000000/maxRecDepth32768, AS12GiB/RSS8GiB/wall1800s and bwrap
isolation retained. No competing process in canonical PREFLIGHT.
No Sage job: these are kernel-checked finite index/source-store facts.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 before/after,0 missing/changed. Parent580 evidence104/104
before/after, no re-baseline or predecessor edit. The initial copied
verifier log kept stale parent579 display labels8/8 and15; its104 hash
checks were real. That log is retained unchanged. Corrected supplemental
and final logs identify actual parent580 canonical5/5 with11 axiom results.
This organizer-label correction changes no proof or pin.

Four failed/partial local attempts among seven remain in the FAILURES
register and .build/generator581, with snapshots, receipts, logs and local
accepted products:
001 opaque lastIndex in the modulo bound;003 duplicated level argument
and an old next-index helper in the mechanical body adapter;005 repeated
reserved prefix-binder parser trap;006 opaque Fin.val and body aliases in
coverage/scope proofs. Fixes expose the correct projections/identifiers;
002/004/007 accept all requested local modules, logs0/0. Cascaded compiler
placeholder diagnostics in the failed body are retained, with no explicit
proof placeholder in the source and no failed product reused. Historical
65+58+4/finding and all575–580 registers remain unchanged.

Next582 is already active: generic scalar power/prelude, row branch,
descending square loop and top elements, then bind that complete generator
to d=2. Subsequent prime/NTT/reduction/CRT loops, later d levels and
root/certificate/codec remain OPEN. No full KeyGen/Sign/compiler/security,
closed-form NTT/root/table or Z>0/p_accept/p_K/Z>=2^-256 claim. Old110,
measured wording and five do_sign obligations unchanged. No stages/C edit
or migration. Foreign run2-reference/Dokumenty/threshold files and the
active next-phase199 drafts are excluded from this checkpoint.
Eleven waiting commits plus this one = twelve, without push; work continues.

## Count supplement before the intermediate checkpoint

The full logn1..9 family contains **511** (level,index) pairs; 510 is the
count for the non-special logn2..9 row-loop family. The earlier paragraph's
510 was a prose count carried from that narrower range. Kernel decisions
quantify over Level=Fin9 and Fin(half level) throughout, so their complete
coverage and all source proofs are unchanged. The initial report bytes
are retained in .build/generator581/REPORT.initial.md.
