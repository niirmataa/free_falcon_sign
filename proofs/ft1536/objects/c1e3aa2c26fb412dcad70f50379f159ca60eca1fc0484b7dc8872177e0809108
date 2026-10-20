import Source3.C99CheckReference
import Source3.C99NormalBodyBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99CheckModels
open B20.C C99Typing C99CheckReference

def initialTypes : Types := fun n => if n="x".toList ∨ n="fpr_one".toList then some .u64 else none
def localTypes : Types := fun n => if n="valid".toList then some .u32 else
  if n="mask".toList ∨ n="xb".toList then some .u64 else initialTypes n
def initial (w : BitVec 64) : B20.C.Scalar.State :=
  ⟨initialTypes,fun n => if n="x".toList then some (.u64 w) else
    if n="fpr_one".toList then some (.u64 Run2.KeygenLeafGate.oneBits) else none⟩
def valid (w : BitVec 64) : BitVec 32 := if Run2.KeygenLeafGate.positive w then 1 else 0
def locals (w : BitVec 64) : B20.C.Scalar.State :=
  ⟨localTypes,update (initial w).values "valid".toList (.u32 (valid w))⟩

theorem initial_good (w : BitVec 64) : WellTyped (initial w) := by
  intro n v hv
  by_cases hx : n="x".toList <;> by_cases ho : n="fpr_one".toList <;>
    simp_all [initial,initialTypes,Val.ty]
  all_goals rw [← hv]
theorem entry_related (w : BitVec 64) : environment (initial w)=entry w := by
  funext n
  by_cases hx : n="x".toList <;> by_cases ho : n="fpr_one".toList <;>
    simp_all [environment,initial,initialTypes,entry,C99ScalarReference.set,C99ValueBridge.type,C99ValueBridge.value]
theorem locals_good (w : BitVec 64) : WellTyped (locals w) := by
  intro n v hv
  by_cases hvn : n="valid".toList <;> by_cases hx : n="x".toList <;>
    by_cases ho : n="fpr_one".toList <;>
      simp_all [locals,initial,initialTypes,localTypes,update,Val.ty]
  all_goals rw [← hv]

theorem prelude_checked : C99StateBridge.checkBody C99CheckCalls.signature initialTypes prelude=some localTypes := by
  change some (fun n => if n="valid".toList then some .u32 else
    if n="xb".toList then some .u64 else if n="mask".toList then some .u64 else initialTypes n)=some localTypes
  apply congrArg some
  funext n
  by_cases hv : n="valid".toList <;> by_cases hb : n="xb".toList <;> by_cases hm : n="mask".toList <;>
    simp_all [localTypes]

theorem prelude_model (w : BitVec 64) :
    UnsignedState.exec StablePositive.pureCalls (initial w) prelude=some (locals w) := by
  cases hw : Run2.KeygenLeafGate.positive w <;>
    simp [UnsignedState.exec,prelude,CLogic.step,CLogic.eval,StablePositive.positive_call,
      B20.C.Scalar.declareMany,B20.C.Scalar.declareOne,B20.C.Scalar.assign,
      initial,initialTypes,locals,valid,hw,CLogic.boolean,B20.C.cast]
  all_goals
    funext n
    by_cases h1 : n="valid".toList <;> by_cases h2 : n="xb".toList <;> by_cases h3 : n="mask".toList <;>
      simp_all [localTypes,initialTypes]

theorem suffix_checked : (C99StateBridge.checkBody C99CheckCalls.signature localTypes suffix).isSome := by decide
theorem rhs_checked : C99Typing.infer C99CheckCalls.signature localTypes rhs=some .u32 := by rfl
theorem rhs_model (w : BitVec 64) :
    ExpressionFuel.unbounded StablePositive.pureCalls (locals w).values rhs=some (.u32 (valid w ^^^ 1)) := by
  simp [ExpressionFuel.unbounded,rhs,locals,update,literalValue,B20.C.bin,commonTy,Val.ty,B20.C.cast,bitsOp]

theorem suffix_model (w : BitVec 64) :
    CLogic.evalBody StablePositive.pureCalls .u64 suffix (locals w)=some (.u64 (Run2.KeygenLeafGate.stableWord w)) := by
  cases hw : Run2.KeygenLeafGate.positive w <;>
    simp [CLogic.evalBody,suffix,CLogic.step,CLogic.eval,locals,localTypes,initial,
      B20.C.Scalar.assign,update,valid,hw,StablePositive.bits_call,StablePositive.fromBits_call,
      B20.C.bin,B20.C.cast,literalValue,commonTy,Val.ty,bitsOp,notBits,Run2.KeygenLeafGate.stableWord_cases]
  all_goals exact BitVec.and_allOnes

end FT1536.Source3.C99CheckModels
