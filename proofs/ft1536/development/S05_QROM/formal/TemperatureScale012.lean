import BlockGaussian012

/- Q-SAMPLER: exact temperature scaling and the 3072-coordinate mass
   sandwich. The concrete FT1536 Gram and its spectral identities remain
   an instance obligation; no source execution or quantum reduction here. -/
namespace FT1536.S05.TemperatureScale012
open Matrix
open SchurGeometry012 GaussianFromSchur012 BlockGaussian012
open FT1536.Run2.TriangularGaussian FT1536.Run2.ShiftedGaussian FT1536.Run2.T5ScalarMass

theorem continuousMass_mul (t a : ℝ) (ht : 0≤t) (ha : 0≤a) :
    continuousMass (t*a)=continuousMass t*continuousMass a := by
  unfold continuousMass
  rw [Real.mul_rpow ht ha]
  ring

theorem scale_temperature : ∀ {n : ℕ} (k t : ℝ) (G : FinMatrix n) (s : Fin n → ℝ),
    G.PosDef → 0<k → 0≤t →
    scale (tower (t*k) G s)=continuousMass t^n*scale (tower k G s)
  | 0,k,t,G,s,_,_,_ => by simp [tower,scale]
  | n+1,k,t,G,s,hG,hk,ht => by
    simp only [tower,scale]
    rw [scale_temperature k t (scalarSchur G) (fun i => s i.succ) (scalarSchur_posDef G hG) hk ht]
    have rearrange : t*k*G 0 0/Real.pi=t*(k*G 0 0/Real.pi) := by ring
    rw [rearrange,continuousMass_mul t _ ht (div_nonneg (mul_pos hk hG.diag_pos).le Real.pi_pos.le)]
    rw [pow_succ]
    ring

theorem temperature_exponent (t : ℝ) (ht : 0≤t) :
    continuousMass t^3072=(t⁻¹)^1536 := by
  unfold continuousMass
  rw [one_div,inv_pow]
  have power : (t^((1:ℝ)/2))^3072=t^(1536:ℕ) := by
    rw [← Real.rpow_mul_natCast ht ((1:ℝ)/2) 3072]
    norm_num
  rw [power,inv_pow]

theorem block_common_positive {m n : ℕ} (k : ℝ) (A : FinMatrix m)
    (B : Matrix (Fin m) (Fin n) ℝ) (D : FinMatrix n) (L : ℝ)
    (hA : A.PosDef) (hG : (fromBlocks A B Bᴴ D).PosDef) (hk : 0<k)
    (capA : ∀ i, A i i≤L) (capS : ∀ i, complement A B D i i≤L)
    (limit : k*L/Real.pi≤maxCoefficient) :
    0<common k A*common k (complement A B D) :=
  mul_pos (common_scale_pos k A L hA hk capA limit)
    (common_scale_pos k _ L (complement_posDef A B D hA hG) hk capS limit)

theorem block_common_temperature {m n : ℕ} (k t : ℝ) (A : FinMatrix m)
    (B : Matrix (Fin m) (Fin n) ℝ) (D : FinMatrix n)
    (hA : A.PosDef) (hG : (fromBlocks A B Bᴴ D).PosDef) (hk : 0<k) (ht : 0≤t) :
    common (t*k) A*common (t*k) (complement A B D)=
      continuousMass t^(m+n)*(common k A*common k (complement A B D)) := by
  unfold common
  rw [scale_temperature k t A _ hA hk ht,
    scale_temperature k t _ _ (complement_posDef A B D hA hG) hk ht,pow_add]
  ring

/-- The SAME positive common scale works at every 0<t≤1 and every affine
    shift, with the exact t^-1536 exponent, not a re-chosen scale per shift. -/
theorem block_mass_all_temperatures {m n : ℕ} (dimension : m+n=3072)
    (k : ℝ) (A : FinMatrix m) (B : Matrix (Fin m) (Fin n) ℝ) (D : FinMatrix n) (L : ℝ)
    (hA : A.PosDef) (hG : (fromBlocks A B Bᴴ D).PosDef) (hk : 0<k) (hL : 0≤L)
    (capA : ∀ i, A i i≤L) (capS : ∀ i, complement A B D i i≤L)
    (limit : k*L/Real.pi≤maxCoefficient)
    (t : ℝ) (ht : 0<t) (ht1 : t≤1) (s : Fin m → ℝ) (u : Fin n → ℝ) :
    let C := common k A*common k (complement A B D)
    (1-massBudget)*(t⁻¹)^1536*C≤blockMass (t*k) A B D s u ∧
    blockMass (t*k) A B D s u≤(1+massBudget)*(t⁻¹)^1536*C := by
  dsimp only
  have capScaled : t*k*L/Real.pi≤maxCoefficient := by
    have nonnegative : 0≤k*L/Real.pi := div_nonneg (mul_nonneg hk.le hL) Real.pi_pos.le
    have hm := mul_le_mul_of_nonneg_right ht1 nonnegative
    have equal : t*k*L/Real.pi=t*(k*L/Real.pi) := by ring
    rw [equal]
    exact (hm.trans_eq (one_mul _)).trans limit
  have bounds := block_mass_bounds (t*k) A B D L hA hG (mul_pos ht hk) capA capS capScaled s u
  rw [block_common_temperature k t A B D hA hG hk ht.le,dimension,temperature_exponent t ht.le] at bounds
  have positive := block_common_positive k A B D L hA hG hk capA capS limit
  have weightNonneg : 0≤(t⁻¹)^1536*(common k A*common k (complement A B D)) :=
    mul_nonneg (pow_nonneg (inv_nonneg.mpr ht.le) _) positive.le
  obtain ⟨lo,hi⟩ := scalar_power_margins
  have low := mul_le_mul_of_nonneg_right lo weightNonneg
  have high := mul_le_mul_of_nonneg_right hi weightNonneg
  constructor
  · apply le_trans ?_ bounds.1
    simpa only [lower,rowError,mul_assoc] using low
  · apply le_trans bounds.2
    simpa only [upper,rowError,mul_assoc] using high

#print axioms continuousMass_mul
#print axioms scale_temperature
#print axioms temperature_exponent
#print axioms block_common_positive
#print axioms block_common_temperature
#print axioms block_mass_all_temperatures
end FT1536.S05.TemperatureScale012
