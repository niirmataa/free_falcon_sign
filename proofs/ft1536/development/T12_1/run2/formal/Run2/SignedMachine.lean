import Run2.FieldMachine

namespace FT1536.Run2.BitArithmetic

structure SignedWord where
  negative : Bool
  magnitude : List Bool

def signedValue (x : SignedWord) : ℤ :=
  if x.negative then -(value x.magnitude : ℤ) else (value x.magnitude : ℤ)

structure SignedResult where
  word : SignedWord
  steps : ℕ

def signedAdd (x y : SignedWord) : SignedResult :=
  if x.negative=y.negative then
    let r:=add x.magnitude y.magnitude false
    ⟨⟨x.negative,r.bits⟩,r.steps+1⟩
  else
    let c:=compareWords x.magnitude y.magnitude
    match c.1 with
    | .lt => let r:=subtract y.magnitude x.magnitude false
             ⟨⟨y.negative,r.bits⟩,c.2+r.steps+2⟩
    | _ => let r:=subtract x.magnitude y.magnitude false
           ⟨⟨x.negative,r.bits⟩,c.2+r.steps+2⟩

theorem signedAdd_correct (x y : SignedWord) :
    signedValue (signedAdd x y).word=signedValue x+signedValue y := by
  unfold signedAdd
  split
  next hs =>
    have hv := add_correct x.magnitude y.magnitude false
    simp only [bit_false,Nat.add_zero] at hv
    cases hx : x.negative <;> cases hy : y.negative <;>
      simp_all [signedValue,add_comm]
  next hs =>
    have hc := compare_correct x.magnitude y.magnitude
    cases ho : (compareWords x.magnitude y.magnitude).1 with
    | lt =>
      rw [ho] at hc
      change value x.magnitude < value y.magnitude at hc
      have hr := (subtract_correct y.magnitude x.magnitude (Nat.le_of_lt hc)).1
      cases hx : x.negative <;> cases hy : y.negative <;>
        simp_all [signedValue]
      all_goals omega
    | eq =>
      rw [ho] at hc
      change value x.magnitude = value y.magnitude at hc
      have hr := (subtract_correct x.magnitude y.magnitude (Nat.le_of_eq hc.symm)).1
      cases hx : x.negative <;> cases hy : y.negative <;>
        simp_all [signedValue]
    | gt =>
      rw [ho] at hc
      change value y.magnitude < value x.magnitude at hc
      have hr := (subtract_correct x.magnitude y.magnitude (Nat.le_of_lt hc)).1
      cases hx : x.negative <;> cases hy : y.negative <;>
        simp_all [signedValue]
      all_goals omega

theorem signedAdd_steps (x y : SignedWord) :
    (signedAdd x y).steps≤32*max x.magnitude.length y.magnitude.length+4 := by
  unfold signedAdd
  split
  · simp only [add_steps]; omega
  · dsimp only
    split <;> simp only [compare_steps,subtract_steps,max_comm y.magnitude.length x.magnitude.length] <;> omega

theorem signedAdd_length (x y : SignedWord) :
    (signedAdd x y).word.magnitude.length≤max x.magnitude.length y.magnitude.length+1 := by
  unfold signedAdd
  split
  · exact add_length _ _ _
  · dsimp only
    split <;> simp only [subtract_length,max_comm y.magnitude.length x.magnitude.length] <;> omega

def signedMultiply (x y : SignedWord) : SignedResult :=
  let r:=multiply x.magnitude y.magnitude
  ⟨⟨Bool.xor x.negative y.negative,r.bits⟩,r.steps+1⟩

theorem signedMultiply_correct (x y : SignedWord) :
    signedValue (signedMultiply x y).word=signedValue x*signedValue y := by
  have hh := multiply_correct x.magnitude y.magnitude
  unfold signedMultiply signedValue
  cases x.negative <;> cases y.negative <;> simp [hh]

theorem signedMultiply_steps (x y : SignedWord) :
    (signedMultiply x y).steps≤64*(x.magnitude.length+y.magnitude.length+1)*(y.magnitude.length+1)+1 := by
  exact Nat.add_le_add_right (multiply_steps _ _) 1

theorem signedMultiply_length (x y : SignedWord) :
    (signedMultiply x y).word.magnitude.length≤x.magnitude.length+2*y.magnitude.length :=
  multiply_length _ _

def signedNeg (x : SignedWord) : SignedWord := ⟨!x.negative,x.magnitude⟩

theorem signedNeg_correct (x : SignedWord) : signedValue (signedNeg x)= -signedValue x := by
  cases h : x.negative <;> simp [signedNeg,signedValue,h]

/- Compare by the signed difference, treating either sign of zero as zero. -/
def signedLess (x y : SignedWord) : Bool × ℕ :=
  let d:=signedAdd x (signedNeg y)
  let c:=compareWords d.word.magnitude []
  (d.word.negative && decide (c.1=Ordering.gt),d.steps+c.2+3)

theorem signedLess_correct (x y : SignedWord) :
    (signedLess x y).1=decide (signedValue x<signedValue y) := by
  have hp (w : List Bool) : (compareWords w []).1=Ordering.gt ↔ 0<value w := by
    have hc:=compare_correct w []
    cases ho : (compareWords w []).1 <;> simp_all [OrderMeaning,value]
  have hz (w : SignedWord) : (w.negative && decide (0<value w.magnitude))=
      decide (signedValue w<0) := by
    cases hw : w.negative <;> simp [signedValue,hw]
  simp only [signedLess,hp]
  rw [hz,signedAdd_correct,signedNeg_correct]
  simp only [←sub_eq_add_neg,sub_lt_zero]

theorem signedLess_steps (x y : SignedWord) :
    (signedLess x y).2≤48*max x.magnitude.length y.magnitude.length+24 := by
  have hs:=signedAdd_steps x (signedNeg y)
  have hl:=signedAdd_length x (signedNeg y)
  simp only [signedLess,compare_steps,List.length_nil,Nat.max_zero]
  dsimp only [signedNeg] at *
  omega

end FT1536.Run2.BitArithmetic
