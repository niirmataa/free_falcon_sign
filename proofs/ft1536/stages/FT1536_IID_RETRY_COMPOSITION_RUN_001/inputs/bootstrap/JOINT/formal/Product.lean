import ForwardGlobal
import Monomials
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Forward
open FT1536Global

theorem eval_sum (n m : Nat) (f : Nat → Nat → Int) (z : Int) :
    peval n (fun k => sumN m (fun i => f i k)) z=(sumN m (fun i => peval n (f i) z))%18433 := by
  unfold peval
  have he : (fun k => sumN m (fun i => f i k)*z^k)=(fun k => sumN m (fun i => f i k*z^k)) := by
    funext k; exact (sum_scale_right m (z^k) (fun i => f i k)).symm
  rw [he,sum_swap,sum_mod]

theorem eval_convolution (n m : Nat) (a b : Nat → Int) (z : Int) :
    (sumN n (fun i => sumN m (fun j => a i*b j*z^(i+j))))%18433=
      (peval n a z*peval m b z)%18433 := by
  have inner (i : Nat) : sumN m (fun j => a i*b j*z^(i+j))=
      (a i*z^i)*sumN m (fun j => b j*z^j) := by
    rw [←sum_scale]
    apply sum_congr
    intro j hj; rw [Int.pow_add]; ac_rfl
  have total : sumN n (fun i => sumN m (fun j => a i*b j*z^(i+j)))=
      sumN n (fun i => a i*z^i)*sumN m (fun j => b j*z^j) := by
    calc
      _ = sumN n (fun i => (a i*z^i)*sumN m (fun j => b j*z^j)) := sum_congr n _ _ (fun i _ => inner i)
      _ = _ := sum_scale_right n _ _
  rw [total]
  simp only [peval,Int.mul_emod,Int.emod_emod]

-- A proof abbreviation, with exact equality to the unchanged List.ofFn/foldl
-- coefficient product below. It is independent of both NTT functions.
def rawCoefficient (h r : Vec) (k : Nat) : Int :=
  sumN 1536 (fun i => sumN 1536 (fun j =>
    fromVec h i*fromVec r j*FT1536Composition.remMonomial (i+j) k))

theorem productCoefficient_eq (h r : Vec) (k : Fin 1536) :
    FT1536Composition.productCoefficient h r k=rawCoefficient h r k.val := by
  unfold FT1536Composition.productCoefficient rawCoefficient
  apply sum_ofFn_congr
  intro i
  apply sum_ofFn_congr
  intro j
  simp only [fromVec,i.isLt,j.isLt,↓reduceDIte]
theorem product_raw (h r : Vec) (k : Fin 1536) :
    FT1536Composition.product h r k=rawCoefficient h r k.val%18433 := by
  unfold FT1536Composition.product
  rw [productCoefficient_eq]

theorem product_eval (z : Int) (hz : PhiZero z) (h r : Vec) :
    peval 1536 (fromVec (FT1536Composition.product h r)) z=
      (peval 1536 (fromVec h) z*peval 1536 (fromVec r) z)%18433 := by
  have hc : peval 1536 (fromVec (FT1536Composition.product h r)) z=peval 1536 (rawCoefficient h r) z := by
    apply eval_congr
    intro k hk
    simp only [fromVec,dite_eq_left hk,product_raw,Int.emod_emod]
  have row (i : Nat) (hi : i<1536) :
      peval 1536 (fun k => sumN 1536 (fun j => fromVec h i*fromVec r j*FT1536Composition.remMonomial (i+j) k)) z=
      sumN 1536 (fun j => fromVec h i*fromVec r j*z^(i+j))%18433 := by
    rw [eval_sum]
    apply sum_congr_mod
    intro j hj
    rw [eval_scale,remMonomial_eval z hz (i+j) (by omega)]
    simp only [Int.mul_emod,Int.emod_emod]
  calc
    _ = peval 1536 (rawCoefficient h r) z := hc
    _ = (sumN 1536 (fun i => peval 1536
        (fun k => sumN 1536 (fun j => fromVec h i*fromVec r j*FT1536Composition.remMonomial (i+j) k)) z))%18433 :=
      eval_sum 1536 1536 _ z
    _ = (sumN 1536 (fun i => sumN 1536 (fun j => fromVec h i*fromVec r j*z^(i+j))))%18433 := by
      apply sum_congr_mod
      intro i hi; rw [row i hi,Int.emod_emod]
    _ = _ := eval_convolution 1536 1536 (fromVec h) (fromVec r) z

theorem forward_product (h r : Vec) :
    liftForward (FT1536Composition.product h r)=FT1536Composition.pointMul (liftForward h) (liftForward r) := by
  funext i
  let b : Fin 512:=⟨i.val/3,by have hi:=i.isLt;omega⟩
  let j : Fin 3:=⟨i.val%3,by omega⟩
  have hi : i=⟨3*b.val+j.val,by have hb:=b.isLt;have hj:=j.isLt;omega⟩ := by
    apply Fin.ext
    change i.val=3*(i.val/3)+i.val%3
    omega
  change liftForward (FT1536Composition.product h r) i=(liftForward h i*liftForward r i)%18433
  rw [hi,liftForward_eval,liftForward_eval,liftForward_eval]
  exact product_eval (node b.val j) (node_zero b.val b.isLt j) h r

theorem lift_canonical (v : Vec) : liftForward (FT1536Composition.canonical v)=liftForward v := by
  unfold liftForward
  rw [canonical_fixed _ (canonicalVec v)]
theorem product_canonical_inputs (h r : Vec) :
    FT1536Composition.product (FT1536Composition.canonical h) (FT1536Composition.canonical r)=FT1536Composition.product h r := by
  have hf : liftForward (FT1536Composition.product (FT1536Composition.canonical h) (FT1536Composition.canonical r))=
      liftForward (FT1536Composition.product h r) := by
    rw [forward_product,forward_product,lift_canonical,lift_canonical]
  have hg:=congrArg liftInverse hf
  rw [inverse_forward,inverse_forward,FT1536Composition.product_canonical,FT1536Composition.product_canonical] at hg
  exact hg

#check @productCoefficient_eq
#check @product_eval
#check @forward_product
#check @product_canonical_inputs
#print axioms eval_sum
#print axioms eval_convolution
#print axioms productCoefficient_eq
#print axioms product_raw
#print axioms product_eval
#print axioms forward_product
#print axioms lift_canonical
#print axioms product_canonical_inputs
end FT1536Forward
