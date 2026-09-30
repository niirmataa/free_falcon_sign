import Source3.FprScaledBridge

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprOfThree
open B20.C FprScaledBinding C99ValueBridge

def three : BitVec 64 := 0x4008000000000000
def fastHeader : B20.C.Scalar.Calls := fun name args =>
  if name="fpr_ursh".toList then CLogic.execute (fun _ _ => none) FprAST.urshCode args
  else if name="fpr_ulsh".toList then CLogic.execute (fun _ _ => none) FprAST.ulshCode args
  else if name="FPR".toList then CLogic.execute (fun _ _ => none) FprAST.packCode args
  else none
theorem fast_header_bound : fastHeader=FprPrimitives.headerCalls := by
  funext name args
  simp [fastHeader,FprPrimitives.headerCalls,FprAST.ursh_binding,FprAST.ulsh_binding,FprAST.pack_binding]
  rfl

def initial : B20.C.Scalar.State := (B20.C.Scalar.bindArgs FprScaledAST.scaledCode.params [.i64 3,.i32 0]).getD B20.C.Scalar.emptyState
def pre : B20.C.Scalar.State := (UnsignedState.exec fastHeader initial prelude).getD B20.C.Scalar.emptyState
def norm : B20.C.Scalar.State := (UnsignedState.exec fastHeader pre FprScaledAST.normCode).getD B20.C.Scalar.emptyState
def clean := FprPrimitives.leaveBlock pre norm (FprPrimitives.scalarDecls FprScaledAST.normCode)

theorem parameters : B20.C.Scalar.bindArgs FprScaledAST.scaledCode.params [.i64 3,.i32 0]=some initial := by rfl
theorem prelude_evaluates : UnsignedState.exec fastHeader initial prelude=some pre := by rfl
theorem norm_evaluates : UnsignedState.exec fastHeader pre FprScaledAST.normCode=some norm := by rfl
theorem tail_evaluates : CLogic.evalBody fastHeader .u64 tail clean=some (.u64 three) := by decide

theorem scaled_three : FprPrimitives.execute FprScaledAST.scaledCode [.i64 3,.i32 0]=some (.u64 three) := by
  have hp := prelude_evaluates
  have hn := norm_evaluates
  have ht := tail_evaluates
  rw [fast_header_bound] at hp hn ht
  obtain ⟨out,hout⟩ := C99ScalarToFpr.return_to_block tail .u64 clean (.u64 three) 247 (by decide) ht
  have hn' : FprPrimitives.execScalars FprScaledAST.normCode pre=some norm := by
    rw [FprScalarSequence.exec_scalars]; exact hn
  have hblock : FprPrimitives.execBlock 256 .u64 FprScaledAST.scaledCode.body initial=some (out,some (.u64 three)) := by
    rw [shape,List.append_assoc,show 256=248+prelude.length by decide]
    rw [FprScalarSequence.scalar_prefix _ _ _ hp]
    simp only [List.singleton_append,FprPrimitives.execBlock,norm_source]
    change (FprPrimitives.execScalars FprScaledAST.normCode pre).bind
      (fun next => FprPrimitives.execBlock 247 .u64 (tail.map FprPrimitives.Instr.scalar)
        (FprPrimitives.leaveBlock pre next (FprPrimitives.scalarDecls FprScaledAST.normCode)))=_
    rw [hn']
    exact hout
  unfold FprPrimitives.execute
  rw [parameters]
  change (FprPrimitives.execBlock 256 .u64 FprScaledAST.scaledCode.body initial).bind
    (fun pair => pair.2)=_
  rw [hblock]
  rfl

def modelCalls : B20.C.Scalar.Calls := fun name args =>
  if name="fpr_scaled".toList then FprPrimitives.execute FprScaledAST.scaledCode args else none
def referenceCalls : C99ScalarReference.CallRelation := fun name args z =>
  name="fpr_scaled".toList ∧ C99ScalarReference.FunctionExec C99Frontend.headerCalls refFunction args z
def signature : C99Typing.Types := fun name => if name="fpr_scaled".toList then some .u64 else none

theorem calls_complete : C99ExpressionBridge.CallsOK signature referenceCalls modelCalls := by
  intro name args z t ht hc
  obtain ⟨rfl,hr⟩ := hc
  have htt : t=.u64 := by simpa [signature] using ht.symm
  subst t
  have hm := FprScaledBridge.complete (args.map encode) z
    (by simpa [List.map_map,Function.comp_def,value_encode] using hr)
  refine ⟨by simpa [modelCalls] using hm,?_⟩
  obtain ⟨_,_,_,_,hz⟩ := C99HeaderProof.function_inv _ _ _ _ hr
  rw [hz,C99Typing.converted_type]
  rfl

theorem calls_sound : C99ExpressionSound.CallsSound referenceCalls modelCalls := by
  intro name args w h
  by_cases hn : name="fpr_scaled".toList
  · exact ⟨hn,FprScaledBridge.sound args w (by simpa only [modelCalls,hn,ite_true] using h)⟩
  · simp only [modelCalls,hn,ite_false] at h
    contradiction

theorem of_checked : C99HeaderProof.checked signature FprScaledAST.ofCode=true := by decide
theorem of_three_model : CLogic.execute modelCalls FprScaledAST.ofCode [.i32 3]=some (.u64 three) := by
  simp [CLogic.execute,FprScaledAST.ofCode,B20.C.Scalar.bindArgs,B20.C.Scalar.emptyState,
    B20.C.Scalar.declareOne,B20.C.Scalar.assign,CLogic.evalBody,CLogic.eval,update,
    B20.C.cast,literalValue,modelCalls]
  exact ⟨.u64 three,scaled_three,rfl⟩

def SourceExec (z : C99IntegerReference.Value) : Prop :=
  C99ScalarReference.FunctionExec referenceCalls (C99Frontend.headerFunction FprScaledAST.ofCode) [.int32 3] z

theorem source_exists : SourceExec (.uint64 three) :=
  C99HeaderSound.function_sound signature referenceCalls modelCalls calls_sound FprScaledAST.ofCode [.i32 3]
    (.u64 three) of_checked of_three_model

theorem source_exact (z : C99IntegerReference.Value) (h : SourceExec z) : z=.uint64 three := by
  have hm := C99HeaderProof.function_complete signature referenceCalls modelCalls calls_complete
    FprScaledAST.ofCode [.i32 3] z of_checked h
  rw [of_three_model] at hm
  have he := congrArg value (Option.some.inj hm)
  rw [value_encode] at he
  exact he.symm

end FT1536.Source3.FprOfThree

#check @FT1536.Source3.FprOfThree.source_exact
#print axioms FT1536.Source3.FprOfThree.source_exact
#print axioms FT1536.Source3.FprOfThree.source_exists
