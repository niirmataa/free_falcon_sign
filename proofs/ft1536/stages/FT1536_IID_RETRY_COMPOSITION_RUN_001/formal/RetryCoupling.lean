import RetryProbability
namespace RetryIID
def checked {A : Type} (bad : Bool) (out : A) : Sum Unit A := if bad then .inl () else .inr out
theorem checked_good {A : Type} (out : A) : checked false out=Sum.inr out := by rfl
theorem checked_bad {A : Type} (out : A) : checked true out=Sum.inl () := by rfl
theorem equal_iff_good {A : Type} (bad : Bool) (out : A) : checked bad out=Sum.inr out ↔ bad=false := by cases bad <;> simp [checked]
theorem preservation_before_norm (a b : Fin 1536→Int) (h : Postprocess.Safe16 a b) :
    (fun i=>Postprocess.narrow16 (a i))=a ∧ (fun i=>Postprocess.narrow16 (b i))=b := by
  constructor
  · funext i;exact (Postprocess.narrow_preserves_iff (a i)).mpr (h i).1
  · funext i;exact (Postprocess.narrow_preserves_iff (b i)).mpr (h i).2
theorem stored_wide_norm_agrees (a b : Fin 1536→Int) (h : Postprocess.Safe16 a b) :
    FT1536Bridge.isShort (fun i=>Postprocess.narrow16 (a i)) (fun i=>Postprocess.narrow16 (b i))=FT1536Bridge.isShort a b := by
  obtain ⟨h1,h2⟩:=preservation_before_norm a b h
  rw [h1,h2]
theorem public_map_preserves_agreement {A B : Type} (observe : A→B) (x y : A) (h : x=y) : observe x=observe y := by rw [h]
end RetryIID
