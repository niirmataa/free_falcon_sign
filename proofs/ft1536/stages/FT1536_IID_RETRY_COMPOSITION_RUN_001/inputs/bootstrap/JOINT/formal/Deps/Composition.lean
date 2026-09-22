import Std
set_option maxRecDepth 8192
set_option maxHeartbeats 20000000

namespace FT1536Composition
abbrev Vec := Fin 1536 → Int
def canonical (v : Vec) : Vec := fun i => v i % 18433
def pointMul (a b : Vec) : Vec := fun i => (a i * b i) % 18433
def montPoint (a b : Vec) : Vec := fun i => (a i * b i * 5184) % 18433
def toMont (a : Vec) : Vec := fun i => (a i * 10237) % 18433
def subtract (a b : Vec) : Vec := fun i => (a i - b i) % 18433

-- Coefficient of X^j in X^k reduced modulo X^1536-X^768+1,
-- for the only required product degrees 0 <= k <= 3070.
def remMonomial (k j : Nat) : Int :=
  if k < 1536 then (if j=k then 1 else 0)
  else if k < 2304 then (if j=k-768 then 1 else 0) - (if j=k-1536 then 1 else 0)
  else -(if j=k-2304 then 1 else 0)

def productCoefficient (h r : Vec) (k : Fin 1536) : Int :=
  (List.ofFn (fun i : Fin 1536 =>
    (List.ofFn (fun j : Fin 1536 =>
      h i * r j * remMonomial (i.val+j.val) k.val)).foldl (· + ·) 0)).foldl (· + ·) 0
def product (h r : Vec) : Vec := fun i => productCoefficient h r i % 18433

theorem product_canonical (h r : Vec) : canonical (product h r) = product h r := by
  funext i
  simp [canonical, product]

theorem tomont_factor (x : Int) : (x*4564*5184)%18433=(x*10237)%18433 := by omega

theorem prepared_product (x y : Int) :
    (x*((y*10237)%18433)*5184)%18433=(x*y)%18433 := by
  calc
    (x*((y*10237)%18433)*5184)%18433 = (x*(y*10237)*5184)%18433 := by simp [Int.mul_emod]
    _ = ((x*y)*(10237*5184))%18433 := by congr 1; ac_rfl
    _ = (x*y)%18433 := by
      have h : ((10237: Int)*5184)%18433=1 := by decide
      rw [Int.mul_emod, h]
      simp

theorem prepared_point_product (a b : Vec) : montPoint a (toMont b) = pointMul b a := by
  funext i
  unfold montPoint toMont pointMul
  rw [prepared_product, Int.mul_comm]

def pipeline (F G : Vec → Vec) (h r c : Vec) : Vec × Vec :=
  let p := G (montPoint (F r) (toMont (F h)))
  (p, subtract p c)

-- Explicitly conditional interface theorem, NOT an instantiation for C.
-- The hypotheses below must be discharged by a global source/CRT model.
theorem L_NTT_after_global_interfaces (F G : Vec → Vec)
    (forward_product : ∀ h r, F (product h r) = pointMul (F h) (F r))
    (inverse_forward : ∀ a, G (F a) = canonical a)
    (h r c : Vec) :
    pipeline F G h r c = (product h r, subtract (product h r) c) := by
  unfold pipeline
  rw [prepared_point_product, ← forward_product h r, inverse_forward, product_canonical]

#print axioms product_canonical
#print axioms tomont_factor
#print axioms prepared_product
#print axioms prepared_point_product
#print axioms L_NTT_after_global_interfaces
end FT1536Composition
