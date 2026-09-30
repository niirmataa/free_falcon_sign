import Run2.T5Tilt

set_option exponentiation.threshold 100000
set_option maxRecDepth 65536

namespace FT1536.Run2.T5Tail
open TriangularGaussian T5GateBudget T5TowerMass T5Cholesky T5CholeskyCert
open T5BoxBound T5Tilt GaussianFiberTilt ShiftedGaussian
open FT1536.Relation FT1536.Geometry CoefficientQuotient ActualNTRUFiber

/- Uniform-MGF layer of the finite proposal-box transport (obligation (c)):
   the tilted coset exponent equals one explicit quadratic scalar plus the
   exponent of a tower at a shifted position. The scalar is purely
   quadratic in the tilt: the linear part cancels because the completion
   shift projects back to the coset representative (`muZero`). Combined
   with the shift-invariance of the tower scale this is the kernel form of
   the T5 "every real shift" guarantee used for coordinate tails. -/

structure TiltCert (h : Rq) (a : ℝ) where
  mk ::
  base : CholeskyKeyCert h a
  /-- The i-th primal coordinate as a linear functional of the w-coordinates. -/
  lin : Fin 3072 → Fin 3072 → ℝ
  /-- Riesz response of `lin i` under the Cholesky bilinear form. -/
  rho : Fin 3072 → Fin 3072 → ℝ
  lin_spec : ∀ (c : Rq) (i : Fin 3072) (u : Vec×Vec),
    (base.flat ((centerRq c,0) + coefficientBasis base.f base.g base.bigF base.bigG u) i : ℝ)
      = (base.flat ((centerRq c,0) : Vec×Vec) i : ℝ)
        + ∑ j, lin i j * (base.flat u j : ℝ)
  rho_spec : ∀ (i : Fin 3072) (w : Fin 3072 → ℝ),
    2*GBil base.d base.L (rho i) w = ∑ j, lin i j * w j
  /-- The completion shift projects back to the coset representative
      (kernel form of B * G^-1 * B^T = M^-1 for square B). -/
  muZero : ∀ (c : Rq) (i : Fin 3072),
    (base.flat ((centerRq c,0) : Vec×Vec) i : ℝ) = ∑ j, lin i j * (base.shiftOf c j)
  /-- The Riesz energy of each coordinate functional is the metric constant
      1/3 (kernel form of diag(M^-1) = 4/3 for the A2 blocks). -/
  varEq : ∀ (i : Fin 3072), GForm base.d base.L (rho i) = 1/3

/- Tilted coset mass in the basis parameterization. -/
noncomputable def uTiltExp {h : Rq} {a : ℝ} (base : CholeskyKeyCert h a)
    (c : Rq) (t : ℝ) (i : Fin 3072) (u : Vec×Vec) : ℝ :=
  Real.exp (-a*(Q ((centerRq c,0)+coefficientBasis base.f base.g base.bigF base.bigG u) : ℝ)
    + t*(base.flat ((centerRq c,0)+coefficientBasis base.f base.g base.bigF base.bigG u) i : ℝ))

theorem tilt_tower_quad {h : Rq} {a : ℝ} (ha : 0 < a) (ht : TiltCert h a) (c : Rq)
    (i : Fin 3072) (t : ℝ) (w : Fin 3072 → ℝ) :
    -a*(GForm ht.base.d ht.base.L (fun j => ht.base.shiftOf c j + w j))
      + t*(ht.base.flat ((centerRq c,0) : Vec×Vec) i + ∑ j, ht.lin i j * w j)
      = -a*(GForm ht.base.d ht.base.L
          (fun j => (ht.base.shiftOf c j - (t/a)*ht.rho i j) + w j))
        + t*(t/a)*GForm ht.base.d ht.base.L (ht.rho i) := by
  have hE0 : t*(t/a)*GForm ht.base.d ht.base.L (ht.rho i)
      = t*((t/a)*GForm ht.base.d ht.base.L (ht.rho i)) := by ring
  rw [hE0]
  set k := t/a with hk
  set P := k*GForm ht.base.d ht.base.L (ht.rho i) with hP
  have hresp : 2*GBil ht.base.d ht.base.L (fun j => k*ht.rho i j) w
      = k*(∑ j, ht.lin i j * w j) := by
    rw [GBil_smul_left]
    have h2 : 2*(k*GBil ht.base.d ht.base.L (ht.rho i) w)
        = k*(2*GBil ht.base.d ht.base.L (ht.rho i) w) := by ring
    rw [h2, ht.rho_spec i w]
  have hcore := gform_tilt_completion ht.base.d ht.base.L
    (ht.base.shiftOf c) (fun j => k*ht.rho i j) w
  rw [hresp] at hcore
  have hsub := GForm_sub_shift ht.base.d ht.base.L (ht.base.shiftOf c)
    (fun j => k*ht.rho i j)
  have hsmul := GForm_smul ht.base.d ht.base.L k (ht.rho i)
  have hsmul2 : GForm ht.base.d ht.base.L (fun i_1 => k*ht.rho i i_1) = k*P := by
    rw [hP, hsmul]
    ring
  have hbsmul := GBil_smul_right ht.base.d ht.base.L (ht.base.shiftOf c) k (ht.rho i)
  have hsym := GBil_symm ht.base.d ht.base.L (ht.rho i) (ht.base.shiftOf c)
  have hzero : 2*GBil ht.base.d ht.base.L (ht.rho i) (ht.base.shiftOf c)
      = ∑ j, ht.lin i j * (ht.base.shiftOf c j) :=
    ht.rho_spec i (ht.base.shiftOf c)
  have hmu := ht.muZero c i
  have hka : a*k = t := by rw [hk]; field_simp [ne_of_gt ha]
  have hA : GForm ht.base.d ht.base.L (fun j => ht.base.shiftOf c j + w j)
      = GForm ht.base.d ht.base.L (fun j => (ht.base.shiftOf c j - k*ht.rho i j) + w j)
        + GForm ht.base.d ht.base.L (ht.base.shiftOf c)
        - GForm ht.base.d ht.base.L (fun j => ht.base.shiftOf c j - k*ht.rho i j)
        + k*(∑ j, ht.lin i j * w j) := by linarith [hcore]
  have hD : GForm ht.base.d ht.base.L (fun j => ht.base.shiftOf c j - k*ht.rho i j)
      = GForm ht.base.d ht.base.L (ht.base.shiftOf c)
        - 2*k*GBil ht.base.d ht.base.L (ht.base.shiftOf c) (ht.rho i)
        + k*P := by nlinarith [hsub, hsmul2, hbsmul]
  have hY2 : (ht.base.flat ((centerRq c,0) : Vec×Vec) i : ℝ)
      = 2*GBil ht.base.d ht.base.L (ht.base.shiftOf c) (ht.rho i) := by
    linarith [hmu, hzero, hsym]
  rw [← hka]
  rw [hA, hD, hY2]
  ring

/- Common scale of the Cholesky towers (shift-independent). -/
noncomputable def certScale {h : Rq} {a : ℝ} (base : CholeskyKeyCert h a) : ℝ :=
  ∏ j : Fin 3072, continuousMass ((a/Real.pi)*base.d j)

theorem certScale_eq {h : Rq} {a : ℝ} (base : CholeskyKeyCert h a) (c : Rq) :
    scale (choleskyTower (a/Real.pi) base.d base.L (base.shiftOf c)) = certScale base := by
  unfold certScale
  exact scale_choleskyTower 3072 (a/Real.pi) base.d base.L (base.shiftOf c)

/- The tilted fiber mass equals one explicit quadratic scalar times the
   total of a tower at the shifted position: the uniform-MGF identity. -/
theorem tilt_sum_eq {h : Rq} {a : ℝ} (ha : 0 < a) (ht : TiltCert h a) (c : Rq)
    (i : Fin 3072) (t : ℝ) :
    (∑' w : {z : Vec×Vec // A h z = c},
        Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ)))
      = Real.exp (t*(t/a)*GForm ht.base.d ht.base.L (ht.rho i))
        * total (choleskyTower (a/Real.pi) ht.base.d ht.base.L
          (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j)) := by
  have hc0 := T5Cholesky.quad_choleskyTower 3072 (a/Real.pi) ht.base.d ht.base.L
    (ht.base.shiftOf c) ht.base.hlower ht.base.hdiag
  have hc1 := T5Cholesky.quad_choleskyTower 3072 (a/Real.pi) ht.base.d ht.base.L
    (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j) ht.base.hlower ht.base.hdiag
  have hex : ∀ u : Vec×Vec,
      -a*(Q ((centerRq c,0)+coefficientBasis ht.base.f ht.base.g ht.base.bigF ht.base.bigG u) : ℝ)
        + t*(ht.base.flat ((centerRq c,0)+coefficientBasis ht.base.f ht.base.g ht.base.bigF ht.base.bigG u) i : ℝ)
      = -Real.pi*quad (choleskyTower (a/Real.pi) ht.base.d ht.base.L
            (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j))
          ((ht.base.flat.trans (pointsEquiv 3072)) u)
        + t*(t/a)*GForm ht.base.d ht.base.L (ht.rho i) := by
    intro u
    have hlin := ht.lin_spec c i u
    have hq1 := hc1 (ht.base.flat u)
    have htilt := tilt_tower_quad ha ht c i t (fun j => (ht.base.flat u j : ℝ))
    rw [ht.base.gramEq c u, hlin]
    have hq1' : -Real.pi*quad (choleskyTower (a/Real.pi) ht.base.d ht.base.L
          (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j))
        ((ht.base.flat.trans (pointsEquiv 3072)) u)
        = -a*GForm ht.base.d ht.base.L
          (fun j => (ht.base.shiftOf c j - (t/a)*ht.rho i j) + (ht.base.flat u j)) := by
      rw [show (ht.base.flat.trans (pointsEquiv 3072)) u = pointsOf (ht.base.flat u) from rfl,
        hq1]
      field_simp
    rw [hq1']
    exact htilt
  have hreindex : (∑' w : {z : Vec×Vec // A h z = c},
        Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ)))
      = ∑' u : Vec×Vec,
          Real.exp (-a*(Q ((centerRq c,0)+coefficientBasis ht.base.f ht.base.g ht.base.bigF ht.base.bigG u) : ℝ)
            + t*(ht.base.flat ((centerRq c,0)+coefficientBasis ht.base.f ht.base.g ht.base.bigF ht.base.bigG u) i : ℝ)) := by
    rw [← (coordinates ht.base.f ht.base.g ht.base.bigF ht.base.bigG h ht.base.fInv c
      ht.base.ntru ht.base.public_eq ht.base.inverse_eq).tsum_eq
        (fun w => Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ)))]
    apply tsum_congr
    intro u
    rw [coordinates_formula ht.base.f ht.base.g ht.base.bigF ht.base.bigG h ht.base.fInv c
      ht.base.ntru ht.base.public_eq ht.base.inverse_eq u]
  rw [hreindex]
  have hkey : (∑' u : Vec×Vec,
        Real.exp (-a*(Q ((centerRq c,0)+coefficientBasis ht.base.f ht.base.g ht.base.bigF ht.base.bigG u) : ℝ)
          + t*(ht.base.flat ((centerRq c,0)+coefficientBasis ht.base.f ht.base.g ht.base.bigF ht.base.bigG u) i : ℝ)))
      = Real.exp (t*(t/a)*GForm ht.base.d ht.base.L (ht.rho i))
        * ∑' u : Vec×Vec,
            Real.exp (-Real.pi*quad (choleskyTower (a/Real.pi) ht.base.d ht.base.L
              (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j))
              ((ht.base.flat.trans (pointsEquiv 3072)) u)) := by
    rw [← tsum_mul_left]
    apply tsum_congr
    intro u
    rw [hex, Real.exp_add]
    ring
  rw [hkey]
  rw [← total_eq_tsum (choleskyTower (a/Real.pi) ht.base.d ht.base.L
    (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j)) (ht.base.flat.trans (pointsEquiv 3072))]

/- Uniform-MGF bound: the tilted fiber mass is at most the explicit
   quadratic scalar times the common scale (shift-independent). -/
theorem tilt_sum_bound {h : Rq} {a : ℝ} (ha : 0 < a) (ht : TiltCert h a) (c : Rq)
    (i : Fin 3072) (t : ℝ) :
    (∑' w : {z : Vec×Vec // A h z = c},
        Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ)))
      ≤ Real.exp (t*(t/a)*(1/3)) * (T5GateBudget.productHi * certScale ht.base) := by
  rw [tilt_sum_eq ha ht c i t, ht.varEq i]
  have hloc : LocalExponent gateRatio (choleskyTower (a/Real.pi) ht.base.d ht.base.L
      (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j)) :=
    localExponent_choleskyTower 3072 (a/Real.pi) ht.base.d ht.base.L
      (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j) (fun j => ht.base.coefBound j)
  have hb := T5GateBudget.product_sandwich hloc
  have hs2 : scale (choleskyTower (a/Real.pi) ht.base.d ht.base.L
      (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j)) = certScale ht.base :=
    scale_choleskyTower 3072 (a/Real.pi) ht.base.d ht.base.L
      (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j)
  rw [hs2] at hb
  exact mul_le_mul_of_nonneg_left hb.2 (Real.exp_pos _).le

/- Exponential core of the coordinate Chernoff bound. -/
theorem chernoff_exp_core {t L z : ℝ} (ht0 : 0 ≤ t)
    (hz : L ≤ |z|) :
    (1 : ℝ) ≤ Real.exp (-t*L + t*z) + Real.exp (-t*L - t*z) := by
  have hz' : L ≤ z ∨ z ≤ -L := by
    by_cases hsg : (0:ℝ) ≤ z
    · left
      rw [abs_of_nonneg hsg] at hz
      exact hz
    · right
      have habs : |z| = -z := abs_of_nonpos (le_of_not_ge hsg)
      rw [habs] at hz
      linarith
  rcases hz' with hz' | hz'
  · have h1 : (0 : ℝ) ≤ t*(z - L) := mul_nonneg ht0 (by linarith)
    have h2 : (0 : ℝ) ≤ Real.exp (-t*L - t*z) := (Real.exp_pos _).le
    have h3 : (1 : ℝ) ≤ Real.exp (t*(z - L)) := Real.one_le_exp h1
    have h4 : Real.exp (-t*L + t*z) = Real.exp (t*(z - L)) := by
      rw [show -t*L + t*z = t*(z - L) by ring]
    linarith
  · have h1 : (0 : ℝ) ≤ t*(-z - L) := mul_nonneg ht0 (by linarith)
    have h2 : (0 : ℝ) ≤ Real.exp (-t*L + t*z) := (Real.exp_pos _).le
    have h3 : (1 : ℝ) ≤ Real.exp (t*(-z - L)) := Real.one_le_exp h1
    have h4 : Real.exp (-t*L - t*z) = Real.exp (t*(-z - L)) := by
      rw [show -t*L - t*z = t*(-z - L) by ring]
    linarith

/- Per-coordinate out-of-box tail: the Chernoff bound on the tilted mass.
   With t = 1/12 (the optimizer L/(2*sigmaHat^2) for L = 65536,
   sigmaHat^2 = 1/(3*a)) the exponent becomes -L^2/(4*sigmaHat^2) =
   -2730.666..., matching the certified Sage constant. -/
theorem coord_tail_pointwise {h : Rq} {a : ℝ} (ht : TiltCert h a)
    (c : Rq) (i : Fin 3072) (t : ℝ) (ht0 : 0 ≤ t) :
    ∀ w : {z : Vec×Vec // A h z = c},
      (if (65536 : ℝ) ≤ |(ht.base.flat w.val i : ℝ)| then Real.exp (-a*(Q w.val : ℝ)) else 0)
        ≤ Real.exp (-t*65536) *
            (Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ))
              + Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ))) := by
  intro w
  have hfac : Real.exp (-t*65536) *
      (Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ))
        + Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ)))
      = Real.exp (-a*(Q w.val : ℝ)) *
        (Real.exp (-t*65536 + t*(ht.base.flat w.val i : ℝ))
          + Real.exp (-t*65536 - t*(ht.base.flat w.val i : ℝ))) := by
    rw [mul_add]
    have e1 : Real.exp (-t*65536) * Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ))
        = Real.exp (-a*(Q w.val : ℝ)) * Real.exp (-t*65536 + t*(ht.base.flat w.val i : ℝ)) := by
      have x1 : (-t*65536) + (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ))
          = (-a*(Q w.val : ℝ)) + (-t*65536 + t*(ht.base.flat w.val i : ℝ)) := by ring
      rw [← Real.exp_add, ← Real.exp_add, x1]
    have e2 : Real.exp (-t*65536) * Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ))
        = Real.exp (-a*(Q w.val : ℝ)) * Real.exp (-t*65536 - t*(ht.base.flat w.val i : ℝ)) := by
      have x2 : (-t*65536) + (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ))
          = (-a*(Q w.val : ℝ)) + (-t*65536 - t*(ht.base.flat w.val i : ℝ)) := by ring
      rw [← Real.exp_add, ← Real.exp_add, x2]
    rw [e1, e2, ← mul_add]
  split_ifs with hmem
  · have hc := chernoff_exp_core ht0 hmem
    rw [hfac]
    nlinarith [mul_le_mul_of_nonneg_right hc (Real.exp_pos (-a*(Q w.val : ℝ))).le]
  · exact mul_nonneg (Real.exp_pos _).le
      (add_nonneg (Real.exp_pos _).le (Real.exp_pos _).le)

/- The fiber point of the basis parameterization. -/
noncomputable def fiberPoint {h : Rq} {a : ℝ} (base : CholeskyKeyCert h a) (c : Rq)
    (u : Vec×Vec) : Vec×Vec :=
  (coordinates base.f base.g base.bigF base.bigG h base.fInv c base.ntru
    base.public_eq base.inverse_eq u).val

theorem fiberPoint_formula {h : Rq} {a : ℝ} (base : CholeskyKeyCert h a) (c : Rq)
    (u : Vec×Vec) :
    fiberPoint base c u = (centerRq c,0)+coefficientBasis base.f base.g base.bigF base.bigG u :=
  coordinates_formula base.f base.g base.bigF base.bigG h base.fInv c base.ntru
    base.public_eq base.inverse_eq u

/- Summability of the tilted fiber function, through the shifted tower. -/
theorem tilt_summable {h : Rq} {a : ℝ} (ha : 0 < a) (ht : TiltCert h a) (c : Rq)
    (i : Fin 3072) (t : ℝ) :
    Summable (fun w : {z : Vec×Vec // A h z = c} =>
      Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ))) := by
  have hr0 : (0 : ℝ) < gateRatio := by unfold gateRatio; positivity
  have hr1 : gateRatio < 1 := by unfold gateRatio; norm_num
  set T' := choleskyTower (a/Real.pi) ht.base.d ht.base.L
    (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j) with hT'
  have hloc : LocalExponent gateRatio T' := by
    rw [hT']
    exact localExponent_choleskyTower 3072 (a/Real.pi) ht.base.d ht.base.L
      (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j) (fun j => ht.base.coefBound j)
  have hts := tower_summable T' gateRatio hr0 hr1 hloc
  have hfun0 : (fun w : Points 3072 => Real.exp (-Real.pi*quad T' w)) = atom T' :=
    funext (fun w => (atom_eq_exp T' w).symm)
  have hs0 : Summable (fun w : Points 3072 => Real.exp (-Real.pi*quad T' w)) :=
    Eq.mpr (congrArg Summable hfun0) hts
  have hs1 : Summable (fun u : Vec×Vec =>
      Real.exp (-Real.pi*quad T' ((ht.base.flat.trans (pointsEquiv 3072)) u))) :=
    hs0.comp_injective (ht.base.flat.trans (pointsEquiv 3072)).injective
  have hex : ∀ u : Vec×Vec,
      Real.exp (-a*(Q (fiberPoint ht.base c u) : ℝ)
          + t*(ht.base.flat (fiberPoint ht.base c u) i : ℝ))
        = Real.exp (t*(t/a)*GForm ht.base.d ht.base.L (ht.rho i))
          * Real.exp (-Real.pi*quad T' ((ht.base.flat.trans (pointsEquiv 3072)) u)) := by
    intro u
    have hq1 := T5Cholesky.quad_choleskyTower 3072 (a/Real.pi) ht.base.d ht.base.L
      (fun j => ht.base.shiftOf c j - (t/a)*ht.rho i j) ht.base.hlower ht.base.hdiag
      (ht.base.flat u)
    have htilt := tilt_tower_quad ha ht c i t (fun j => (ht.base.flat u j : ℝ))
    have hq1' : quad T' ((ht.base.flat.trans (pointsEquiv 3072)) u)
        = (a/Real.pi)*GForm ht.base.d ht.base.L
          (fun j => (ht.base.shiftOf c j - (t/a)*ht.rho i j) + (ht.base.flat u j)) := by
      rw [hT', show (ht.base.flat.trans (pointsEquiv 3072)) u = pointsOf (ht.base.flat u) from rfl]
      exact hq1
    rw [fiberPoint_formula ht.base c u, ht.lin_spec c i u, ht.base.gramEq c u]
    have he : Real.exp (-Real.pi*((a/Real.pi)*GForm ht.base.d ht.base.L
        (fun j => (ht.base.shiftOf c j - (t/a)*ht.rho i j) + (ht.base.flat u j))))
        = Real.exp (-a*GForm ht.base.d ht.base.L
          (fun j => (ht.base.shiftOf c j - (t/a)*ht.rho i j) + (ht.base.flat u j))) := by
      congr 1
      field_simp
    rw [hq1', he, htilt, Real.exp_add]
    ring
  have hs2 : Summable (fun u : Vec×Vec =>
      Real.exp (t*(t/a)*GForm ht.base.d ht.base.L (ht.rho i))
        * Real.exp (-Real.pi*quad T' ((ht.base.flat.trans (pointsEquiv 3072)) u))) :=
    hs1.mul_left _
  have hfun2 : (fun u : Vec×Vec => Real.exp (-a*(Q (fiberPoint ht.base c u) : ℝ)
        + t*(ht.base.flat (fiberPoint ht.base c u) i : ℝ)))
      = (fun u : Vec×Vec =>
        Real.exp (t*(t/a)*GForm ht.base.d ht.base.L (ht.rho i))
          * Real.exp (-Real.pi*quad T' ((ht.base.flat.trans (pointsEquiv 3072)) u))) :=
    funext hex
  have hs3 : Summable (fun u : Vec×Vec => Real.exp (-a*(Q (fiberPoint ht.base c u) : ℝ)
      + t*(ht.base.flat (fiberPoint ht.base c u) i : ℝ))) :=
    Eq.mpr (congrArg Summable hfun2) hs2
  have hinj : Function.Injective
      (coordinates ht.base.f ht.base.g ht.base.bigF ht.base.bigG h ht.base.fInv c
        ht.base.ntru ht.base.public_eq ht.base.inverse_eq).symm :=
    (coordinates ht.base.f ht.base.g ht.base.bigF ht.base.bigG h ht.base.fInv c
      ht.base.ntru ht.base.public_eq ht.base.inverse_eq).symm.injective
  have hs4 := hs3.comp_injective hinj
  have hfun3 : (fun w : {z : Vec×Vec // A h z = c} => Real.exp (-a*(Q (fiberPoint ht.base c
        ((coordinates ht.base.f ht.base.g ht.base.bigF ht.base.bigG h ht.base.fInv c
          ht.base.ntru ht.base.public_eq ht.base.inverse_eq).symm w)) : ℝ)
        + t*(ht.base.flat (fiberPoint ht.base c
          ((coordinates ht.base.f ht.base.g ht.base.bigF ht.base.bigG h ht.base.fInv c
            ht.base.ntru ht.base.public_eq ht.base.inverse_eq).symm w)) i : ℝ)))
      = (fun w : {z : Vec×Vec // A h z = c} =>
        Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ))) := by
    funext w
    have hfp : fiberPoint ht.base c
        ((coordinates ht.base.f ht.base.g ht.base.bigF ht.base.bigG h ht.base.fInv c
          ht.base.ntru ht.base.public_eq ht.base.inverse_eq).symm w) = w.val :=
      congrArg Subtype.val ((coordinates ht.base.f ht.base.g ht.base.bigF ht.base.bigG h
        ht.base.fInv c ht.base.ntru ht.base.public_eq ht.base.inverse_eq).apply_symm_apply w)
    rw [hfp]
  exact Eq.mp (congrArg Summable hfun3) hs4


/- Per-coordinate out-of-box tail bound: Chernoff + uniform MGF. -/
/- Summands of the per-coordinate tail, packaged to keep elaboration light. -/
noncomputable def coordTailFun {h : Rq} {a : ℝ} (base : CholeskyKeyCert h a)
    (i : Fin 3072) (w : {z : Vec×Vec // A h z = c}) : ℝ :=
  if (65536 : ℝ) ≤ |(base.flat w.val i : ℝ)| then Real.exp (-a*(Q w.val : ℝ)) else 0

noncomputable def coordMajFun {h : Rq} {a : ℝ} (base : CholeskyKeyCert h a)
    (i : Fin 3072) (t : ℝ) (w : {z : Vec×Vec // A h z = c}) : ℝ :=
  Real.exp (-t*65536) * (Real.exp (-a*(Q w.val : ℝ) + t*(base.flat w.val i : ℝ))
    + Real.exp (-a*(Q w.val : ℝ) - t*(base.flat w.val i : ℝ)))

theorem coordTailFun_le {h : Rq} {a : ℝ} (ht : TiltCert h a)
    (i : Fin 3072) (t : ℝ) (ht0 : 0 ≤ t) :
    ∀ w : {z : Vec×Vec // A h z = c}, coordTailFun ht.base i w ≤ coordMajFun ht.base i t w := by
  intro w
  unfold coordTailFun coordMajFun
  exact coord_tail_pointwise ht c i t ht0 w

/- Per-coordinate out-of-box tail bound: Chernoff + uniform MGF. -/
theorem coord_tail_bound {h : Rq} {a : ℝ} (ha : 0 < a) (ht : TiltCert h a)
    (c : Rq) (i : Fin 3072) (t : ℝ) (ht0 : 0 ≤ t) :
    (∑' w : {z : Vec×Vec // A h z = c}, coordTailFun ht.base i w)
      ≤ 2*Real.exp (-t*65536 + t*(t/a)*(1/3)) * (T5GateBudget.productHi * certScale ht.base) := by
  have hpt : ∀ w : {z : Vec×Vec // A h z = c},
      coordTailFun ht.base i w ≤ coordMajFun ht.base i t w :=
    coordTailFun_le ht i t ht0
  have hg1 : Summable (fun w : {z : Vec×Vec // A h z = c} =>
      Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ))) :=
    tilt_summable ha ht c i t
  have hg2raw : Summable (fun w : {z : Vec×Vec // A h z = c} =>
      Real.exp (-a*(Q w.val : ℝ) + (-t)*(ht.base.flat w.val i : ℝ))) :=
    tilt_summable ha ht c i (-t)
  have hconv2 : (fun w : {z : Vec×Vec // A h z = c} =>
      Real.exp (-a*(Q w.val : ℝ) + (-t)*(ht.base.flat w.val i : ℝ)))
      = (fun w : {z : Vec×Vec // A h z = c} =>
        Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ))) := by
    funext w
    rw [show -a*(Q w.val : ℝ) + (-t)*(ht.base.flat w.val i : ℝ)
        = -a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ) by ring]
  have hg2 : Summable (fun w : {z : Vec×Vec // A h z = c} =>
      Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ))) :=
    Eq.mp (congrArg Summable hconv2) hg2raw
  have hadd : Summable (fun w : {z : Vec×Vec // A h z = c} =>
      (Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ))
        + Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ)))) :=
    hg1.add hg2
  have hgmaj : Summable (fun w : {z : Vec×Vec // A h z = c} => coordMajFun ht.base i t w) := by
    have hcm : (fun w : {z : Vec×Vec // A h z = c} => coordMajFun ht.base i t w)
        = (fun w : {z : Vec×Vec // A h z = c} =>
          Real.exp (-t*65536) * (Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ))
            + Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ)))) := by
      rfl
    rw [hcm]
    exact hadd.mul_left _
  have hf : Summable (fun w : {z : Vec×Vec // A h z = c} => coordTailFun ht.base i w) :=
    Summable.of_nonneg_of_le (fun w => by unfold coordTailFun; split_ifs <;> positivity) hpt hgmaj
  have hsum := hf.tsum_le_tsum hpt hgmaj
  have hmaj : (∑' w : {z : Vec×Vec // A h z = c}, coordMajFun ht.base i t w)
      = Real.exp (-t*65536) *
          ((∑' w : {z : Vec×Vec // A h z = c}, Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ)))
          + (∑' w : {z : Vec×Vec // A h z = c}, Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ)))) := by
    rw [← hg1.tsum_add hg2]
    rw [← tsum_mul_left]
    exact tsum_congr (fun w => by unfold coordMajFun; rw [mul_add])
  have hpos := T5Tail.tilt_sum_bound ha ht c i t
  have hneg := T5Tail.tilt_sum_bound ha ht c i (-t)
  have hconv : ∀ w : {z : Vec×Vec // A h z = c},
      Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ))
        = Real.exp (-a*(Q w.val : ℝ) + (-t)*(ht.base.flat w.val i : ℝ)) := by
    intro w
    rw [show -a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ)
        = -a*(Q w.val : ℝ) + (-t)*(ht.base.flat w.val i : ℝ) by ring]
  have hneg' : (∑' w : {z : Vec×Vec // A h z = c},
      Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ)))
      = ∑' w : {z : Vec×Vec // A h z = c},
        Real.exp (-a*(Q w.val : ℝ) + (-t)*(ht.base.flat w.val i : ℝ)) :=
    tsum_congr (fun w => hconv w)
  rw [← hneg'] at hneg
  set K := T5GateBudget.productHi * certScale ht.base with hK
  have hE2 : Real.exp ((-t)*((-t)/a)*(1/3)) = Real.exp (t*(t/a)*(1/3)) := by
    rw [show (-t)*((-t)/a)*(1/3) = t*(t/a)*(1/3) by field_simp]
  rw [hE2] at hneg
  calc
    (∑' w : {z : Vec×Vec // A h z = c}, coordTailFun ht.base i w)
        ≤ Real.exp (-t*65536) *
            ((∑' w : {z : Vec×Vec // A h z = c}, Real.exp (-a*(Q w.val : ℝ) + t*(ht.base.flat w.val i : ℝ)))
            + (∑' w : {z : Vec×Vec // A h z = c}, Real.exp (-a*(Q w.val : ℝ) - t*(ht.base.flat w.val i : ℝ)))) :=
      hsum.trans (le_of_eq hmaj)
    _ ≤ Real.exp (-t*65536) *
          (Real.exp (t*(t/a)*(1/3))*K + Real.exp (t*(t/a)*(1/3))*K) := by
      have hK' : K = T5GateBudget.productHi * certScale ht.base := hK
      rw [hK'] at hpos hneg ⊢
      exact mul_le_mul_of_nonneg_left (add_le_add hpos hneg) (Real.exp_pos _).le
    _ = 2*Real.exp (-t*65536 + t*(t/a)*(1/3)) * K := by
      rw [hK]
      have he : Real.exp (-t*65536) * Real.exp (t*(t/a)*(1/3))
          = Real.exp (-t*65536 + t*(t/a)*(1/3)) := by
        rw [← Real.exp_add]
      have hcalc : Real.exp (-t*65536) *
            (Real.exp (t*(t/a)*(1/3)) * (T5GateBudget.productHi * certScale ht.base)
              + Real.exp (t*(t/a)*(1/3)) * (T5GateBudget.productHi * certScale ht.base))
          = 2*(Real.exp (-t*65536) * Real.exp (t*(t/a)*(1/3)))
              * (T5GateBudget.productHi * certScale ht.base) := by
        ring
      rw [hcalc, he]

end FT1536.Run2.T5Tail
