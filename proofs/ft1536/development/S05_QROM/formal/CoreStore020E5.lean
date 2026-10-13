import CoreDataPatch020E5
import ControlStore020E5

namespace FT1536.S05.CoreStore020E5
open WordRAM020 CoreState020E5 CoreEncoding020E5 CoreFieldPatch020E5 VerifiedPatch020E5

/-- Actual emitted word stores. No successor Core/array is materialized by
    the code generator: the data part emits ≤3 words, the control part16. -/
def code {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) (q : Core cap capacity limit) :
    List (WordPatch020E5.Write (payloadWords cap capacity)) :=
  (CoreDataPatch020E5.program hc hf hl a i q).val.code ++
    ControlStore020E5.code hc hf hl (CoreControl020E5.next a i q)

theorem realizes {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) (q : Core cap capacity limit) :
    WordPatch020E5.apply (code hc hf hl a i q) (image hc hf hl q)=
      image hc hf hl (CoreStep020E5.step a i q) := by
  rw [code,append_apply,(CoreDataPatch020E5.program hc hf hl a i q).val.correct]
  rw [←ControlStore020E5.control_code hc hf hl (CoreData020E5.next a i q) (CoreControl020E5.next a i q)]
  rw [(CoreFieldPatch020E5.control hc hf hl (CoreData020E5.next a i q) (CoreControl020E5.next a i q)).correct]
  rw [CoreControl020E5.reconstruct]

theorem length_bound {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) (q : Core cap capacity limit) :
    (code hc hf hl a i q).length≤19 := by
  have h := (CoreDataPatch020E5.program hc hf hl a i q).property
  simp only [code,List.length_append,ControlStore020E5.length]
  omega

/-- This is a concrete filled store program, not a field asking for the
    missing allocation or refinement theorem. -/
def program {cap capacity limit : Nat} (hc : cap<2^511) (hf : capacity<2^511) (hl : limit<2^511)
    (a : ArrayArena020E4.Arena cap) (i : ArrayState020E4.Input) (q : Core cap capacity limit) :
    Program (image hc hf hl q) (image hc hf hl (CoreStep020E5.step a i q)) :=
  ⟨code hc hf hl a i q,realizes hc hf hl a i q⟩

end FT1536.S05.CoreStore020E5
