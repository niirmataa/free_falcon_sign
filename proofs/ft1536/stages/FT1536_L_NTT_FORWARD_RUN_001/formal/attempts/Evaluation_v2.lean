import Sums
set_option maxRecDepth 16384
set_option maxHeartbeats 1000000
namespace FT1536Forward
open FT1536Global

-- Independent finite polynomial evaluation: source transforms remain imported.
def peval (n : Nat) (a : Nat → Int) (z : Int) : Int := sumN n (fun k => a k*z^k)%18433
def blockEval (n base : Nat) (s : Mem) (z : Int) : Int := peval n (fun k => s (base+k)) z

theorem eval_congr (n : Nat) (a b : Nat → Int) (z : Int)
    (h : ∀ k, k<n → a k%18433=b k%18433) : peval n a z=peval n b z := by
  apply sum_congr_mod
  intro k hk; simp only [Int.mul_emod,h k hk]
theorem eval_mod_coeff (n : Nat) (a : Nat → Int) (z : Int) : peval n (fun k => a k%18433) z=peval n a z := by
  apply eval_congr; intro k hk; simp
theorem eval_linear (n : Nat) (a b : Nat → Int) (c z : Int) :
    peval n (fun k => a k+c*b k) z=(peval n a z+c*peval n b z)%18433 := by
  unfold peval
  simp only [Int.add_mul,Int.mul_assoc,sum_add,sum_scale]
  simp only [Int.add_emod,Int.mul_emod,Int.emod_emod]
theorem eval_sub (n : Nat) (a b : Nat → Int) (z : Int) :
    peval n (fun k => a k-b k) z=(peval n a z-peval n b z)%18433 := by
  unfold peval
  simp only [Int.sub_mul,sum_sub,Int.sub_emod,Int.emod_emod]
theorem eval_scale (n : Nat) (a : Nat → Int) (c z : Int) :
    peval n (fun k => c*a k) z=(c*peval n a z)%18433 := by
  unfold peval
  simp only [Int.mul_assoc,sum_scale,Int.mul_emod,Int.emod_emod]
theorem eval_split (n m : Nat) (a : Nat → Int) (z : Int) :
    peval (n+m) a z=(peval n a z+z^n*peval m (fun k => a (n+k)) z)%18433 := by
  unfold peval
  rw [sum_split]
  have he : (fun k => a (n+k)*z^(n+k))=(fun k => z^n*(a (n+k)*z^k)) := by
    funext k; rw [Int.pow_add]; ac_rfl
  rw [he,sum_scale]
  simp only [Int.add_emod,Int.mul_emod,Int.emod_emod]

theorem split_preserves_eval (n : Nat) (f : Nat → Int) (c z : Int) (hz : z^n%18433=c%18433) :
    peval n (fun k => (f k+c*f (n+k))%18433) z=peval (n+n) f z := by
  rw [eval_mod_coeff,eval_linear,eval_split]
  simp only [Int.add_emod,Int.mul_emod,hz,Int.emod_emod]

theorem pow_mod (z : Int) (n : Nat) : (z%18433)^n%18433=z^n%18433 := by
  induction n <;> simp_all [Int.pow_succ,Int.mul_emod]
theorem eval_mod_node (n : Nat) (a : Nat → Int) (z : Int) : peval n a (z%18433)=peval n a z := by
  apply sum_congr_mod
  intro k hk; simp only [Int.mul_emod,pow_mod]
theorem eval_delta (n k : Nat) (z : Int) :
    peval n (fun j => if j=k then 1 else 0) z=if k<n then z^k%18433 else 0 := by
  unfold peval
  have he : (fun j => (if j=k then (1:Int) else 0)*z^j)=(fun j => if j=k then z^j else 0) := by
    funext j; split <;> simp
  rw [he,sum_delta]
  split <;> simp_all

-- Bounded modular powering for finite node certificates. Soundness is
-- proved here; numerical checks will concern only source-bound constants.
def powM (z : Int) : Nat → Int
  | 0 => 1
  | n+1 => (powM z n*z)%18433
theorem powM_correct (z : Int) (n : Nat) : powM z n=z^n%18433 := by
  induction n <;> simp_all [powM,Int.pow_succ,Int.mul_emod]

#check @split_preserves_eval
#print axioms eval_congr
#print axioms eval_mod_coeff
#print axioms eval_linear
#print axioms eval_sub
#print axioms eval_scale
#print axioms eval_split
#print axioms split_preserves_eval
#print axioms pow_mod
#print axioms eval_mod_node
#print axioms eval_delta
#print axioms powM_correct
end FT1536Forward
