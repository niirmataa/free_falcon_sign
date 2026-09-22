# Attack problem definitions (FT768 / FT1536 / FT3072)

Status of this file: **problem definitions, revised after review**. All
estimator cells remain **NOT_RUN** (`scripts/estimator_campaign/`). The first
draft of this file had three model defects, now fixed here: an inconsistent
lattice sign, an underspecified trapdoor-recovery goal, and a single-target
reading of MT-ISIS with unspoken witness/bytes implications.

Throughout: `q = 18433`, `R_N = Z[X]/(Phi_N)` with `Phi_N(X) = X^N - X^(N/2)
+ 1 = Phi_{3N}(X)` (exact identity, `results/sage_exact.json` SA1), `N =
3*2^(logn-1) = 3*2^k`, `d = 2N`. The verification metric is the quadratic
form of `Extra/c/falcon-enc.c` (`falcon_is_short`, ternary branch):

    Q(z1, z2) = Q_A2(z1) + Q_A2(z2),
    Q_A2(a)   = sum_{i<N/2} (a_i^2 + a_i a_{i+N/2} + a_{i+N/2}^2)
              = (1/N) Tr_{K/Q}(a * conj(a)),

(Lemma 2 of the paper; kernel algebra in `lean/FTA2.lean`). The lattice for
the public key `h = g/f` is the **coset convention matching the source**
(`z1 + h*z2 = c` in `falcon_vrfy_verify_raw` / L_V):

    Lambda_{h,c} = { (u, v) in R_N^2 : u + h*v = c mod (q, Phi_N) },
    Lambda_h     = Lambda_{h,0}.

Then `(g, -f) in Lambda_h`, since `g + h*(-f) = g - h*f = 0`. (The withdrawn
`u - h*v = 0` convention does **not** contain `(g,-f)`: it would give
`g + h f = 2g`. With `u - h*v = 0` the short key vector would be `(g, f)`.)

Volumes: `det G = (3/4)^N` for the Gram matrix `G = [[1,1/2],[1/2,1]]` of
`Q_A2` per coefficient pair (twice, for `(z1,z2)`); the lattice volumes are
`covol_coeff(Lambda) = q^N` and
`covol_Q(Lambda) = (3/4)^(N/2) * q^N`, so `covol_Q^(1/2N) = (3/4)^(1/4) sqrt(q)`.
Do not conflate `det G` with the volume factor (review item 4).

## P1 — key recovery (trapdoor recovery)

Two nested goals, kept apart (review item 2):

- **P1a short-vector recovery**: given `h`, output any nonzero
  `(u, v) in Lambda_h` with `Q_A2(u) + Q_A2(v)` at most the emitted-key class
  length (`E = 4N/3` for raw ternary proposals, plus a stated margin). This is
  the Falcon-specification eq. (2.3) target.
- **P1b full trapdoor recovery**: output `(f, g, F, G)` (up to units/sign)
  with `f*G - g*F = q mod Phi_N` and small entries, i.e. a working signing
  basis. Given P1a output equal to the key class, completion `G` is the
  polynomial `falcon_complete_private` step **when `f` is invertible mod
  `(Phi_N, q)`**; for an arbitrary short vector the completion may fail, so
  P1a => P1b is conditional on the completion's invertibility condition and
  the returned vector being key-class, while P1b => P1a is immediate.

Estimator rows estimate **P1a** (as Falcon eq. 2.3 does); the P1b gap is a
stated modeling caveat, not silently closed.

- Secret law: **full ternary**, `f, g` with iid uniform coefficients in
  `{-1,0,1}` as RAW PROPOSAL, conditioned on successful KeyGen for the
  emitted population (`E Q_A2(g) + E Q_A2(f) = 4N/3` for raw proposals only).
  Never substitute any signing sigma here.
- Estimator mapping (NOT_RUN): `NTRU.estimate(NTRUParameters(n=N, q=q,
  Xs=DUniform(-1,1), Xe=DUniform(-1,1), m=N, ntru_type='circulant'))`, plus
  the pinned Falcon eq. (2.3) block-size loop as an independent model. OPEN:
  circulant model vs the `Phi_{3N}` tower ring; accepted-KeyGen conditioning
  sensitivity.

## P2 — MT-ISIS: accepted-byte production (unforgery), multi-target

- **Single-target form**: given `(h, c)`, output any
  `(z1, z2) in Lambda_{h,c}` with `Q(z1, z2) < B_N` (`B_1536 = 2093922385`,
  kernel-checked). Call this MT-ISIS-1.
- **Multi-target form (the game-relevant one)**: the adversary chooses
  polynomially many target challenges `c_i` (and, in the M0 game with
  observable aborts, interacts with up to the query bound — the Falcon
  convention caps signing queries at `2^64`), and wins by producing an
  accepted pair for **any one** target without a prior honest signature for
  it. Report either the per-target cost with the per-target success
  probability `p`, or the full cost including the number of targets and
  success amplification `1 - (1-p)^Q_target`. **Single-target cost must not be
  presented as the game cost.**
- Threshold semantics: `B_N` exceeds the typical coset minimum by a wide
  margin (paper, Table geo), so the search has exponentially many solutions;
  the honest cost object is "find ANY coset vector below `B_N`", e.g. via
  exact CVP in the coset / the Falcon inhomogeneous embedding (eq. 2.4,
  DBKZ + MW16 Corollary 1), **not** generic homogeneous SIS. The homogeneous
  SIS control is retained only as a documented rejected row: for FT1536 its
  Euclidean radius exceeds `q`, so trivial kernel vectors `q*e_i` solve
  `A z = 0` but not the required `A z = c` (recorded negative result).
- Estimator mapping (NOT_RUN): the pinned Falcon eq. (2.4) block-size loop
  transported through the exact `Q_A2` metric
  (`covol^(1/2N) = (3/4)^(1/4) sqrt(q)`), and the vendored
  `lattice-estimator` A2-ISIS embedding; `B_N` for FT768/FT3072 requires a
  pinned `sigma_N` first (scaling regimes).

## P3 — witness/bytes implications (all directions stated)

Let `ACCEPT(h, c, b)` mean the byte string `b` passes `Verify`, and
`WITNESS(z1, z2, c)` mean `z1 + h*z2 = c mod (q, Phi_N)` and `Q(z1, z2) < B_N`.

1. `ACCEPT(h, c, b) => exists (z1, z2). WITNESS(z1, z2, c)` — **PROVED** for
   the pinned candidate (L_V checkpoint: decoder, centering, exact norm,
   strict threshold, extractor Ext0 defined).
2. `WITNESS(z1, z2, c) => exists b. ACCEPT(h, c, b)` — **NOT ESTABLISHED**.
   A witness need not lie in the image of the byte decoder; no codec
   surjectivity is proved. What exists is the honest-path roundtrip (STATIC
   encode/decode of the same bytes), which does not extend to arbitrary
   witnesses. Treating byte production and witness production as one problem
   is exactly the conflation the review flagged.
3. Consequence for reductions: an MT-ISIS solver yields forgeries through
   (1)'s contrapositive direction (`forged bytes => witness => MT-ISIS
   solution`). The converse reduction (hardness of MT-ISIS => hardness of
   forging) needs (2) or a direct argument and is **OPEN**.
4. Sampling law questions (distribution of honest outputs, retry behaviour,
   R\'enyi loss) are neither P1 nor P2 cost cells; they are separate
   obligations (`SOURCE_SAMPLER_LAW` in the repo's next interfaces).

## Attack-class inventory (every cost cell NOT_RUN)

| class | reference (verified) | status |
|---|---|---|
| primal uSVP/BDD (BKZ/sieve cost models) | [AC:AGVW17]; ADPS16 core-SVP 2^(0.292 beta) cl. / 2^(0.265 beta) q. | NOT_RUN |
| Falcon v1.2 eq. (2.3)/(2.4) block-size loops | Falcon specification + pinned `parameters.py` | NOT_RUN |
| dual (+ hybrid, MITM) | [C:HowgraveGraham07], [JMC:Wunderer19] | NOT_RUN |
| subfield / norm-down (7 index-2 subfields per degree) | Albrecht–Bai–Ducas, ePrint 2016/127 (CRYPTO 2016) | NOT_RUN |
| overstretched-NTRU refinements | Kirchner–Fouque (EUROCRYPT 2017); Ducas–van Woerden (ASIACRYPT 2021) | NOT_RUN |
| homogeneous SIS control | — | REJECTED row (trivial kernel vectors; see P2) |

Cost outputs must separate core-SVP, rop, gates, memory, depth and success
probability, and must record number of targets and per-target success (P2).
The historical worksheet row `2^446.2` (TERNARY1536_WORKFLOW.md, 2026-05-06)
belongs to the Gaussian-like secret population and MUST NOT be transported to
the ternary family.
