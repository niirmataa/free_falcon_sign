import Source3.FprScaledBinding

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.FprScaledBridge
open B20.C C99Typing C99ValueBridge FprScaledBinding

theorem complete (args : List Val) (z : C99IntegerReference.Value)
    (h : C99ScalarReference.FunctionExec C99Frontend.headerCalls refFunction (args.map value) z) :
    FprPrimitives.execute FprScaledAST.scaledCode args=some (encode z) := by
  obtain ⟨env,v,hparam,hbody,hreturn⟩ := C99HeaderProof.function_inv _ _ _ _ h
  obtain ⟨s,hbind,henv,ht,hgood⟩ := C99ParametersBridge.bind_complete FprScaledAST.scaledCode.params args env
    paramTypes params_checked hparam
  rw [← henv] at hbody
  obtain ⟨middle,hprefix,hrest⟩ := C99PrefixBridge.prefix_inv _ _ _ _ _ pre_no_return hbody
  obtain ⟨sp,hp,hsp,tp,gp⟩ := C99NormalBodyBridge.normal_complete C99HeaderSignature.signature
    C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok prelude s preTypes middle hgood
    (by rw [ht]; exact pre_checked) hprefix
  rw [← hsp] at hrest
  rcases C99ControlInversion.seq_inv _ _ _ _ _ hrest with ⟨afterNorm,hmacro,htail⟩ | ⟨ret,hmacro,_⟩
  · obtain ⟨sn,hn,tn,gn,hRn⟩ := C99ScopeBridge.scalar_block_complete C99HeaderSignature.signature
      C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok sp FprScaledAST.normCode
      normTypes (.normal afterNorm) gp (by rw [tp]; exact norm_checked) norm_no_return hmacro
    let clean := FprPrimitives.leaveBlock sp sn (FprPrimitives.scalarDecls FprScaledAST.normCode)
    have henvClean : afterNorm=environment clean := C99ScalarReference.Result.normal.inj hRn
    subst afterNorm
    have tc : clean.types=preTypes := clean_types sp sn tp tn
    have gc : WellTyped clean := C99ScopeBridge.restore_good sp sn _ gp gn
    obtain ⟨ctxTail,hTailCheck⟩ := Option.isSome_iff_exists.mp tail_checked
    have hval := C99BodyBridge.body_complete C99HeaderSignature.signature C99Frontend.headerCalls
      FprPrimitives.headerCalls C99HeaderSignature.calls_ok tail .u64 clean ctxTail v gc
      (by rw [tc]; exact hTailCheck) htail
    obtain ⟨final,hfinal⟩ := C99ScalarToFpr.return_to_block tail .u64 clean
      (B20.C.cast .u64 (encode v)) 247 (by decide) hval
    have hnorm : FprPrimitives.execScalars FprScaledAST.normCode sp=some sn := by
      rw [FprScalarSequence.exec_scalars]; exact hn
    have hfull : FprPrimitives.execBlock 256 .u64 FprScaledAST.scaledCode.body s=
        some (final,some (B20.C.cast .u64 (encode v))) := by
      rw [shape,List.append_assoc,show 256=248+prelude.length by decide]
      rw [FprScalarSequence.scalar_prefix _ _ _ hp]
      simp only [List.singleton_append,FprPrimitives.execBlock,norm_source]
      simp [hnorm,hfinal,clean]
    have hz : encode z=B20.C.cast .u64 (encode v) := by rw [hreturn]; exact C99ExpressionBridge.cast_encode .u64 v
    have htype : FprScaledAST.scaledCode.result=.u64 := rfl
    simp [FprPrimitives.execute,hbind,htype,hfull,hz]
  · obtain ⟨_,_,_,_,hbad⟩ := C99ScopeBridge.scalar_block_complete C99HeaderSignature.signature
      C99Frontend.headerCalls FprPrimitives.headerCalls C99HeaderSignature.calls_ok sp FprScaledAST.normCode
      normTypes (.returned ret) gp (by rw [tp]; exact norm_checked) norm_no_return hmacro
    cases hbad

theorem sound (args : List Val) (w : Val)
    (h : FprPrimitives.execute FprScaledAST.scaledCode args=some w) :
    C99ScalarReference.FunctionExec C99Frontend.headerCalls refFunction (args.map value) (value w) := by
  obtain ⟨s,out,hbind,hbody⟩ := C99FprInversion.execute_inv _ _ _ h
  rw [shape,List.append_assoc] at hbody
  obtain ⟨hp,hg⟩ := C99HeaderSound.bind_sound _ _ _ hbind
  obtain ⟨other,ho,_,ht,_⟩ := C99ParametersBridge.bind_complete _ _ _ _ params_checked hp
  have hsame : other=s := Option.some.inj (ho.symm.trans hbind)
  subst other
  obtain ⟨sp,hpre,hrest⟩ := C99FprInversion.prefix_inv prelude _ s out (some w) .u64 248 pre_no_return hbody
  obtain ⟨hrp,gp,tp⟩ := C99BodySound.normal_sound C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSound.header_sound prelude s sp preTypes hg (by rw [ht]; exact pre_checked) hpre
  have hshape : (do
      let inner ← FprPrimitives.execScalars FprScaledAST.normCode sp
      FprPrimitives.execBlock 247 .u64 (tail.map FprPrimitives.Instr.scalar)
        (FprPrimitives.leaveBlock sp inner (FprPrimitives.scalarDecls FprScaledAST.normCode)))=some (out,some w) := by
    simpa [FprPrimitives.execBlock,norm_source] using hrest
  obtain ⟨inner,hinner,htail⟩ := Option.bind_eq_some_iff.mp hshape
  have hin : UnsignedState.exec FprPrimitives.headerCalls sp FprScaledAST.normCode=some inner := by
    rw [← FprScalarSequence.exec_scalars]; exact hinner
  obtain ⟨hrn,gn,tn⟩ := C99BodySound.normal_sound C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSound.header_sound FprScaledAST.normCode sp inner normTypes gp
    (by rw [tp]; exact norm_checked) hin
  let clean := FprPrimitives.leaveBlock sp inner (FprPrimitives.scalarDecls FprScaledAST.normCode)
  have hrblock : C99ScalarReference.Exec C99Frontend.headerCalls (environment sp)
      (.block (FprPrimitives.scalarDecls FprScaledAST.normCode) (C99Frontend.scalars FprScaledAST.normCode))
      (.normal (environment clean)) := by
    rw [C99ScopeBridge.restore_environment]
    exact C99ScalarReference.Exec.blockNormal _ _ _ _ hrn
  have gc := C99ScopeBridge.restore_good sp inner (FprPrimitives.scalarDecls FprScaledAST.normCode) gp gn
  have tc := clean_types sp inner tp tn
  have hscalar := C99FprInversion.scalar_return _ _ _ _ _ _ htail
  obtain ⟨ctxTail,hct⟩ := Option.isSome_iff_exists.mp tail_checked
  obtain ⟨v,hrt,hw⟩ := C99BodySound.return_sound C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSound.header_sound tail .u64 clean ctxTail w gc
    (by rw [tc]; exact hct) hscalar
  have hfull := C99FprInversion.prefix_sound _ _ _ _ _ _ hrp
    (C99ScalarReference.Exec.seqNormal _ _ _ _ _ hrblock hrt)
  rw [hw,cast_matches,value_encode]
  exact C99ScalarReference.FunctionExec.call _ _ _ hp hfull

end FT1536.Source3.FprScaledBridge

#print axioms FT1536.Source3.FprScaledBridge.complete
#print axioms FT1536.Source3.FprScaledBridge.sound
