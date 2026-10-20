import Source3.C99OperatorBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99IntegerSound
open B20.C C99ValueBridge C99ArithmeticBridge

theorem checked_some (P : Prop) [Decidable P] (a b : α)
    (h : (if decide P then some a else none)=some b) : P ∧ b=a := by
  by_cases hp : P
  · exact ⟨hp,(Option.some.inj (by simpa [hp] using h)).symm⟩
  · simp [hp] at h

theorem arithmetic_sound (op : C99IntegerReference.Arithmetic) (x y z : Val)
    (h : B20.C.bin (C99ArithmeticBridge.operation op) x y=some z) :
    C99IntegerReference.ArithmeticExec op (value x) (value y) (value z) := by
  rw [C99IntegerReference.arithmetic_iff]
  simp only [type_matches,usual_matches,integer_matches]
  cases op <;> cases x <;> cases y <;> cases z <;>
    simp_all [C99ArithmeticBridge.operation,B20.C.bin,B20.C.commonTy,B20.C.cast,Val.ty,Val.integer,
      signedBitsOp,signedSafe,bitsOp,type,value,C99IntegerReference.convert,
      C99IntegerReference.signed,C99IntegerReference.exact,C99IntegerReference.fits,
      C99IntegerReference.width,C99IntegerReference.Value.integer,
      BitVec.ofInt_add,C99ArithmeticBridge.ofInt_sub,BitVec.ofInt_mul,BitVec.signExtend,
      ofInt64_maxmod,ofInt64_mod,ofInt64_bmod]
  all_goals exact checked_some _ _ _ h

theorem bitwise_sound (op : C99IntegerReference.Bitwise) (x y z : Val)
    (h : B20.C.bin (C99BitwiseBridge.operation op) x y=some z) :
    C99IntegerReference.BitwiseExec op (value x) (value y) (value z) := by
  rw [C99IntegerReference.bitwise_iff]
  simp only [type_matches,usual_matches,integer_matches]
  cases op <;> cases x <;> cases y <;> cases z <;>
    simp_all [C99BitwiseBridge.operation,B20.C.bin,B20.C.commonTy,B20.C.cast,Val.ty,Val.integer,
      signedBitsOp,signedSafe,bitsOp,type,value,C99IntegerReference.convert,
      C99IntegerReference.bitResult,C99IntegerReference.Value.bits,BitVec.signExtend,
      C99BitwiseBridge.nat_of_int_mod64,C99BitwiseBridge.nat_mod64]

theorem compare_sound (op : CLogic.Cmp) (x y : Val) :
    C99IntegerReference.CompareExec (C99Frontend.comparison op) (value x) (value y)
      (value (CLogic.compare op x y)) := by
  let t := C99IntegerReference.usual (value x).type (value y).type
  let a := C99IntegerReference.convert t (value x).integer
  let b := C99IntegerReference.convert t (value y).integer
  let z := C99IntegerReference.Value.int32
    (if C99IntegerReference.compare (C99Frontend.comparison op) a.integer b.integer then 1#32 else 0#32)
  have hz : C99IntegerReference.CompareExec (C99Frontend.comparison op) (value x) (value y) z :=
    C99IntegerReference.CompareExec.step _ _ _ t rfl a b rfl rfl
  have he : CLogic.compare op x y=encode z := C99CompareBridge.source_to_interpreter _ _ _ _
    (by simpa only [value_encode] using hz)
  rw [he,value_encode]
  exact hz

end FT1536.Source3.C99IntegerSound

#print axioms FT1536.Source3.C99IntegerSound.arithmetic_sound
#print axioms FT1536.Source3.C99IntegerSound.bitwise_sound
#print axioms FT1536.Source3.C99IntegerSound.compare_sound
