import ProducerReferenceData020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerSlotExt020E8
open ArrayBank020E4 ProducerReferenceSlots020E8 ProducerReferenceData020E8

theorem slots {A : Type} (a b : Bank A 96)
    (hd : ∀ j : Fin 3,∀ f : Fin 3,read a (finProdFinEquiv (dataSlot j,f))=read b (finProdFinEquiv (dataSlot j,f)))
    (hc : ∀ j : Fin 16,∀ f : Fin 3,read a (finProdFinEquiv (controlSlot j,f))=read b (finProdFinEquiv (controlSlot j,f)))
    (hp : ∀ j : Fin 13,∀ f : Fin 3,read a (finProdFinEquiv (paddingSlot j,f))=read b (finProdFinEquiv (paddingSlot j,f))) : a=b := by
  apply ArrayBank020E4.ext
  funext j
  obtain ⟨⟨s,f⟩,hs⟩ := (finProdFinEquiv : Fin 32 × Fin 3 ≃ Fin 96).surjective j
  rw [←hs]
  by_cases h0 : s.val<3
  · have he : s=dataSlot ⟨s.val,h0⟩ := Fin.ext (by rfl)
    rw [he]
    exact hd _ f
  · by_cases h1 : s.val<19
    · let k : Fin 16 := ⟨s.val-3,by omega⟩
      have he : s=controlSlot k := by apply Fin.ext;change s.val=3+(s.val-3);omega
      rw [he]
      exact hc k f
    · let k : Fin 13 := ⟨s.val-19,by have := s.isLt;omega⟩
      have he : s=paddingSlot k := by apply Fin.ext;change s.val=3+(16+(s.val-19));omega
      rw [he]
      exact hp k f

end FT1536.S05.ProducerSlotExt020E8
