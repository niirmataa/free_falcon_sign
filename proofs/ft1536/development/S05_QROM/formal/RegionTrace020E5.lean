import RegionFrame020E5

namespace FT1536.S05.RegionTrace020E5
open RegionRam020E5

theorem append {a b c : Heap} {xs ys : List Heap} (h : Steps a xs b) (g : Steps b ys c) : Steps a (xs++ys) c := by
  induction h with
  | nil a => exact g
  | cons hab tail ih => exact .cons hab (ih g)

theorem peak {a b : Heap} {xs : List Heap} (h : Steps a xs b) : ∀ x∈a::xs,live x=live a := by
  intro x hx
  rcases List.mem_cons.mp hx with he|he
  · subst x;rfl
  · exact (steps_live h).2 x he

end FT1536.S05.RegionTrace020E5
