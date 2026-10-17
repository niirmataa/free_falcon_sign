# Z_LOWER_134 — analytic Z > 0 and bounds: partial proof and named wall

2026-10-17. **PARTIAL_PROOF / STOP_AND_REPORT / NOT_REVIEWED.** The owner
window "analytic Z > 0 and bounds (instead of a kernel witness)" is **NOT
COMPLETE**: no positive numerical epsilon is established for the actual
32-byte seed law of `KeygenProbability134`. What is established, with full
kernel proofs and no new assumption, is the MODE1 coefficient law derived
from the pinned sampler body (step 1), the exact consumption chain from any
positive first-attempt bound to the `KeygenModelBinding134.package`
(step 4), and the exact structural reduction showing why steps 2-3 cannot
close without either a seed witness or a new RNG premise. Per the hard
anti-loop rule the window stops here with a re-scope instead of spending the
remaining windows on gate analysis that the open solver/certificate lane
cannot ground.

## Step table (owner KROKI 1-4)

| # | Goal | Status | Exact declarations |
|---|------|--------|--------------------|
| 1 | MODE1 coefficient law for f,g from the sampler execution/sources (per-coefficient marginal; not F04); deviations computed and bounded, not skipped | **DONE** in the exact conditional form; the residual deviation is named, not hidden | `KeygenMode1Law134.{chunkAt, chunkAt_val, chunkAt_lt, chunks, chunks_length, chunkStream, chunkStream_nil, chunkStream_cons, chunkStream_append, chunkStream_length, accepted, coeffs, accepted_append, accepted_sublist, accepted_mem, accepted_length_le, coeffs_length, coeffs_append, coeffs_mem, chunkOf, chunkOf_val, chunkOf_inj, chunkOf_zero, chunkOf_one, chunkOf_two, valueLaw, valueLaw_mass, oneDraw_transfer, valueLaw_uniform, valueLaw_deviation}` |
| 2 | Acceptance-region probability: bounds 1/1/2047/2047 + fG-gF=18433 (resultant gates) + auxiliary conditions => epsilon > 0 (target >= 1/4) | **NOT ESTABLISHED**; per-gate decomposition recorded below | none (nothing is claimed) |
| 3 | Coding bound given acceptance, from the failure-path structure of 134 => final epsilon | consumer structure pre-existing; **numerical c_1 OPEN** (certificate/codec lane) | `KeygenFirstMass134.{factorization, first_attempt_bound, quantitative}` (existing consumers) |
| 4 | Z >= epsilon > 0 as a theorem consumed by `KeygenSuccessMass134` / `KeygenModelBinding134.package` | **consumption chain DONE**; epsilon itself OPEN | `KeygenModelUnlock134.{acceptCount, encodedCount, acceptMass_uniform_count, encodedMass_uniform_count, acceptMass_positive_iff, encodedMass_positive_iff, z_positive_of_first_attempt_bounds, z_bound_of_first_attempt_bounds, package_of_z_positive, package_of_first_attempt_bounds, z_positive_of_witness, package_of_witness, package_of_certified_set}` |

## Step 1: the MODE1 coefficient law from the sampler body

The pinned body (`sample_true_ternary_secret`, `TRUE_TERNARY_SECRET_MODE 1`)
consumes two-bit chunks `x = (uint32_t)rb & 3U` with `rb >>= 2`, refills one
64-bit SHAKE word per 32 chunks (`rbits < 2`), rejects `x = 3` and stores
`v[u] = x - 1`. Derived exactly, without any distribution assumption:

* `chunkAt/chunks/chunkStream`: 32 two-bit chunks per word, low bits first;
  `chunkStream_length` fixes the consumption rate.
* `accepted/coeffs`: the stored coefficient sequence is exactly the accepted
  chunks (`x.val != 3`) in stream order, mapped `x-1`; `coeffs_mem` proves the
  values are exactly `{-1,0,1}` (the value-level form of the executed
  sampler's `Bound 1`).
* `valueLaw`: the rejection-normalized per-coefficient marginal under an
  arbitrary per-chunk law `m`, mass `m(c)/(1 - m(3))` on the three stored
  values (`valueLaw_mass`).
* `oneDraw_transfer`: the unbounded retry loop is the geometric series
  `sum_j m(3)^j * m(c) = m(c)/(1 - m(3))` — the exact infinite-retry marginal.
* `valueLaw_uniform`: with per-chunk mass `1/4` the stored-value marginal is
  **exactly 1/3**; the sampler body introduces no code-level deviation.
* `valueLaw_deviation`: if every chunk mass deviates from `1/4` by at most
  `delta < 3/4`, every stored-value mass deviates from `1/3` by at most
  **16 delta / (9 - 12 delta)**.

**Deviation accounting (the owner's explicit clause).** The MODE1 body is
exact rejection sampling: given an ideal uniform chunk stream there is *no*
deviation (`valueLaw_uniform`). The deviation of the real sampler from the
assumed uniform-ternary law is therefore *exactly* the deviation delta of
the chunk law `m` of the SHAKE word stream, transferred by
`valueLaw_deviation` with the explicit bound `16 delta / (9 - 12 delta)`.
The chunk law `m` over the uniform 32-byte seed law is **not supplied by the
sampler sources or any pinned artifact**: the source lane performs no
independent or uniform replacement of any RNG draw
(`KeygenSamplerFunction091` docstring), and the input law is a pushforward
through SHAKE (`KeygenInputLaw110.seedLaw`, uniform on `Fin 32 -> BitVec 8`).
This missing premise is recorded here as open; it is not skipped and not
assumed. F04 is not used: its audited theorem
`JointDecomp.samplerLaw_marginal_uniform` is signing-challenge uniformity
over `Law (Rq x Option BoxVec)`, a different family (as pinned in the 112
report).

## Step 2: acceptance-region bound — why it does not close here

The per-attempt acceptance predicate (S1, `S1_P_ACCEPT_FACTS.md`) is the
ordered chain resultants -> norm -> gs -> public -> solve -> mandatory leaf
certificate, with the acceptance region described by the small bounds
1/1/2047/2047, the NTRU equation fG-gF = 18433 and the auxiliary gates. The
measured conditional chain (control only, never a premise) is resultants
0.9675 -> norm 1.0 (the 1250/100 bound is pass-through in this profile) ->
gs 0.4618 -> public 0.9229 -> solve 0.8408, product 0.3467 = 8192/23628.
A rigorous epsilon >= 1/4 needs, for each gate, a distribution theorem of
its own:

* resultants: the law of Res(f, x^1536+1) mod 2q for ternary f (analytic
  number theory over random polynomials);
* norm gate: possibly a universal pass-through bound for ternary inputs
  (an FPR word inequality over the executed bound code; provable but not
  attempted here);
* gs gate: the law of the Gram-Schmidt norm of random ternary pairs — a
  Littlewood-type Fourier estimate for random +/-1 polynomials;
* public gate: invertibility of f mod (phi, q) for random ternary f;
* solve gate and the leaf certificate: behavior of `solve_NTRU` and the
  certificate — this lane is still **OPEN** at the 159 wall (root solver,
  certificate and codecs are among the named open items).

None of these is within the three-window budget, and two of them cannot be
grounded at all until the solver/certificate lane closes. The target 1/4 is
calibrated to the measured 0.3467; it cannot be promoted from measurement.

## Step 3: coding bound given acceptance — status

The consumer structure already exists and is reused unchanged:
`KeygenFirstMass134.factorization` (acceptMass * codingRatio = encodedMass),
`first_attempt_bound` and `quantitative` (which transports separately proved
`a <= acceptMass`, `c <= codingRatio`). A numerical `c_1 >= ...` at the same
first accepted state requires the certificate/codec success from that state
(the 112 report already named the caller-side premises: adequate writable
private buffer and full capacity); that execution lane is OPEN. Nothing is
claimed.

## Step 4: the consumption chain (proved now)

`KeygenModelUnlock134` closes every remaining consumer step so that the
moment any positive bound exists, the package unlocks:

* `z_positive_of_first_attempt_bounds`: `0 < a * c` with
  `a <= acceptMass`, `c <= codingRatio` implies
  `0 < KeygenProbability134.successMass`; `z_bound_of_first_attempt_bounds`
  is the exact `a * c <= Z` form (`KeygenFirstMass134.quantitative`).
* `package_of_z_positive` / `package_of_first_attempt_bounds`:
  positive `Z` unlocks `KeygenModelBinding134.package`
  (via `package_none_iff`, the package is `none` exactly when `Z = 0`).
* `package_of_witness` / `z_positive_of_witness` / `package_of_certified_set`:
  the witness and certified-set routes unlock the same package.
* `acceptMass_uniform_count`, `encodedMass_uniform_count` with the exact
  count functions `acceptCount`, `encodedCount`.

**Structural reduction (kernel):** `acceptMass_positive_iff` proves
`0 < acceptMass <-> exists seed, Accepted env input seed` (and
`encodedMass_positive_iff` for the encoded mass). A strictly positive
analytical bound for the actual seed law therefore carries the same
existence content as a concrete accepting seed: the analytic route cannot be
strictly easier than the G(seed*) witness track, only non-constructive.

## Exact epsilon

The proved factorized shape of the final epsilon is
`epsilon = a * c` with `a <= KeygenFirstMass134.acceptMass` and
`c <= KeygenFirstMass134.codingRatio`, consumed by
`KeygenFirstMass134.quantitative` and delivered to the package by
`KeygenModelUnlock134.package_of_first_attempt_bounds`. **`a` is not
established, `c` is not established, therefore epsilon is not established
and `Z >= epsilon > 0` is not claimed.** The only unconditional positive
form remains the atom bound `2^-256` per certified seed
(`KeygenSuccessMass134.success_lower_of_witness`,
`certified_set_lower`), which requires a seed witness. Exact sampler-law
numbers proved here: uniform case `1/3` per stored value
(`KeygenMode1Law134.valueLaw_uniform`), deviation transfer
`16 delta / (9 - 12 delta)` (`valueLaw_deviation`), geometric retry identity
(`oneDraw_transfer`). The measurement 8192/23628 is a consistency control
only (`KeygenCountTarget112.measured_*`, `probe_subset_below_quarter`).

## Re-scope (sufficient forms for the goal)

* **R1 (sufficient; constructive; already the separate track):** kernel
  certify one public synthetic seed in the actual source relation ->
  `KeygenModelUnlock134.package_of_witness`. Cheapest sufficient form; the
  112 report named the same discriminator. It also yields the analytic
  lower bound `a >= 2^-256` for that seed through
  `KeygenSuccessMass112.event_lower_of_witness`.
* **R2 (owner decision required):** explicitly authorize an RNG idealization
  premise (uniform chunk law). This instantiates step 1 to the `1/3`
  marginals but leaves step 2's per-gate distribution bounds unsolved, so it
  is not sufficient alone and is currently forbidden (new assumption).
* **R3 (maximal honest analytic content; delivered here):** the MODE1 law,
  deviation transfer and the consumption chain above.

Recommendation: R1 for unblocking `KeygenModelBinding134.package`; keep R3
as the mathematical record of the sampler law.

## Checks and preservation

Jobs: `keygen_zlower134_006` (both modules, accepted, logs 0/0),
`keygen_zlower134_007` (audit `KeygenZLower134Audit`, 43 declarations, full
term/type DAG roundtrip, axioms exactly `propext`, `Classical.choice`,
`Quot.sound`), `keygen_zlower134_011` (Sage control, standard preparser,
exact ZZ/QQ, 2763 marginal grid points, 0 new KeyGen runs, clean log).
Failures 001-005 and 008-010 retained with causes in
`KEYGEN_Z_LOWER_134_FAILURES.json`. No new axiom or assumption, no paper
change (measured stays measured), no push, no reviewer/worker, five do_sign
items unchanged, frozen stages untouched; the untracked 158/159 probe files
found at entry were left exactly as found.

## Three sentences

The sampler sources determine the MODE1 store exactly: rejection sampling
gives per-coefficient marginal `m(c)/(1-m(3))`, uniform `1/3` under uniform
chunks, and a `16 delta/(9-12 delta)` deviation transfer — but they do not
determine the SHAKE chunk law over the uniform 32-byte seed, so no positive
`a` for the real seed law follows from them. Because
`KeygenModelUnlock134.acceptMass_positive_iff` shows that any positive bound
for this law is already equivalent to an accepting-seed witness, the
analytic route cannot beat the separate G(seed*) track, and the measured
8192/23628 stays a control. The consumption chain is now closed end to end
(`package_of_first_attempt_bounds`, `package_of_witness`), so the package
unblocks the moment either the witness or a genuinely proved `a * c > 0`
lands.
