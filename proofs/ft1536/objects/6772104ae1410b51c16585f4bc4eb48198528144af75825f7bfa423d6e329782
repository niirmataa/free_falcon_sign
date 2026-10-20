import Source3.C99BitcastReference
import Source3.StableBinaryInlineTotal

namespace FT1536.Source3.C99LeafCalls
open B20.C C99ValueBridge

theorem positive_checked : C99HeaderProof.checked C99BitcastReference.signature KeygenHelpers.positiveProgram=true := by decide
theorem half_checked : C99HeaderProof.checked C99HeaderProof.noSignature StableBinary.halfProgram=true := by decide
theorem double_checked : C99HeaderProof.checked C99HeaderProof.noSignature StableBinary.doubleProgram=true := by decide

def Positive (x : BitVec 64) (v : C99IntegerReference.Value) : Prop :=
  C99ScalarReference.FunctionExec C99BitcastReference.calls (C99Frontend.headerFunction KeygenHelpers.positiveProgram)
    [.uint64 x] v

theorem positive_exact (x : BitVec 64) (v : C99IntegerReference.Value) (h : Positive x v) :
    v=C99ScalarReference.boolean (Run2.KeygenLeafGate.positive x) := by
  have hm := C99HeaderProof.function_complete _ _ _ C99BitcastReference.calls_ok _ [.u64 x] v positive_checked h
  rw [KeygenHelpers.positive_execution] at hm
  have he := congrArg value (Option.some.inj hm)
  rw [value_encode] at he
  exact he.symm

theorem positive_exists (x : BitVec 64) : Positive x (C99ScalarReference.boolean (Run2.KeygenLeafGate.positive x)) :=
  C99HeaderSound.function_sound _ _ _ C99BitcastReference.calls_sound _ [.u64 x] _ positive_checked
    (KeygenHelpers.positive_execution x)

def Half (x z : BitVec 64) : Prop :=
  C99ScalarReference.FunctionExec C99Frontend.noCalls (C99Frontend.headerFunction StableBinary.halfProgram)
    [.uint64 x] (.uint64 z)
def Double (x z : BitVec 64) : Prop :=
  C99ScalarReference.FunctionExec C99Frontend.noCalls (C99Frontend.headerFunction StableBinary.doubleProgram)
    [.uint64 x] (.uint64 z)

theorem half_iff (x z : BitVec 64) : Half x z ↔
    CLogic.execute (fun _ _ => none) StableBinary.halfProgram [.u64 x]=some (.u64 z) := by
  constructor
  · exact C99HeaderProof.function_complete _ _ _ C99HeaderProof.no_calls_ok _ [.u64 x] (.uint64 z) half_checked
  · exact C99HeaderSound.function_sound _ _ _ C99HeaderSound.no_calls_sound _ _ _ half_checked
theorem double_iff (x z : BitVec 64) : Double x z ↔
    CLogic.execute (fun _ _ => none) StableBinary.doubleProgram [.u64 x]=some (.u64 z) := by
  constructor
  · exact C99HeaderProof.function_complete _ _ _ C99HeaderProof.no_calls_ok _ [.u64 x] (.uint64 z) double_checked
  · exact C99HeaderSound.function_sound _ _ _ C99HeaderSound.no_calls_sound _ _ _ double_checked

end FT1536.Source3.C99LeafCalls

#print axioms FT1536.Source3.C99LeafCalls.positive_exact
#print axioms FT1536.Source3.C99LeafCalls.positive_exists
