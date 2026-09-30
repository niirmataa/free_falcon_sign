import Run2.WordEncoding
import FT1536.Geometry

namespace FT1536.Run2.BitArithmetic

def halfModulusBits : List Bool := encodeNat 9216 14
theorem halfModulusBits_value : value halfModulusBits=9216 := encodeNat_value _ _ (by decide)
theorem halfModulusBits_length : halfModulusBits.length=14 := encodeNat_length _ _

def centerCode (xs : List Bool) : SignedResult :=
  let c:=compareWords xs halfModulusBits
  match c.1 with
  | .gt => let r:=subtract modulusBits xs false; ⟨⟨true,r.bits⟩,c.2+r.steps+2⟩
  | _ => ⟨⟨false,xs⟩,c.2+1⟩

theorem centerCode_correct (xs : List Bool) (h : value xs<18433) :
    signedValue (centerCode xs).word=Geometry.center (value xs) := by
  have hc:=compare_correct xs halfModulusBits
  rw [halfModulusBits_value] at hc
  cases ho : (compareWords xs halfModulusBits).1 with
  | lt =>
    rw [ho] at hc
    change value xs<9216 at hc
    simp only [centerCode,ho,signedValue,Bool.false_eq_true,ite_false,Geometry.center]
    omega
  | eq =>
    rw [ho] at hc
    change value xs=9216 at hc
    simp only [centerCode,ho,signedValue,Bool.false_eq_true,ite_false,Geometry.center]
    omega
  | gt =>
    rw [ho] at hc
    change 9216<value xs at hc
    have hr:=(subtract_correct modulusBits xs (by rw [modulusBits_value]; omega)).1
    rw [modulusBits_value] at hr
    simp only [centerCode,ho,signedValue,ite_true,hr,Geometry.center]
    omega

theorem centerCode_length (xs : List Bool) (hx : xs.length≤16) :
    (centerCode xs).word.magnitude.length≤16 := by
  unfold centerCode
  dsimp only
  split
  · simp only [subtract_length,modulusBits_length]; omega
  · exact hx

theorem centerCode_steps (xs : List Bool) (hx : xs.length≤16) :
    (centerCode xs).steps≤516 := by
  unfold centerCode
  dsimp only
  split <;> simp only [compare_steps,subtract_steps,modulusBits_length,halfModulusBits_length] <;> omega

def fieldReduceSigned (x : SignedWord) : Result :=
  let r:=canonicalRemainder x.magnitude modulusBits
  if x.negative then
    let p:=fieldMultiply r.bits negOneBits
    ⟨p.bits,r.steps+p.steps+2⟩
  else ⟨r.bits,r.steps+1⟩

theorem fieldReduceSigned_correct (x : SignedWord) :
    (value (fieldReduceSigned x).bits : ZMod 18433)=(signedValue x : ZMod 18433) := by
  have hr:=(canonicalRemainder_correct x.magnitude modulusBits (by rw [modulusBits_value]; decide)).1
  rw [modulusBits_value] at hr
  have hn : (value negOneBits : ZMod 18433)= -1 := by rw [negOneBits_value]; decide
  cases hx : x.negative <;>
    simp [fieldReduceSigned,hx,signedValue,fieldMultiply_correct,hn,hr,ZMod.natCast_mod]

theorem fieldReduceSigned_length (x : SignedWord) : (fieldReduceSigned x).bits.length≤15 := by
  unfold fieldReduceSigned
  split
  · exact fieldMultiply_length _ _
  · have hr:=(canonicalRemainder_correct x.magnitude modulusBits (by rw [modulusBits_value]; decide)).2
    simpa only [modulusBits_length] using hr

theorem fieldReduceSigned_canonical (x : SignedWord) : value (fieldReduceSigned x).bits<18433 := by
  unfold fieldReduceSigned
  split
  · rw [fieldMultiply_value]; exact Nat.mod_lt _ (by decide)
  · rw [(canonicalRemainder_correct x.magnitude modulusBits (by rw [modulusBits_value]; decide)).1,
      modulusBits_value]
    exact Nat.mod_lt _ (by decide)

theorem fieldReduceSigned_steps (x : SignedWord) (hx : x.magnitude.length≤16) :
    (fieldReduceSigned x).steps≤2^22 := by
  have hr:=remainder_steps x.magnitude modulusBits
  rw [modulusBits_length] at hr
  have hm:=(canonicalRemainder_correct x.magnitude modulusBits (by rw [modulusBits_value]; decide)).2
  rw [modulusBits_length] at hm
  have hp:=fieldMultiply_steps (canonicalRemainder x.magnitude modulusBits).bits negOneBits
    (by omega) (by rw [negOneBits_length]; decide)
  have hb : (remainder x.magnitude modulusBits).steps≤128*32*17 := by nlinarith
  unfold fieldReduceSigned
  split <;> simp only [canonicalRemainder,modulusBits_length] at * <;> omega

def fieldSubtract (xs ys : List Bool) : Result :=
  let n:=fieldMultiply ys negOneBits
  let a:=fieldAdd xs n.bits
  ⟨a.bits,n.steps+a.steps+2⟩

theorem fieldSubtract_correct (xs ys : List Bool) :
    (value (fieldSubtract xs ys).bits : ZMod 18433)=
      (value xs : ZMod 18433)-(value ys : ZMod 18433) := by
  have hn : (value negOneBits : ZMod 18433)= -1 := by rw [negOneBits_value]; decide
  simp [fieldSubtract,fieldAdd_correct,fieldMultiply_correct,hn,sub_eq_add_neg]

theorem fieldSubtract_length (xs ys : List Bool) : (fieldSubtract xs ys).bits.length≤15 :=
  fieldAdd_length _ _

theorem fieldSubtract_canonical (xs ys : List Bool) : value (fieldSubtract xs ys).bits<18433 := by
  change value (fieldAdd _ _).bits<18433
  rw [fieldAdd_value]
  exact Nat.mod_lt _ (by decide)

theorem fieldSubtract_steps (xs ys : List Bool) (hx : xs.length≤16) (hy : ys.length≤16) :
    (fieldSubtract xs ys).steps≤2^22 := by
  have hn:=fieldMultiply_steps ys negOneBits hy (by rw [negOneBits_length]; decide)
  have hl:=fieldMultiply_length ys negOneBits
  have ha:=fieldAdd_steps xs (fieldMultiply ys negOneBits).bits hx (by omega)
  dsimp only [fieldSubtract]
  omega

end FT1536.Run2.BitArithmetic
