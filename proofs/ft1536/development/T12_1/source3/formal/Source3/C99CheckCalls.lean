import Source3.C99LeafCalls

namespace FT1536.Source3.C99CheckCalls
open B20.C C99ValueBridge

def calls : C99ScalarReference.CallRelation := fun name args z =>
  if name=KeygenHelpers.positiveName then
    C99ScalarReference.FunctionExec C99BitcastReference.calls
      (C99Frontend.headerFunction KeygenHelpers.positiveProgram) args z
  else C99BitcastReference.calls name args z

def signature : C99Typing.Types := fun name =>
  if name=KeygenHelpers.positiveName then some .i32 else C99BitcastReference.signature name

theorem calls_ok : C99ExpressionBridge.CallsOK signature calls StablePositive.pureCalls := by
  intro name args z t ht hc
  by_cases hn : name=KeygenHelpers.positiveName
  · subst name
    have htt : t=.i32 := by simpa [signature] using ht.symm
    subst t
    have hr : C99ScalarReference.FunctionExec C99BitcastReference.calls
        (C99Frontend.headerFunction KeygenHelpers.positiveProgram) args z := by simpa [calls] using hc
    have he := C99HeaderProof.function_complete _ _ _ C99BitcastReference.calls_ok _
      (args.map encode) z C99LeafCalls.positive_checked (by simpa [List.map_map,Function.comp_def,value_encode] using hr)
    refine ⟨by simpa [StablePositive.pureCalls] using he,?_⟩
    obtain ⟨_,v,_,_,hz⟩ := C99HeaderProof.function_inv _ _ _ _ hr
    rw [hz,C99Typing.converted_type]
    rfl
  · have hb := C99BitcastReference.calls_ok name args z t (by simpa [signature,hn] using ht)
      (by simpa [calls,hn] using hc)
    exact ⟨by simpa [StablePositive.pureCalls,hn] using hb.1,hb.2⟩

theorem calls_sound : C99ExpressionSound.CallsSound calls StablePositive.pureCalls := by
  intro name args v h
  by_cases hn : name=KeygenHelpers.positiveName
  · subst name
    have he : CLogic.execute KeygenHelpers.calls KeygenHelpers.positiveProgram args=some v := by
      simpa [StablePositive.pureCalls] using h
    exact C99HeaderSound.function_sound _ _ _ C99BitcastReference.calls_sound _ _ _
      C99LeafCalls.positive_checked he
  · have hc := C99BitcastReference.calls_sound name args v (by simpa [StablePositive.pureCalls,hn] using h)
    simpa [calls,hn] using hc

end FT1536.Source3.C99CheckCalls

#print axioms FT1536.Source3.C99CheckCalls.calls_ok
#print axioms FT1536.Source3.C99CheckCalls.calls_sound
