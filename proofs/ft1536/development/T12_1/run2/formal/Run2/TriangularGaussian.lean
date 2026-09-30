import Run2.ShiftedGaussian

namespace FT1536.Run2.TriangularGaussian
open ShiftedGaussian

def Points : ℕ → Type
  | 0 => Unit
  | n+1 => Points n × ℤ

/- Each new coordinate is shifted by an arbitrary real function of the
   preceding integer coordinates. Real LDL shears need not be integral. -/
inductive Tower : ℕ → Type
  | nil : Tower 0
  | snoc {n : ℕ} (prior : Tower n) (a : ℝ) (shift : Points n → ℝ) : Tower (n+1)

noncomputable def atom : {n : ℕ} → Tower n → Points n → ℝ
  | _, .nil, _ => 1
  | _, .snoc prior a shift, z =>
    atom prior z.1 * Real.exp (-Real.pi*a*((z.2 : ℝ)+shift z.1)^2)

noncomputable def scale : {n : ℕ} → Tower n → ℝ
  | _, .nil => 1
  | _, .snoc prior a _ => scale prior * continuousMass a

noncomputable def total {n : ℕ} (T : Tower n) : ℝ := ∑' z, atom T z

def LocalExponent (r : ℝ) : {n : ℕ} → Tower n → Prop
  | _, .nil => True
  | _, .snoc prior a _ => LocalExponent r prior ∧ 0<a ∧ Real.exp (-Real.pi/a) ≤ r

theorem atom_nonnegative {n : ℕ} (T : Tower n) (z : Points n) : 0 ≤ atom T z := by
  induction T with
  | nil => norm_num [atom]
  | snoc prior a shift ih =>
    exact mul_nonneg (ih z.1) (Real.exp_pos _).le

theorem scale_positive {n : ℕ} (T : Tower n) (r : ℝ) (h : LocalExponent r T) :
    0 < scale T := by
  induction T with
  | nil => norm_num [scale]
  | snoc prior a shift ih =>
    exact mul_pos (ih h.1) (continuousMass_positive a h.2.1)

theorem tower_summable {n : ℕ} (T : Tower n) (r : ℝ) (hr0 : 0<r) (hr1 : r<1)
    (h : LocalExponent r T) : Summable (atom T) := by
  induction T with
  | nil =>
    change Summable (fun _ : Unit => (1 : ℝ))
    exact (hasSum_fintype _).summable
  | snoc prior a shift ih =>
    have hi := ih h.1
    change Summable (fun z : Points _ × ℤ =>
      atom prior z.1*Real.exp (-Real.pi*a*((z.2 : ℝ)+shift z.1)^2))
    apply (summable_prod_of_nonneg (fun z => mul_nonneg (atom_nonnegative prior z.1)
      (Real.exp_pos _).le)).2
    constructor
    · intro z
      change Summable (fun y : ℤ => atom prior z*Real.exp (-Real.pi*a*((y : ℝ)+shift z)^2))
      exact (shifted_summable a (shift z) h.2.1).mul_left (atom prior z)
    · simp only [tsum_mul_left]
      refine (hi.mul_right ((1+2*r/(1-r))*continuousMass a)).of_nonneg_of_le ?_ ?_
      · intro z
        exact mul_nonneg (atom_nonnegative prior z) (tsum_nonneg fun _ => (Real.exp_pos _).le)
      · intro z
        exact mul_le_mul_of_nonneg_left
          (shifted_mass_bounds a (shift z) r h.2.1 hr0 hr1 h.2.2).2
          (atom_nonnegative prior z)

theorem last_coordinate_bounds {n : ℕ} (T : Tower n) (a : ℝ) (shift : Points n → ℝ)
    (r : ℝ) (hr0 : 0<r) (hr1 : r<1) (h : LocalExponent r (.snoc T a shift)) :
    total T*((1-2*r/(1-r))*continuousMass a) ≤ total (.snoc T a shift) ∧
      total (.snoc T a shift) ≤ total T*((1+2*r/(1-r))*continuousMass a) := by
  have hs := tower_summable (.snoc T a shift) r hr0 hr1 h
  have hi := tower_summable T r hr0 hr1 h.1
  have hrows : Summable (fun z => atom T z*shiftedMass a (shift z)) := by
    simpa only [atom, tsum_mul_left, shiftedMass] using hs.prod
  have he : total (.snoc T a shift) = ∑' z, atom T z*shiftedMass a (shift z) := by
    unfold total
    change (∑' z : Points n × ℤ, atom (.snoc T a shift) z) = _
    rw [hs.tsum_prod]
    simp only [atom, tsum_mul_left, shiftedMass]
  rw [he]
  constructor
  · have hh := (hi.mul_right ((1-2*r/(1-r))*continuousMass a)).tsum_le_tsum
      (fun z => mul_le_mul_of_nonneg_left
        (shifted_mass_bounds a (shift z) r h.2.1 hr0 hr1 h.2.2).1
        (atom_nonnegative T z)) hrows
    simpa only [tsum_mul_right, total] using hh
  · have hh := hrows.tsum_le_tsum
      (fun z => mul_le_mul_of_nonneg_left
        (shifted_mass_bounds a (shift z) r h.2.1 hr0 hr1 h.2.2).2
        (atom_nonnegative T z))
      (hi.mul_right ((1+2*r/(1-r))*continuousMass a))
    simpa only [tsum_mul_right, total] using hh

theorem triangular_mass_bounds {n : ℕ} (T : Tower n) (r : ℝ)
    (hr0 : 0<r) (hr1 : r<1) (he : 2*r/(1-r) ≤ 1) (h : LocalExponent r T) :
    (1-2*r/(1-r))^n*scale T ≤ total T ∧
      total T ≤ (1+2*r/(1-r))^n*scale T := by
  induction T with
  | nil => simp [scale, total, atom, Points]
  | @snoc n prior a shift ih =>
    obtain ⟨hl,hu⟩ := ih h.1
    obtain ⟨hsl,hsu⟩ := last_coordinate_bounds prior a shift r hr0 hr1 h
    have hc := (continuousMass_positive a h.2.1).le
    have he0 : 0 ≤ 2*r/(1-r) := by positivity
    constructor
    · calc
        _ = ((1-2*r/(1-r))^n*scale prior)*((1-2*r/(1-r))*continuousMass a) := by
          rw [scale, pow_succ]
          ring
        _ ≤ total prior*((1-2*r/(1-r))*continuousMass a) :=
          mul_le_mul_of_nonneg_right hl (mul_nonneg (by linarith) hc)
        _ ≤ _ := hsl
    · calc
        _ ≤ total prior*((1+2*r/(1-r))*continuousMass a) := hsu
        _ ≤ ((1+2*r/(1-r))^n*scale prior)*((1+2*r/(1-r))*continuousMass a) :=
          mul_le_mul_of_nonneg_right hu (mul_nonneg (by linarith) hc)
        _ = _ := by
          rw [scale, pow_succ]
          ring

end FT1536.Run2.TriangularGaussian
