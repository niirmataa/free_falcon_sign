# M7 — security floor: 2^-256 atom vs certified_set_lower (both GOALS)

**Status:** binding note (K1 ans 8). Both floors are **open GOALS**, not
claims, until R1 witness/acceptance (MAP M7 BLOCKED; R5 §1).

1. **Atom GOAL** `2^-256`: per certified seed, via
   `KeygenSuccessMass134.success_lower_of_witness`
   (`evaluate env input seed = some (.inr packet)` ⇒ `1/2^256 ≤ Z`).
2. **Set GOAL** `certified_set_lower`: a finite set of distinct seeds with
   proved source success ⇒ `|seeds|/2^256 ≤ Z` (SUCCESS_112).
3. **Binding rule when a witness exists:** use **`success_lower_of_witness`**
   for that seed (constructive, already closed shape). Widen to
   `certified_set_lower` only with a proved certified set of such seeds.
   Analytic ε>0 (acceptMass·codingRatio) stays **not established** (Z_LOWER_134).
4. **Conflict** (floor disagreement, pin/seed/hash clash, witness vs set
   mismatch): **stop-and-report** (M8) — retain both, no silent max/min;
   owner decides. No claim broader than the witnessed scope.
5. Until R1 region 5 + `package_of_witness`: both floors remain objectives
   at `G(seed*)`; spike `G_frag` results do not bind either floor.
