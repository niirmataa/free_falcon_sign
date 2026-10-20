import Source3.C99PrefixBridge
import Source3.C99HeaderSignature
import Source3.FprNormTotal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99AddProof
open B20.C C99Typing C99StateBridge C99ValueBridge

def prelude : List CLogic.Stmt := (FprUnsignedPrefixes.scalars (FprAST.addCode.body.take 28)).getD []
def tail : List CLogic.Stmt := (FprUnsignedPrefixes.scalars (FprAST.addCode.body.drop 29)).getD []
def referenceBody : C99ScalarReference.Stmt :=
  C99PrefixBridge.withTail prelude
    (.seq (.block (FprPrimitives.scalarDecls FprAST.normCode) (C99Frontend.scalars FprAST.normCode))
      (C99Frontend.scalars tail))
def referenceFunction : C99ScalarReference.Function :=
  ⟨FprAST.addCode.params.map (fun (t,n) => (type t,n)),.uint64,referenceBody⟩

theorem body_shape : FprAST.addCode.body=prelude.map FprPrimitives.Instr.scalar ++
    [.norm ['x','u'] ['e','x']] ++ tail.map FprPrimitives.Instr.scalar := by rfl
theorem lowering : C99Frontend.function FprAST.addCode=some referenceFunction := by
  unfold C99Frontend.function
  rw [body_shape]
  rw [List.append_assoc,C99PrefixBridge.lower_with_tail]
  simp [C99Frontend.lowerBody,FprAST.norm_binding,C99ScalarToFpr.lower_scalars,referenceFunction,referenceBody]
  rfl

theorem params_checked : C99ParametersBridge.paramTypes FprAST.addCode.params=some FprUnsignedPrefixes.xyTypes := by rfl
theorem prelude_checked : checkBody C99HeaderSignature.signature FprUnsignedPrefixes.xyTypes prelude=
    some FprUnsignedPrefixes.addTypes := by rfl
theorem norm_checked : checkBody C99HeaderSignature.signature FprUnsignedPrefixes.addTypes FprAST.normCode=
    some FprNormTotal.normTypes := by rfl
theorem tail_checked : (checkBody C99HeaderSignature.signature FprUnsignedPrefixes.addTypes tail).isSome := by decide
theorem prelude_no_return : ∀ e, CLogic.Stmt.ret e∉prelude := by
  intro e
  simp [prelude,FprUnsignedPrefixes.scalars,FprAST.addCode]
theorem norm_no_return : ∀ e, CLogic.Stmt.ret e∉FprAST.normCode := by intro e; simp [FprAST.normCode]

theorem clean_types (s out : B20.C.Scalar.State)
    (hts : s.types=FprUnsignedPrefixes.addTypes) (hto : out.types=FprNormTotal.normTypes) :
    (FprPrimitives.leaveBlock s out (FprPrimitives.scalarDecls FprAST.normCode)).types=
      FprUnsignedPrefixes.addTypes := by
  funext name
  by_cases hn : name=['n','t']
  · subst name
    simpa [FprPrimitives.leaveBlock,FprPrimitives.scalarDecls,FprAST.normCode] using congrFun hts ['n','t']
  · simp [FprPrimitives.leaveBlock,FprPrimitives.scalarDecls,FprAST.normCode,hn,hto,
      FprNormTotal.normTypes,UnsignedState.setType]

theorem add_complete (args : List Val) (z : C99IntegerReference.Value)
    (hs : C99ScalarReference.FunctionExec C99Frontend.headerCalls referenceFunction (args.map value) z) :
    FprPrimitives.execute FprAST.addCode args=some (encode z) := by
  obtain ⟨env,v,hparam,hbody,hreturn⟩ := C99HeaderProof.function_inv _ _ _ _ hs
  obtain ⟨s,hbind,henv,ht,hgood⟩ := C99ParametersBridge.bind_complete FprAST.addCode.params args env
    FprUnsignedPrefixes.xyTypes params_checked hparam
  rw [← henv] at hbody
  obtain ⟨middle,hprefix,hrest⟩ := C99PrefixBridge.prefix_inv _ _ _ _ _ prelude_no_return hbody
  obtain ⟨sp,hp,hsp,tp,gp⟩ := C99NormalBodyBridge.normal_complete C99HeaderSignature.signature
    C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok
    prelude s FprUnsignedPrefixes.addTypes middle hgood (by rw [ht]; exact prelude_checked) hprefix
  rw [← hsp] at hrest
  rcases C99ControlInversion.seq_inv _ _ _ _ _ hrest with ⟨afterNorm,hmacro,htail⟩ | ⟨ret,hmacro,hRet⟩
  · obtain ⟨sn,hn,tn,gn,hRn⟩ := C99ScopeBridge.scalar_block_complete C99HeaderSignature.signature
      C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok
      sp FprAST.normCode FprNormTotal.normTypes (.normal afterNorm) gp
      (by rw [tp]; exact norm_checked) norm_no_return hmacro
    let clean := FprPrimitives.leaveBlock sp sn (FprPrimitives.scalarDecls FprAST.normCode)
    have henvClean : afterNorm=environment clean := C99ScalarReference.Result.normal.inj hRn
    subst afterNorm
    have tc : clean.types=FprUnsignedPrefixes.addTypes := clean_types sp sn tp tn
    have gc : WellTyped clean := C99ScopeBridge.restore_good sp sn _ gp gn
    obtain ⟨ctxTail,hTailCheck⟩ := Option.isSome_iff_exists.mp tail_checked
    have hval := C99BodyBridge.body_complete C99HeaderSignature.signature C99Frontend.headerCalls
      FprPrimitives.headerCalls C99HeaderSignature.calls_ok tail .u64 clean ctxTail v gc
      (by rw [tc]; exact hTailCheck) htail
    obtain ⟨final,hfinal⟩ := C99ScalarToFpr.return_to_block tail .u64 clean
      (B20.C.cast .u64 (encode v)) 227 (by decide) hval
    have hnorm : FprPrimitives.execScalars FprAST.normCode sp=some sn := by
      rw [FprScalarSequence.exec_scalars]; exact hn
    have hfull : FprPrimitives.execBlock 256 .u64 FprAST.addCode.body s=
        some (final,some (B20.C.cast .u64 (encode v))) := by
      rw [body_shape,List.append_assoc]
      rw [show 256=228+prelude.length by decide,FprScalarSequence.scalar_prefix _ _ _ hp]
      simp only [List.singleton_append,FprPrimitives.execBlock,FprAST.norm_binding]
      simp [hnorm,hfinal,clean]
    have hz : encode z=B20.C.cast .u64 (encode v) := by rw [hreturn]; exact C99ExpressionBridge.cast_encode .u64 v
    have htype : FprAST.addCode.result=.u64 := rfl
    simp [FprPrimitives.execute,hbind,htype,hfull,hz]
  · obtain ⟨_,_,_,_,hbad⟩ := C99ScopeBridge.scalar_block_complete C99HeaderSignature.signature
      C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok
      sp FprAST.normCode FprNormTotal.normTypes (.returned ret) gp
      (by rw [tp]; exact norm_checked) norm_no_return hmacro
    cases hbad

theorem pinned_add_complete (x y z : BitVec 64)
    (hs : C99Frontend.primitiveCall ['f','p','r','_','a','d','d'] [.uint64 x,.uint64 y] (.uint64 z)) :
    FprPrimitives.add x y=some z := by
  obtain ⟨f,hlookup,hf⟩ := hs
  have heq : f=referenceFunction := by simpa [C99Frontend.lookup,lowering] using hlookup.symm
  subst f
  have he := add_complete [.u64 x,.u64 y] (.uint64 z) hf
  simp [FprPrimitives.add,FprPrimitives.call,FprAST.add_binding,he,encode]

end FT1536.Source3.C99AddProof

#check @FT1536.Source3.C99AddProof.pinned_add_complete
#print axioms FT1536.Source3.C99AddProof.pinned_add_complete
