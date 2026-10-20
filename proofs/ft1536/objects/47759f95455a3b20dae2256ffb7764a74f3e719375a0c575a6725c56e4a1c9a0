import Source3.C99HeaderProof

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

namespace FT1536.Source3.C99HeaderSignature
open B20.C C99Typing C99ValueBridge C99ExpressionBridge

def names : List Name := [['F','P','R'],['f','p','r','_','u','l','s','h'],['f','p','r','_','u','r','s','h']]
def signature : Types := fun name => if name∈names then some .u64 else none

theorem header_result (name : Name) (f : C99ScalarReference.Function)
    (hn : name∈names) (hf : C99Frontend.lookup name=some f) : f.result=.uint64 := by
  simp only [names,List.mem_cons,List.not_mem_nil,or_false] at hn
  rcases hn with hp | hl | hr
  · subst name
    have heq : f=C99Frontend.headerFunction FprAST.packCode := by simpa [C99Frontend.lookup] using hf.symm
    rw [heq]; rfl
  · subst name
    have heq : f=C99Frontend.headerFunction FprAST.ulshCode := by simpa [C99Frontend.lookup] using hf.symm
    rw [heq]; rfl
  · subst name
    have heq : f=C99Frontend.headerFunction FprAST.urshCode := by simpa [C99Frontend.lookup] using hf.symm
    rw [heq]; rfl

theorem calls_ok : CallsOK signature C99Frontend.headerCalls FprPrimitives.headerCalls := by
  intro name args z t hs hc
  have hn : name∈names := by
    by_contra hno
    simp [signature,hno] at hs
  have ht : t=.u64 := by simpa [signature,hn] using hs.symm
  subst t
  refine ⟨?_,?_⟩
  · have h := C99HeaderProof.header_completeness name (args.map encode) (encode z) hn
      (by simpa [List.map_map,Function.comp_def,value_encode] using hc)
    exact h
  · obtain ⟨f,hf,hr⟩ := hc
    obtain ⟨_,_,_,_,hz⟩ := C99HeaderProof.function_inv _ _ _ _ hr
    rw [hz,C99Typing.converted_type,header_result name f hn hf]
    rfl

end FT1536.Source3.C99HeaderSignature

#print axioms FT1536.Source3.C99HeaderSignature.calls_ok
