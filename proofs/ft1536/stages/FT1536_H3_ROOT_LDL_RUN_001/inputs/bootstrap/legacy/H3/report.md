# S20-H3 reachable exponent bridge — OPEN executor bundle

The complete production exponent/BerExp arithmetic is certified only under
an explicit integer-center premise.  H3 remains `OPEN`: the committed signer
has no source-derived or runtime bound before converting `fpr_floor(mu)` to
`int`, and no checked `s+z`.  This bundle performs no review, sets no
`ACCEPT`, and changes no production source.

## Corrected conditional arithmetic result

The certificate covers every H4 width, both terminal calls (including
`2/sqrt(3)`), all five banks and exact table supports, all source-reachable
binary64 fractional states, subnormals, all 394 exponent bands, cutoff and
the 55-bit comparator.  It uses a monotone whole-domain partition; the
historical H3 grid is not proof.

| item | certified log2 upper bound |
|---|---:|
| global chain plus center-split displacement | -43.2441059 |
| main-region chain plus center-split displacement | -45.2773722 |
| main range-reduction displacement | -47.6656431 |
| main relative likelihood defect | -44.9362286 |
| accepted-submeasure L1 defect including cutoff | -44.9362260 |
| normalized scalar TV using H1R `9/20` floor | -43.7842229 |
| 3072-call conditional TV union | -32.1992604 |
| 16-trial with-bot conditional TV union | -28.1992604 |

The source cutoff is exact: BerExp quotient `s>=64` accepts with probability
zero.  The omitted exact probability is pointwise below
`2^-63.9999999999998`.  Seventeen range-reduction residuals above stored
`fpr_log2` are replayed independently under the H2 `2^-50` budget.  The
comparator spacing remains `2^-55`, with half-step floor `2^-56`; E1's refit
and E2's U72 path are not deployed.

## Fractional split correction

An integer-safe floor does not imply exact `r=mu-s` or `r<1`.  For
`mu=-2^-1074`, emulated `fpr_floor` gives `s=-1`, while the exact fractional
part is `rho=1-2^-1074` and the committed subtraction rounds to `rhat=1`.
The revised theorem therefore uses

```text
rho  = mu-floor(mu) in [0,1),
rhat = RN(rho) in [0,1].
```

It compares production directly with the exact H1R kernel at `rho`, charging
`|rhat-rho|<=u+eta` and branch-one delta error `<=2(u+eta)`.  This preserves
centering at the original target `mu`; no false exact-subtraction premise
remains.

## Integer reachability result and remaining gap

The sufficient current-support contract is

```text
-2147483283 <= floor(mu) <= 2147483281,
```

equivalently `-2147483283 <= mu < 2147483282`.  The committed source checks
only `finite(mu)`.

The relational audit distinguishes the signer-accepted population from
canonical KeyGen.  Exact NTRU gives `d11=q^2/g00` and
`t0+t1*L=H*adj(g)/g00`, but the actual root center uses a sampled residual.
The accepted shear `(F,G)->(F+kf,G+kg)` preserves NTRU and H4, changes
`L->L+k`, and changes the actual root center by `-k*y1`.  Thus a canonical
Babai claim cannot be imported into all decoded keys.

The correlation-aware coarse root calculation gives:

| population/cap | root residual product upper | relation to `INT_MAX` |
|---|---:|---:|
| canonical KeyGen, `2047` | 2,114,107,003.079... | 98.4458% |
| signer uncompressed, `9216` | 9,518,129,037.800... | 4.4322x |
| signer static/int16, `32768` | 33,842,236,578.845... | 15.7590x |

The canonical row has only about 27.1 million remaining after even a coarse
initial-target term, with no certified allocation for internal tree/ring/FP
error.  KeyGen's final Babai quotient is promising, but no uniform
FFT3/iFFT3/division/round/subtraction error certificate is exported and the
signer does not retest canonicality.  Plain independent intervals lose the
Schur/Babai correlations.  Therefore no constructive whole-population center
bound is claimed.

`CENTER_BOUND_AUDIT.md` records the required seven-stage workflow and all
rejected paths.  `CENTER_REMEDIATION_CONTRACT.md` specifies a minimal future
pre-floor gate, widened checked addition and sticky fault-to-bot path.  The
separate task is `S20-H3G-CENTER-RANGE-GATE-001-PLANNED`, status `OPEN`.

The R3G-facing statement is `h3_theorem.tex`.  It is consumable only with the
named integer premise (or after the future guarded-source task is separately
implemented, replayed and reviewed).
