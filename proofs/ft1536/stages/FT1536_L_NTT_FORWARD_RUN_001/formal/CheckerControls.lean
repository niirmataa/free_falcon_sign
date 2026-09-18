import Complete
set_option maxRecDepth 16384
set_option maxHeartbeats 3000000
namespace FT1536Forward
open FT1536Global

def cubicCheckAt (word : Int) (rowSlot nodeSlot : Fin 3) : Bool :=
  ([0,1,2] : List (Fin 3)).all (fun k => decide
    ((cubeFExpr word fW rowSlot).eval (basis k)=powFast (nodeFromWord word nodeSlot) k.val))
def badRem (k j : Nat) : Int := if k<2304 then FT1536Composition.remMonomial k j else if j=k-2304 then 1 else 0

theorem checker_noop : nodeCheck 512 ((gmAt 512+18433)%18433) 0=true := by decide
theorem checker_bad_word : nodeCheck 512 ((gmAt 512+1)%18433) 0=false := by decide
theorem checker_bad_index : nodeCheck 513 (gmAt 512) 0=false := by decide
theorem checker_bad_sign : decide (powFast (node 0 0) 384=(-splitLabel 2 384 0)%18433)=false := by decide
theorem checker_bad_cubic : cubicCheckAt (gmAt 512) 1 0=false := by decide
theorem checker_bad_rem : peval 1536 (badRem 2304) (node 0 0)≠powFast (node 0 0) 2304 := by
  change peval 1536 (fun j => if j=0 then 1 else 0) (node 0 0)≠powFast (node 0 0) 2304
  rw [eval_delta,powFast_correct,phi_cube _ (node_zero 0 (by decide) 0)]
  simp

#print axioms checker_noop
#print axioms checker_bad_word
#print axioms checker_bad_index
#print axioms checker_bad_sign
#print axioms checker_bad_cubic
#print axioms checker_bad_rem
end FT1536Forward
