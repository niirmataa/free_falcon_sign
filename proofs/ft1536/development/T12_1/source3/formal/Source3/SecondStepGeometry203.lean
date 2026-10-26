import Source3.SecondStepInverse203

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepGeometry203
open C99MemoryReference (ArrayPointer)
open Word32Memory176 (Separate)
open StepCopyBody190 (addr elem)
open SecondStepCopy203 (Side)
open SecondStepLayout197 (t1 igm)

def scratch (index : Nat) : ArrayPointer := ⟨31,0,71680,4,index⟩

theorem ordered (a b : Nat) (less : a<b) : Separate (scratch a) (scratch b) := by
  right; left
  change 0+4*a+4 ≤ 0+4*b
  omega

theorem data_shape (side : Side) (u j : Nat) : addr (SecondStepCopy203.root side) u j 2=
    scratch ((SecondStepCopy203.root side).index+u+j*2) := by cases side <;> rfl

theorem product_shape (side : Side) (u j : Nat) : addr (SecondStepProduct203.root side) u j 3=
    scratch ((SecondStepProduct203.root side).index+u+j*3) := by cases side <;> rfl

theorem data_bounds (side : Side) (u j : Nat) (bound : u<2) (slot : j<256) :
    1438 ≤ (SecondStepCopy203.root side).index+u+j*2 ∧
      (SecondStepCopy203.root side).index+u+j*2<2462 := by
  have range : 1438 ≤ (SecondStepCopy203.root side).index ∧ (SecondStepCopy203.root side).index ≤ 1950 := by
    cases side <;> decide
  omega

theorem product_bound (side : Side) (u j : Nat) (bound : u<2) (slot : j<128) :
    (SecondStepProduct203.root side).index+u+j*3<1438 := by
  have range : (SecondStepProduct203.root side).index ≤ 1054 := by cases side <;> decide
  omega

theorem copy_data (side : Side) (u j : Nat) (bound : u<2) (slot : j<256) (i : Fin 256) :
    Separate (elem t1 i.val) (addr (SecondStepCopy203.root side) u j 2) := by
  apply StepCopyFixed190.separate_symm
  rw [data_shape]
  change Separate (scratch ((SecondStepCopy203.root side).index+u+j*2)) (scratch (2974+i.val))
  exact ordered _ _ (by have h:=data_bounds side u j bound slot; omega)

theorem copy_twiddle (k : Nat) (slot : k<256) (i : Fin 256) : Separate (elem t1 i.val) (elem igm k) := by
  apply StepCopyFixed190.separate_symm
  change Separate (scratch (2718+k)) (scratch (2974+i.val))
  exact ordered _ _ (by omega)

theorem product_data (destination source : Side) (u j v k : Nat) (bound : u<2) (slot : j<128) :
    Separate (addr (SecondStepProduct203.root destination) u j 3) (addr (SecondStepCopy203.root source) v k 2) := by
  rw [product_shape,data_shape]
  have low:=product_bound destination u j bound slot
  have high : 1438 ≤ (SecondStepCopy203.root source).index := by cases source <;> decide
  exact ordered _ _ (by omega)

theorem product_twiddle (side : Side) (u j k : Nat) (bound : u<2) (slot : j<128) :
    Separate (addr (SecondStepProduct203.root side) u j 3) (elem igm k) := by
  rw [product_shape]
  change Separate (scratch ((SecondStepProduct203.root side).index+u+j*3)) (scratch (2718+k))
  exact ordered _ _ (by have h:=product_bound side u j bound slot; omega)

end FT1536.Source3.SecondStepGeometry203
