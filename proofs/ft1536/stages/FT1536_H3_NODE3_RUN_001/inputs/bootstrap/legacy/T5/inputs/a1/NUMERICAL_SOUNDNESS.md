# Numerical soundness of the KeyGen leaf bridge

The active KeyGen acceptance test is evaluated by the committed emulated-FPR
implementation.  The theorem therefore needs a proved bridge from those
machine values to the exact Fourier/LDL leaves; a binary64 observation alone
would be only experimental.

## Twiddle audit

`FFT_TWIDDLE_AUDIT.json` independently reconstructs all source-used FFT3
twiddles as 4608th roots of unity.  It checks:

- all 255 square-stage twiddles;
- all 256 cubic-stage twiddles;
- the six fixed constants used by the implementation;
- the source's bit-reversal exponent patterns.

Every stored real and imaginary component differs from the exact root by less
than `2^-50`.  The two exponent-map digests are frozen in the audit and in the
uniform verifier.

## Forward-error recurrence

The source-bound backend implements correctly rounded binary64 arithmetic.
The verifier uses exact rationals with unit roundoff `u=2^-53`, twiddle error
`eps=2^-50`, and the conservative absolute subnormal floor `2^-1074`.

It propagates absolute component error through exactly eight degree-doubling
passes and the final ternary pass, following the committed `FPC_MUL`,
`FPC_SQR`, `FPC_ADD`, and `FPC_SUB` paths.  The result is

`FFT component error < 2^-29`.

Using the exact unit-root evaluation bound `|component| <= N = 1536`, the same
model propagates through the two squared norms and their final sum and proves

`|g00_exact - g00_computed| < 1/64`.

## LDL and reciprocal leaves

An accepted machine root is at least `1/2`.  The preceding absolute error
therefore places the exact root between `31/32` and `33/32` times the computed
root.  Exact symbolic Sage identities verify the recursive pivots:

- binary: `(a+b)/2` and `2ab/(a+b)`;
- ternary: `e1/3`, `e2/e1`, and `3abc/e2`.

The outward rounding envelope covers the ternary top level, all eight binary
levels, and the final rounded reciprocal `q^2/D`.  Applied to the exact
binary64 value of the committed minimum-leaf constant, it proves

`every exact block leaf > 992.0003083424699... > 991`.

The verifier deliberately uses the conservative integer lower bound 991.

## Exactness classification

All theorem comparisons are integer/rational or exact symbolic Sage checks.
The displayed 512-bit real-ball values are rigorous outward enclosures used
only to make the exact results readable.  No ordinary binary floating-point
observation promotes a claim.
