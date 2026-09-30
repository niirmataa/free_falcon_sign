import Source3.KeygenSmallOutput
import Source3.KeygenIntegerLift

/- Bind the successful conversion's actual bytes to the existing paired
   coefficient representation. This is not yet a statement about sk/pk. -/
namespace FT1536.Source3.KeygenMaterial
open C99MemoryReference KeygenSmallOutput FT1536.Geometry KeygenIntegerLift

def Represents (h : Memory) (dst : ArrayPointer) (v : Vec) : Prop := ∀ i : Fin 768,
  Stored h (element dst i.val) (BitVec.ofInt 16 (v i).1) ∧
  Stored h (element dst (i.val+768)) (BitVec.ofInt 16 (v i).2)

theorem converted_material (dst src : ArrayPointer) (before after : Memory)
    (source : Loop dst src 0 before after true) (hd : dst.elementBytes=2) :
    ∃ v : Vec, Represents after dst v ∧ Bound v 2047 := by
  classical
  have hw := output_range dst src before after source hd
  choose z hz using hw
  let v : Vec := fun i => (z ⟨i.val,by have := i.isLt; omega⟩,
                          z ⟨i.val+768,by have := i.isLt; omega⟩)
  refine ⟨v,?_,?_⟩
  · intro i
    exact ⟨(hz ⟨i.val,by have := i.isLt; omega⟩).2.2.1,
      (hz ⟨i.val+768,by have := i.isLt; omega⟩).2.2.1⟩
  · intro i
    have h0 := hz ⟨i.val,by have := i.isLt; omega⟩
    have h1 := hz ⟨i.val+768,by have := i.isLt; omega⟩
    exact ⟨abs_le.mpr ⟨h0.1,h0.2.1⟩,abs_le.mpr ⟨h1.1,h1.2.1⟩⟩

end FT1536.Source3.KeygenMaterial
