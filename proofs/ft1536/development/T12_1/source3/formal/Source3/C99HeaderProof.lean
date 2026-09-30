import Source3.C99ParametersBridge
import Source3.C99CompletenessObligations

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99HeaderProof
open B20.C C99Typing C99StateBridge C99ValueBridge C99ExpressionBridge

def checked (sig : Types) (f : CLogic.Function) : Bool :=
  ((C99ParametersBridge.paramTypes f.params).bind (fun ctx => checkBody sig ctx f.body)).isSome

theorem function_inv (rc : C99ScalarReference.CallRelation) (f : C99ScalarReference.Function)
    (args : List C99IntegerReference.Value) (z : C99IntegerReference.Value)
    (hs : C99ScalarReference.FunctionExec rc f args z) :
    ∃ env v, C99ScalarReference.BindArgs f.params args env ∧
      C99ScalarReference.Exec rc env f.body (.returned v) ∧
      z=C99IntegerReference.convert f.result v.integer := by
  cases hs
  exact ⟨_,_,by assumption,by assumption,rfl⟩

theorem function_complete (sig : Types) (rc : C99ScalarReference.CallRelation)
    (mc : B20.C.Scalar.Calls) (hok : CallsOK sig rc mc)
    (f : CLogic.Function) (args : List Val) (z : C99IntegerReference.Value)
    (hc : checked sig f=true)
    (hs : C99ScalarReference.FunctionExec rc (C99Frontend.headerFunction f) (args.map value) z) :
    CLogic.execute mc f args=some (encode z) := by
  obtain ⟨env,v,hparam,hbody,hreturn⟩ := function_inv _ _ _ _ hs
  obtain ⟨outTypes,hchecks⟩ := Option.isSome_iff_exists.mp hc
  obtain ⟨ctx,hctx,hbodyCheck⟩ := Option.bind_eq_some_iff.mp hchecks
  obtain ⟨s,hbind,henv,ht,hgood⟩ := C99ParametersBridge.bind_complete f.params args env ctx hctx hparam
  have he : CLogic.evalBody mc f.result f.body s=some (B20.C.cast f.result (encode v)) := by
    apply C99BodyBridge.body_complete sig rc mc hok f.body f.result s outTypes v hgood
    · rw [ht]; exact hbodyCheck
    · rw [henv]; exact hbody
  have hz : encode z=B20.C.cast f.result (encode v) := by
    rw [hreturn]
    exact cast_encode f.result v
  simp [CLogic.execute,hbind,he,hz]

def noSignature : Types := fun _ => none
theorem no_calls_ok : CallsOK noSignature C99Frontend.noCalls (fun _ _ => none) := by
  intro name args z t hsig
  simp [noSignature] at hsig

theorem pack_checked : checked noSignature FprAST.packCode=true := by decide
theorem ulsh_checked : checked noSignature FprAST.ulshCode=true := by decide
theorem ursh_checked : checked noSignature FprAST.urshCode=true := by decide

theorem header_completeness : C99CompletenessObligations.HeaderCompleteness := by
  intro name args z hname hsrc
  obtain ⟨f,hlookup,hf⟩ := hsrc
  simp only [List.mem_cons,List.not_mem_nil,or_false] at hname
  rcases hname with hpack | hulsh | hursh
  · subst name
    have heq : f=C99Frontend.headerFunction FprAST.packCode := by
      simpa [C99Frontend.lookup] using hlookup.symm
    subst f
    have h := function_complete noSignature C99Frontend.noCalls (fun _ _ => none)
      no_calls_ok FprAST.packCode args (value z) pack_checked hf
    simpa [FprPrimitives.headerCalls,FprAST.pack_binding,encode_value] using h
  · subst name
    have heq : f=C99Frontend.headerFunction FprAST.ulshCode := by
      simpa [C99Frontend.lookup] using hlookup.symm
    subst f
    have h := function_complete noSignature C99Frontend.noCalls (fun _ _ => none)
      no_calls_ok FprAST.ulshCode args (value z) ulsh_checked hf
    simpa [FprPrimitives.headerCalls,FprAST.ulsh_binding,encode_value] using h
  · subst name
    have heq : f=C99Frontend.headerFunction FprAST.urshCode := by
      simpa [C99Frontend.lookup] using hlookup.symm
    subst f
    have h := function_complete noSignature C99Frontend.noCalls (fun _ _ => none)
      no_calls_ok FprAST.urshCode args (value z) ursh_checked hf
    simpa [FprPrimitives.headerCalls,FprAST.ursh_binding,encode_value] using h

end FT1536.Source3.C99HeaderProof

#check @FT1536.Source3.C99HeaderProof.header_completeness
#print FT1536.Source3.C99HeaderProof.header_completeness
#print axioms FT1536.Source3.C99HeaderProof.header_completeness
