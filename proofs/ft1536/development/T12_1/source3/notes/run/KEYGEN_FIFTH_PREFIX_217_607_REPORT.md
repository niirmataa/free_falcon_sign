# R1 actual d=5 entry and changed-layout move — checkpoint 607

Status: PROVED_KERNEL_SCOPED / NOT_REVIEWED. Overall source-to-fiber B1
remains IN_PROGRESS; continue after this local checkpoint.

The original fifth make_fg_step call is bound from the actual fourth
return and d4-to5 true guard. Its scalar arguments are logn5/depth5 and
ter/in_ntt/out_ntt1; both384-word arrays produced by the completed d4
execution are available at the fifth entry. Earlier source executions and
output words are constructed by the theorem rather than assumed.

The original part0/part1 declarations and prefix execute with n32/hn16.
The source reads MAX_BL_SMALL3[5]=12 and [6]=22 from the pinned readonly
table and binds slen12/tlen22. The new scratch roots are fd670, gd1022,
fs1374, gs1758, gm2142, igm2174 and t1=2206. The source data still use
the previous d4 fd670/gd1054 layout: new gd1022 is proved distinct from
previous gd1054 and is not substituted for that previous source.

The actual overlapping 3072-byte memmove is executed with byte
initialization and extent/writability from the actual caller. Both moved
384-word fs/gs images are exported at one output. This explicitly handles
the changed output-array size 352 while copying two previous384-word
arrays; the source and new destination layouts are distinct.

Canonical keygen_fifth607_canonical accepted7/7, exit0, diagnostics0/0,
warningAsError. Six checked interfaces and68 axiom results use only
propext/Classical.choice/Quot.sound. Lean time24.402s; maximum cumulative
child RSS4355932 KiB. One Lean job, -j1, -M6144, unchanged AS/RSS/wall
budgets and bwrap --unshare-net were maintained. Independent review: NOT_RUN.

Five local Lean attempts were accepted with no failures. Earlier retained
findings remain recorded; no mathematical counterexample, resource failure,
suppression or failed cache was observed in607.

ENTRY_PINS00f602e751e7324b9628cb753c537941858acac44371d7949e400f97a2573964:
74673/74673 unchanged before/after; all278 predecessor606 bindings verified.
Python handles scaffolding/jobs/hashes; source execution/arithmetic is
kernel checked. No re-baseline, production C change, migration, stages,
reviewer start or push. A local source commit is not independent acceptance.

Next608: d5 first-prime generator/copy/product/inverse loops, then CRT,
additional primes, complete d5 return, later d6..9/root/certificate/codec/
full B1. This checkpoint does not execute the d5 computational body and
establishes no mathematical CRT/NTT/root/table/centering/Montgomery/integer
law, broad KeyGen/Sign/compiler/security or unconditional positivity/
probability. Old110/measured/five do_sign remain unchanged.
