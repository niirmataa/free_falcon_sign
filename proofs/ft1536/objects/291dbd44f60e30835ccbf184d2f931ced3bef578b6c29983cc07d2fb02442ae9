# Formal KeyGen attempt model

## Deterministic interfaces

`SampleTernary(tape)` returns 1536 coefficients.  It consumes successive
little-endian 64-bit words, then 2-bit chunks, rejects 3, and maps 0/1/2 to
-1/0/+1.

`Trial(tape_suffix)` performs:

1. `f <- SampleTernary`;
2. `g <- SampleTernary`;
3. `R_f <- mod2_res_ternary(f)`; reject `RESULTANT_F` if zero;
4. `R_g <- mod2_res_ternary(g)`; reject `RESULTANT_G` if zero;
5. evaluate the raw FFT3 norm; reject `RAW_NORM` unless strictly below bound;
6. evaluate the orthogonalized FFT3 norm; reject `GS_NORM` unless strictly
   below bound;
7. compute `h`; reject `PUBLIC` if an NTT coordinate of `f` is zero mod q;
8. solve the NTRU equation; reject `SOLVE` on deterministic failure;
9. derive and validate the LDL leaf array; reject `LEAF_CERT` on failure;
10. otherwise return `(f,g,F,G,h)`.

`KeyGenCall(tape)` runs at most 3,000,000 trials, returns the first successful
tuple, then applies the deterministic private/public encoders.  Failure modes
outside the trial loop are `RNG`, `ATTEMPT_LIMIT`, `PRIVATE_ENCODING`, and
`PUBLIC_ENCODING`.

## Arithmetic labels

| Stage | Arithmetic actually used |
|---|---|
| ternary sample | exact bit operations and rejection |
| mod-2 resultants | exact GF(2) bit operations |
| raw/GS norms | committed emulated-FPR implementation |
| public key | exact modular NTT over q=18433 |
| NTRU solve | mixed exact integer/modular plus committed reduction path |
| leaf certificate | committed emulated-FPR FFT3/LDL and bit comparisons |
| encoding | exact integer/bit encoding |

No binary64 observation is promoted to an exact mathematical predicate; the
committed emulated-FPR code path itself defines the two norm and leaf events.

## Distribution labels

- `D0_ideal`: product-uniform ternary pair under an infinite ideal tape.
- `D1_ideal`: `D0_ideal` conditioned on the full deterministic acceptance
  event.
- `Dpk_ideal`: public-key pushforward of `D1_ideal`.
- `Dseed_real`: actual operating-system 256-bit seed law.
- `Dpk_real`: deterministic seed-to-SHAKE-to-KeyGen public-key pushforward.

These labels must never be silently identified.
