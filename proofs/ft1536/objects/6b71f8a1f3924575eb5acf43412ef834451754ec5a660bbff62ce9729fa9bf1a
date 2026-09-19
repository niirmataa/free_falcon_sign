# Global leaf-to-A2 bridge

## 1. Exact objects

Let `N=1536`, `q=18433`, and

`R=ZZ[x]/(x^1536-x^768+1)`.

For `a in R`, let `M(a)` be multiplication by `a` in the power basis.  Let
`M_R` be the T1 canonical coefficient metric, with one block

`A2 = [[1,1/2],[1/2,1]]`

on every pair `(i,i+768)`.  Put `M=diag(M_R,M_R)`.

For a successfully emitted key, KeyGen has proved `f` invertible modulo `q`
and has produced `F,G` with `fG-gF=q`.  Define the column basis

`B = [[M(g),M(G)],[-M(f),-M(F)]].`

With `h=g/f mod q` and `A_h=[I,M(h)]`, both block columns of `B` lie in
`ker(A_h mod q)`.  Indeed,

`M(g)-M(h)M(f)=0 mod q`

and multiplication of the second identity by `M(f)` gives

`M(f)(M(G)-M(h)M(F))=M(fG-gF)=qI.`

Moreover `|det B|=q^N`, while the kernel of the surjective map `A_h` has
index `q^N`.  Hence the T1 lattice is exactly

`Lambda_h = B ZZ^(2N)`.

Consequently every dual vector is uniquely `w=B^(-T)z`, `z in ZZ^(2N)`, and

`w^T M^(-1) w = z^T (B^T M B)^(-1) z`.                 (1)

This is the required relation between the source trapdoor Gram matrix and the
T1 dual metric; it does not identify modular and Archimedean embeddings.

## 2. Integral coefficient tower

All domain changes used below are coefficient permutations.

At the top level,

`a(x)=a0(x^3)+x*a1(x^3)+x^2*a2(x^3)`

is a bijection of coefficient lattices from `ZZ^1536` to three copies of
`ZZ^512`.  At every deep level,

`a(x)=a0(x^2)+x*a1(x^2)`

is a bijection from `ZZ^m` to `ZZ^(m/2) x ZZ^(m/2)`.  These maps merely group
indices by residues modulo 3 and then by repeated parity.  Their matrices are
permutations, so every map and inverse is integral, has determinant `+/-1`,
has index one, and creates no omitted or duplicated coset.

After the top split and eight binary splits, each branch is the rank-two ring

`ZZ[x]/(x^2-x+1)`.

The restriction of `M_R` to its two coefficients is exactly `A2`.  Thus one
ring component gives

`3*2^8=768`

terminal `A2` blocks.  The two Schur branches of the trapdoor Gram give

`2*3*2^8=1536`                                                (2)

blocks.  The count is a consequence of the integral tower, not a literal
assumption.

## 3. Exact block LDL induction

For a positive self-adjoint ring multiplier `d`, write `G_d` for its
coefficient Gram matrix in the canonical metric.  Apply the integral split
before eliminating blocks.

At a binary node with positive spectral children `a,b`, the exact Gram block
has pivots

`p1=(a+b)/2`, `p2=2ab/(a+b)`.

At a ternary node with positive spectral children `a,b,c`, put
`e1=a+b+c`, `e2=ab+ac+bc`.  Its exact Gram block has pivots

`p1=e1/3`, `p2=e2/e1`, `p3=3abc/e2`.

These are exact Schur-complement identities.  Induction down the integral
coefficient tower gives a real block-unit-lower matrix `L_d` and an integral
permutation `P_d` such that

`P_d^T G_d P_d = L_d diag(l_1*A2,...,l_768*A2) L_d^T`.       (3)

The entries of `L_d` need not be integral.  Integrality is required only of
the domain split `P_d`; the nonintegral lower-triangular entries become shifts
when the Gaussian sum is evaluated.

For the complete trapdoor Gram `G_B=B^T M B`, the pointwise two-by-two
Hermitian determinant is

`g00*g11-|g10|^2=|fG-gF|^2=q^2`.

Its first ring Schur branch is `d=g00=|f|^2+|g|^2`; the second is `q^2/d`.
Applying (3) to both branches gives 1536 positive scalars.

Reciprocal values reverse every local pivot list.  Explicitly, binary
reciprocal children give `(q^2/p2,q^2/p1)`, while ternary reciprocal children
give `(q^2/p3,q^2/p2,q^2/p1)`.  Induction therefore proves that if the primary
list is `(l_1,...,l_768)`, the second list is

`(q^2/l_768,...,q^2/l_1)`.                                 (4)

This is exactly the physical ordering built and checked by the source.  The
a1 numerical bridge proves that every exact member of the combined list is
strictly greater than 991.

## 4. Dual blocks and shifted theta induction

Let the diagonal blocks in (3), including both Schur branches, be
`lambda_j*A2`.  By (4), for every `lambda_j` there is another certified leaf
`lambda_j_sharp=q^2/lambda_j`, also greater than 991.

The inverse terminal block is

`(lambda_j*A2)^(-1)=(lambda_j_sharp/q^2)*A2^(-1)`.

For the integral sign matrix `J=diag(1,-1)`,

`A2^(-1)=(4/3)*J*A2*J`.                                    (5)

Thus its T1 dual exponent is an `A2` exponent with coefficient

`4*lambda_j_sharp/(3q^2)`.

It remains to justify multiplication of the block bounds.  Write the inverse
block decomposition as

`G_B^(-1)=U^T Delta^(-1) U`,

where `U` is block-unit-lower and `Delta` has the blocks above.  In the sum
over the original integer block coordinates, the last block occurs as
`v+x`, where `v in ZZ^2` and the shift `x` depends only on earlier blocks.
T1 Poisson summation gives, for every lattice and every real shift,

`rho(L+x) <= rho(L)`,

because the dual Fourier coefficients are positive and every phase has real
part at most one.  Sum the last block, apply this inequality, and continue
backwards.  Induction yields

`rho_{s,M^-1}(Lambda_h^*)`
` <= product_j rho_{kappa*lambda_j_sharp,A2}(ZZ^2)`,          (6)

with

`kappa=8*pi^2*sigma^2/(3q^2)`.

No factor is lost: all coefficient splits have index one, each integer block
is summed exactly once, and the triangular operations only change its shift.

## 5. Uniform numerical conclusion

The a1 exact arithmetic proves

`kappa*991 > 65*ln(2)`.

For `y=2^-65`, the number of nonzero `A2` vectors of norm `m` is at most
`6m`; hence one centered block has nonzero mass at most

`a=6*y/(1-y)^2`.

Equations (2), (4), (5), and (6) now give

`tau_h <= (1+a)^1536-1 < 2^-40`

for every successfully emitted key.  The proof uses the mandatory KeyGen leaf
predicate, not a campaign or the previously accepted canonical key.

## 6. Machine checks and boundary

The a2 verifier checks the generic binary/ternary and reciprocal identities,
constructs exact graph-lattice bases and dual Grams for nontrivial instances
of degrees 6, 12 and 24, derives their integral recursive permutations,
performs exact block LDL, obtains only scalar `A2` pivots, verifies reciprocal
reversal and determinant identities, and derives the full-parameter count
from `2*3*2^8`.

This is a candidate repair of `T5-MATH-001`.  It closes nothing until fresh
independent implementation/evidence and mathematical reviews accept the exact
frozen a2 manifest.  It does not establish any later FFO, MT-ISIS or final
security claim.
