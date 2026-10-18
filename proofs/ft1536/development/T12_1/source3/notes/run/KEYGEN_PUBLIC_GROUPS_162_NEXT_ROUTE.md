# Next after162

PublicGroupLoop162.source gives the complete group loop from Fixed,
u1=start and v1=start*(2*ht), ending at m. Fixed requires m*(2*ht)=1536,
m<=512, the real scalar slots and arrays, initialized input/table cells,
legal allocation and distinct data/table blocks; it assumes no table value.

Next163: declare ht/u1/v1 in each outer round, compute ht=t>>1 using the
existing C99OuterScalar144.half_word, set both group counters to0, consume
GroupLoop162, set t=ht, restore the scope and double m using the existing
C99ControlShift142.double_word. Certify the finite eight-round schedule
768/2 down to3/512 in the kernel. PublicRoundContext163 and
PublicRoundSetup163 are prepared, not accepted at this checkpoint.

After the outer loop: tripling512, preservation of both generated tables,
actual caller composition and the second forward invocation. Then public
nonzero tests/division/inverse/return, solver/certificate/codecs and G(seed*).
Generic source-domain theorems do not instantiate the seed witness by
 themselves. Preserve corrected134 and the measured/proved distinction.
