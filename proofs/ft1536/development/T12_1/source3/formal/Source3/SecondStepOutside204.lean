import Source3.SecondStepGeneratorOne204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepOutside204
open C99MemoryReference (ArrayPointer)
open StepCopyBody190 (addr elem)
open SecondStepCopy203 (Side)
open SecondStepLayout197 (gm igm)
open MkgmCallKeep203 (Outside)

theorem data (side : Side) (u j : Nat) (bound : u<2) (slot : j<256) :
    Outside gm (addr (SecondStepCopy203.root side) u j 2) ∧
      Outside igm (addr (SecondStepCopy203.root side) u j 2) := by
  have all:=SecondStepGeneratorKeep203.source_outside (u+j*2) (by omega)
  cases side
  · simpa only [SecondStepCopy203.root,SecondStepFirstBodyKeep204.addr_elem,
      StepCopyBody190.elem,KeygenSmallOutput.element] using ⟨all.1,all.2.1⟩
  · simpa only [SecondStepCopy203.root,SecondStepFirstBodyKeep204.addr_elem,
      StepCopyBody190.elem,KeygenSmallOutput.element] using ⟨all.2.2.1,all.2.2.2⟩

theorem product (side : Side) (u j : Nat) (bound : u<2) (slot : j<128) :
    Outside gm (addr (SecondStepProduct203.root side) u j 3) ∧
      Outside igm (addr (SecondStepProduct203.root side) u j 3) := by
  rw [SecondStepGeometry203.product_shape]
  have indexBound:=SecondStepGeometry203.product_bound side u j bound slot
  constructor
  · intro byte
    right; left
    change 0+4*((SecondStepProduct203.root side).index+u+j*3)+byte.val<0+4*2462
    have b:=byte.isLt
    omega
  · intro byte
    right; left
    change 0+4*((SecondStepProduct203.root side).index+u+j*3)+byte.val<0+4*2718
    have b:=byte.isLt
    omega

theorem different_products (side : Side) (u v j k : Nat) (ub : u<2) (vb : v<2) (different : u≠v) :
    Word32Memory176.Separate (addr (SecondStepProduct203.root side) u j 3) (addr (SecondStepProduct203.root side) v k 3) := by
  rw [SecondStepGeometry203.product_shape,SecondStepGeometry203.product_shape]
  change 31≠31 ∨ 0+4*((SecondStepProduct203.root side).index+u+j*3)+4 ≤ 0+4*((SecondStepProduct203.root side).index+v+k*3) ∨
    0+4*((SecondStepProduct203.root side).index+v+k*3)+4 ≤ 0+4*((SecondStepProduct203.root side).index+u+j*3)
  omega

end FT1536.Source3.SecondStepOutside204
