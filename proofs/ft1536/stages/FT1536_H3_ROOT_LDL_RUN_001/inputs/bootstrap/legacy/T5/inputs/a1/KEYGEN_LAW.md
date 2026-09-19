# Exact KeyGen law and the uniform support theorem

## Ideal tape

The ternary sampler consumes disjoint 2-bit chunks, rejects value 3, and maps
0, 1, 2 to -1, 0, +1.  Under an infinite iid uniform bit tape, one trial
therefore samples independent uniform ternary polynomials `f` and `g`.

All subsequent trial predicates are deterministic: the two mod-2 resultants,
raw and orthogonalized norms, public-key computation, NTRU solve, and the leaf
certificate.  Conditional on a successful call, the first-accepted geometric
factor cancels, so the cap does not bias the accepted tuple distribution.

## Real implementation

The deployed caller obtains a 256-bit operating-system seed and deterministically
expands it with SHAKE-512.  Its public-key law is therefore a finite seed
pushforward, not an information-theoretic iid tape law.  No unproved
independence or entropy claim is made about that expanded stream.

## Why the distinction does not weaken this T5 result

The theorem is pointwise: every source-bound successful output must have
passed the same leaf certificate, and that certificate implies
`tau_h < 2^-40`.  A pointwise support theorem survives every distribution on
that support.  It therefore holds simultaneously for:

- the ideal accepted iid law;
- the real 256-bit-seed pushforward;
- every conditioning on successful completion of the call.

Thus `K_good` is the entire successful-output support and `delta_key=0`.
Seed quality and XOF assumptions remain relevant to other security claims,
but are not premises of this deterministic T5 implication.
