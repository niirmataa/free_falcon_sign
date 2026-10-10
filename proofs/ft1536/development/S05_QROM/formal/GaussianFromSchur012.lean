import SchurGeometry012
import Run2.T5ScalarMass

/- Q-SAMPLER: actual integer coordinates and exact Gaussian atoms under
   scalar Schur elimination. No change of integer variables by a real shear. -/
namespace FT1536.S05.GaussianFromSchur012
open Matrix Finset
open SchurGeometry012
open FT1536.Run2.TriangularGaussian
open FT1536.Run2.ShiftedGaussian
open FT1536.Run2.T5ScalarMass

def vectorOfPoints : {n : ℕ} → Points n → (Fin n → ℤ)
  | 0,_ => Fin.elim0
  | _+1,z => Fin.cons z.2 (vectorOfPoints z.1)

def pointsOfVector : {n : ℕ} → (Fin n → ℤ) → Points n
  | 0,_ => ()
  | _+1,x => (pointsOfVector (fun i => x i.succ),x 0)

theorem points_vector : ∀ {n : ℕ} (z : Points n), pointsOfVector (vectorOfPoints z)=z
  | 0,z => by cases z; rfl
  | n+1,(z,a) => by
    simp only [vectorOfPoints,pointsOfVector,Fin.cons_succ,Fin.cons_zero,points_vector]
    rfl

theorem vector_points : ∀ {n : ℕ} (x : Fin n → ℤ), vectorOfPoints (pointsOfVector x)=x
  | 0,x => by funext i; exact Fin.elim0 i
  | n+1,x => by
    funext i
    induction i using Fin.cases
    · rfl
    · rename_i i
      exact congrFun (vector_points (fun j => x j.succ)) i

def pointsEquiv (n : ℕ) : Points n ≃ (Fin n → ℤ) :=
  ⟨vectorOfPoints,pointsOfVector,points_vector,vector_points⟩

def translated {n : ℕ} (s : Fin n → ℝ) (x : Fin n → ℤ) : Fin n → ℝ :=
  fun i => (x i : ℝ)+s i

noncomputable def tower : {n : ℕ} → ℝ → FinMatrix n → (Fin n → ℝ) → Tower n
  | 0,_,_,_ => .nil
  | _+1,k,G,s => .snoc (tower k (scalarSchur G) (fun i => s i.succ))
      (k*G 0 0/Real.pi)
      (fun z => s 0+scalarOffset G (translated (fun i => s i.succ) (vectorOfPoints z)))

theorem atom_eq : ∀ {n : ℕ} (k : ℝ) (G : FinMatrix n) (s : Fin n → ℝ),
    G.PosDef → ∀ z, atom (tower k G s) z=
      Real.exp (-k*energy G (translated s (vectorOfPoints z)))
  | 0,k,G,s,_,z => by simp [tower,atom,energy,dotProduct]
  | n+1,k,G,s,hG,(z,a) => by
    change atom (tower k (scalarSchur G) (fun i => s i.succ)) z *
      Real.exp (-Real.pi*(k*G 0 0/Real.pi)*
        ((a : ℝ)+(s 0+scalarOffset G (translated (fun i => s i.succ) (vectorOfPoints z))))^2)=_
    rw [atom_eq k (scalarSchur G) (fun i => s i.succ) (scalarSchur_posDef G hG)]
    rw [energy_scalar_step G hG]
    have cancel : -Real.pi*(k*G 0 0/Real.pi)= -k*G 0 0 := by
      field_simp
    rw [cancel,← Real.exp_add]
    congr 1
    let y : Fin n → ℝ := translated (fun i => s i.succ) (vectorOfPoints z)
    change -k*energy (scalarSchur G) y+(-k*G 0 0)*((a : ℝ)+(s 0+scalarOffset G y))^2 =
      -k*(G 0 0*((a : ℝ)+s 0+scalarOffset G y)^2+energy (scalarSchur G) y)
    ring

noncomputable def mass {n : ℕ} (k : ℝ) (G : FinMatrix n) (s : Fin n → ℝ) : ℝ :=
  ∑' x : Fin n → ℤ, Real.exp (-k*energy G (translated s x))

theorem mass_eq_total {n : ℕ} (k : ℝ) (G : FinMatrix n) (s : Fin n → ℝ)
    (hG : G.PosDef) : mass k G s=total (tower k G s) := by
  unfold mass total
  rw [← (pointsEquiv n).tsum_eq (fun x => Real.exp (-k*energy G (translated s x)))]
  apply tsum_congr
  intro z
  exact (atom_eq k G s hG z).symm

theorem scale_independent : ∀ {n : ℕ} (k : ℝ) (G : FinMatrix n)
    (s t : Fin n → ℝ), scale (tower k G s)=scale (tower k G t)
  | 0,k,G,s,t => rfl
  | n+1,k,G,s,t => by
    simp only [tower,scale]
    rw [scale_independent k (scalarSchur G) (fun i => s i.succ) (fun i => t i.succ)]

theorem coefficient_range : ∀ {n : ℕ} (k : ℝ) (G : FinMatrix n)
    (s : Fin n → ℝ) (L : ℝ), G.PosDef → 0<k → (∀ i, G i i≤L) →
    k*L/Real.pi≤maxCoefficient → CoefficientRange (tower k G s)
  | 0,k,G,s,L,_,_,_,_ => trivial
  | n+1,k,G,s,L,hG,hk,bound,limit => by
    have prior := coefficient_range k (scalarSchur G) (fun i => s i.succ) L
      (scalarSchur_posDef G hG) hk
      (fun i => (scalarSchur_diagonal_le G hG i).trans (bound i.succ)) limit
    have pos : 0<k*G 0 0/Real.pi := div_pos (mul_pos hk hG.diag_pos) Real.pi_pos
    have upper : k*G 0 0/Real.pi≤maxCoefficient :=
      (div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left (bound 0) hk.le) Real.pi_pos.le).trans limit
    exact ⟨prior,pos,upper⟩

/-- Generic n-row mass bound. The common scale is independent of the shift. -/
theorem mass_bounds {n : ℕ} (k : ℝ) (G : FinMatrix n) (s : Fin n → ℝ) (L : ℝ)
    (hG : G.PosDef) (hk : 0<k) (bound : ∀ i, G i i≤L)
    (limit : k*L/Real.pi≤maxCoefficient) :
    (1-2*rowRatio/(1-rowRatio))^n*scale (tower k G (fun _ => 0))≤mass k G s ∧
    mass k G s≤(1+2*rowRatio/(1-rowRatio))^n*scale (tower k G (fun _ => 0)) := by
  have range := coefficient_range k G s L hG hk bound limit
  have exponents := local_exponents (tower k G s) range
  obtain ⟨rpos,rlt,_,budget,unit,_,_,_⟩ := dimension_margins
  have result := triangular_mass_bounds (tower k G s) rowRatio rpos rlt (budget.trans unit) exponents
  rw [← mass_eq_total k G s hG] at result
  rw [scale_independent k G s (fun _ => 0)] at result
  exact result

theorem mass_3072 {n : ℕ} (hn : n=3072) (k : ℝ) (G : FinMatrix n) (s : Fin n → ℝ) (L : ℝ)
    (hG : G.PosDef) (hk : 0<k) (bound : ∀ i, G i i≤L)
    (limit : k*L/Real.pi≤maxCoefficient) :
    (1-massBudget)*scale (tower k G (fun _ => 0))≤mass k G s ∧
    mass k G s≤(1+massBudget)*scale (tower k G (fun _ => 0)) := by
  subst n
  have result := uniform_shifted_mass_3072 (tower k G s) (coefficient_range k G s L hG hk bound limit)
  rw [← mass_eq_total k G s hG] at result
  rw [scale_independent k G s (fun _ => 0)] at result
  exact result

theorem mass_summable {n : ℕ} (k : ℝ) (G : FinMatrix n) (s : Fin n → ℝ) (L : ℝ)
    (hG : G.PosDef) (hk : 0<k) (bound : ∀ i, G i i≤L)
    (limit : k*L/Real.pi≤maxCoefficient) :
    Summable (fun x : Fin n → ℤ => Real.exp (-k*energy G (translated s x))) := by
  have range := coefficient_range k G s L hG hk bound limit
  have exponents := local_exponents (tower k G s) range
  obtain ⟨rpos,rlt,_,_,_,_,_,_⟩ := dimension_margins
  have hs := tower_summable (tower k G s) rowRatio rpos rlt exponents
  have equal : atom (tower k G s)=
      (fun x : Fin n → ℤ => Real.exp (-k*energy G (translated s x))) ∘ pointsEquiv n := by
    funext z
    exact atom_eq k G s hG z
  rw [equal] at hs
  exact (pointsEquiv n).summable_iff.mp hs

theorem common_scale_pos {n : ℕ} (k : ℝ) (G : FinMatrix n) (L : ℝ)
    (hG : G.PosDef) (hk : 0<k) (bound : ∀ i, G i i≤L)
    (limit : k*L/Real.pi≤maxCoefficient) : 0<scale (tower k G (fun _ => 0)) :=
  scale_positive _ rowRatio (local_exponents _ (coefficient_range k G _ L hG hk bound limit))

#print axioms mass_summable
#print axioms common_scale_pos
#print axioms points_vector
#print axioms vector_points
#print axioms atom_eq
#print axioms mass_eq_total
#print axioms scale_independent
#print axioms coefficient_range
#print axioms mass_bounds
#print axioms mass_3072
end FT1536.S05.GaussianFromSchur012
