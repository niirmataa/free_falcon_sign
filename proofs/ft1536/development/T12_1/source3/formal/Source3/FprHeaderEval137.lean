import Source3.C99CompactScalar115
import Source3.FprPrefixCalls
import Source3.C99CountedWords

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FprHeaderEval137
open C99CompactCells115 (Locals Cell environment)
open C99CompactScalar115 (evaluate step)
open C99ValueBridge (value)
open C99IntegerReference (Value convert)

def returning (calls : B20.C.Scalar.Calls) : List CLogic.Stmt → Locals → Option B20.C.Val
  | [], _ => none
  | .ret expr::_, before => evaluate calls before expr
  | code::rest, before => do returning calls rest (← step calls before code)

theorem returning_sound (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionSound.CallsSound rc mc) (code : List CLogic.Stmt) (before : Locals) (out : B20.C.Val)
    (computed : returning mc code before=some out) :
    C99ScalarReference.Exec rc (environment before) (C99Frontend.scalars code) (.returned (value out)) := by
  induction code generalizing before with
  | nil => cases computed
  | cons first rest ih =>
    cases first with
    | ret expr => exact .seqReturn _ _ _ _ (.ret _ _ _ (C99CompactScalar115.evaluate_sound rc mc calls before expr out computed))
    | declare ty names | assign name expr | update name op expr =>
      simp only [returning] at computed
      obtain ⟨middle,head,tail⟩ := Option.bind_eq_some_iff.mp computed
      exact .seqNormal _ _ _ _ _ (C99CompactScalar115.step_sound rc mc calls before middle _ head) (ih middle tail)

def unaryEnv (x : BitVec 64) : C99ScalarReference.Env :=
  C99ScalarReference.set (fun _ => none) ['x'] (.uint64,some (.uint64 x))

def binaryEnv (x y : BitVec 64) : C99ScalarReference.Env :=
  C99ScalarReference.set (C99ScalarReference.set (fun _ => none) ['y'] (.uint64,some (.uint64 y))) ['x'] (.uint64,some (.uint64 x))

def unaryLocals (x : BitVec 64) : Locals :=
  [(['x'],.u64 (some x)),("fpr_one".toList,.u64 (some Run2.KeygenLeafGate.oneBits))]

def binaryLocals (x y : BitVec 64) : Locals :=
  [(['x'],.u64 (some x)),(['y'],.u64 (some y)),("fpr_one".toList,.u64 (some Run2.KeygenLeafGate.oneBits))]

theorem unary_environment (x : BitVec 64) : environment (unaryLocals x)=FprPrefixCalls.withGlobals (unaryEnv x) := by
  funext name
  by_cases first : name=['x'] <;> by_cases global : name="fpr_one".toList
  all_goals simp [environment,unaryLocals,unaryEnv,FprPrefixCalls.withGlobals,C99ScalarReference.set,
    C99NameMap115.lookup,Cell.reference,Cell.ty,Cell.value,value,C99ValueBridge.type,first,global]
  all_goals rfl

theorem binary_environment (x y : BitVec 64) : environment (binaryLocals x y)=FprPrefixCalls.withGlobals (binaryEnv x y) := by
  funext name
  by_cases first : name=['x'] <;> by_cases second : name=['y'] <;> by_cases global : name="fpr_one".toList
  all_goals simp [environment,binaryLocals,binaryEnv,FprPrefixCalls.withGlobals,C99ScalarReference.set,
    C99NameMap115.lookup,Cell.reference,Cell.ty,Cell.value,value,C99ValueBridge.type,first,second,global]
  all_goals rfl

theorem unary (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionSound.CallsSound rc mc) (code : CLogic.Function)
    (params : code.params=[(.u64,['x'])]) (result : code.result=.u64) (x out : BitVec 64)
    (computed : returning mc code.body (unaryLocals x)=some (.u64 out)) :
    FprPrefixCalls.ValueCall rc code [.uint64 x] (.uint64 out) := by
  have bound := C99ScalarReference.BindArgs.cons .uint64 ['x'] [] (.uint64 x) [] (fun _ => none) .nil
  rw [show convert .uint64 (Value.uint64 x).integer=Value.uint64 x from C99CountedWords.convert_self (.uint64 x)] at bound
  have parameters : C99ScalarReference.BindArgs (C99Frontend.headerFunction code).params [.uint64 x] (unaryEnv x) := by
    simpa only [C99Frontend.headerFunction,params,List.map_cons,List.map_nil,C99ValueBridge.type,unaryEnv] using bound
  have body := returning_sound rc mc calls code.body (unaryLocals x) (.u64 out) computed
  rw [unary_environment] at body
  have source := @FprPrefixCalls.ValueCall.call rc code [.uint64 x] (unaryEnv x) (.uint64 out) parameters body
  have converted : convert (C99ValueBridge.type code.result) (Value.uint64 out).integer=Value.uint64 out := by
    rw [result]
    exact C99CountedWords.convert_self (.uint64 out)
  rw [converted] at source
  exact source

theorem binary (rc : C99ScalarReference.CallRelation) (mc : B20.C.Scalar.Calls)
    (calls : C99ExpressionSound.CallsSound rc mc) (code : CLogic.Function)
    (params : code.params=[(.u64,['x']),(.u64,['y'])]) (result : code.result=.u64) (x y out : BitVec 64)
    (computed : returning mc code.body (binaryLocals x y)=some (.u64 out)) :
    FprPrefixCalls.ValueCall rc code [.uint64 x,.uint64 y] (.uint64 out) := by
  have boundY := C99ScalarReference.BindArgs.cons .uint64 ['y'] [] (.uint64 y) [] (fun _ => none) .nil
  rw [show convert .uint64 (Value.uint64 y).integer=Value.uint64 y from C99CountedWords.convert_self (.uint64 y)] at boundY
  have bound := C99ScalarReference.BindArgs.cons .uint64 ['x'] [(.uint64,['y'])] (.uint64 x) [.uint64 y] _ boundY
  rw [show convert .uint64 (Value.uint64 x).integer=Value.uint64 x from C99CountedWords.convert_self (.uint64 x)] at bound
  have parameters : C99ScalarReference.BindArgs (C99Frontend.headerFunction code).params [.uint64 x,.uint64 y] (binaryEnv x y) := by
    simpa only [C99Frontend.headerFunction,params,List.map_cons,List.map_nil,C99ValueBridge.type,binaryEnv] using bound
  have body := returning_sound rc mc calls code.body (binaryLocals x y) (.u64 out) computed
  rw [binary_environment] at body
  have source := @FprPrefixCalls.ValueCall.call rc code [.uint64 x,.uint64 y] (binaryEnv x y) (.uint64 out) parameters body
  have converted : convert (C99ValueBridge.type code.result) (Value.uint64 out).integer=Value.uint64 out := by
    rw [result]
    exact C99CountedWords.convert_self (.uint64 out)
  rw [converted] at source
  exact source

end FT1536.Source3.FprHeaderEval137
