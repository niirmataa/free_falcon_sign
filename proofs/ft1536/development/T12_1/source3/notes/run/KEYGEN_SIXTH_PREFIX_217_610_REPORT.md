# R1 actual d=6 entry and changed-layout move — checkpoint 610

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The original sixth make_fg_step call is bound from the actual fifth return
and d5-to6 true guard. Its scalar arguments are logn4/depth6 and
ter/in_ntt/out_ntt1; both352-word arrays produced by the completed d5
execution are available at the sixth entry. Earlier source executions and
output words are constructed by the theorem rather than assumed.

The original part0/part1 declarations and prefix execute with n16/hn8.
The source reads MAX_BL_SMALL3[6]=22 and [7]=42 from the pinned readonly
table and binds slen22/tlen42. The new scratch roots are fd670, gd1006,
fs1342, gs1694, gm2046, igm2062 and t1=2078. The source data still use
the previous d5 fd670/gd1022 layout: new gd1006 is proved distinct from
previous gd1022 and is not substituted for that previous source.

The actual overlapping 2816-byte memmove is executed with byte
initialization and extent/writability from the actual caller. Both moved
352-word fs/gs images are exported at one output. This handles the changed
output-array size336 while copying two previous352-word arrays.

Canonical keygen_sixth610_canonical accepted7/7, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and68 axiom results use only
propext/Classical.choice/Quot.sound. Lean time29.437s; maximum cumulative
child RSS4817056 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall
budgets and bwrap --unshare-net were maintained. Independent review: NOT_RUN.

Five local Lean attempts were accepted with no failures. Earlier retained
findings remain recorded; no mathematical counterexample, resource failure,
suppression or failed cache was observed in610.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all250 predecessor609 bindings verified.
Python handles scaffolding/jobs/hashes; source execution/arithmetic is
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. A local source commit is not independent acceptance.

Next611: d6 first-prime generator/copy/product/inverse loops, then CRT,
additional primes, complete d6 return, later d7..9/root/certificate/codec/
full B1. This checkpoint does not execute the d6 computational body and
establishes no mathematical CRT/NTT/root/table/centering/Montgomery/integer
law, broad KeyGen/Sign/compiler/security or unconditional positivity/
probability. Old110/measured/five do_sign remain unchanged.
