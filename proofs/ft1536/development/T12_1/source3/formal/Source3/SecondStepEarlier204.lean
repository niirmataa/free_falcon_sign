import Source3.SecondStepExit204

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondStepEarlier204
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open StepCopyBody190 (addr elem)
open SecondStepCopy203 (Side)
open SecondStepLayout197 (fd gd fs gs gm igm t1)
open SecondStepGeometry203 (scratch ordered)

def Keep (s out : State) : Prop :=
  ∀ q : ArrayPointer, MkgmCallKeep203.Outside gm q → MkgmCallKeep203.Outside igm q →
    (∀ i : Fin 256, Separate (elem t1 i.val) q) →
    (∀ i : Fin 128, Separate (addr fd 1 i.val 3) q) →
    (∀ i : Fin 128, Separate (addr gd 1 i.val 3) q) →
    (∀ j<256, Separate (addr fs 1 j 2) q) →
    (∀ j<256, Separate (addr gs 1 j 2) q) →
    ∀ w, Load32 s.heap q w → Load32 out.heap q w

theorem product (s out : State) (keeps : Keep s out) (side : Side) (j : Fin 128) (w : BitVec 32)
    (read : Load32 s.heap (addr (SecondStepProduct203.root side) 0 j.val 3) w) :
    Load32 out.heap (addr (SecondStepProduct203.root side) 0 j.val 3) w := by
  have outside:=SecondStepOutside204.product side 0 j.val (by decide) j.isLt
  apply keeps _ outside.1 outside.2 ?_ ?_ ?_ ?_ ?_ w read
  · intro i
    apply StepCopyFixed190.separate_symm
    rw [SecondStepGeometry203.product_shape]
    change Separate (scratch ((SecondStepProduct203.root side).index+0+j.val*3)) (scratch (2974+i.val))
    exact ordered _ _ (by have h:=SecondStepGeometry203.product_bound side 0 j.val (by decide) j.isLt; omega)
  · intro i
    cases side
    · exact SecondStepOutside204.different_products .f 1 0 i.val j.val (by decide) (by decide) (by decide)
    · change Separate (scratch (670+1+i.val*3)) (scratch (1054+0+j.val*3))
      exact ordered _ _ (by have h:=i.isLt; omega)
  · intro i
    cases side
    · apply StepCopyFixed190.separate_symm
      change Separate (scratch (670+0+j.val*3)) (scratch (1054+1+i.val*3))
      exact ordered _ _ (by have h:=j.isLt; omega)
    · exact SecondStepOutside204.different_products .g 1 0 i.val j.val (by decide) (by decide) (by decide)
  · intro k _
    exact StepCopyFixed190.separate_symm (SecondStepGeometry203.product_data side .f 0 j.val 1 k (by decide) j.isLt)
  · intro k _
    exact StepCopyFixed190.separate_symm (SecondStepGeometry203.product_data side .g 0 j.val 1 k (by decide) j.isLt)

theorem data (s out : State) (keeps : Keep s out) (side : Side) (j : Fin 256) (w : BitVec 32)
    (read : Load32 s.heap (addr (SecondStepCopy203.root side) 0 j.val 2) w) :
    Load32 out.heap (addr (SecondStepCopy203.root side) 0 j.val 2) w := by
  have outside:=SecondStepOutside204.data side 0 j.val (by decide) j.isLt
  apply keeps _ outside.1 outside.2 (SecondStepGeometry203.copy_data side 0 j.val (by decide) j.isLt)
    (fun i => SecondStepGeometry203.product_data .f side 1 i.val 0 j.val (by decide) i.isLt)
    (fun i => SecondStepGeometry203.product_data .g side 1 i.val 0 j.val (by decide) i.isLt) ?_ ?_ w read
  · intro i bound
    cases side
    · exact SecondStepFirstBodyKeep204.different_columns .f 1 0 i j.val (by decide) (by decide) (by decide)
    · exact SecondStepPair203.fs_gs 1 i 0 j.val (by decide) bound
  · intro i _
    cases side
    · exact StepCopyFixed190.separate_symm (SecondStepPair203.fs_gs 0 j.val 1 i (by decide) j.isLt)
    · exact SecondStepFirstBodyKeep204.different_columns .g 1 0 i j.val (by decide) (by decide) (by decide)

end FT1536.Source3.SecondStepEarlier204
