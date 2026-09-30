import Source3.FprOfThree
import Source3.C99HelperOrders

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.CertificateQSquared
open B20.C FprScaledBinding C99ValueBridge

def macroExpr : CLogic.Expr := .cast .i64 (.literal .i32 339775489)
def parseMacro (line : String) : Option CLogic.Expr := do
  let '#'::cs := line.toList | none
  let ts ← CLogicParser.tokenize (cs.length+1) cs
  let directive::name::rest := ts | none
  if directive != "define".toList || name != "FT1536_KEYGEN_Q_SQUARED".toList then none else do
  let (expr,tail) ← CLogicParser.expression 16 rest
  if tail.isEmpty then some expr else none
theorem macro_source : (Pinned.keygenLines[7445]?).bind parseMacro=some macroExpr := by decide

def argument : BitVec 64 := 339775489
def word : BitVec 64 := 0x41b4409001000000
def initial : B20.C.Scalar.State :=
  (B20.C.Scalar.bindArgs FprScaledAST.scaledCode.params [.i64 argument,.i32 0]).getD B20.C.Scalar.emptyState
def pre : B20.C.Scalar.State := (UnsignedState.exec FprOfThree.fastHeader initial prelude).getD B20.C.Scalar.emptyState
def norm : B20.C.Scalar.State := (UnsignedState.exec FprOfThree.fastHeader pre FprScaledAST.normCode).getD B20.C.Scalar.emptyState
def clean := FprPrimitives.leaveBlock pre norm (FprPrimitives.scalarDecls FprScaledAST.normCode)
theorem parameters : B20.C.Scalar.bindArgs FprScaledAST.scaledCode.params [.i64 argument,.i32 0]=some initial := by rfl
theorem prelude_evaluates : UnsignedState.exec FprOfThree.fastHeader initial prelude=some pre := by rfl
theorem norm_evaluates : UnsignedState.exec FprOfThree.fastHeader pre FprScaledAST.normCode=some norm := by rfl
theorem tail_evaluates : CLogic.evalBody FprOfThree.fastHeader .u64 tail clean=some (.u64 word) := by decide

theorem scaled_value : FprPrimitives.execute FprScaledAST.scaledCode [.i64 argument,.i32 0]=some (.u64 word) := by
  have hp := prelude_evaluates; have hn := norm_evaluates; have ht := tail_evaluates
  rw [FprOfThree.fast_header_bound] at hp hn ht
  obtain ⟨out,hout⟩ := C99ScalarToFpr.return_to_block tail .u64 clean (.u64 word) 247 (by decide) ht
  have hn' : FprPrimitives.execScalars FprScaledAST.normCode pre=some norm := by
    rw [FprScalarSequence.exec_scalars]; exact hn
  have hblock : FprPrimitives.execBlock 256 .u64 FprScaledAST.scaledCode.body initial=some (out,some (.u64 word)) := by
    rw [shape,List.append_assoc,show 256=248+prelude.length by decide]
    rw [FprScalarSequence.scalar_prefix _ _ _ hp]
    simp only [List.singleton_append,FprPrimitives.execBlock,norm_source]
    change (FprPrimitives.execScalars FprScaledAST.normCode pre).bind
      (fun next => FprPrimitives.execBlock 247 .u64 (tail.map FprPrimitives.Instr.scalar)
        (FprPrimitives.leaveBlock pre next (FprPrimitives.scalarDecls FprScaledAST.normCode)))=_
    rw [hn']; exact hout
  unfold FprPrimitives.execute
  rw [parameters]
  change (FprPrimitives.execBlock 256 .u64 FprScaledAST.scaledCode.body initial).bind (fun p => p.2)=_
  rw [hblock]; rfl

theorem of_model : CLogic.execute FprOfThree.modelCalls FprScaledAST.ofCode [.i64 argument]=some (.u64 word) := by
  simp [CLogic.execute,FprScaledAST.ofCode,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,
    B20.C.Scalar.declareOne,B20.C.Scalar.assign,CLogic.evalBody,CLogic.eval,update,
    B20.C.cast,literalValue,FprOfThree.modelCalls]
  exact ⟨.u64 word,scaled_value,rfl⟩
theorem empty_good : C99Typing.WellTyped B20.C.Scalar.emptyState := by
  intro n v h; simp [B20.C.Scalar.emptyState] at h
theorem macro_model : ExpressionFuel.unbounded (fun _ _ => none) (fun _ => none) macroExpr=some (.i64 argument) := by decide

def SourceExec (z : C99IntegerReference.Value) : Prop := ∃ arg,
  C99ScalarReference.Eval C99Frontend.noCalls (fun _ => none) (C99Frontend.expression macroExpr) arg ∧
  C99ScalarReference.FunctionExec FprOfThree.referenceCalls (C99Frontend.headerFunction FprScaledAST.ofCode) [arg] z

theorem source_exists : SourceExec (.uint64 word) := by
  refine ⟨.int64 argument,?_,?_⟩
  · exact C99ExpressionSound.expression_sound _ _ C99HeaderSound.no_calls_sound B20.C.Scalar.emptyState
      empty_good macroExpr (.i64 argument) macro_model
  · exact C99HeaderSound.function_sound FprOfThree.signature _ _ FprOfThree.calls_sound _ [.i64 argument]
      (.u64 word) FprOfThree.of_checked of_model

theorem source_exact (z : C99IntegerReference.Value) (h : SourceExec z) : z=.uint64 word := by
  obtain ⟨arg,he,hf⟩ := h
  have hm := (C99ExpressionBridge.expression_complete C99HeaderProof.noSignature _ _ C99HeaderProof.no_calls_ok
    B20.C.Scalar.emptyState empty_good macroExpr .i64 arg (by rfl) he).1
  have ha : encode arg=.i64 argument := Option.some.inj (hm.symm.trans macro_model)
  have har := congrArg value ha
  rw [value_encode] at har
  change arg=.int64 argument at har
  subst arg
  have hv := C99HeaderProof.function_complete FprOfThree.signature _ _ FprOfThree.calls_complete
    FprScaledAST.ofCode [.i64 argument] z FprOfThree.of_checked hf
  rw [of_model] at hv
  have hh := congrArg value (Option.some.inj hv)
  rw [value_encode] at hh
  exact hh.symm

theorem exact_real_value : Run2.KeygenLeafGate.positiveNormalValue word=(339775489 : ℝ) := by
  norm_num [Run2.KeygenLeafGate.positiveNormalValue,word]

end FT1536.Source3.CertificateQSquared

#check @FT1536.Source3.CertificateQSquared.source_exact
#print FT1536.Source3.CertificateQSquared.source_exists
#print axioms FT1536.Source3.CertificateQSquared.source_exists
#print axioms FT1536.Source3.CertificateQSquared.source_exact
#print axioms FT1536.Source3.CertificateQSquared.exact_real_value
