import Run2.T5TowerMass

set_option exponentiation.threshold 100000

namespace FT1536.Run2.T5Cholesky
open TriangularGaussian T5GateBudget T5TowerMass

/- Generic kernel layer of the T5 completion-of-squares (obligation (b)):
   any quadratic form given by a Cholesky factorization G = L^T D L with
   unit-lower L, evaluated at integer points plus a real shift, is exactly
   the quad of an explicit tower. Once the key supplies (d, L, shift) and
   the polynomial identity with the concrete fiber exponent, the whole
   mass comparison is T5TowerMass/T5GateBudget kernel content. -/

/- Coordinate packing of nested tower points. -/
def pointsOf : {n : ℕ} → (Fin n → ℤ) → Points n
  | 0, _ => ()
  | n+1, z => (pointsOf (fun i => z i.castSucc), z (Fin.last n))

def coordsOf : {n : ℕ} → Points n → (Fin n → ℤ)
  | 0, _ => Fin.elim0
  | _+1, p => Fin.snoc (coordsOf p.1) p.2

theorem coordsOf_pointsOf : ∀ {n : ℕ} (z : Fin n → ℤ), coordsOf (pointsOf z) = z := by
  intro n
  induction n with
  | zero => intro z; funext i; exact Fin.elim0 i
  | succ n ih =>
    intro z
    have := ih (fun i => z i.castSucc)
    simp only [pointsOf, coordsOf, this]
    exact Fin.snoc_init_self z

theorem pointsOf_coordsOf : ∀ {n : ℕ} (p : Points n), pointsOf (coordsOf p) = p := by
  intro n
  induction n with
  | zero => intro p; rfl
  | succ n ih =>
    intro p
    have := ih p.1
    simp only [coordsOf, pointsOf, Fin.snoc_castSucc, Fin.snoc_last, this]
    rfl

def pointsEquiv (n : ℕ) : (Fin n → ℤ) ≃ Points n where
  toFun := pointsOf
  invFun := coordsOf
  left_inv := coordsOf_pointsOf
  right_inv := pointsOf_coordsOf

/- Quadratic form of the Cholesky data: x |-> sum_j d_j * (row_j L x)^2,
   i.e. the x^T L^T D L x form. -/
def GForm {n : ℕ} (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ) (x : Fin n → ℝ) : ℝ :=
  ∑ j : Fin n, d j * (∑ i : Fin n, L j i * x i)^2

/- Tower built from the Cholesky data: coefficient j is k*d_j, the j-th
   shift is the affine part of row j on the earlier coordinates. -/
def choleskyTower : {n : ℕ} → (k : ℝ) → (d : Fin n → ℝ) → (L : Fin n → Fin n → ℝ)
    → (v : Fin n → ℝ) → Tower n
  | 0, _, _, _, _ => .nil
  | n+1, k, d, L, v =>
    .snoc (choleskyTower k (fun i => d i.castSucc)
        (fun i j => L i.castSucc j.castSucc) (fun i => v i.castSucc))
      (k*d (Fin.last n))
      (fun p : Points n => v (Fin.last n) +
        ∑ i : Fin n, L (Fin.last n) i.castSucc * ((coordsOf p i : ℝ) + v i.castSucc))

theorem GForm_succ {n : ℕ} (d : Fin (n+1) → ℝ) (L : Fin (n+1) → Fin (n+1) → ℝ)
    (x : Fin (n+1) → ℝ) (hlower : ∀ i j : Fin (n+1), i < j → L i j = 0)
    (hdiag : ∀ j : Fin (n+1), L j j = 1) :
    GForm d L x =
      GForm (fun i => d i.castSucc) (fun i j => L i.castSucc j.castSucc)
          (fun i => x i.castSucc) +
      d (Fin.last n) *
        (x (Fin.last n) + ∑ i : Fin n, L (Fin.last n) i.castSucc * x i.castSucc)^2 := by
  unfold GForm
  rw [Fin.sum_univ_castSucc]
  congr 1
  · apply Finset.sum_congr rfl
    intro j _
    have hz : L j.castSucc (Fin.last n) = 0 := by
      apply hlower
      rw [Fin.lt_def, Fin.val_castSucc, Fin.val_last]
      exact j.isLt
    rw [Fin.sum_univ_castSucc, hz, zero_mul, add_zero]
  · have h1 : L (Fin.last n) (Fin.last n) = 1 := hdiag (Fin.last n)
    rw [Fin.sum_univ_castSucc, h1, one_mul]
    ring

theorem quad_choleskyTower (n : ℕ) :
    ∀ (k : ℝ) (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ) (v : Fin n → ℝ),
      (∀ i j : Fin n, i < j → L i j = 0) → (∀ j : Fin n, L j j = 1) →
      ∀ z : Fin n → ℤ,
        quad (choleskyTower k d L v) (pointsOf z)
          = k*GForm d L (fun i => v i + (z i : ℝ)) := by
  induction n with
  | zero =>
    intro k d L v _hlower _hdiag z
    simp [choleskyTower, pointsOf, quad, GForm]
  | succ n ih =>
    intro k d L v hlower hdiag z
    have hlower' : ∀ i j : Fin n, i < j → L i.castSucc j.castSucc = 0 := by
      intro i j hij
      apply hlower
      rw [Fin.lt_def, Fin.val_castSucc, Fin.val_castSucc]
      exact Fin.lt_def.mp hij
    have hdiag' : ∀ j : Fin n, L j.castSucc j.castSucc = 1 := fun j => hdiag j.castSucc
    have hih := ih k (fun i => d i.castSucc) (fun i j => L i.castSucc j.castSucc)
      (fun i => v i.castSucc) hlower' hdiag' (fun i => z i.castSucc)
    have hlast : L (Fin.last n) (Fin.last n) = 1 := hdiag (Fin.last n)
    have hsum : (∑ i : Fin n, L (Fin.last n) i.castSucc *
          ((z i.castSucc : ℝ) + v i.castSucc))
        = ∑ i : Fin n, L (Fin.last n) i.castSucc *
          (v i.castSucc + (z i.castSucc : ℝ)) := by
      apply Finset.sum_congr rfl
      intro i _
      ring
    have hsq : v (Fin.last n) +
        ∑ i : Fin n, L (Fin.last n) i.castSucc *
          ((coordsOf (pointsOf (fun i => z i.castSucc)) i : ℝ) + v i.castSucc)
        = v (Fin.last n) +
          ∑ i : Fin n, L (Fin.last n) i.castSucc * (v i.castSucc + (z i.castSucc : ℝ)) := by
      rw [coordsOf_pointsOf]
      simp only [hsum]
    simp only [choleskyTower, pointsOf, quad, hsq]
    simp only [hih, GForm_succ d L (fun i => v i + (z i : ℝ)) hlower hdiag]
    ring

theorem localExponent_choleskyTower (n : ℕ) :
    ∀ (k : ℝ) (d : Fin n → ℝ) (L : Fin n → Fin n → ℝ) (v : Fin n → ℝ),
      (∀ j : Fin n, 0 < k*d j ∧ k*d j ≤ gateCoefficientCap) →
      LocalExponent gateRatio (choleskyTower k d L v) := by
  induction n with
  | zero => intro k d L v _; trivial
  | succ n ih =>
    intro k d L v hcoef
    simp only [choleskyTower]
    exact ⟨ih k (fun i => d i.castSucc) (fun i j => L i.castSucc j.castSucc)
        (fun i => v i.castSucc) (fun j => hcoef j.castSucc),
      (hcoef (Fin.last n)).1,
      gate_row_exponential (k*d (Fin.last n)) (hcoef (Fin.last n)).1
        (hcoef (Fin.last n)).2⟩

end FT1536.Run2.T5Cholesky
