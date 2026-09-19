# Center/floor reachability and fractional-split audit

H3 remains `OPEN`.  This audit separates two distinct issues that must not be
collapsed: integer reachability of `fpr_floor(mu)`/`s+z`, and binary64
rounding of `r = mu-s` even when the integer conversion is safe.

## A. Integer center reachability

### PROBLEM

`sampler_large` declares `int s`, checks only that `mu` is finite, assigns
`s = fpr_floor(mu)`, and later returns `s + z`.  The emulated floor routine
returns `long`; finite binary64 input alone neither makes the `long -> int`
conversion safe nor prevents signed overflow in `s+z`.

### INTERPRETACJA / INTERPRETATION

The parsed tables give the complete proposal range `z in [-365,366]`.
Therefore the exact sufficient 32-bit contract is

```text
-2147483283 <= floor(mu) <= 2147483281,
```

equivalently the half-open pre-floor interval

```text
-2147483283 <= mu < 2147483282.
```

This contract makes the floor conversion and every current proposal sum
integer-safe.  It says nothing by itself about exactness of the subsequent
binary64 subtraction; that is Problem B below.

### MOŻLIWOŚCI / POSSIBILITIES

1. Derive a whole-population analytic bound from hash, accepted-key, FFT/LDL
   and `ffSampling` structure.
2. Use the NTRU determinant/Schur identities and KeyGen's final Babai
   quotient to obtain a much smaller relational root multiplier.
3. Propagate correlation-preserving intervals through the complete expanded
   tree and all sampling recursions.
4. Add a future pre-floor range gate and widened checked `s+z`, with a sticky
   fault that reaches explicit bot.
5. Retain the displayed interval as a named theorem premise.  This keeps the
   arithmetic result usable conditionally but does not close H3.

### OGRANICZENIA / CONSTRAINTS

The source has two different key populations.

- **Signer-accepted population.**  The signer checks `f,g in {-1,0,1}` and
  the exact relation `fG-gF=q`.  H4's stable leaves depend only on `f,g`.
  Uncompressed decoding admits exactly `[-9216,9216]`; static decoding stores
  into `int16_t`, for which a safe absolute cap is `32768`.  No signer check
  requires the loaded `(F,G)` to be the Babai-reduced representative emitted
  by KeyGen.
- **Canonical KeyGen population.**  KeyGen additionally applies its final
  floating Babai quotient and rejects unless `|F_i|,|G_i|<=2047`.  A proof
  about that path must certify the floating quotient/iFFT/round/subtraction
  circuit uniformly; one generated key is only a diagnostic.

For exact ring evaluations set

```text
g00 = |g|^2 + |f|^2,
g10 = G*adj(g) + F*adj(f),
L   = g10/g00,
g11 = |G|^2 + |F|^2.
```

The NTRU identity gives the exact Schur cancellation

```text
d11 = g11 - |g10|^2/g00 = q^2/g00.
```

It also gives, for the root targets `t0=-H F/q`, `t1=H f/q`,

```text
t0 + t1*L = H*adj(g)/g00.
```

These identities are useful but do not directly bound the actual root center
`t0+r1*L`, where `r1` is the residual returned by the second subtree.

The accepted-key shear makes the quantifier issue explicit.  For any integer
ring polynomial `k`,

```text
(F,G) -> (F+k*f, G+k*g)
```

preserves the NTRU relation and H4 leaves, while

```text
L -> L+k,       t0 -> t0-k*t1,       d11 -> d11.
```

If the second subtree returns `r1=t1-y1`, with integer lattice coordinate
`y1`, the actual root center transforms as

```text
c0=t0+r1*L  ->  c0-k*y1.
```

Thus the fractional sampling law is shear-equivariant, but absolute
`fpr_floor` reachability is not.  Importing the canonical Babai property into
the broader signer-accepted population would be a quantifier error.

Finally, the signer computes `d11` and all internal multipliers through the
subtractive floating `ffLDL_fft3`; replacing only the terminal leaves by the
stable H4 construction does not replace those internal multipliers.  Any
Schur-based proof must also bound that floating cancellation.

### ROZWIĄZANIA / SOLUTIONS

No committed-source solution is established here.  The conditional H3
theorem uses the exact integer interval as a named premise.  The minimal
future fail-closed solution is specified in
`CENTER_REMEDIATION_CONTRACT.md` and in the separate planned task
`S20-H3G-CENTER-RANGE-GATE-001-PLANNED`; this bundle does not modify source.

### PRÓBY RÓŻNYCH ŚCIEŻEK / ATTEMPTS ALONG DIFFERENT PATHS

**Coarse positive-Gram energy path.**  Reversing the positive H4 leaf map
loses at most `3*2^8`, hence

```text
g00(root) >= D_min/(3*2^8) = 1.3333337477...
```

At a ternary base, the second scalar residual is at most `366` and the first
returned residual at most `366+366/2=549`.  With the canonical KeyGen cap,

```text
||L||_2 <= sqrt(2*1536*2047^2/g00_min) = 98255.98...,
||L||_2 * (549*sqrt(1536)) = 2,114,107,003.079... .
```

This is `98.4458%` of `INT_MAX`.  Adding a coarse initial-target bound uses
another `6,288,042.852...` and leaves only `27,088,601.069...`, with no
certified allocation for internal multipliers, ring maps or floating error.
It is not a proof.  Repeating the same source-bound calculation for the
actual decoder caps gives `9,518,129,037.800...` for uncompressed keys and
`33,842,236,578.845...` for the broad static/int16 population, both already
above `INT_MAX`.

**NTRU/Schur path.**  The exact descendant spectra are generated from `g00`
and `q^2/g00`, which removes exact descendant dependence on the NTRU
representative.  The actual root residual term and floating subtractive tree
remain.  The shear formula above shows why Schur cancellation alone cannot
certify absolute centers for all signer-accepted representatives.

**Canonical Babai path.**  Let

```text
Q=(F*adj(f)+G*adj(g))/g00.
```

KeyGen computes a floating approximation `Qhat`, inverse-transforms it,
rounds an integer polynomial `k`, and subtracts `k*f,k*g`.  If a uniform
coefficient error `|Qhat-Q|<=epsilon_B` were proved, the exact final root
quotient would have coefficient bound `1/2+epsilon_B`, giving large center
margin.  The source exports no such certificate, comments that depth-zero
intermediates require floating point, and the signer does not retest the
property.  The path remains promising for the canonical KeyGen population
only, not proved here.

**Plain interval path.**  Independent component intervals discard Gram
positivity, the determinant identity and the Babai correlation, and blow up
past the integer boundary.  A valid second attempt needs affine/relational
intervals or an exact Schur rewrite, plus a binary64 error ledger for every
FFT3/LDL/split/merge operation.

**Finite/canonical-key probes.**  These can detect regressions but cannot
establish either population-wide quantifier.  They are not used as proof.

### WYNIK / POZOSTAŁA LUKA / RESULT / REMAINING GAP

There is no constructive whole-population center bound from the committed
gates in this bundle.  The accepted-key route is analytically too broad; the
canonical route lacks a uniform Babai and floating-LDL certificate.  Until a
relational proof or the separately reviewed fail-closed source gate exists,
the integer interval remains an explicit premise and H3 remains `OPEN`.

## B. Fractional split and the reachable value `r=1`

### PROBLEM

Even under the integer-safe interval it is false that
`r=fpr_sub(mu,fpr_of(floor(mu)))` is always the exact mathematical fractional
part or always lies in `[0,1)`.  The previous draft of the conditional bundle
made that false inference.

### INTERPRETACJA / INTERPRETATION

Let

```text
rho  = mu - floor(mu)          (exact real, 0 <= rho < 1),
rhat = RN(rho)                 (the committed fpr_sub result).
```

For `mu=-2^-1074`, the emulated floor is `s=-1`, exact
`rho=1-2^-1074`, and RN-even binary64 gives `rhat=1.0`.  Therefore the correct
computed domain is `rhat in [0,1]` and the universal split error is

```text
|rhat-rho| <= u*rho+eta <= u+eta,
u=2^-53, eta=2^-1075.
```

### MOŻLIWOŚCI / POSSIBILITIES

1. Keep claiming exact subtraction after the range gate.
2. Define the exact comparison kernel around computed `rhat` and ignore the
   drift from the original center `mu`.
3. Compare production directly with the exact kernel at `rho`, adding the
   split and `RN(1-rhat)` semantic displacement to H3's exponent ledger.
4. Restrict future centers to a domain on which subtraction is exact.

### OGRANICZENIA / CONSTRAINTS

H1R's exact-kernel theorem is uniform for `r in [0,1]`, so both `rho` and
`rhat` are legal parameters.  However the exact rejection identity centered
at the original scalar target uses `rho`, because `s+rho=mu`.  Choosing
`rhat` alone would produce an exact Gaussian centered at `s+rhat` and leave a
separate, uncharged center-drift bridge.  A restrictive exact-subtraction
gate would reject valid ordinary centers and still require delicate boundary
classification; it is not the minimal range remediation requested here.

### ROZWIĄZANIA / SOLUTIONS

The selected repair is Path 3.  For branch zero,

```text
delta=rhat,       |delta-rho| <= u+eta.
```

For branch one,

```text
delta=RN(1-rhat),
|delta-(1-rho)| <= 2*(u+eta).
```

Since all exact and computed deltas lie in `[0,1]`, the induced exact
exponent displacement is bounded uniformly by

```text
2*(u+eta)*(2*k+2)*d.
```

This term is separate from the seven-operation production rounding ledger.
The exact comparison kernel uses `rho`; hence its accepted integer is still
centered at the original `mu`.  No assumption `rhat<1` is used.

### PRÓBY RÓŻNYCH ŚCIEŻEK / ATTEMPTS ALONG DIFFERENT PATHS

- Path 1 is refuted by the minimum-negative-subnormal counterexample and is
  retained as a checker mutation.
- Path 2 is arithmetically valid for the first H3 arrow but insufficient for
  the intended signer target unless another center-drift theorem is added.
- Path 3 preserves the H1R interface and costs only a mixed absolute exponent
  term; it is implemented in the revised certificate/checker.
- Path 4 is future-only, stronger than necessary, and not selected.

### WYNIK / POZOSTAŁA LUKA / RESULT / REMAINING GAP

The `r=1` counterexample does not require a new source change: it can be
covered by the corrected mixed semantic ledger.  The revised conditional
arithmetic theorem must be replayed before any numeric bound is cited.  This
repair does not discharge Problem A; the integer center premise and H3's
`OPEN` status remain.
