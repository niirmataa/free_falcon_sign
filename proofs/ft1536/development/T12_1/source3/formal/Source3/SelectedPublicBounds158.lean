import Source3.SelectedPublicConvert158
import Source3.KeygenPublicRangeMemory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.SelectedPublicBounds158
open SelectedSamplerWords158 (fValues gValues)
open SelectedPublicConvert158 (after tValues hValues)
open SelectedPublicStart157 (t)
open SelectedPublicBinding157 (h)

def check (values : Fin 1536 → BitVec 16) : Bool :=
  (List.finRange 1536).all (fun i => decide (values i=0 ∨ values i=1 ∨ values i=65535))

theorem sound (values : Fin 1536 → BitVec 16) (checked : check values=true) (i : Fin 1536) :
    values i=0 ∨ values i=1 ∨ values i=65535 :=
  of_decide_eq_true (List.all_eq_true.mp checked i (by simp))

theorem f_checked : check fValues=true := by decide +kernel
theorem g_checked : check gValues=true := by decide +kernel

theorem converted_range (word : BitVec 16) (small : word=0 ∨ word=1 ∨ word=65535) :
    (PublicConvertBody158.converted word).toNat<18433 := by
  rcases small with rfl|rfl|rfl <;> decide +kernel

theorem t_range (i : Fin 1536) : (tValues i).toNat<18433 := converted_range (fValues i) (sound fValues f_checked i)
theorem h_range (i : Fin 1536) : (hValues i).toNat<18433 := converted_range (gValues i) (sound gValues g_checked i)

theorem t_image : KeygenPublicRangeMemory.Image after.heap t 1536 := fun i inside =>
  ⟨tValues ⟨i,inside⟩,SelectedPublicConvert158.t_image ⟨i,inside⟩,t_range ⟨i,inside⟩⟩
theorem h_image : KeygenPublicRangeMemory.Image after.heap h 1536 := fun i inside =>
  ⟨hValues ⟨i,inside⟩,SelectedPublicConvert158.h_image ⟨i,inside⟩,h_range ⟨i,inside⟩⟩

end FT1536.Source3.SelectedPublicBounds158
