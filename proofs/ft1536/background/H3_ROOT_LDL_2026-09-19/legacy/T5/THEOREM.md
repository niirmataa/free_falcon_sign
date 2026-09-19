# T5 uniform accepted-key theorem — a2 candidate

For every public key `h` produced by a successful call to the committed
FT1536 KeyGen implementation, let

`L_h=s*M^(-1/2)*Lambda_h^*`, `s=sqrt(2*pi)*768`,

with the graph lattice and metric fixed by T1.  Then the a2 bridge proves

`rho(L_h)-1 < 2^-40`.                                      (1)

The exact ideal KeyGen law, the deterministic acceptance predicate, the
three-million-attempt conditional-law cancellation, the distinction between
the ideal tape and the real 256-bit-seed pushforward, and the source-bound
numerical leaf lower bound are the unchanged, manifest-bound a1 subresults.

The repaired global step is `GLOBAL_LEAF_A2_BRIDGE.md`.  In summary:

1. the NTRU coefficient matrix `B` is an exact basis of the T1 graph lattice;
2. `B^T M B` is the primal Gram whose inverse represents the T1 dual metric;
3. the ternary and binary coefficient splits are integral index-one
   permutations;
4. exact block LDL down that tower yields 768 `A2` blocks in each of two
   Schur branches;
5. the second leaf list is the reverse `q^2`-reciprocal of the first;
6. every inverse block is therefore controlled by another source-certified
   leaf, all strictly greater than 991;
7. backward completion of squares and the shifted-theta maximum at the origin
   give the product bound without requiring the real triangular shears to be
   integral;
8. exact arithmetic gives (1).

Therefore the proposed good set is the entire support of both the ideal
accepted-key law and the real deterministic seed pushforward, and

`delta_key=0`.

This theorem has status `PROVED_CANDIDATE_PENDING_DUAL_REVIEW`.  It does not
promote T5 or any security claim until both fresh reviewers accept the final
a2 manifest.  No historical campaign, private input or later obligation is a
premise.
