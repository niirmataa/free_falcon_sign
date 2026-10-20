import Source3.C99MulProof
import Source3.C99DivProof

namespace FT1536.Source3.C99PrimitiveProof

theorem primitive_completeness : C99CompletenessObligations.PrimitiveCompleteness := by
  intro name x y z hname hs
  simp only [List.mem_cons,List.not_mem_nil,or_false] at hname
  rcases hname with hadd | hmul | hdiv
  · subst name
    simpa using C99AddProof.pinned_add_complete x y z hs
  · subst name
    simpa using C99MulProof.pinned_mul_complete x y z hs
  · subst name
    simpa using C99DivProof.pinned_div_complete x y z hs

end FT1536.Source3.C99PrimitiveProof

#check @FT1536.Source3.C99HeaderProof.header_completeness
#check @FT1536.Source3.C99PrimitiveProof.primitive_completeness
#print FT1536.Source3.C99PrimitiveProof.primitive_completeness
#print axioms FT1536.Source3.C99PrimitiveProof.primitive_completeness
