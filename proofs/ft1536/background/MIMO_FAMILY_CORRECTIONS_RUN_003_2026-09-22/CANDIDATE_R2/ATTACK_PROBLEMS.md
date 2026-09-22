# Attack problem definitions (FT768 / FT1536 / FT3072) — game interface repair

Status: **revised after independent review R1–R4** (checkpoint
`FT_FAMILY_SCALING_REVIEW_RUN_001`). The previous draft of this file had
three model defects: an inverted reduction direction (R1), a trivializable
multi-target formulation (R2) and an incomplete trapdoor-completion step
(R3). All estimator cells remain **NOT_RUN**; the campaign skeleton itself
was inconsistent with this document and is repaired (R4).

Binding: the game is the pinned M0 contract
(`FT1536_M0_CONTRACT_RUN_001/GAME.md`, identifier
`FT1536-M0-r40-static4096-parametric-v1`) with the future-reduction type of
`TARGET_TYPE.md`; the extractor is the pinned L_V result
(`FT1536_L_V_BRIDGE_RUN_001`). Throughout: `q = 18433`,
`R_N = Z[X]/(Phi_N)`, `Phi_N = Phi_{3N}` (exact identity, SA1), `N =
3*2^(logn-1) = 3*2^k`, `d = 2N`, and the verification metric

    Q(z1, z2) = Q_A2(z1) + Q_A2(z2),
    Q_A2(a)   = sum_{i<N/2} (a_i^2 + a_i a_{i+N/2} + a_{i+N/2}^2)
              = (1/N) Tr_{K/Q}(a * conj(a)).

Lattice convention (matching `z1 + h*z2 = c` in the source and in L_V):

    Lambda_{h,c} = { (u, v) : u + h*v = c mod (q, Phi_N) },   (g,-f) in Lambda_{h,0}.

Volumes: `det G = (3/4)^N` for the `Q_A2` Gram matrix on `(z1,z2)`;
`covol_coeff(Lambda) = q^N`; `covol_Q(Lambda) = (3/4)^(N/2) q^N`, i.e.
`covol_Q^(1/2N) = (3/4)^(1/4) sqrt(q)`. `det G` is not the volume factor.

## 0. Typed interfaces (game-level)

    Forge(E, beta):   oracles H (M0 §3), Sign (M0 §4), input pk_bytes;
                      output (m*, r*, b*).
                      WIN  <=>  m* not in SeenSign, |r*| = 40, legal input,
                      Verify(m*, r*, b*) = 1          (M0 §5; ordinary,
                      not strong EUF-CMA; aborted Sign messages not fresh).

    Extract(h, c, b): total on ACCEPT(h, c, b) = 1 and then returns
                      (z1, z2) with z1 + h*z2 = c mod (q, Phi_N) and
                      Q(z1, z2) < B_N.                 (L_V; pinned model)

    Solve_rel(E, keys = 1, targets = Q_H + 1):
                      one key h (K_seed, conditioned on E_K), a list of
                      target names (x_1..x_{Q_H}, x*) chosen by B and the
                      ROM table values c_i = T[x_i] (M0 §3: values uniform
                      per *distinct* name, repeats consistent);
                      output (i, z1, z2) with z1 + h*z2 = c_i and
                      Q < B_N.  This is the type requested of the future
                      reduction in TARGET_TYPE.md.

Budgets are the M0 tuple `beta = (Q_s, Q_H, t, w, L)`; `Q_H` counts all
explicit H-queries (repeats included), `Q_s` all Sign calls. No external
`2^64` convention replaces these definitions.

## 1. Reduction arrows (R1 — direction fixed)

1. **Proved direction (witness extraction).**
   `ACCEPT => witness` is the pinned L_V statement. Composing
   `B = Extract o Forge(A)` (same queries, identity on the transcript) gives
   a `Solve_rel` adversary with
   `Adv_rel(B) >= Adv_cond(G0[E], A)` inside the L_V scope. Hence
   **hardness of the relation problem bounds forging**; equivalently, a
   successful forger yields a relation solver. This is the direction used by
   any claim of the form "EUF-CMA hardness from MT-ISIS".
2. **Reverse direction (encoding) — OPEN.**
   Building a byte-level forger *from* a relation solver needs a map
   `Enc(h, c, z1, z2) -> b` with `ACCEPT(h, c, b) = 1` for arbitrary
   witnesses. Byte-decoder image surjectivity is not established (the only
   proved roundtrip is the honest STATIC path). Absent `Enc`, a solver is
   *not* an attack on accepted-byte production.
3. **Full M0 reduction — OPEN, beyond both arrows.**
   The M7 target additionally requires ROM/Sign simulation, distribution
   equalities, freshness and the resource ledger
   (`ComposeOrdered` over `HOP_LEDGER.json.target`). The pointwise L_V
   property does not provide these. Until then the composed bound is
   stated as conditional on the component certificates of `TARGET_TYPE.md`.

## 2. P2 game: multi-target MT-ISIS, with targets from the ROM table (R2)

**Definition (fixed).** Targets are `c_i = T[x_i]` — values of the M0 ROM
table at adversarially chosen *names* `x_i` (M0 §3). The adversary chooses
names; the values are uniform in `R_q`, one value per distinct name, and
repeats of a name return the same value. The win event is `Solve_rel` above;
the forgery target is `c* = T[r*||m*]`, so the relevant target count is at
most `Q_H + 1` table values with at most that many *distinct* names.

**Negative controls (kept as part of the definition):**

- **N1 (c=0 countermodel).** The withdrawn formulation ("adversary chooses
  values `c_i`") is trivially solvable: `c = 0`, `z1 = z2 = 0` has `Q = 0 <
  B_N` for every `h`. That is a countermodel of the *definition*, not a ROM
  forgery; targets must be table values at fresh or repeated names.
- **N2 (dependence).** For repeated names the targets coincide, so
  per-target success events are not independent and not identically
  distributed. Counterexample: two identical events with `p = 1/2` have
  union `1/2`, not `3/4`. Therefore no `1-(1-p)^Q_target` amplification
  without stated independence; the valid generic bound is the union bound
  `Pr[Win] <= sum_i p_i` over **distinct** names with `p_i` the conditional
  per-target success of the fixed solver run, or an explicitly derived
  conditional estimate.

**Threshold semantics.** `B_N` exceeds the typical coset minimum by a wide
margin, so the search has exponentially many solutions; the cost object is
"find ANY coset vector below `B_N`" for one of the table targets (the Falcon
inhomogeneous embedding, spec eq. (2.4), DBKZ + MW16 Corollary 1), **not**
generic homogeneous SIS. The homogeneous SIS control is retained only as a
documented rejected row: for FT1536 its Euclidean radius exceeds `q`, so
trivial kernel vectors `q*e_i` solve `A z = 0` but not `A z = c` (recorded
negative result).

`B_N` for FT768/FT3072 requires a pinned `sigma_N` first (scaling regimes).
`B_1536 = 2093922385` is kernel-checked.

## 3. P1: key recovery and the missing F (R3)

**P1a short-vector recovery (Falcon eq. (2.3) target).** Given `h`, output
any nonzero `(u, v) in Lambda_h` with `Q_A2(u) + Q_A2(v) <= B_KR`, where the
threshold must be stated **with its population**:

- RAW population (iid ternary proposal, pre-gate): `E[Q_A2(g)+Q_A2(f)] =
  4N/3`; any threshold above this expectation is a *proposal-class* target
  and needs an explicit margin and tail statement (e.g. Markov or a
  concentration bound) — the raw expectation alone is not a threshold;
- EMITTED population (`K_seed`, conditioned on completed KeyGen `E_K`): the
  length law is **OPEN** (conditioning sensitivity); the only quantitative
  statement available is the KeyGen gate predicate itself. No
  emitted-population threshold is claimed here.

**P1b full trapdoor recovery.** Output `(f, g, F, G)` with
`f*G - g*F = q mod Phi_N` and small entries (a signing basis).

**P1a does not supply P1b.** The source completion routine
`falcon_complete_private` (`falcon-vrfy.c:1551-1553`) computes **G from
f, g, F** — it needs `F` as input and solves nothing for it. A P1a solver
returns at most the pair class. The missing step is a separate NTRU-equation
solve producing `(F, G)` (the KeyGen "solve" gate), with its own:

- *conditions* (the equation must be solvable for the recovered pair —
  coprimality/resultant conditions on `f`, invertibility mod `(Phi_N, q)`;
- *lengths* (a generic solution `(F', G')` differs from the small accepted
  one by `(f, g)*k`; keeping `F, G` small needs the reduction step that
  KeyGen enforces by rejection);
- *cost* (big-integer polynomial arithmetic; not a constant-time claim).

Estimator rows estimate **P1a** (as Falcon eq. (2.3) does); the P1a -> P1b
gap above is a stated modeling caveat, not closed.

Estimator mapping (NOT_RUN): `NTRU.estimate(NTRUParameters(n=N, q=q,
Xs=DUniform(-1,1), Xe=DUniform(-1,1), m=N, ntru_type='circulant'))` for the
RAW population plus the pinned Falcon eq. (2.3) loop as an independent
model. OPEN: circulant model vs the `Phi_{3N}` tower ring; emitted-population
conditioning sensitivity.

## 4. P3: witness/bytes implications (all directions)

`ACCEPT(h, c, b)` = byte string `b` passes Verify; `WITNESS(z1, z2, c)` =
`z1 + h*z2 = c mod (q, Phi_N)` and `Q(z1, z2) < B_N`.

1. `ACCEPT => exists witness` — **PROVED** for the pinned candidate (L_V).
2. `WITNESS => exists accepted bytes` — **NOT ESTABLISHED** (no decoder-image
   surjectivity; only the honest STATIC roundtrip). See arrow (2) of Sec. 1.
3. Reduction use: direction (1) composed with a forger gives the solver of
   Sec. 1(1); the opposite composition needs (2). Sampling-law questions
   (honest output distribution, retry behaviour, R\'enyi loss) are separate
   obligations (`SOURCE_SAMPLER_LAW`).

## 5. Attack-class inventory (every cost cell NOT_RUN)

| class | reference (verified) | status |
|---|---|---|
| primal uSVP/BDD (BKZ/sieve cost models) | [AC:AGVW17]; ADPS16 core-SVP 2^(0.292 beta) cl. / 2^(0.265 beta) q. | NOT_RUN |
| Falcon v1.2 eq. (2.3)/(2.4) block-size loops | Falcon specification + pinned `parameters.py` | NOT_RUN |
| dual (+ hybrid, MITM) | [C:HowgraveGraham07], [JMC:Wunderer19] | NOT_RUN |
| subfield / norm-down (7 index-2 subfields per degree) | Albrecht--Bai--Ducas, ePrint 2016/127 (CRYPTO 2016) | NOT_RUN |
| overstretched-NTRU refinements | Kirchner--Fouque (EUROCRYPT 2017); Ducas--van Woerden (ASIACRYPT 2021) | NOT_RUN |
| homogeneous SIS control | — | REJECTED row (N1/trivial kernel vectors) |

Cost outputs must separate core-SVP, rop, gates, memory, depth and success
probability; for P2 additionally the number of *distinct* targets and the
per-target conditional success (union bound form). The historical worksheet
row `2^446.2` (Gaussian-like population) MUST NOT be transported to the
ternary family.
