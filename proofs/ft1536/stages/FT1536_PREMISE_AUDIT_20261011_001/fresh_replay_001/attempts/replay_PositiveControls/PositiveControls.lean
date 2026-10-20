import AllSource3

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.PremisePositive
open Source3

theorem canonical_witness : KeygenMakeInvocation.Canonical ⟨0,0,3072,2,0⟩ :=
  ⟨rfl,rfl,rfl,rfl⟩

theorem binary_layout_witness :
    StableBinary.Layout.wellFormed ⟨0,4096,8192,256⟩ 8 := by decide +kernel

theorem top_layout_witness : StableTopMemory.WellFormed ⟨0,8192,16384,24576⟩ := by
  constructor <;> norm_num [StableTopMemory.Separate]

theorem certificate_layout_witness : CertificateMemory.WellFormed ⟨0,8192,32768⟩ := by
  constructor <;> norm_num [StableTopMemory.Separate]

theorem helper_shape_witness (s : C99HelperReference.State) : C99HelperShape.Shape s s := ⟨rfl,rfl⟩

#print axioms canonical_witness
#print axioms binary_layout_witness
#print axioms top_layout_witness
#print axioms certificate_layout_witness
#print axioms helper_shape_witness
#print axioms C99HeaderProof.header_completeness
#print axioms C99PrimitiveProof.primitive_completeness
#print axioms CertificateFunctionSyntax.bound
#print axioms FprAllTotal.all_pinned_fpr_words_defined
#print axioms HelperAllTotal.all_legal_helpers_defined
#print axioms StableBinarySourceProof.byte_interpreter_refinement
end FT1536.PremisePositive
