import Source3.KeygenPublicScalarControl
import Source3.KeygenPublicArguments
import Source3.C99DivWhileProof
import Source3.KeygenRev10

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The complete ten-iteration public rev10 function, not the solver's static
   REV10 table. The observed source return is derived for every uint32 input. -/
namespace FT1536.Source3.KeygenPublicRev
open B20.C C99Typing C99ValueBridge
open C99ScalarReference (Exec Result)

def var (n : String) : CLogic.Expr := .var n.toList
def condition : CLogic.Expr := .cmp .lt (var "i") (.literal .i32 10)
def increment : CLogic.Expr := .bin .add (var "i") (.literal .i32 1)
def round : List CLogic.Stmt := [
  .assign "y".toList (.bin .bor (.bin .shl (var "y") (.literal .i32 1))
    (.bin .band (var "x") (.literal .i32 1))),
  .update "x".toList .shr (.literal .i32 1)]
def prologue : List CLogic.Stmt := [.declare .u32 ["y".toList],
  .declare .i32 ["i".toList],.assign "y".toList (.literal .i32 0),
  .assign "i".toList (.literal .i32 0)]
def iteration : C99ScalarReference.Stmt :=
  .seq (.block [] (C99Frontend.scalars round)) (.assign "i".toList (C99Frontend.expression increment))
def loop : C99ScalarReference.Stmt := .while (C99Frontend.expression condition) iteration
def tail : C99ScalarReference.Stmt := .seq loop
  (.seq (.ret (.variable "y".toList)) .skip)
def prepend : List CLogic.Stmt → C99ScalarReference.Stmt → C99ScalarReference.Stmt
  | [],tail => tail | s::ss,tail => .seq (C99Frontend.scalar s) (prepend ss tail)
def program : C99ScalarReference.Stmt := prepend prologue tail
def sourceProgram : C99ScalarReference.Stmt := prepend (prologue.take 3)
  (.seq (.seq (C99Frontend.scalar (.assign "i".toList (.literal .i32 0))) loop)
    (.seq (.ret (.variable "y".toList)) .skip))
theorem source_lowered : KeygenPublicScalarControl.lower (KeygenPublicScalar.code .rev)=some sourceProgram := by rfl

def types : C99Typing.Types := fun n =>
  if n="i".toList then some .i32 else if n="x".toList ∨ n="y".toList then some .u32 else none
def state (x y : BitVec 32) (i : Nat) : B20.C.Scalar.State :=
  ⟨types,fun n => if n="i".toList then some (.i32 (BitVec.ofNat 32 i))
    else if n="x".toList then some (.u32 x) else if n="y".toList then some (.u32 y) else none⟩
def initial (x : BitVec 32) : B20.C.Scalar.State :=
  ⟨fun n => if n="x".toList then some .u32 else none,
    fun n => if n="x".toList then some (.u32 x) else none⟩
def nextY (x y : BitVec 32) : BitVec 32 := (y <<< 1) ||| (x &&& 1#32)
def reversed : Nat → BitVec 32 → BitVec 32 → BitVec 32
  | 0,_,y => y | n+1,x,y => reversed n (x >>> 1) (nextY x y)
def noCalls : B20.C.Scalar.Calls := fun _ _ => none
theorem calls_ok : C99ExpressionBridge.CallsOK C99HeaderProof.noSignature FprPrefixCalls.calls noCalls := by
  intro n args v t signature _
  cases signature
theorem state_good (x y : BitVec 32) (i : Nat) : WellTyped (state x y i) := by
  intro n v h
  simp only [state] at h ⊢
  split_ifs at h <;> simp_all [types]
  all_goals subst v; rfl
theorem initial_good (x : BitVec 32) : WellTyped (initial x) := by
  intro n v h
  simp only [initial] at h ⊢
  split_ifs at h; simp_all
  subst v
  rfl
theorem round_checked : C99StateBridge.checkBody C99HeaderProof.noSignature types round=some types := by rfl
theorem round_no_return (e : CLogic.Expr) : .ret e∉round := by simp [round]
theorem prologue_checked (x : BitVec 32) :
    C99StateBridge.checkBody C99HeaderProof.noSignature (initial x).types prologue=some types := by
  simp [C99StateBridge.checkBody,C99StateBridge.check,C99StateBridge.declareTypes,
    C99StateBridge.expressionCheck,C99Typing.infer,prologue,initial,ExpressionFuel.depth]
  funext n
  simp [types]
  split_ifs <;> simp_all
theorem round_model (x y : BitVec 32) (i : Nat) :
    UnsignedState.exec noCalls (state x y i) round=some (state (x >>> 1) (nextY x y) i) := by
  simp [UnsignedState.exec,round,CLogic.step,CLogic.eval,var,state,types,nextY,
    B20.C.Scalar.assign,B20.C.update,B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,
    B20.C.Val.ty,B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe,B20.C.shift]
  funext n
  simp only [B20.C.update]
  split_ifs <;> simp_all
theorem increment_model (x y : BitVec 32) (i : Nat) (hi : i≤10) :
    CLogic.step noCalls (state x y i) (.assign "i".toList increment)=some (state x y (i+1)) := by
  interval_cases i <;>
    simp [CLogic.step,CLogic.eval,increment,var,state,types,B20.C.Scalar.assign,
    B20.C.cast,B20.C.literalValue,B20.C.bin,B20.C.commonTy,
    B20.C.Val.ty,B20.C.bitsOp,B20.C.signedBitsOp,B20.C.signedSafe]
  all_goals
    funext n
    simp only [B20.C.update]
    split_ifs <;> simp_all

theorem condition_model (x y : BitVec 32) (i : Nat) (hi : i≤10) :
    CLogic.eval noCalls (state x y i).values 32 condition=some (CLogic.boolean (decide (i<10))) := by
  interval_cases i <;> simp [CLogic.eval,condition,var,state,B20.C.literalValue,
    CLogic.compare,B20.C.commonTy,B20.C.Val.ty,B20.C.cast,B20.C.Val.integer]
theorem condition_value (x y : BitVec 32) (i : Nat) (hi : i≤10) (v : C99IntegerReference.Value)
    (source : C99ScalarReference.Eval FprPrefixCalls.calls (environment (state x y i))
      (C99Frontend.expression condition) v) : v.integer≠0 ↔ i<10 := by
  have checked : C99Typing.infer C99HeaderProof.noSignature (state x y i).types condition=some .i32 := rfl
  have complete := (C99ExpressionBridge.expression_complete _ _ _ calls_ok _ (state_good x y i)
    condition .i32 v checked source).1
  have executed : CLogic.eval noCalls (state x y i).values 32 condition=some (encode v) := by
    rw [ExpressionFuel.fuel_adequate _ _ _ _ (by decide : ExpressionFuel.depth condition≤32)]
    exact complete
  have equal := congrArg CLogic.truth (Option.some.inj (executed.symm.trans (condition_model x y i hi)))
  rw [C99ExpressionBridge.truth_encode,CLogic.truth_boolean] at equal
  by_cases lt : i<10
  · simpa [lt] using equal
  · have zero : v.integer=0 := by simpa [lt] using equal
    simp [zero,lt]

theorem iteration_complete (x y : BitVec 32) (i : Nat) (hi : i<10) (out : Result)
    (source : Exec FprPrefixCalls.calls (environment (state x y i)) iteration out) :
    out=.normal (environment (state (x >>> 1) (nextY x y) (i+1))) := by
  rcases C99ControlInversion.seq_inv _ _ _ _ _ source with ⟨middle,first,rest⟩ | ⟨v,first,_⟩
  · obtain ⟨inner,model,_,_,result⟩ := C99ScopeBridge.scalar_block_complete _ _ _ calls_ok
      (state x y i) round types (.normal middle) (state_good x y i) round_checked round_no_return first
    have innerEqual := Option.some.inj (model.symm.trans (round_model x y i))
    subst inner
    have clean : FprPrimitives.leaveBlock (state x y i) (state (x >>> 1) (nextY x y) i)
        (FprPrimitives.scalarDecls round)=state (x >>> 1) (nextY x y) i := by rfl
    rw [clean] at result
    have middleEqual := Result.normal.inj result
    subst middle
    obtain ⟨last,model,result,_,_⟩ := C99StatementBridge.assign_complete _ _ _ calls_ok
      (state (x >>> 1) (nextY x y) i) "i".toList increment .i32 out
      (state_good _ _ _) rfl (by rfl) rest
    have lastEqual := Option.some.inj (model.symm.trans (increment_model _ _ i (by omega)))
    subst last
    exact result
  · obtain ⟨_,_,_,_,result⟩ := C99ScopeBridge.scalar_block_complete _ _ _ calls_ok
      (state x y i) round types (.returned v) (state_good x y i) round_checked round_no_return first
    cases result

theorem loop_complete (remaining : Nat) : ∀ i x y out,
    i+remaining=10 → Exec FprPrefixCalls.calls (environment (state x y i)) loop out →
    out=.normal (environment (state (x >>> remaining) (reversed remaining x y) 10)) := by
  induction remaining with
  | zero =>
      intro i x y out count source
      have index : i=10 := by omega
      subst i
      rcases C99DivWhileProof.while_inv _ _ _ _ _ source with ⟨v,hv,zero,result⟩ |
        ⟨v,middle,hv,nonzero,_,_⟩ | ⟨v,z,hv,nonzero,_,_⟩
      · simpa [reversed] using result
      · have impossible := (condition_value x y 10 (by omega) v hv).mp nonzero
        omega
      · have impossible := (condition_value x y 10 (by omega) v hv).mp nonzero
        omega
  | succ remaining ih =>
      intro i x y out count source
      have index : i<10 := by omega
      rcases C99DivWhileProof.while_inv _ _ _ _ _ source with ⟨v,hv,zero,result⟩ |
        ⟨v,middle,hv,nonzero,first,rest⟩ | ⟨v,z,hv,nonzero,first,result⟩
      · have impossible := (condition_value x y i (by omega) v hv).mpr index
        exact (impossible zero).elim
      · have equal := Result.normal.inj (iteration_complete x y i index (.normal middle) first)
        subst middle
        have result := ih (i+1) (x >>> 1) (nextY x y) out (by omega) rest
        simpa only [reversed,← BitVec.shiftRight_add,Nat.add_comm] using result
      · have impossible := iteration_complete x y i index (.returned z) first
        cases impossible

theorem prologue_model (x : BitVec 32) :
    UnsignedState.exec noCalls (initial x) prologue=some (state x 0 0) := by
  simp [UnsignedState.exec,prologue,CLogic.step,CLogic.eval,initial,state,
    B20.C.Scalar.declareMany,B20.C.Scalar.declareOne,B20.C.Scalar.assign,B20.C.literalValue,B20.C.cast]
  constructor
  · funext n; split_ifs <;> simp_all [types]
  · funext n; simp only [B20.C.update]; split_ifs <;> simp_all

theorem prefix_complete (codes : List CLogic.Stmt) (finish : C99ScalarReference.Stmt)
    (s : B20.C.Scalar.State) (ctx : C99Typing.Types) (out : Result)
    (good : WellTyped s) (checked : C99StateBridge.checkBody C99HeaderProof.noSignature s.types codes=some ctx)
    (normal : ∀ c∈codes, ∀ e, c≠.ret e)
    (source : Exec FprPrefixCalls.calls (environment s) (prepend codes finish) out) :
    ∃ last, UnsignedState.exec noCalls s codes=some last ∧
      Exec FprPrefixCalls.calls (environment last) finish out := by
  induction codes generalizing s with
  | nil => exact ⟨s,rfl,source⟩
  | cons c cs ih =>
      obtain ⟨middleTypes,headChecked,restChecked⟩ := Option.bind_eq_some_iff.mp checked
      rcases C99ControlInversion.seq_inv _ _ _ _ _ source with ⟨middle,head,rest⟩ | ⟨v,head,_⟩
      · obtain ⟨next,model,result,types,goodNext⟩ := C99StatementBridge.step_complete _ _ _ calls_ok
          s c middleTypes (.normal middle) good headChecked (normal c (by simp)) head
        have equal := Result.normal.inj result
        subst middle
        obtain ⟨last,lastModel,lastSource⟩ := ih next goodNext (by rw [types]; exact restChecked)
          (fun c hc => normal c (by simp [hc])) rest
        exact ⟨last,by simp [UnsignedState.exec,model,lastModel],lastSource⟩
      · obtain ⟨_,_,result,_,_⟩ := C99StatementBridge.step_complete _ _ _ calls_ok
          s c middleTypes (.returned v) good headChecked (normal c (by simp)) head
        cases result

theorem seq_associate (calls : C99ScalarReference.CallRelation) (env : C99ScalarReference.Env)
    (a b c : C99ScalarReference.Stmt) (out : Result) (source : Exec calls env (.seq (.seq a b) c) out) :
    Exec calls env (.seq a (.seq b c)) out := by
  cases source with
  | seqNormal _ middle _ _ _ first rest =>
      cases first with
      | seqNormal _ step _ _ _ head tail => exact .seqNormal _ _ _ _ _ head (.seqNormal _ _ _ _ _ tail rest)
  | seqReturn _ _ _ v first =>
      cases first with
      | seqNormal _ step _ _ _ head tail => exact .seqNormal _ _ _ _ _ head (.seqReturn _ _ _ _ tail)
      | seqReturn _ _ _ v head => exact .seqReturn _ _ _ _ head
theorem prepend_map (calls : C99ScalarReference.CallRelation) (codes : List CLogic.Stmt)
    (a b : C99ScalarReference.Stmt)
    (transform : ∀ env out, Exec calls env a out → Exec calls env b out)
    (env : C99ScalarReference.Env) (out : Result) (source : Exec calls env (prepend codes a) out) :
    Exec calls env (prepend codes b) out := by
  induction codes generalizing env with
  | nil => exact transform env out source
  | cons c cs ih =>
      cases source with
      | seqNormal _ middle _ _ _ head rest => exact .seqNormal _ _ _ _ _ head (ih middle rest)
      | seqReturn _ _ _ v head => exact .seqReturn _ _ _ _ head
theorem source_program (env : C99ScalarReference.Env) (out : Result)
    (source : Exec FprPrefixCalls.calls env sourceProgram out) : Exec FprPrefixCalls.calls env program out :=
  prepend_map _ (prologue.take 3) _ _ (fun env out => seq_associate _ env _ _ _ out) env out source

theorem program_result (x : BitVec 32) (out : Result)
    (source : Exec FprPrefixCalls.calls (environment (initial x)) program out) :
    out=.returned (.uint32 (reversed 10 x 0)) := by
  obtain ⟨last,model,rest⟩ := prefix_complete prologue tail (initial x) types out
    (initial_good x) (prologue_checked x) (by intro c hc e; simp [prologue] at hc; rcases hc with h | h | h | h <;> rw [h] <;> intro no <;> cases no)
    source
  have equal := Option.some.inj (model.symm.trans (prologue_model x))
  subst last
  rcases C99ControlInversion.seq_inv _ _ _ _ _ rest with ⟨middle,executed,returned⟩ | ⟨v,executed,_⟩
  · have equal := Result.normal.inj (loop_complete 10 0 x 0 (.normal middle) rfl executed)
    subst middle
    cases returned with
    | seqNormal _ _ _ _ _ first rest => cases first
    | seqReturn _ _ _ v first =>
        cases first with
        | ret _ _ _ value =>
            cases value with
            | «variable» _ ty _ bound =>
                have equal : v=.uint32 (reversed 10 x 0) := by
                  simpa [environment,state,types,C99ValueBridge.value] using
                    (congrArg (fun cell => cell.map Prod.snd) bound).symm
                subst v
                rfl
  · have impossible := loop_complete 10 0 x 0 (.returned v) rfl executed
    cases impossible

theorem call_body (args : List C99IntegerReference.Value) (v : C99IntegerReference.Value)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .rev) args v) :
    KeygenPublicScalar.Body (fun _ _ _ => False) .rev args v := by
  generalize hn : KeygenPublicScalar.name KeygenPublicScalar.Kind.rev=n at source
  cases source with
  | square _ _ _ invoked =>
      cases invoked with
      | leaf _ _ _ leaf =>
          apply KeygenPublicAlgebra.leaf_body .rev args v
          rw [hn]
          exact leaf
      | square _ _ _ => simp [KeygenPublicScalar.name] at hn
  | binary _ _ _ => simp [KeygenPublicScalar.name] at hn
  | ternary _ _ _ => simp [KeygenPublicScalar.name] at hn
theorem source_result (x : BitVec 32) (v : C99IntegerReference.Value)
    (source : KeygenPublicScalar.Call (KeygenPublicScalar.name .rev) [.uint32 x] v) :
    v=.uint32 (reversed 10 x 0) := by
  obtain ⟨out,execution,returned⟩ := (call_body _ v source).2
  have projected := (KeygenPublicScalarControl.projection _ _ _ out sourceProgram execution source_lowered).2
  obtain ⟨raw,flow,result⟩ := KeygenPublicLinear.return_value out.flow v returned
  rw [KeygenPublicLinear.observation,flow] at projected
  have entry : (C99ModularReference.bindParams KeygenPublicScalar.empty (KeygenPublicScalar.params .rev)
      [.uint32 x]).locals=environment (initial x) := by
    funext n
    have converted : C99IntegerReference.convert .uint32 (C99IntegerReference.Value.uint32 x).integer=.uint32 x :=
      C99CountedWords.convert_self (.uint32 x)
    by_cases hn : n=['x']
    all_goals simp [KeygenPublicScalar.params,C99ModularReference.bindParams,C99ArrayReference.bindValue,
      C99ScalarReference.set,KeygenPublicScalar.empty,environment,initial,converted,hn,type,value]
  rw [entry] at projected
  have rawEqual := Result.returned.inj (program_result x (.returned raw) (source_program _ _ projected))
  rw [rawEqual] at result
  exact result.trans (C99CountedWords.convert_self (.uint32 (reversed 10 x 0)))

end FT1536.Source3.KeygenPublicRev
