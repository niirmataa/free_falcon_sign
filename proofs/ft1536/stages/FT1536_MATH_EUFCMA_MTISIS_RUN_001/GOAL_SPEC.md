# Pre-proof goal specification (T12.1)

Domains: finite real probability laws for bounded observable histories;
integer coefficient vectors of length 1536, q=18433, A2 quadratic form,
strict bound 2093922385. Finite full-reply alphabets include explicit abort
tags. No nonreturn is identified with an observable abort.

Target Lean interfaces (the actual checked declaration types will additionally
be captured in `formal_types.txt`; unmet interfaces remain OPEN):

1. `MathSign.full_reply_law`: for a finite normalized single-attempt law,
   a fixed target and an explicit Emit, capped IID retry has mass
   `(1-a)^n` at exhaustion and `(sum i<n (1-a)^i)*attempt_success(o)`
   at each successful emitted observation. Normalization includes encoding
   failures and does not post-filter by Verify.
2. `PublicSimulation.joint_law`: a public weighted finite sampler and Emit
   induce a normalized joint law; honest law is `U(c)*K(c,o)`.
3. `Divergence.joint_chi2`: finite second moment factorization under absolute
   continuity, and multiplicative image/conditional upper bound.
4. `Divergence.stopped_adaptive_chi2`: arbitrary history-indexed transition
   laws with local second-moment bound yield product bound on transcript
   second moment. Histories contain observations, not just a time index.
5. `EventTransfer.phi_bound (a b d : ℝ)`: `0≤a`, `a≤1`, `0≤b`, `b≤1`,
   `0≤d`, `(a-b)^2≤d*a*(1-a)` imply
   `a≤(2*b+d+sqrt(d^2+4*d*b*(1-b)))/(2*(1+d))`.
   Monotonicity in b, endpoints and d=0 separately.
6. `ROM.programming_conflict_bound`: adaptive fresh uniform nonce input
   conflicts bounded by `(Q_s*Q_H+Q_s*(Q_s-1)/2)/2^320`, clipped at 1.
7. `Reduction.indexed_extraction`: a fresh accepted message at a table entry
   yields a witness for that exact challenge index; no target-guess factor.
8. `Reduction.euf_cma_to_mt_isis`: construct B with public sampler interface,
   account for resources and derive the stated clipped collision + Phi bound.

This is a declaration of intended obligations, not axioms in Lean. No final
advantage inequality or simulation correctness is admitted as a certificate.
An abstract intermediate analytic lemma is not advertised as the entire
reduction. Every remaining missing type will be listed explicitly.
