import Source3.GeneratedPublicTree170

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTreeRoots170
open GeneratedPublicTree170 (roots)
open KeygenPublicAlgebra (R)
open PublicTreeEvaluation170 (value)

def power (i : Nat) : Nat := 25^(2*KeygenMkgm3Indices.tableExponent i)%18433
def block (b : Nat) : Bool := (List.finRange 64).all (fun j => decide ((C99FiniteMap114.lookup roots.data (64*b+j.val)).getD 0=power (64*b+j.val)))

theorem block0 : block 0=true := by decide +kernel
theorem block1 : block 1=true := by decide +kernel
theorem block2 : block 2=true := by decide +kernel
theorem block3 : block 3=true := by decide +kernel
theorem block4 : block 4=true := by decide +kernel
theorem block5 : block 5=true := by decide +kernel
theorem block6 : block 6=true := by decide +kernel
theorem block7 : block 7=true := by decide +kernel
theorem block8 : block 8=true := by decide +kernel
theorem block9 : block 9=true := by decide +kernel
theorem block10 : block 10=true := by decide +kernel
theorem block11 : block 11=true := by decide +kernel
theorem block12 : block 12=true := by decide +kernel
theorem block13 : block 13=true := by decide +kernel
theorem block14 : block 14=true := by decide +kernel
theorem block15 : block 15=true := by decide +kernel

theorem blocks (b : Fin 16) : block b.val=true :=
  match b with
  | ⟨0,_⟩ => block0
  | ⟨1,_⟩ => block1
  | ⟨2,_⟩ => block2
  | ⟨3,_⟩ => block3
  | ⟨4,_⟩ => block4
  | ⟨5,_⟩ => block5
  | ⟨6,_⟩ => block6
  | ⟨7,_⟩ => block7
  | ⟨8,_⟩ => block8
  | ⟨9,_⟩ => block9
  | ⟨10,_⟩ => block10
  | ⟨11,_⟩ => block11
  | ⟨12,_⟩ => block12
  | ⟨13,_⟩ => block13
  | ⟨14,_⟩ => block14
  | ⟨15,_⟩ => block15
  | ⟨n+16,h⟩ => False.elim (by omega)

theorem natural (i : Nat) (inside : i<1024) : (C99FiniteMap114.lookup roots.data i).getD 0=power i := by
  have hb : i/64<16 := by omega
  have hj : i%64<64 := Nat.mod_lt _ (by decide)
  have checked := List.all_eq_true.mp (blocks ⟨i/64,hb⟩) ⟨i%64,hj⟩ (by simp)
  have addr : 64*(i/64)+i%64=i := by omega
  have equal := of_decide_eq_true checked
  simpa only [addr] using equal

theorem field (i : Nat) (inside : i<1024) : value roots i=KeygenPublicRoots.root^KeygenMkgm3Indices.tableExponent i := by
  unfold value
  rw [natural i inside]
  unfold power KeygenPublicRoots.root
  rw [← pow_mul,KeygenPublicRoots.generator_pow]

theorem first : value roots 1=KeygenPublicRoots.firstRoot := (field 1 (by decide)).trans (by rfl)
theorem unity : (value roots 1)^2=KeygenPublicRoots.unity := by rw [first]; rfl

end FT1536.Source3.PublicTreeRoots170
