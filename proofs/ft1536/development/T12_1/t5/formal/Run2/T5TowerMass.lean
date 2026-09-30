import Run2.T5GateBudget
import Run2.ActualNTRUFiber

set_option exponentiation.threshold 100000

namespace FT1536.Run2.T5TowerMass
open TriangularGaussian T5GateBudget ActualNTRUFiber
open FT1536.Relation FT1536.Geometry CoefficientQuotient

/- Kernel layer of the T5 Poisson/LDL step (obligation (b)): the infinite
   Gaussian mass of one fiber is the total of a 3072-coordinate tower, and
   the tower scale is the common Poisson scale. All probability-side
   bounds below are kernel reductions to T5GateBudget/ShiftedGaussian; the
   named algebraic content is packaged as TowerRep (completion of squares
   of the concrete key Gram). -/

noncomputable def infFiberMass (h c : Rq) (a : ℝ) : ℝ :=
  ∑' z : {z : Vec×Vec // A h z = c}, Real.exp (-a*(Q z.val : ℝ))

theorem infFiberMass_basis (f g bigF bigG : Vec) (h fInv : Rq) (c : Rq)
    (ntru : multiply f bigG - multiply g bigF = constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f) = reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f) = constantCoeffs (1 : ZMod 18433))
    (a : ℝ) :
    infFiberMass h c a =
      ∑' u : Vec×Vec,
        Real.exp (-a*(Q ((centerRq c,0)+coefficientBasis f g bigF bigG u) : ℝ)) :=
  ActualNTRUFiber.gaussian_fiber_in_basis f g bigF bigG h fInv c
    ntru public_eq inverse_eq a

/- Completed-squares quadratic of a tower: atom is its exponential. -/
noncomputable def quad : {n : ℕ} → Tower n → Points n → ℝ
  | _, .nil, _ => 0
  | _, .snoc prior a shift, z => quad prior z.1 + a*((z.2 : ℝ) + shift z.1)^2

theorem atom_eq_exp : ∀ {n : ℕ} (T : Tower n) (z : Points n),
    atom T z = Real.exp (-Real.pi*quad T z)
  | _, .nil, _ => by simp [atom, quad]
  | _, .snoc prior a shift, z => by
    simp only [atom, quad]
    rw [mul_add, Real.exp_add, atom_eq_exp prior z.1]
    simp only [mul_assoc]

/- Global tilt of a tower: coefficients scale by k, shifts are unchanged. -/
def tiltTower (k : ℝ) : {n : ℕ} → Tower n → Tower n
  | _, .nil => .nil
  | _, .snoc prior a shift => .snoc (tiltTower k prior) (k*a) shift

theorem quad_tiltTower {n : ℕ} (k : ℝ) (T : Tower n) :
    ∀ z : Points n, quad (tiltTower k T) z = k*quad T z := by
  induction T with
  | nil => intro z; simp [tiltTower, quad]
  | snoc prior a shift ih =>
    intro z
    simp only [tiltTower, quad, ih z.1]
    ring

theorem scale_tiltTower {n : ℕ} (k : ℝ) (hk : 0 < k) (T : Tower n) :
    scale (tiltTower k T) = (1/Real.sqrt k)^n*scale T := by
  induction T with
  | nil => simp [tiltTower, scale]
  | snoc prior a shift ih =>
    simp only [tiltTower, scale]
    rw [ih, continuousMass_scale k a hk, pow_succ]
    ring

theorem localExponent_tiltTower {n : ℕ} (k : ℝ) (hk : 0 < k) (hk1 : k ≤ 1)
    {T : Tower n} (h : LocalExponent gateRatio T) :
    LocalExponent gateRatio (tiltTower k T) := by
  induction T with
  | nil => trivial
  | snoc prior a shift ih =>
    obtain ⟨h1, h2, h3⟩ := h
    refine ⟨ih h1, mul_pos hk h2, ?_⟩
    have hka : k*a ≤ a := by nlinarith
    have hdiv : Real.pi/a ≤ Real.pi/(k*a) :=
      div_le_div_of_nonneg_left Real.pi_pos.le (mul_pos hk h2) hka
    have hmono : Real.exp (-Real.pi/(k*a)) ≤ Real.exp (-Real.pi/a) := by
      apply Real.exp_le_exp.mpr
      rw [neg_div, neg_div]
      exact neg_le_neg hdiv
    exact hmono.trans h3

theorem total_eq_tsum {α : Type} {n : ℕ} (T : Tower n) (idx : α ≃ Points n) :
    total T = ∑' u : α, Real.exp (-Real.pi*quad T (idx u)) := by
  unfold total
  have h := idx.tsum_eq (fun w => atom T w)
  rw [← h]
  exact tsum_congr (fun u => atom_eq_exp T (idx u))

theorem infFiberMass_eq_quad (f g bigF bigG : Vec) (h fInv c : Rq)
    (ntru : multiply f bigG - multiply g bigF = constantCoeffs (18433 : ℤ))
    (public_eq : mulRq h (reduceVec f) = reduceVec g)
    (inverse_eq : mulRq fInv (reduceVec f) = constantCoeffs (1 : ZMod 18433))
    (a : ℝ) {T : Tower 3072} {idx : (Vec×Vec) ≃ Points 3072}
    (hq : ∀ u : Vec×Vec,
      (a/Real.pi)*(Q ((centerRq c,0)+coefficientBasis f g bigF bigG u) : ℝ)
        = quad T (idx u)) :
    infFiberMass h c a = total T := by
  rw [infFiberMass_basis f g bigF bigG h fInv c ntru public_eq inverse_eq a]
  have hs : (∑' u : Vec×Vec,
      Real.exp (-a*(Q ((centerRq c,0)+coefficientBasis f g bigF bigG u) : ℝ))) =
      ∑' u : Vec×Vec, Real.exp (-Real.pi*quad T (idx u)) := by
    apply tsum_congr
    intro u
    have hm : -a*(Q ((centerRq c,0)+coefficientBasis f g bigF bigG u) : ℝ)
        = -Real.pi*((a/Real.pi)*
            (Q ((centerRq c,0)+coefficientBasis f g bigF bigG u) : ℝ)) := by
      field_simp
    rw [hm, hq u]
  rw [hs]
  exact (total_eq_tsum T idx).symm

/- The algebraic certificate of obligation (b) for one key, target and
   scale: in the NTRU basis coordinates of the emitted key material the
   fiber exponent is the completed-squares quadratic of a tower whose
   local coefficients obey the gate cap. The tower data are the exact
   block-LDL pivots of the trapdoor Gram (stable leaf schedule) and real
   shear shifts; discharging this certificate is pure algebra/source
   refinement, no probability remains in it. -/
structure TowerRep (h c : Rq) (a : ℝ) where
  mk ::
  f : Vec
  g : Vec
  bigF : Vec
  bigG : Vec
  fInv : Rq
  ntru : multiply f bigG - multiply g bigF = constantCoeffs (18433 : ℤ)
  public_eq : mulRq h (reduceVec f) = reduceVec g
  inverse_eq : mulRq fInv (reduceVec f) = constantCoeffs (1 : ZMod 18433)
  T : Tower 3072
  idx : (Vec×Vec) ≃ Points 3072
  quadEq : ∀ u : Vec×Vec,
    (a/Real.pi)*(Q ((centerRq c,0)+coefficientBasis f g bigF bigG u) : ℝ)
      = quad T (idx u)
  localExp : LocalExponent gateRatio T

theorem infFiberMass_eq_total {h c : Rq} {a : ℝ} (hr : TowerRep h c a) :
    infFiberMass h c a = total hr.T :=
  infFiberMass_eq_quad hr.f hr.g hr.bigF hr.bigG h hr.fInv c
    hr.ntru hr.public_eq hr.inverse_eq a hr.quadEq

theorem infFiberMass_bounds_of {h c : Rq} {a : ℝ} {T : Tower 3072}
    (hmass : infFiberMass h c a = total T) (hloc : LocalExponent gateRatio T) :
    productLo*scale T ≤ infFiberMass h c a ∧
      infFiberMass h c a ≤ productHi*scale T := by
  rw [hmass]
  exact T5GateBudget.product_sandwich hloc

theorem infFiberMass_bounds {h c : Rq} {a : ℝ} (hr : TowerRep h c a) :
    productLo*scale hr.T ≤ infFiberMass h c a ∧
      infFiberMass h c a ≤ productHi*scale hr.T :=
  infFiberMass_bounds_of (infFiberMass_eq_total hr) hr.localExp

/- The tilted tower representation is derived kernel-side; no second
   algebraic certificate is needed for the Chernoff scale. -/
theorem infFiberMass_tilted {h c : Rq} {a : ℝ} (hr : TowerRep h c a) :
    infFiberMass h c ((7/8 : ℝ)*a) ≤ productHi*((8 : ℝ)/7)^1536*scale hr.T := by
  have hk : 0 < (7/8 : ℝ) := by norm_num
  have hk1 : (7/8 : ℝ) ≤ 1 := by norm_num
  have hq : ∀ u : Vec×Vec,
      (((7/8 : ℝ)*a)/Real.pi)*
        (Q ((centerRq c,0)+coefficientBasis hr.f hr.g hr.bigF hr.bigG u) : ℝ)
        = quad (tiltTower (7/8) hr.T) (hr.idx u) := by
    intro u
    have hm : (((7/8 : ℝ)*a)/Real.pi)*
        (Q ((centerRq c,0)+coefficientBasis hr.f hr.g hr.bigF hr.bigG u) : ℝ)
        = ((7/8 : ℝ))*((a/Real.pi)*
            (Q ((centerRq c,0)+coefficientBasis hr.f hr.g hr.bigF hr.bigG u) : ℝ)) := by
      field_simp
    rw [hm, hr.quadEq u, quad_tiltTower]
  have hmass := infFiberMass_eq_quad hr.f hr.g hr.bigF hr.bigG h hr.fInv c
    hr.ntru hr.public_eq hr.inverse_eq ((7/8 : ℝ)*a) hq
  have hloc : LocalExponent gateRatio (tiltTower (7/8) hr.T) :=
    localExponent_tiltTower (7/8) hk hk1 hr.localExp
  have hb := (infFiberMass_bounds_of hmass hloc).2
  have hscale : scale (tiltTower (7/8) hr.T) = ((8 : ℝ)/7)^1536*scale hr.T := by
    rw [scale_tiltTower (7/8) hk hr.T, tilt_const_power]
  rw [hscale, ← mul_assoc] at hb
  exact hb

/- Cross-target coherence: the towers of all fibers of one key share one
   scale (the pivots are key data; only the shear shifts depend on c). -/
def KeyTowerCert (h : Rq) (a : ℝ) : Prop :=
  ∃ v : ℝ, 0 < v ∧ ∀ c : Rq, ∃ hr : TowerRep h c a, scale hr.T = v

theorem inf_bounds_of_keyTower {h : Rq} {a : ℝ} (hk : KeyTowerCert h a) (c : Rq) :
    ∃ v : ℝ, 0 < v ∧
      productLo*v ≤ infFiberMass h c a ∧
      infFiberMass h c a ≤ productHi*v ∧
      infFiberMass h c ((7/8 : ℝ)*a) ≤ productHi*((8 : ℝ)/7)^1536*v := by
  obtain ⟨v, hv, hall⟩ := hk
  obtain ⟨hr, hs⟩ := hall c
  refine ⟨v, hv, ?_, ?_, ?_⟩
  · rw [← hs]
    exact (infFiberMass_bounds hr).1
  · rw [← hs]
    exact (infFiberMass_bounds hr).2
  · rw [← hs]
    exact infFiberMass_tilted hr

end FT1536.Run2.T5TowerMass
