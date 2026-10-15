import Mathlib.Tactic

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.FiniteWordVector153

def checkChunk {n : Nat} (actual expected : Fin n → BitVec 64) (start count : Nat) : Bool :=
  (List.range count).all (fun offset => if inside : start+offset<n then
    decide (actual ⟨start+offset,inside⟩=expected ⟨start+offset,inside⟩) else false)

theorem chunk_sound {n : Nat} (actual expected : Fin n → BitVec 64) (start count : Nat)
    (checked : checkChunk actual expected start count=true) (i : Fin n)
    (lower : start ≤ i.val) (upper : i.val < start+count) : actual i=expected i := by
  have member : i.val-start∈List.range count := List.mem_range.mpr (by omega)
  have found := List.all_eq_true.mp checked (i.val-start) member
  have position : start+(i.val-start)=i.val := by omega
  simp only [position,dite_eq_left i.isLt] at found
  exact of_decide_eq_true found

/-- Disjoint fixed-width kernel checks imply equality of the entire vector. -/
theorem complete {n : Nat} (actual expected : Fin n → BitVec 64) (width blocks : Nat)
    (positive : 0<width) (coverage : n≤blocks*width)
    (checked : ∀ block : Fin blocks, checkChunk actual expected (width*block.val) width=true) : actual=expected := by
  funext i
  have bound : i.val/width<blocks := (Nat.div_lt_iff_lt_mul positive).mpr (lt_of_lt_of_le i.isLt coverage)
  let block : Fin blocks := ⟨i.val/width,bound⟩
  have decomposition := Nat.mod_add_div i.val width
  have remainder := Nat.mod_lt i.val positive
  apply chunk_sound actual expected (width*block.val) width (checked block) i
  · change width*(i.val/width) ≤ i.val
    omega
  · change i.val<width*(i.val/width)+width
    omega

end FT1536.Source3.FiniteWordVector153
