import Source3.NttInverseSchedule201

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseImage201
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Load32)
open MkgmParams198 (Level)
open NttInverseCorrectionLoop192 (walk)
open NttInverseMiddleBody192 (bb high)
open NttInverseMiddleRounds192 (tOf htOf tOf_htOf pow_nonzero tOf_succ htOf_eq nextWord next_low next_high group_shift round_lowpos round_highpos)
open NttInverseSchedule201 (mOf roundTws fvAt mOf_succ)

theorem mOf_two (l : Level) (i : Nat) (bound : i+1  ≤  l.val) : mOf l i = 2*mOf l (i+1) := by
  show 2^(l.val-i) = 2*2^(l.val-(i+1))
  have tail : l.val-(i+1) = l.val-i-1 := by omega
  have e : l.val-i = (l.val-i-1)+1 := by omega
  rw [e,tail,Nat.pow_succ]
  exact (Nat.mul_comm _ _).symm


theorem group_two (l : Level) (i g : Nat) (bound : i+1  ≤  l.val) (slot : g < mOf l (i+1)) : g*2 < mOf l i := by
  have split := mOf_two l i bound
  omega


theorem round_image (l : Level) (s : State) (a : ArrayPointer) (stride : Nat) (i : Nat)
    (p p0i : BitVec 32) (tws : Nat → BitVec 32) (fv0 : Nat → BitVec 32)
    (bound : i+1  ≤  l.val)
    (image : NttInverseMiddleU1Loop192.Image s a stride (tOf i) (htOf i) (mOf l i)
      (roundTws l tws i) p p0i (fvAt l fv0 tws p p0i i) (mOf l i)) :
    NttInverseMiddleU1Loop192.Image s a stride (tOf (i+1)) (htOf (i+1)) (mOf l (i+1))
      (roundTws l tws (i+1)) p p0i (fvAt l fv0 tws p p0i (i+1)) 0 := by
  intro g' j slot' jBound
  have group : g'*2 < mOf l i := group_two l i g' bound slot'
  have groupSucc : g'*2+1 < mOf l i := by
    have split := mOf_two l i bound
    omega
  have span : 2*htOf i = tOf i := tOf_htOf i
  have jSmall : j < tOf i := jBound
  constructor
  · intro impossible
    exact absurd impossible (Nat.not_lt_zero g')
  · intro _
    by_cases low : j < htOf i
    · have evaluated := next_low (fvAt l fv0 tws p p0i i) (tOf i) (htOf i) (roundTws l tws i)
        p p0i (g'*2) j (Nat.le_of_eq span) (pow_nonzero _) low
      have transformed := (image (g'*2) j group low).1 group
      have evaluated' := next_low (fvAt l fv0 tws p p0i i) (tOf i) (htOf i) (roundTws l tws i)
        p p0i (g'*2+1) j (Nat.le_of_eq span) (pow_nonzero _) low
      have transformed' := (image (g'*2+1) j groupSucc low).1 groupSucc
      constructor
      · rw [round_lowpos i g' j]
        show Load32 s.heap (walk a ((g'*2)*tOf i + j) stride)
          (fvAt l fv0 tws p p0i (i+1) ((g'*2)*tOf i + j))
        rw [show fvAt l fv0 tws p p0i (i+1) ((g'*2)*tOf i + j)=
          nextWord (fvAt l fv0 tws p p0i i) (tOf i) (htOf i) (roundTws l tws i) p p0i
            ((g'*2)*tOf i + j) from rfl,evaluated]
        exact transformed.1
      · rw [round_highpos i g' j]
        show Load32 s.heap (walk a ((g'*2+1)*tOf i + j) stride)
          (fvAt l fv0 tws p p0i (i+1) ((g'*2+1)*tOf i + j))
        rw [show fvAt l fv0 tws p p0i (i+1) ((g'*2+1)*tOf i + j)=
          nextWord (fvAt l fv0 tws p p0i i) (tOf i) (htOf i) (roundTws l tws i) p p0i
            ((g'*2+1)*tOf i + j) from rfl,evaluated']
        exact transformed'.1
    · have offset : j - htOf i < htOf i := by
        have := span
        omega
      have join : htOf i + (j - htOf i) = j := by omega
      have evaluated := next_high (fvAt l fv0 tws p p0i i) (tOf i) (htOf i) (roundTws l tws i)
        p p0i (g'*2) (j - htOf i) (Nat.le_of_eq span) (pow_nonzero _) offset
      have transformed := (image (g'*2) (j - htOf i) group offset).1 group
      have evaluated' := next_high (fvAt l fv0 tws p p0i i) (tOf i) (htOf i) (roundTws l tws i)
        p p0i (g'*2+1) (j - htOf i) (Nat.le_of_eq span) (pow_nonzero _) offset
      have transformed' := (image (g'*2+1) (j - htOf i) groupSucc offset).1 groupSucc
      have position : g'*tOf (i+1)+j = (g'*2)*tOf i + htOf i + (j - htOf i) := by
        rw [round_lowpos i g' j]
        omega
      have position' : g'*tOf (i+1)+htOf (i+1)+j =
          (g'*2+1)*tOf i + htOf i + (j - htOf i) := by
        rw [round_highpos i g' j]
        omega
      constructor
      · rw [position]
        show Load32 s.heap (walk a ((g'*2)*tOf i + htOf i + (j - htOf i)) stride)
          (fvAt l fv0 tws p p0i (i+1) ((g'*2)*tOf i + htOf i + (j - htOf i)))
        rw [show fvAt l fv0 tws p p0i (i+1) ((g'*2)*tOf i + htOf i + (j - htOf i))=
          nextWord (fvAt l fv0 tws p p0i i) (tOf i) (htOf i) (roundTws l tws i) p p0i
            ((g'*2)*tOf i + htOf i + (j - htOf i)) from rfl,evaluated]
        exact transformed.2
      · rw [position']
        show Load32 s.heap (walk a ((g'*2+1)*tOf i + htOf i + (j - htOf i)) stride)
          (fvAt l fv0 tws p p0i (i+1) ((g'*2+1)*tOf i + htOf i + (j - htOf i)))
        rw [show fvAt l fv0 tws p p0i (i+1) ((g'*2+1)*tOf i + htOf i + (j - htOf i))=
          nextWord (fvAt l fv0 tws p p0i i) (tOf i) (htOf i) (roundTws l tws i) p p0i
            ((g'*2+1)*tOf i + htOf i + (j - htOf i)) from rfl,evaluated']
        exact transformed'.2

end FT1536.Source3.NttInverseImage201
