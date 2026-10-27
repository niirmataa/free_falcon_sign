# R1 d=3 body remainder: CRT transition and additional primes u=3..5 — checkpoint 602

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall B1 is IN_PROGRESS.
Owner decision 2026-10-27: Source3 modules are produced with real
proofs, zero markers, or not at all. Window 602 closes, in the
WORK_STATE/601-report order, the two remaining execution layers of the
d=3 make_fg_step body: the part-3 zint_rebuild_CRT pair and the part-4
additional-prime loop u = slen..tlen-1 = 3..5. The part-2/3/4 body
composition and the full-body audit remain OPEN for the next window.

## Part 3 — the fs/gs zint_rebuild_CRT pair (ThirdStepCrt215)

The two original calls `zint_rebuild_CRT(fs/gs, slen, slen, n, primes,
1, gm)` execute through the real call frames (Bind of the seven
parameters at xlen = xstride = 3 from the slen cell, num = 128 from the
n cell, tmp = gm into the fresh callee scope). The callee bodies run
the u/x declarations, the actual `tmp[0] = primes[0].p` block-21 store
word, the u = 1 init, the co-reduction loop `for (u = 1; u < xlen;
u++)` and the taken normalize branch (zint_norm_zero over all 384
words). The co-loop runs through the accepted generic one-round engine
CrtRound214.round_source driven by a new exact-room loop driver
(ThirdStepCrtLoop215): the 599 generic LoopInput demands roomL :
L+1 <= stride (one spare column), which cannot hold at the original
make_fg instance xstride = xlen; the driver restates the invariant with
the exact L <= stride bound (the last round at len = L-1 rewrites the
L words of each row) and reuses the accepted round/guard/increment
engines unchanged. This is a scope note on the 599 generic formulation,
not a source or domain change. The result images are the exact words3
executed-word families (rowAt/tmpAt compositions); only the fs/gs words
and the three gm scratch words are written (combined Keeps).

## Part 4 — the additional-prime loop u = 3..5 (ThirdStepExtra215)

Three counted iterations over the PRIMES3 rows 3..5 execute the
original loop body at the d=3 geometry: the seven-statement row prefix
with the new Rx = modp_Rx(slen = 3, p, p0i, R2) word (generic in the
loop index u and row v — ThirdStepExtraPrime215), the ter modp_mkgm3
generator, both zint_mod_small_signed walks over the 384 reassembled
fs/gs words, the taken modp_NTT3 forwards at Level 6 (logn 7, 128
words) and the Montgomery product marches into the fd/gd columns u at
tlen = 6 / hn = 64 (the u<6 march clone of the ThirdStepProduct215
instance which pinned u<3), and the false !out_ntt skip. The loop runs
from the u = slen = 3 initializer to the false u < 6 guard and
produces the three additional product columns with exact sWords
images, preserving the fs/gs images, every earlier column and the
readonly PRIMES3/REV10 facts (LoopKeep).

## Validation

Canonical replay keygen_crt602_canonical accepted 9/9, exit 0,
diagnostics 0/0, warningAsError, ~128s total Lean time, maxRSS
4649660 KiB: ThirdStepCrtLoop215, ThirdStepCrtBody215, ThirdStepCrt215,
ThirdStepExtraPrime215, ThirdStepExtraSide215, ThirdStepExtraPair215,
ThirdStepExtraInner215, ThirdStepExtra215 and ThirdStepExtraAudit215
(eleven checked public interfaces and eleven axiom results using only
propext/Classical.choice/Quot.sound). Marker scan 0
sorry/admit/native_decide across the eight new sources; no linter
suppression. Original limits and internal network isolation unchanged
(bwrap --unshare-net, -j1, -M6144). Independent review: NOT_RUN.

ENTRY_PINS 00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; predecessor 600 evidence 168/168,
599 113/113 and 597 133/133 bindings verified before and after the
first and the last 602 proof job (.build/body602/*.log).

## Retained failures

Twenty-five local attempts retain fifteen failures, all recorded in
the failure register: thirteen scaffolding/transfer defects (stray refine
arguments and field counts, the RoundInput uBound living inside the
prime component, Word32Memory176.source placeholder inference, an
Allocated construction at elem tmp 3 with the wrong block literal, the
SecondStepCopy203.root d=2 layout (gs@1950) versus the d=3 views
(gs@1822) needing a local croot, side-chain v-cell and argument-order
defects, the Image load word being a StepProductBody191.value pair,
implicit-before-decide argument ordering, let-state heap defeqs
needing explicit bridges, and a nested-by parse defect) and two
pinned -M6144 ceiling aborts ("failed to create thread") that forced
the ThirdStepExtraInner215/ThirdStepExtra215 split (the 601 March/Loop
pattern). No mathematical counterexample, resource race, suppression
or failed cache artifact occurred; every raw snapshot/log is retained
under .build/jobs/keygen_crt602_*.

## Scope and open work

Executed words only: no CRT, centering, Montgomery, NTT, root or
table law is proved, no desired output/run/certificate premise is
introduced, and executed-word formulas stay separate from unproved
mathematical laws. OPEN: ThirdStepBody215 (the parts 2/3/4 composition
from ThirdStepLoop215.body_run + ThirdStepCrt215.source +
ThirdStepExtra215.source plus the make_fg_step return), the full-body
audit, d=4..9 levels, root/certificate/codec and full B1. This
checkpoint is a local source commit, not an independent acceptance of
the overall target.
