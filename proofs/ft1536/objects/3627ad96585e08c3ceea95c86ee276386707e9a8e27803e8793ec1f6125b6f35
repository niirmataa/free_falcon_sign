import Source3.C99AddProof
import Source3.FprDivLoopTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99DivLoopBridge
open B20.C C99Typing C99StateBridge C99ValueBridge

def roundStatements : List CLogic.Stmt := (FprUnsignedPrefixes.scalars FprDivRound.roundCode).getD []
def roundTypes : Types := fun n => if n=['b'] then some .u64 else FprUnsignedPrefixes.divTypes n
def condExpr : CLogic.Expr := .cmp .lt (.var ['i']) (.literal .i32 55)
def incrementExpr : CLogic.Expr := .bin .add (.var ['i']) (.literal .i32 1)
def condition : C99ScalarReference.Expr := C99Frontend.expression condExpr
def iteration : C99ScalarReference.Stmt :=
  .seq (.block (FprPrimitives.blockDecls FprDivRound.roundCode) (C99Frontend.scalars roundStatements))
    (.assign ['i'] (C99Frontend.expression incrementExpr))

theorem round_shape : FprDivRound.roundCode=roundStatements.map FprPrimitives.Instr.scalar := by rfl
theorem round_checked : checkBody C99HeaderSignature.signature FprUnsignedPrefixes.divTypes roundStatements=
    some roundTypes := by rfl
theorem round_no_return : ∀ e, CLogic.Stmt.ret e∉roundStatements := by
  intro e; simp [roundStatements,FprUnsignedPrefixes.scalars,FprDivRound.roundCode,FprAST.divCode]
theorem condition_checked : C99Typing.infer C99HeaderSignature.signature FprUnsignedPrefixes.divTypes condExpr=some .i32 := by rfl
theorem increment_checked : expressionCheck C99HeaderSignature.signature FprUnsignedPrefixes.divTypes incrementExpr=true := by decide
theorem decl_names : FprPrimitives.blockDecls FprDivRound.roundCode=FprPrimitives.scalarDecls roundStatements := by rfl

theorem restore_types (s out : B20.C.Scalar.State)
    (hs : s.types=FprUnsignedPrefixes.divTypes) (ho : out.types=roundTypes) :
    (FprPrimitives.leaveBlock s out (FprPrimitives.scalarDecls roundStatements)).types=
      FprUnsignedPrefixes.divTypes := by
  funext name
  by_cases hn : name=['b']
  · subst name
    simpa [FprPrimitives.leaveBlock,FprPrimitives.scalarDecls,roundStatements,
      FprUnsignedPrefixes.scalars,FprDivRound.roundCode,FprAST.divCode] using congrFun hs ['b']
  · simp [FprPrimitives.leaveBlock,FprPrimitives.scalarDecls,roundStatements,
      FprUnsignedPrefixes.scalars,FprDivRound.roundCode,FprAST.divCode,ho,roundTypes,hn]

theorem condition_value (s : B20.C.Scalar.State) (i : Nat) (hi : i≤55)
    (hs : FprDivLoopTotal.Inv s i) (hg : WellTyped s) (v : C99IntegerReference.Value)
    (hv : C99ScalarReference.Eval C99Frontend.headerCalls (environment s) condition v) :
    (v.integer≠0 ↔ i<55) := by
  have ht : C99Typing.infer C99HeaderSignature.signature s.types condExpr=some .i32 := by
    rw [hs.types]; exact condition_checked
  have he := (C99ExpressionBridge.expression_complete C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSignature.calls_ok s hg condExpr .i32 v ht hv).1
  have he32 : CLogic.eval FprPrimitives.headerCalls s.values 32 condExpr=some (encode v) := by
    rw [ExpressionFuel.fuel_adequate _ _ _ _ (by decide : ExpressionFuel.depth condExpr≤32)]
    exact he
  have hmodel : CLogic.eval FprPrimitives.headerCalls s.values 32 condExpr=
      some (CLogic.boolean (decide (i<55))) := by
    have hiInt := FprDivLoopTotal.index_value i (by omega)
    simp [condExpr,CLogic.eval,hs.index,B20.C.literalValue,CLogic.compare,B20.C.commonTy,
      B20.C.Val.ty,B20.C.cast,B20.C.Val.integer,hiInt]
  have heq : encode v=CLogic.boolean (decide (i<55)) := Option.some.inj (he32.symm.trans hmodel)
  have htruth := congrArg CLogic.truth heq
  rw [C99ExpressionBridge.truth_encode,CLogic.truth_boolean] at htruth
  by_cases hlt : i<55
  · simpa [hlt] using htruth
  · have hz : v.integer=0 := by simpa [hlt] using htruth
    simp [hz,hlt]

theorem increment_model (s : B20.C.Scalar.State) :
    CLogic.step FprPrimitives.headerCalls s (.assign ['i'] incrementExpr)=FprPrimitives.inc ['i'] s := by
  simp [CLogic.step,CLogic.eval,incrementExpr,FprPrimitives.inc,B20.C.literalValue,Option.bind_assoc]

theorem iteration_complete (s : B20.C.Scalar.State) (i : Nat) (hi : i<55)
    (inv : FprDivLoopTotal.Inv s i) (hg : WellTyped s) (r : C99ScalarReference.Result)
    (hs : C99ScalarReference.Exec C99Frontend.headerCalls (environment s) iteration r) :
    ∃ next, FprDivLoopTotal.oneStep s=some next ∧ r=.normal (environment next) ∧
      WellTyped next ∧ FprDivLoopTotal.Inv next (i+1) := by
  rcases C99ControlInversion.seq_inv _ _ _ _ _ hs with ⟨afterBlock,hbody,hinc⟩ | ⟨v,hbody,_⟩
  · rw [decl_names] at hbody
    obtain ⟨inner,hmodel,hti,hgi,hr⟩ := C99ScopeBridge.scalar_block_complete C99HeaderSignature.signature
      C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok s roundStatements roundTypes
      (.normal afterBlock) hg (by rw [inv.types]; exact round_checked) round_no_return hbody
    let clean := FprPrimitives.leaveBlock s inner (FprPrimitives.scalarDecls roundStatements)
    have henv : afterBlock=environment clean := C99ScalarReference.Result.normal.inj hr
    subst afterBlock
    have htc : clean.types=FprUnsignedPrefixes.divTypes := restore_types s inner inv.types hti
    have hgc : WellTyped clean := C99ScopeBridge.restore_good s inner _ hg hgi
    have indexTy : clean.types ['i']=some .i32 := by rw [htc]; rfl
    obtain ⟨next,hnext,hresult,_,hgn⟩ := C99StatementBridge.assign_complete C99HeaderSignature.signature
      C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok clean ['i'] incrementExpr .i32 r
      hgc indexTy (by rw [htc]; exact increment_checked) hinc
    rw [increment_model] at hnext
    have hexec : FprPrimitives.execBlock 250 .u64 FprDivRound.roundCode s=some (inner,none) := by
      rw [round_shape,show 250=244+roundStatements.length by decide]
      have h := FprScalarSequence.scalar_prefix roundStatements s inner hmodel [] 244 .u64
      simpa [FprPrimitives.execBlock] using h
    have hguard := FprDivLoopTotal.index_guard s i (by omega) inv.index
    have hstep : FprDivLoopTotal.oneStep s=some next := by
      simp [FprDivLoopTotal.oneStep,hguard,hi,hexec,decl_names]
      exact hnext
    obtain ⟨w,hw,hwInv⟩ := FprDivLoopTotal.one_step_total s i hi inv
    have heq : w=next := Option.some.inj (hw.symm.trans hstep)
    subst w
    exact ⟨next,hstep,hresult,hgn,hwInv⟩
  · rw [decl_names] at hbody
    obtain ⟨_,_,_,_,hbad⟩ := C99ScopeBridge.scalar_block_complete C99HeaderSignature.signature
      C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok s roundStatements roundTypes
      (.returned v) hg (by rw [inv.types]; exact round_checked) round_no_return hbody
    cases hbad

end FT1536.Source3.C99DivLoopBridge

#print axioms FT1536.Source3.C99DivLoopBridge.condition_value
#print axioms FT1536.Source3.C99DivLoopBridge.iteration_complete
