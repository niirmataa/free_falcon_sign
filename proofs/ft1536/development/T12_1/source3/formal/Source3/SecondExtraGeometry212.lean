import Source3.SecondExtraForward212

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SecondExtraGeometry212
open C99MemoryReference (ArrayPointer)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem addr)
open SecondStepCopy203 (Side)
open SecondStepGeometry203 (scratch ordered)
open SecondStepLayout197 (t1 gm)
open SecondExtraProduct212 (root)

def Outside (side : Side) (q : ArrayPointer) : Prop :=
  (∀ i, i < 256 → Separate (elem t1 i) q) ∧
  (∀ byte : Fin 4, MakeFgConversionFrame176.Outside t1 256 q.block (q.offset+byte.val)) ∧
  (∀ i : Fin 128, Separate (addr (root side) 2 i.val 3) q)

def Safe (q : ArrayPointer) : Prop := Outside .f q ∧ Outside .g q

theorem before_t1 (index : Nat) (bound : index<2974) :
    (∀ i, i < 256 → Separate (elem t1 i) (scratch index)) ∧
    (∀ byte : Fin 4, MakeFgConversionFrame176.Outside t1 256 (scratch index).block ((scratch index).offset+byte.val)) := by
  constructor
  · intro i _
    exact StepCopyFixed190.separate_symm (ordered _ _ (by change index<2974+i; omega))
  · intro byte
    right; left
    change 0+4*index+byte.val<0+4*2974
    have b:=byte.isLt
    omega

theorem middle (side : Side) (index : Nat) (lower : 1438 ≤ index) (upper : index<2974) : Outside side (scratch index) := by
  refine ⟨(before_t1 index upper).1,(before_t1 index upper).2,?_⟩
  intro i
  cases side
  · change Separate (scratch (670+2+i.val*3)) (scratch index)
    exact ordered _ _ (by have b:=i.isLt; omega)
  · change Separate (scratch (1054+2+i.val*3)) (scratch index)
    exact ordered _ _ (by have b:=i.isLt; omega)

theorem data (side source : Side) (i : Nat) (bound : i<512) : Outside side (elem (SecondStepCopy203.root source) i) := by
  cases source
  · exact middle side (1438+i) (by omega) (by omega)
  · exact middle side (1950+i) (by omega) (by omega)

theorem twiddle (side : Side) (i : Fin 256) : Outside side (elem gm i.val) :=
  middle side (2462+i.val) (by omega) (by have b:=i.isLt; omega)

theorem product_old (side source : Side) (u j : Nat) (ub : u<2) (jb : j<128) :
    Outside side (addr (root source) u j 3) := by
  have before : (addr (root source) u j 3)=scratch ((root source).index+u+j*3) := by cases source <;> rfl
  rw [before]
  have idx : (root source).index+u+j*3<1438 := by
    cases source
    · change 670+u+j*3<1438; omega
    · change 1054+u+j*3<1438; omega
  refine ⟨(before_t1 _ (by omega)).1,(before_t1 _ (by omega)).2,?_⟩
  intro i
  cases side <;> cases source
  · change 31≠31 ∨ 0+4*(670+2+i.val*3)+4 ≤ 0+4*(670+u+j*3) ∨ 0+4*(670+u+j*3)+4 ≤ 0+4*(670+2+i.val*3)
    have b:=i.isLt
    omega
  · change 31≠31 ∨ 0+4*(670+2+i.val*3)+4 ≤ 0+4*(1054+u+j*3) ∨ 0+4*(1054+u+j*3)+4 ≤ 0+4*(670+2+i.val*3)
    have b:=i.isLt
    omega
  · change 31≠31 ∨ 0+4*(1054+2+i.val*3)+4 ≤ 0+4*(670+u+j*3) ∨ 0+4*(670+u+j*3)+4 ≤ 0+4*(1054+2+i.val*3)
    have b:=i.isLt
    omega
  · change 31≠31 ∨ 0+4*(1054+2+i.val*3)+4 ≤ 0+4*(1054+u+j*3) ∨ 0+4*(1054+u+j*3)+4 ≤ 0+4*(1054+2+i.val*3)
    have b:=i.isLt
    omega

theorem f_after_g (j : Nat) (jb : j<128) : Outside .g (addr (root .f) 2 j 3) := by
  change Outside .g (scratch (670+2+j*3))
  refine ⟨(before_t1 _ (by omega)).1,(before_t1 _ (by omega)).2,?_⟩
  intro i
  change Separate (scratch (1054+2+i.val*3)) (scratch (670+2+j*3))
  exact StepCopyFixed190.separate_symm (ordered _ _ (by omega))

end FT1536.Source3.SecondExtraGeometry212
