import FT1536.Divergence
import Run2.LawBinding
import SecondMoment
import VerifyBind.HashTo

/-! # Marginal-joint decomposition and second-moment transport (rung B4)

Every law `p : Law (α × β)` on a product is EXACTLY the `Divergence.joint` of
its first marginal `p.map Prod.fst` and its conditional family. The
conditional at a zero-mass point is not determined by `p`; it is filled by an
explicit fallback law (`Law.pure default`, see `fallbackLaw`). The choice of
fallback is immaterial for every identity below: at such a point the marginal
factor is zero, and the decomposition forces `p` itself to vanish there.

Consequences transported across the decomposition through the pinned
`Divergence.joint_chi2`:

* `second_eq_of_decomposition` — the exact identity for any law pair;
* `second_le_of_layers` — per-layer second-moment bounds compose as
  `(1 + e1) * (1 + e2)`;
* `second_joint_transport` / `second_joint_transport_le` — comparison of an
  arbitrary law against a joint reference law `Divergence.joint k l`, giving
  `second q (Divergence.joint k l) ≤ second (marginal q) k * (1 + e)`, with
  `=` when the conditional ratio is the constant `1 + e`.

All statements are about the pinned types `FT1536.Law` and
`FT1536.Divergence.second/AC/joint`; no new model is introduced. No
unfinished-proof markers; standard axioms only.
-/

namespace FT1536.JointDecomp
open Finset

variable {α : Type} [Fintype α] [DecidableEq α]
variable {β : Type} [Fintype β] [DecidableEq β] [Inhabited β]

/-! ### The marginal and the conditional family -/

/-- The explicit fallback law for the zero-mass case of the conditional
family: `Law.pure default`, a point mass at the default point of `β`. Any
fixed law would do (the decomposition multiplies it by a zero marginal), but
a `Law.pure`-style choice keeps the fallback a genuine law (total mass one)
without any normalization argument. -/
noncomputable def fallbackLaw : Law β := Law.pure (default : β)

/-- The first marginal of a law on a product. Definitionally
`p.map Prod.fst` (see `marginal_eq`); `marginal_mass` computes it as the
fiber sum. -/
noncomputable def marginal (p : Law (α × β)) : Law α := p.map Prod.fst

omit [DecidableEq β] [Inhabited β] in
/-- `marginal` is definitionally the mapped law `p.map Prod.fst`. -/
theorem marginal_eq (p : Law (α × β)) : marginal p = p.map Prod.fst := rfl

omit [DecidableEq β] [Inhabited β] in
theorem marginal_mass (p : Law (α × β)) (x : α) :
    (marginal p).mass x = ∑ y, p.mass (x, y) := by
  show (p.map Prod.fst).mass x = ∑ y, p.mass (x, y)
  rw [FT1536.Run2.FiberBinding.map_mass, Fintype.sum_prod_type]
  have hinner : ∀ a : α,
      (∑ y : β, (if a = x then p.mass (a, y) else 0))
        = if a = x then ∑ y : β, p.mass (a, y) else 0 := by
    intro a
    by_cases ha : a = x
    · rw [ite_eq_left ha]
      apply sum_congr rfl
      intro y _
      exact ite_eq_left ha
    · rw [ite_eq_right ha]
      exact sum_eq_zero (fun y _ => ite_eq_right ha)
  have houter : (∑ a : α, ∑ y : β, (if a = x then p.mass (a, y) else 0))
      = ∑ a : α, (if a = x then ∑ y : β, p.mass (a, y) else 0) :=
    sum_congr rfl (fun a _ => hinner a)
  rw [houter]
  exact Finset.sum_ite_eq_of_mem' univ x (fun a => ∑ y : β, p.mass (a, y))
    (mem_univ x)

/-- The conditional family of `p` at `x`: the regular conditional of `p` on
the fiber over `x`, normalized by the marginal mass. At zero marginal mass
the explicit `fallbackLaw` is used instead of a `0/0` collapse (the
normalization would fail and no conditional is determined by `p` there). -/
noncomputable def condOf (p : Law (α × β)) (x : α) : Law β where
  mass y := if 0 < (marginal p).mass x then
    p.mass (x, y) / (marginal p).mass x else fallbackLaw.mass y
  nonneg y := by
    show 0 ≤ (if 0 < (marginal p).mass x then
      p.mass (x, y) / (marginal p).mass x else fallbackLaw.mass y)
    by_cases h : 0 < (marginal p).mass x
    · rw [ite_eq_left h]
      exact div_nonneg (p.nonneg (x, y)) (le_of_lt h)
    · rw [ite_eq_right h]
      exact fallbackLaw.nonneg y
  total := by
    show (∑ y, (if 0 < (marginal p).mass x then
      p.mass (x, y) / (marginal p).mass x else fallbackLaw.mass y)) = 1
    by_cases h : 0 < (marginal p).mass x
    · have key : (∑ y, (if 0 < (marginal p).mass x then
          p.mass (x, y) / (marginal p).mass x else fallbackLaw.mass y))
          = ∑ y : β, p.mass (x, y) / (marginal p).mass x := by
        apply sum_congr rfl
        intro y _
        exact ite_eq_left h
      have hsum : (∑ y : β, p.mass (x, y) / (marginal p).mass x)
          = (∑ y, p.mass (x, y)) / (marginal p).mass x :=
        (sum_div _ _ _).symm
      rw [key, hsum, ← marginal_mass p x]
      exact div_self (ne_of_gt h)
    · have key : (∑ y, (if 0 < (marginal p).mass x then
          p.mass (x, y) / (marginal p).mass x else fallbackLaw.mass y))
          = ∑ y : β, fallbackLaw.mass y := by
        apply sum_congr rfl
        intro y _
        exact ite_eq_right h
      rw [key, fallbackLaw.total]

theorem condOf_mass_of_pos (p : Law (α × β)) (x : α)
    (hx : 0 < (marginal p).mass x) (y : β) :
    (condOf p x).mass y = p.mass (x, y) / (marginal p).mass x := by
  show (if 0 < (marginal p).mass x then
    p.mass (x, y) / (marginal p).mass x else fallbackLaw.mass y) = _
  rw [ite_eq_left hx]

theorem condOf_mass_of_zero (p : Law (α × β)) (x : α)
    (hx : (marginal p).mass x = 0) (y : β) :
    (condOf p x).mass y = fallbackLaw.mass y := by
  show (if 0 < (marginal p).mass x then
    p.mass (x, y) / (marginal p).mass x else fallbackLaw.mass y) = _
  rw [ite_eq_right (not_lt.mpr hx.le)]

/-- Extensionality of laws from equality of mass functions (the remaining
fields are proofs). -/
theorem law_ext {γ : Type} [Fintype γ] {p q : Law γ} (h : p.mass = q.mass) :
    p = q := by
  rcases p with ⟨mp, np, tp⟩
  rcases q with ⟨mq, nq, tq⟩
  subst h
  rfl

/-! ### The decomposition identity -/

theorem decomposition_mass (p : Law (α × β)) (z : α × β) :
    (Divergence.joint (marginal p) (condOf p)).mass z = p.mass z := by
  show (marginal p).mass z.1 * (condOf p z.1).mass z.2 = p.mass (z.1, z.2)
  rcases eq_or_ne ((marginal p).mass z.1) 0 with hz | hz
  · rw [hz, zero_mul]
    have hsum0 : (∑ y, p.mass (z.1, y)) = 0 := by
      rw [← marginal_mass p z.1]
      exact hz
    have hle : p.mass (z.1, z.2) ≤ 0 :=
      (single_le_sum (fun y _ => p.nonneg (z.1, y)) (mem_univ z.2)).trans
        (le_of_eq hsum0)
    exact (le_antisymm hle (p.nonneg (z.1, z.2))).symm
  · have hpos : 0 < (marginal p).mass z.1 :=
      lt_of_le_of_ne ((marginal p).nonneg z.1) (Ne.symm hz)
    rw [condOf_mass_of_pos p z.1 hpos z.2]
    exact mul_div_cancel₀ (p.mass (z.1, z.2)) (ne_of_gt hpos)

/-- THE marginal-joint decomposition: every law on a product is exactly the
`Divergence.joint` of its first marginal and its conditional family. -/
theorem decomposition (p : Law (α × β)) :
    Divergence.joint (marginal p) (condOf p) = p :=
  law_ext (funext fun z => decomposition_mass p z)

omit [DecidableEq β] [Inhabited β] in
/-- The first marginal of a joint law is its first factor. -/
theorem marginal_joint (k : Law α) (l : α → Law β) :
    marginal (Divergence.joint k l) = k := by
  apply law_ext
  funext x
  rw [marginal_mass]
  show (∑ y : β, k.mass x * (l x).mass y) = k.mass x
  rw [← mul_sum, (l x).total, mul_one]

/-- At positive marginal mass the conditional family of a joint law is its
second factor (the fallback is never engaged). -/
theorem condOf_joint (k : Law α) (l : α → Law β) (x : α) (hx : 0 < k.mass x) :
    condOf (Divergence.joint k l) x = l x := by
  have hxx : 0 < (marginal (Divergence.joint k l)).mass x := by
    rw [marginal_joint]
    exact hx
  apply law_ext
  funext y
  rw [condOf_mass_of_pos (Divergence.joint k l) x hxx y]
  have h2 : (Divergence.joint k l).mass (x, y) = k.mass x * (l x).mass y := rfl
  rw [h2, marginal_joint]
  exact mul_div_cancel_left₀ ((l x).mass y) (ne_of_gt hx)

/-! ### Second-moment transport across the decomposition -/

omit [DecidableEq α] in
/-- A law against itself has second moment exactly one (zero-mass points
contribute `0/0 = 0` and are consistent). -/
theorem second_self (p : Law α) : Divergence.second p p = 1 := by
  show (∑ x, p.mass x ^ 2 / p.mass x) = 1
  have hpt : ∀ x, p.mass x ^ 2 / p.mass x = p.mass x := by
    intro x
    rcases eq_or_ne (p.mass x) 0 with hx | hx
    · rw [hx]
      simp
    · have h2 : p.mass x ^ 2 = p.mass x * p.mass x := pow_two _
      rw [h2]
      exact mul_div_cancel_left₀ (p.mass x) hx
  calc (∑ x, p.mass x ^ 2 / p.mass x)
        = ∑ x, p.mass x := sum_congr rfl (fun x _ => hpt x)
    _ = 1 := p.total

/-- The exact identity behind layer composition: `Divergence.second` of two
laws on a product is the marginal `second` weighted by the conditional
`second`s — the pinned `Divergence.joint_chi2` transported through the
decomposition of BOTH laws. -/
theorem second_eq_of_decomposition (q p : Law (α × β)) :
    Divergence.second q p =
      ∑ x, ((marginal q).mass x ^ 2 / (marginal p).mass x)
        * Divergence.second (condOf q x) (condOf p x) := by
  conv_lhs => rw [← decomposition q, ← decomposition p]
  exact Divergence.joint_chi2 (marginal q) (marginal p) (condOf q) (condOf p)

/-- Inequality form of the decomposition: per-layer bounds `1 + e1`
(marginals) and `1 + e2` (conditionals), given `0 ≤ 1 + e2`, compose to
`(1 + e1) * (1 + e2)`. -/
theorem second_le_of_layers (q p : Law (α × β)) (e1 e2 : ℝ)
    (hm : Divergence.second (marginal q) (marginal p) ≤ 1 + e1)
    (hc : ∀ x, Divergence.second (condOf q x) (condOf p x) ≤ 1 + e2)
    (he2 : 0 ≤ 1 + e2) :
    Divergence.second q p ≤ (1 + e1) * (1 + e2) := by
  have h := SecondMoment.second_joint_le (marginal q) (marginal p)
    (condOf q) (condOf p) e1 e2 hm hc he2
  rw [decomposition q, decomposition p] at h
  exact h

/-- Second transport against a joint reference law, exact form: when the
conditional ratio is the constant `1 + e`, the second moment of `q` against
`Divergence.joint k l` is exactly `second (marginal q) k * (1 + e)`. -/
theorem second_joint_transport (q : Law (α × β)) (k : Law α) (l : α → Law β)
    (e : ℝ) (hc : ∀ x, Divergence.second (condOf q x) (l x) = 1 + e) :
    Divergence.second q (Divergence.joint k l)
      = Divergence.second (marginal q) k * (1 + e) := by
  conv_lhs => rw [← decomposition q]
  rw [Divergence.joint_chi2 (marginal q) k (condOf q) l]
  have hterm : ∀ x,
      ((marginal q).mass x ^ 2 / k.mass x) * Divergence.second (condOf q x) (l x)
        = ((marginal q).mass x ^ 2 / k.mass x) * (1 + e) := fun x => by
    rw [hc x]
  have h1 : (∑ x, ((marginal q).mass x ^ 2 / k.mass x)
        * Divergence.second (condOf q x) (l x))
      = ∑ x, ((marginal q).mass x ^ 2 / k.mass x) * (1 + e) :=
    sum_congr rfl (fun x _ => hterm x)
  have h2 : (∑ x, ((marginal q).mass x ^ 2 / k.mass x) * (1 + e))
      = (∑ x, ((marginal q).mass x ^ 2 / k.mass x)) * (1 + e) := by
    rw [← sum_mul]
  have h3 : (∑ x, ((marginal q).mass x ^ 2 / k.mass x))
      = Divergence.second (marginal q) k := rfl
  rw [h1, h2, h3]

/-- Second transport against a joint reference law, inequality form. -/
theorem second_joint_transport_le (q : Law (α × β)) (k : Law α)
    (l : α → Law β) (e : ℝ)
    (hc : ∀ x, Divergence.second (condOf q x) (l x) ≤ 1 + e) :
    Divergence.second q (Divergence.joint k l)
      ≤ Divergence.second (marginal q) k * (1 + e) := by
  conv_lhs => rw [← decomposition q]
  exact Divergence.joint_bound (marginal q) k (condOf q) l (1 + e)
    (fun x _ => hc x)

/-! ### The joint-bounds constructor for `FT1536.Run2.LocalJointCertificate` -/

/-- The honest per-challenge reply family: `FT1536.SigmaMath.freshHonest h`
decomposes as `Divergence.joint Law.uniform (honestReply h)` (see
`freshHonest_eq_joint`), and `honestReply h c` is exactly the conditional of
`freshHonest h` at the challenge `c` (see `freshHonest_condOf`). This is the
comparison target of layer 2 (reply per challenge). -/
noncomputable def honestReply (h c : FT1536.Relation.Rq) :
    Law (Option FT1536.PublicSimulation.BoxVec) :=
  FT1536.PublicSimulation.signBody (FT1536.SigmaMath.syndrome h) c

/-- The uniform mass is positive at every point. -/
theorem uniform_mass_pos (c : FT1536.Relation.Rq) :
    (0:ℝ) < (Law.uniform : Law FT1536.Relation.Rq).mass c := by
  show (0:ℝ) < 1 / Fintype.card FT1536.Relation.Rq
  have hn : (0:ℕ) < Fintype.card FT1536.Relation.Rq :=
    Fintype.card_pos_iff.mpr (by infer_instance)
  have hn' : (0:ℝ) < Fintype.card FT1536.Relation.Rq := by exact_mod_cast hn
  exact div_pos (by norm_num) hn'

/-- Absolute continuity against `Law.uniform` is free: the uniform mass is
positive everywhere. -/
theorem ac_uniform (q : Law FT1536.Relation.Rq) :
    Divergence.AC q (Law.uniform : Law FT1536.Relation.Rq) := by
  intro x hx
  exact absurd hx (ne_of_gt (uniform_mass_pos x))

/-- `FT1536.SigmaMath.freshHonest h` in its pinned joint form. -/
theorem freshHonest_eq_joint (h : FT1536.Relation.Rq) :
    FT1536.SigmaMath.freshHonest h
      = Divergence.joint (Law.uniform : Law FT1536.Relation.Rq) (honestReply h) :=
  rfl

/-- `honestReply h c` is the conditional of `FT1536.SigmaMath.freshHonest h`
at `c`: the marginal of `freshHonest` is `Law.uniform`, positive everywhere,
so the fallback is never engaged. -/
theorem freshHonest_condOf (h c : FT1536.Relation.Rq) :
    condOf (FT1536.SigmaMath.freshHonest h) c = honestReply h c := by
  rw [freshHonest_eq_joint h]
  exact condOf_joint (Law.uniform : Law FT1536.Relation.Rq) (honestReply h) c
    (uniform_mass_pos c)

/-- THE B4 joint-bounds constructor: two layer bounds compose directly into
a full `FT1536.Run2.LocalJointCertificate` with
`e = (1 + d1) * (1 + d2) - 1`.

* Layer 1 (challenge): the sampler's challenge marginal
  `marginal (samplerLaw S h st m r)` (defeq `(...).map Prod.fst`) has second
  moment at most `1 + d1` against `Law.uniform`; the ROM exact case `d1 = 0`
  is `localJointCertificate_of_uniform_challenge`;
* Layer 2 (reply per challenge): the conditional of the sampler law at each
  challenge `c` has second moment at most `1 + d2` against the honest reply
  family `honestReply h c`, which IS the conditional of
  `FT1536.SigmaMath.freshHonest h` (`freshHonest_condOf`);
* `hac` is the support/AC part of layer 2 — a pure second-moment bound does
  not see points where the honest mass is zero. -/
theorem localJointCertificate_of_joint_bounds
    (S : FT1536.Run2.Sampler) (d1 d2 : ℝ) (hd1 : 0 ≤ d1) (hd2 : 0 ≤ d2)
    (hmarg : ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State)
      (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce),
      Divergence.second (marginal (FT1536.Run2.samplerLaw S h st m r))
        (Law.uniform : Law FT1536.Relation.Rq) ≤ 1 + d1)
    (hcond : ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State)
      (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce) (c : FT1536.Relation.Rq),
      Divergence.second (condOf (FT1536.Run2.samplerLaw S h st m r) c)
        (honestReply h c) ≤ 1 + d2)
    (hac : ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State)
      (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce) (c : FT1536.Relation.Rq)
      (z : Option FT1536.PublicSimulation.BoxVec),
      (honestReply h c).mass z = 0 →
        (condOf (FT1536.Run2.samplerLaw S h st m r) c).mass z = 0) :
    FT1536.Run2.LocalJointCertificate S ((1 + d1) * (1 + d2) - 1) where
  nonnegative := by
    have h12 : ((1 + d1) * (1 + d2) - 1) = d1 + d2 + d1 * d2 := by ring
    rw [h12]
    nlinarith [mul_nonneg hd1 hd2]
  ac h st m r := by
    rw [← decomposition (FT1536.Run2.samplerLaw S h st m r),
      freshHonest_eq_joint h]
    exact Divergence.joint_ac (marginal (FT1536.Run2.samplerLaw S h st m r))
      (Law.uniform : Law FT1536.Relation.Rq)
      (condOf (FT1536.Run2.samplerLaw S h st m r)) (honestReply h)
      (ac_uniform _) (fun x _ => hac h st m r x)
  moment h st m r := by
    have h12 : (1:ℝ) + ((1 + d1) * (1 + d2) - 1) = (1 + d1) * (1 + d2) := by
      ring
    rw [h12, ← decomposition (FT1536.Run2.samplerLaw S h st m r),
      freshHonest_eq_joint h]
    exact SecondMoment.second_joint_le
      (marginal (FT1536.Run2.samplerLaw S h st m r))
      (Law.uniform : Law FT1536.Relation.Rq)
      (condOf (FT1536.Run2.samplerLaw S h st m r)) (honestReply h) d1 d2
      (hmarg h st m r) (hcond h st m r) (by linarith [hd2])

/-- The exact case `d1 = 0` of `localJointCertificate_of_joint_bounds`: if
the challenge marginal satisfies `FT1536.VerifyBind.UniformChallenge` (the
ROM identification with `Law.uniform`), the composed certificate has
`e = (1 + 0) * (1 + d2) - 1 = d2`. -/
theorem localJointCertificate_of_uniform_challenge
    (S : FT1536.Run2.Sampler) (d2 : ℝ) (hd2 : 0 ≤ d2)
    (huc : ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State)
      (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce),
      FT1536.VerifyBind.UniformChallenge
        (marginal (FT1536.Run2.samplerLaw S h st m r)))
    (hcond : ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State)
      (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce) (c : FT1536.Relation.Rq),
      Divergence.second (condOf (FT1536.Run2.samplerLaw S h st m r) c)
        (honestReply h c) ≤ 1 + d2)
    (hac : ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State)
      (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce) (c : FT1536.Relation.Rq)
      (z : Option FT1536.PublicSimulation.BoxVec),
      (honestReply h c).mass z = 0 →
        (condOf (FT1536.Run2.samplerLaw S h st m r) c).mass z = 0) :
    FT1536.Run2.LocalJointCertificate S d2 := by
  have hr : ((1 + (0:ℝ)) * (1 + d2) - 1) = d2 := by ring
  rw [← hr]
  refine localJointCertificate_of_joint_bounds S (0:ℝ) d2 (by norm_num) hd2
    ?_ hcond hac
  intro h st m r
  have h1 : marginal (FT1536.Run2.samplerLaw S h st m r)
      = (Law.uniform : Law FT1536.Relation.Rq) := huc h st m r
  rw [h1, second_self]
  norm_num

/-- Per-pointwise shortcut: one-sided factors `(1 + d1)` and `(1 + d2)` on
the two layers give the certificate `e = (1 + d1)^2 * (1 + d2)^2 - 1` (via
`SecondMoment.second_le_of_pointwise`, with the support/AC part of layer 2
supplied for free by `SecondMoment.ac_of_pointwise`). -/
theorem localJointCertificate_of_pointwise_bounds
    (S : FT1536.Run2.Sampler) (d1 d2 : ℝ) (hd1 : 0 ≤ d1) (hd2 : 0 ≤ d2)
    (hmarg : ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State)
      (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce) (c : FT1536.Relation.Rq),
      (marginal (FT1536.Run2.samplerLaw S h st m r)).mass c
        ≤ (1 + d1) * (Law.uniform : Law FT1536.Relation.Rq).mass c)
    (hcond : ∀ (h : FT1536.Relation.Rq) (st : FT1536.Run2.State)
      (m : FT1536.Run2.Bytes) (r : FT1536.Run2.Nonce) (c : FT1536.Relation.Rq)
      (z : Option FT1536.PublicSimulation.BoxVec),
      (condOf (FT1536.Run2.samplerLaw S h st m r) c).mass z
        ≤ (1 + d2) * (honestReply h c).mass z) :
    FT1536.Run2.LocalJointCertificate S ((1 + d1) ^ 2 * (1 + d2) ^ 2 - 1) := by
  have hdn1 : (0:ℝ) ≤ (1 + d1) ^ 2 - 1 := by
    have h : ((1:ℝ) + d1) ^ 2 - 1 = d1 ^ 2 + 2 * d1 := by ring
    rw [h]
    exact add_nonneg (sq_nonneg d1) (mul_nonneg (by norm_num) hd1)
  have hdn2 : (0:ℝ) ≤ (1 + d2) ^ 2 - 1 := by
    have h : ((1:ℝ) + d2) ^ 2 - 1 = d2 ^ 2 + 2 * d2 := by ring
    rw [h]
    exact add_nonneg (sq_nonneg d2) (mul_nonneg (by norm_num) hd2)
  have hr : ((1 + ((1 + d1) ^ 2 - 1)) * (1 + ((1 + d2) ^ 2 - 1)) - 1)
      = (1 + d1) ^ 2 * (1 + d2) ^ 2 - 1 := by ring
  rw [← hr]
  refine localJointCertificate_of_joint_bounds S ((1 + d1) ^ 2 - 1)
    ((1 + d2) ^ 2 - 1) hdn1 hdn2 ?_ ?_ ?_
  · intro h st m r
    have h1 := SecondMoment.second_le_of_pointwise
      (marginal (FT1536.Run2.samplerLaw S h st m r))
      (Law.uniform : Law FT1536.Relation.Rq) d1 hd1 (hmarg h st m r)
    have hr1 : (1:ℝ) + ((1 + d1) ^ 2 - 1) = (1 + d1) ^ 2 := by ring
    rw [hr1]
    exact h1
  · intro h st m r c
    have h1 := SecondMoment.second_le_of_pointwise
      (condOf (FT1536.Run2.samplerLaw S h st m r) c) (honestReply h c) d2 hd2
      (hcond h st m r c)
    have hr1 : (1:ℝ) + ((1 + d2) ^ 2 - 1) = (1 + d2) ^ 2 := by ring
    rw [hr1]
    exact h1
  · intro h st m r c z hz
    exact SecondMoment.ac_of_pointwise
      (condOf (FT1536.Run2.samplerLaw S h st m r) c) (honestReply h c)
      (hcond h st m r c) z hz

end FT1536.JointDecomp
