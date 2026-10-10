#017 — route update: avoid an enormous exact convolution

At base32d2639a, normalizer≤4300000 and actual zero_mass/CubeLeaf now
have kernel proofs. For rejection/raw, the following route is ACTIVE:

1. Certify one Gaussian sequence exp(-k²/2359296), k=0..30720, by384-bit
   dyadic lower/upper bounds. Step t=(2k+1)/2359296<1/32 uses a positive
   Taylor polynomial with48 terms and a kernel upper remainder2^-400.
   Generate integer recurrence certificates and check every row in Lean.
2. Compare actual CDF differences and actual thresholds against these bounds:
   W/2^256 within1±2^-108 of the coordinate Gaussian; V/2^256≤Gaussian
   everywhere, and≥(1−2^-108)Gaussian for |s|≤15360. Verify actualCDF increase.
3. Prove exact modulo/CDF count laws. S/2^384≤2^-115 and S/2^256≤2723
   can be checked on the actual terminalCDF literal.
4. Kernel Gaussian lower mass≥4200000 and discarded central-triangle mass
   ≤2^-130*g1. A quarter-temperature fixed A2 bound proves the latter;
   this is NOT an extra temperature assumed in(M).
5. The lower accepted mass gives alpha≥9/16 and the raw normalized density
   ≤1+2^-100. No exact high-precision alpha or pi and no30721² enumeration
   is then needed in the kernel.

Alternative retained: exact packed convolution via ROM PackedConvolution.
Its soundness exists; applying it to30721 terms would create multi-megabit
integer products and additional cost. It is DEFERRED pending the cheaper
sandwich discriminator, not refuted or silently treated as proved.
Sage will first test whether the proposed integer certificate actually passes
all literals. A false comparison is retained and changes this route.
