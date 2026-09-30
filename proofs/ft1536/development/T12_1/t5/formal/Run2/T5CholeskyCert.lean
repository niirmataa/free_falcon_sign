import Run2.T5Cholesky

set_option exponentiation.threshold 100000

namespace FT1536.Run2.T5CholeskyCert
open TriangularGaussian T5GateBudget T5TowerMass T5Cholesky ShiftedGaussian
open FT1536.Relation FT1536.Geometry CoefficientQuotient ActualNTRUFiber

/- Structured algebraic certificate of obligation (b) for one key: the
   concrete fiber exponent of the key in its NTRU basis coordinates is the
   Cholesky form GForm of data (d, L) with real per-target shifts. The
   single identity `gramEq` is a polynomial identity on integer points;
   everything probabilistic (tower assembly, mass comparison, tilt) is
   kernel content of T5Cholesky/T5TowerMass/T5GateBudget. Discharging
   gramEq is the exact block-LDL work of the pinned T5 a2 bridge plus
   source refinement of the leaf schedule. -/
structure CholeskyKeyCert (h : Rq) (a : ℝ) where
  mk ::
  f : Vec
  g : Vec
  bigF : Vec
  bigG : Vec
  fInv : Rq
  ntru : multiply f bigG - multiply g bigF = constantCoeffs (18433 : ℤ)
  public_eq : mulRq h (reduceVec f) = reduceVec g
  inverse_eq : mulRq fInv (reduceVec f) = constantCoeffs (1 : ZMod 18433)
  d : Fin 3072 → ℝ
  L : Fin 3072 → Fin 3072 → ℝ
  flat : (Vec×Vec) ≃ (Fin 3072 → ℤ)
  hlower : ∀ i j : Fin 3072, i < j → L i j = 0
  hdiag : ∀ j : Fin 3072, L j j = 1
  coefBound : ∀ j : Fin 3072, 0 < (a/Real.pi)*d j ∧ (a/Real.pi)*d j ≤ gateCoefficientCap
  shiftOf : Rq → Fin 3072 → ℝ
  gramEq : ∀ (c : Rq) (u : Vec×Vec),
    (Q ((centerRq c,0)+coefficientBasis f g bigF bigG u) : ℝ)
      = GForm d L (fun i => shiftOf c i + (flat u i : ℝ))

/- The tower scale of Cholesky data is the product of the per-coordinate
   continuous masses; it does not see the shifts. -/
theorem scale_choleskyTower : ∀ (n : ℕ) (k : ℝ) (d : Fin n → ℝ)
    (L : Fin n → Fin n → ℝ) (v : Fin n → ℝ),
    scale (choleskyTower k d L v) = ∏ j : Fin n, continuousMass (k*d j) := by
  intro n
  induction n with
  | zero => intro k d L v; simp [choleskyTower, scale]
  | succ n ih =>
    intro k d L v
    simp only [choleskyTower, scale]
    rw [ih, Fin.prod_univ_castSucc]

noncomputable def towerRep_of_cholesky {h : Rq} {a : ℝ} (hc : CholeskyKeyCert h a) (c : Rq) :
    TowerRep h c a where
  f := hc.f
  g := hc.g
  bigF := hc.bigF
  bigG := hc.bigG
  fInv := hc.fInv
  ntru := hc.ntru
  public_eq := hc.public_eq
  inverse_eq := hc.inverse_eq
  T := choleskyTower (a/Real.pi) hc.d hc.L (hc.shiftOf c)
  idx := hc.flat.trans (pointsEquiv 3072)
  quadEq := by
    intro u
    have hq := quad_choleskyTower 3072 (a/Real.pi) hc.d hc.L (hc.shiftOf c)
      hc.hlower hc.hdiag (hc.flat u)
    have hidx : (hc.flat.trans (pointsEquiv 3072)) u = pointsOf (hc.flat u) := rfl
    rw [hidx, hq, hc.gramEq c u]
  localExp := localExponent_choleskyTower 3072 (a/Real.pi) hc.d hc.L (hc.shiftOf c)
    (fun j => hc.coefBound j)

/- Kernel consumption: the Cholesky certificate yields the common-scale
   tower certificate of T5TowerMass; only the shift data depend on c. -/
theorem keyTowerCert_of_cholesky {h : Rq} {a : ℝ} (hc : CholeskyKeyCert h a) :
    KeyTowerCert h a := by
  refine ⟨∏ j : Fin 3072, continuousMass ((a/Real.pi)*hc.d j), ?_, ?_⟩
  · exact Finset.prod_pos (fun j _ => continuousMass_positive _ (hc.coefBound j).1)
  · intro c
    refine ⟨towerRep_of_cholesky hc c, ?_⟩
    exact scale_choleskyTower 3072 (a/Real.pi) hc.d hc.L (hc.shiftOf c)

end FT1536.Run2.T5CholeskyCert
