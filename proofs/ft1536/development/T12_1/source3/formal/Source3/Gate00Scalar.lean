import Source3.C99CompareObjects
import Source3.RootGate00
import Source3.C99NormalBodyBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.Gate00Scalar
open B20.C C99Typing C99ValueBridge

def modelCalls : B20.C.Scalar.Calls := fun name args =>
  if name=RootGate00.ltName then match args with
    | [.u64 x,.u64 y] => some (.i32 (FprCompare.spec x y))
    | _ => none
  else StablePositive.pureCalls name args
def calls : C99ScalarReference.CallRelation := fun name args z =>
  if name=RootGate00.ltName then ∃ x y, args=[.uint64 x,.uint64 y] ∧ C99CompareObjects.Exec x y z
  else C99CheckCalls.calls name args z
def signature : Types := fun n => if n=RootGate00.ltName then some .i32 else C99CheckCalls.signature n

theorem calls_ok : C99ExpressionBridge.CallsOK signature calls modelCalls := by
  intro name args z t ht hc
  by_cases hn : name=RootGate00.ltName
  · obtain ⟨x,y,ha,he⟩ : ∃ x y, args=[.uint64 x,.uint64 y] ∧ C99CompareObjects.Exec x y z := by
      simpa only [calls,hn,ite_true] using hc
    have hz := C99CompareObjects.exact_result x y z he
    have hty : t=.i32 := by simpa [signature,hn] using ht.symm
    subst args; subst z; subst t
    exact ⟨by simp [modelCalls,hn,encode],rfl⟩
  · have ho := C99CheckCalls.calls_ok name args z t (by simpa [signature,hn] using ht)
      (by simpa [calls,hn] using hc)
    exact ⟨by simpa [modelCalls,hn] using ho.1,ho.2⟩

theorem calls_sound : C99ExpressionSound.CallsSound calls modelCalls := by
  intro name args v h
  by_cases hn : name=RootGate00.ltName
  · simp only [modelCalls,hn,ite_true] at h
    split at h
    · rename_i x y
      have hv : v=.i32 (FprCompare.spec x y) := (Option.some.inj h).symm
      subst v
      simp only [calls,hn,ite_true]
      exact ⟨x,y,rfl,C99CompareObjects.exists_execution x y⟩
    · contradiction
  · have he := C99CheckCalls.calls_sound name args v (by simpa [modelCalls,hn] using h)
    simpa [calls,hn] using he

theorem positive_call (w : BitVec 64) : modelCalls KeygenHelpers.positiveName [.u64 w]=
    some (CLogic.boolean (Run2.KeygenLeafGate.positive w)) := by
  simp only [modelCalls,show KeygenHelpers.positiveName≠RootGate00.ltName by decide,ite_false,
    StablePositive.positive_call]
theorem bits_call (w : BitVec 64) : modelCalls KeygenHelpers.bitsName [.u64 w]=some (.u64 w) := by
  simp only [modelCalls,show KeygenHelpers.bitsName≠RootGate00.ltName by decide,ite_false,
    StablePositive.bits_call]
theorem from_bits_call (w : BitVec 64) : modelCalls KeygenHelpers.fromBitsName [.u64 w]=some (.u64 w) := by
  simp only [modelCalls,show KeygenHelpers.fromBitsName≠RootGate00.ltName by decide,ite_false,
    StablePositive.fromBits_call]
theorem compare_call (x y : BitVec 64) : modelCalls RootGate00.ltName [.u64 x,.u64 y]=some (.i32 (FprCompare.spec x y)) := by
  simp only [modelCalls,ite_true]

def types : Types := fun n =>
  if n=CElementLoop.cellName ∨ n="fpr_onehalf".toList ∨ n="fpr_one".toList then some .u64
  else if n="bad".toList then some .u32 else none
def finalTypes : Types := fun n =>
  if n="xb".toList then some .u64 else if n="mask".toList then some .u64
  else if n="valid".toList then some .u32 else types n
def initial (w : BitVec 64) (bad : BitVec 32) : B20.C.Scalar.State :=
  ⟨types,(CElementLoop.initial RootGate00.globals w bad).values⟩
theorem checked : C99StateBridge.checkBody signature types RootGate00.program.body=some finalTypes := by rfl
theorem initial_good (w : BitVec 64) (bad : BitVec 32) : WellTyped (initial w bad) := by
  intro n v hv
  by_cases hc : n=CElementLoop.cellName <;> by_cases hb : n="bad".toList <;>
    by_cases hh : n="fpr_onehalf".toList <;> by_cases ho : n="fpr_one".toList <;>
      simp_all [initial,types,CElementLoop.initial,RootGate00.globals,CElementLoop.cellName,Val.ty]
  all_goals rw [← hv]

def observe (st : B20.C.Scalar.State) : Option (BitVec 64×BitVec 32) := do
  match ← st.values CElementLoop.cellName, ← st.values "bad".toList with
  | .u64 w,.u32 bad => some (w,bad)
  | _,_ => none
def run (w : BitVec 64) (bad : BitVec 32) : Option (BitVec 64×BitVec 32) :=
  (UnsignedState.exec modelCalls (initial w bad) RootGate00.program.body).bind observe

theorem model_body (w : BitVec 64) (bad : BitVec 32) : run w bad=some (RootGate00.step w bad) := by
  cases hp : Run2.KeygenLeafGate.positive w <;>
    simp [run,observe,UnsignedState.exec,initial,types,CElementLoop.initial,CElementLoop.cellName,
      RootGate00.program,RootGate00.globals,CLogic.step,CLogic.eval,
      B20.C.Scalar.declareOne,B20.C.Scalar.declareMany,B20.C.Scalar.assign,update,
      positive_call,compare_call,bits_call,from_bits_call,
      B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,B20.C.Val.ty,B20.C.bitsOp,
      B20.C.signedBitsOp,B20.C.signedSafe,CLogic.boolean,B20.C.notBits,
      RootGate00.step,RootGate00.selectMask,RootGate00.valid,Run2.KeygenLeafGate.positiveFlag,hp]

def Exec (w : BitVec 64) (bad : BitVec 32) (z : BitVec 64) (flag : BitVec 32) : Prop :=
  ∃ env, C99ScalarReference.Exec calls (environment (initial w bad))
    (C99Frontend.scalars RootGate00.program.body) (.normal env) ∧
    env CElementLoop.cellName=some (.uint64,some (.uint64 z)) ∧
    env "bad".toList=some (.uint32,some (.uint32 flag))

theorem exact_result (w : BitVec 64) (bad : BitVec 32) (z : BitVec 64) (flag : BitVec 32)
    (h : Exec w bad z flag) : (z,flag)=RootGate00.step w bad := by
  obtain ⟨env,he,hz,hflag⟩ := h
  obtain ⟨out,hm,henv,ht,hgood⟩ := C99NormalBodyBridge.normal_complete signature calls modelCalls calls_ok
    RootGate00.program.body (initial w bad) finalTypes env (initial_good w bad) checked he
  have hz' := (variable_related out CElementLoop.cellName .u64 .uint64 (.uint64 z) hgood
    (by rw [ht]; rfl) (by rw [henv]; exact hz)).1
  have hb' := (variable_related out "bad".toList .u32 .uint32 (.uint32 flag) hgood
    (by rw [ht]; rfl) (by rw [henv]; exact hflag)).1
  change out.values ['b','a','d']=some (.u32 flag) at hb'
  have hr : run w bad=some (z,flag) := by simp [run,hm,observe,hz',hb',encode]
  exact Option.some.inj (hr.symm.trans (model_body w bad))

theorem exists_execution (w : BitVec 64) (bad : BitVec 32) :
    Exec w bad (RootGate00.step w bad).1 (RootGate00.step w bad).2 := by
  obtain ⟨out,hm,ho⟩ := Option.bind_eq_some_iff.mp (model_body w bad)
  obtain ⟨he,hgood,ht⟩ := C99BodySound.normal_sound signature calls modelCalls calls_sound
    RootGate00.program.body (initial w bad) out finalTypes (initial_good w bad) checked hm
  have hread : out.values CElementLoop.cellName=some (.u64 (RootGate00.step w bad).1) ∧
      out.values "bad".toList=some (.u32 (RootGate00.step w bad).2) := by
    cases hz : out.values CElementLoop.cellName with
    | none => simp [observe,hz] at ho
    | some v =>
      cases hb : out.values ['b','a','d'] with
      | none => cases v <;> simp [observe,hz,hb] at ho
      | some f =>
        cases v <;> cases f <;> simp [observe,hz,hb] at ho
        obtain ⟨h1,h2⟩ := ho
        exact ⟨rfl,hb⟩
  refine ⟨environment out,he,?_,?_⟩
  · simp only [environment,ht,hread.1]
    rfl
  · simp only [environment,ht,hread.2]
    rfl

end FT1536.Source3.Gate00Scalar
