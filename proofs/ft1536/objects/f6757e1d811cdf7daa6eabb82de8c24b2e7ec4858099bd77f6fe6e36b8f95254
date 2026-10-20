import Run2.FieldConstants
import Mathlib.Data.ZMod.Basic

namespace FT1536.Run2.BitArithmetic

def fieldMultiply (xs ys : List Bool) : Result :=
  let p:=multiply xs ys
  let r:=canonicalRemainder p.bits modulusBits
  ⟨r.bits,p.steps+r.steps+1⟩

theorem fieldMultiply_value (xs ys : List Bool) :
    value (fieldMultiply xs ys).bits=(value xs*value ys)%18433 := by
  have hh := canonicalRemainder_correct (multiply xs ys).bits modulusBits
    (by rw [modulusBits_value]; decide)
  change value (canonicalRemainder (multiply xs ys).bits modulusBits).bits=_
  rw [hh.1,multiply_correct,modulusBits_value]

theorem fieldMultiply_correct (xs ys : List Bool) :
    (value (fieldMultiply xs ys).bits : ZMod 18433)=(value xs : ZMod 18433)*(value ys : ZMod 18433) := by
  rw [fieldMultiply_value]
  have hh := ZMod.natCast_mod (value xs*value ys) 18433
  rw [hh,Nat.cast_mul]

theorem fieldMultiply_length (xs ys : List Bool) : (fieldMultiply xs ys).bits.length≤15 := by
  have hh := (canonicalRemainder_correct (multiply xs ys).bits modulusBits
    (by rw [modulusBits_value]; decide)).2
  simpa only [fieldMultiply,modulusBits_length] using hh

theorem fieldMultiply_steps (xs ys : List Bool) (hx : xs.length≤16) (hy : ys.length≤16) :
    (fieldMultiply xs ys).steps<2^20 := by
  have hp := multiply_steps xs ys
  have hl := multiply_length xs ys
  have hr := remainder_steps (multiply xs ys).bits modulusBits
  rw [modulusBits_length] at hr
  have hpl : (multiply xs ys).bits.length≤48 := by omega
  have hpc : (multiply xs ys).steps≤64*(16+16+1)*(16+1) := by nlinarith
  have hrc : (remainder (multiply xs ys).bits modulusBits).steps≤128*(48+15+1)*(48+1) := by nlinarith
  change (multiply xs ys).steps+(canonicalRemainder (multiply xs ys).bits modulusBits).steps+1<2^20
  simp only [canonicalRemainder,modulusBits_length]
  omega

def fieldAdd (xs ys : List Bool) : Result :=
  let p:=add xs ys false
  let r:=canonicalRemainder p.bits modulusBits
  ⟨r.bits,p.steps+r.steps+1⟩

theorem fieldAdd_value (xs ys : List Bool) :
    value (fieldAdd xs ys).bits=(value xs+value ys)%18433 := by
  have hh := canonicalRemainder_correct (add xs ys false).bits modulusBits
    (by rw [modulusBits_value]; decide)
  change value (canonicalRemainder (add xs ys false).bits modulusBits).bits=_
  rw [hh.1,add_correct,modulusBits_value,bit_false,Nat.add_zero]

theorem fieldAdd_correct (xs ys : List Bool) :
    (value (fieldAdd xs ys).bits : ZMod 18433)=(value xs : ZMod 18433)+(value ys : ZMod 18433) := by
  rw [fieldAdd_value]
  have hh := ZMod.natCast_mod (value xs+value ys) 18433
  rw [hh,Nat.cast_add]

theorem fieldAdd_length (xs ys : List Bool) : (fieldAdd xs ys).bits.length≤15 := by
  have hh := (canonicalRemainder_correct (add xs ys false).bits modulusBits
    (by rw [modulusBits_value]; decide)).2
  simpa only [fieldAdd,modulusBits_length] using hh

theorem fieldAdd_steps (xs ys : List Bool) (hx : xs.length≤16) (hy : ys.length≤16) :
    (fieldAdd xs ys).steps<2^20 := by
  have hp := add_steps xs ys false
  have hl := add_length xs ys false
  have hr := remainder_steps (add xs ys false).bits modulusBits
  rw [modulusBits_length] at hr
  have hpl : (add xs ys false).bits.length≤17 := by omega
  have hpc : (add xs ys false).steps≤16*16+1 := by omega
  have hrc : (remainder (add xs ys false).bits modulusBits).steps≤128*(17+15+1)*(17+1) := by nlinarith
  change (add xs ys false).steps+(canonicalRemainder (add xs ys false).bits modulusBits).steps+1<2^20
  simp only [canonicalRemainder,modulusBits_length]
  omega

end FT1536.Run2.BitArithmetic
