import Source3.HelperMemoryTotal

namespace FT1536.Source3.HelperCalleesTotal

theorem add_total (s : StableBinaryCExec.State) (a b : BitVec 64) :
    ∃ z, StableBinaryCExec.binary "fpr_add".toList s a b=some (z,s) := by
  obtain ⟨z,hz⟩ := Option.isSome_iff_exists.mp (FprAddTotal.add_total a b)
  exact ⟨z,by rw [StableBinaryCalleeBridge.add_source_word_and_frame,hz]; rfl⟩
theorem mul_total (s : StableBinaryCExec.State) (a b : BitVec 64) :
    ∃ z, StableBinaryCExec.binary "fpr_mul".toList s a b=some (z,s) := by
  obtain ⟨z,hz⟩ := Option.isSome_iff_exists.mp (FprMulTotal.mul_total a b)
  exact ⟨z,by rw [StableBinaryCalleeBridge.mul_source_word_and_frame,hz]; rfl⟩
theorem div_total (s : StableBinaryCExec.State) (a b : BitVec 64) :
    ∃ z, StableBinaryCExec.binary "fpr_div".toList s a b=some (z,s) := by
  obtain ⟨z,hz⟩ := Option.isSome_iff_exists.mp (FprDivTotal.div_total a b)
  exact ⟨z,by rw [StableBinaryCalleeBridge.div_source_word_and_frame,hz]; rfl⟩
theorem half_total (s : StableBinaryCExec.State) (a : BitVec 64) :
    ∃ z, StableBinaryCExec.unary "fpr_half".toList s a=some (z,s) :=
  ⟨_,by rw [StableBinaryCalleeBridge.half_source_word_and_frame,StableBinaryInlineTotal.half_total]; rfl⟩
theorem double_total (s : StableBinaryCExec.State) (a : BitVec 64) :
    ∃ z, StableBinaryCExec.unary "fpr_double".toList s a=some (z,s) :=
  ⟨_,by rw [StableBinaryCalleeBridge.double_source_word_and_frame,StableBinaryInlineTotal.double_total]; rfl⟩

end FT1536.Source3.HelperCalleesTotal

#print axioms FT1536.Source3.HelperCalleesTotal.add_total
#print axioms FT1536.Source3.HelperCalleesTotal.div_total
