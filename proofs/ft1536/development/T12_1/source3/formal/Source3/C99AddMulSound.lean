import Source3.C99FprInversion

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99AddMulSound
open B20.C C99Typing C99ValueBridge

theorem mul_sound (args : List Val) (w : Val)
    (h : FprPrimitives.execute FprAST.mulCode args=some w) :
    C99ScalarReference.FunctionExec C99Frontend.headerCalls
      (C99Frontend.headerFunction C99MulProof.function) (args.map value) (value w) := by
  have hfun := C99FprInversion.scalar_execute _ _ C99MulProof.body_shape args w h
  exact C99HeaderSound.function_sound _ _ _ C99HeaderSound.header_sound _ _ _ C99MulProof.checked hfun

theorem add_sound (args : List Val) (w : Val)
    (h : FprPrimitives.execute FprAST.addCode args=some w) :
    C99ScalarReference.FunctionExec C99Frontend.headerCalls C99AddProof.referenceFunction
      (args.map value) (value w) := by
  obtain ⟨s,out,hbind,hbody⟩ := C99FprInversion.execute_inv _ _ _ h
  rw [C99AddProof.body_shape,List.append_assoc] at hbody
  obtain ⟨hp,hg⟩ := C99HeaderSound.bind_sound _ _ _ hbind
  obtain ⟨other,ho,_,ht,_⟩ := C99ParametersBridge.bind_complete _ _ _ _ C99AddProof.params_checked hp
  have hsame : other=s := Option.some.inj (ho.symm.trans hbind)
  subst other
  obtain ⟨sp,hpre,hrest⟩ := C99FprInversion.prefix_inv C99AddProof.prelude _ s out (some w) .u64 228
    C99AddProof.prelude_no_return hbody
  obtain ⟨hrp,gp,tp⟩ := C99BodySound.normal_sound C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSound.header_sound C99AddProof.prelude s sp
    FprUnsignedPrefixes.addTypes hg (by rw [ht]; exact C99AddProof.prelude_checked) hpre
  have hshape : (do
      let inner ← FprPrimitives.execScalars FprAST.normCode sp
      FprPrimitives.execBlock 227 .u64 (C99AddProof.tail.map FprPrimitives.Instr.scalar)
        (FprPrimitives.leaveBlock sp inner (FprPrimitives.scalarDecls FprAST.normCode)))=some (out,some w) := by
    simpa [FprPrimitives.execBlock,FprAST.norm_binding] using hrest
  obtain ⟨inner,hinner,htail⟩ := Option.bind_eq_some_iff.mp hshape
  have hin : UnsignedState.exec FprPrimitives.headerCalls sp FprAST.normCode=some inner := by
    rw [← FprScalarSequence.exec_scalars]; exact hinner
  obtain ⟨hrn,gn,tn⟩ := C99BodySound.normal_sound C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSound.header_sound FprAST.normCode sp inner
    FprNormTotal.normTypes gp (by rw [tp]; exact C99AddProof.norm_checked) hin
  let clean := FprPrimitives.leaveBlock sp inner (FprPrimitives.scalarDecls FprAST.normCode)
  have hrblock : C99ScalarReference.Exec C99Frontend.headerCalls (environment sp)
      (.block (FprPrimitives.scalarDecls FprAST.normCode) (C99Frontend.scalars FprAST.normCode))
      (.normal (environment clean)) := by
    rw [C99ScopeBridge.restore_environment]
    exact C99ScalarReference.Exec.blockNormal _ _ _ _ hrn
  have gc := C99ScopeBridge.restore_good sp inner (FprPrimitives.scalarDecls FprAST.normCode) gp gn
  have tc := C99AddProof.clean_types sp inner tp tn
  have hscalar := C99FprInversion.scalar_return _ _ _ _ _ _ htail
  obtain ⟨ctxTail,hct⟩ := Option.isSome_iff_exists.mp C99AddProof.tail_checked
  obtain ⟨v,hrt,hw⟩ := C99BodySound.return_sound C99HeaderSignature.signature C99Frontend.headerCalls
    FprPrimitives.headerCalls C99HeaderSound.header_sound C99AddProof.tail .u64 clean ctxTail w gc
    (by rw [tc]; exact hct) hscalar
  have hfull := C99FprInversion.prefix_sound _ _ _ _ _ _ hrp
    (C99ScalarReference.Exec.seqNormal _ _ _ _ _ hrblock hrt)
  rw [hw,cast_matches,value_encode]
  exact C99ScalarReference.FunctionExec.call _ _ _ hp hfull

end FT1536.Source3.C99AddMulSound

#print axioms FT1536.Source3.C99AddMulSound.add_sound
#print axioms FT1536.Source3.C99AddMulSound.mul_sound
