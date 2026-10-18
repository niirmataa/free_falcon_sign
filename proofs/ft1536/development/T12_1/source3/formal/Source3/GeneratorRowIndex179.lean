import Source3.GeneratorRowFixed179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorRowIndex179
open C99ArrayReference (State scalar Pointer)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open KeygenMkgm3Indices (reverse9 lastIndex)

theorem first (s : State) (u : Nat) (bound : u<512) (counter : USlot s "u" u) (k : Slot s "k" 1) :
    scalar s KeygenMkgm3Program.revIndex (u64 (2*u)) :=
  .shift .left _ _ _ _ _ (.variable _ _ _ counter) (.variable _ _ _ k)
    (PublicGenerateIndex159.shl_one u (by omega) (.uint32 1) rfl)

theorem next (s : State) (u : Nat) (bound : u+1<512) (counter : USlot s "u" u) (k : Slot s "k" 1) :
    scalar s KeygenMkgm3Program.revIndexNext (u64 (2*(u+1))) :=
  .shift .left _ _ _ _ _
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ counter) (.literal .int32 1) (C99NatWord141.add_one u (by omega)))
    (.variable _ _ _ k) (PublicGenerateIndex159.shl_one (u+1) (by omega) (.uint32 1) rfl)

theorem reverse_bound (u : Nat) (bound : u<512) : reverse9 u<512 :=
  ((KeygenMkgm3IndexCert.all_indices u (by omega)).1 bound).1

theorem reverse_word (u : Nat) (bound : u<512) : (BitVec.ofNat 16 (reverse9 u)).toNat=reverse9 u :=
  Nat.mod_eq_of_lt (by have h:=reverse_bound u bound; omega)

theorem destination_index (u : Nat) (bound : u<512) :
    ((u64 512).integer.toNat+(C99NarrowReads.unsignedPromotion (BitVec.ofNat 16 (reverse9 u))).integer.toNat)%2^64=lastIndex u := by
  rw [KeygenNttLoopSupport.u64_toNat 512 (by decide),C99NarrowReads.unsigned_promotion_exact]
  simp only [Int.toNat_natCast,reverse_word u bound]
  exact Nat.mod_eq_of_lt (by have h:=reverse_bound u bound; omega)

theorem read_allocated (heap : C99MemoryReference.Memory) (pointer : ArrayPointer) (word : BitVec 16)
    (read : C99NarrowReads.Load16 heap pointer word) : Allocated heap pointer := by
  cases read with
  | load _ allocated _ _ => exact allocated

theorem rev_pointer (s : State) (rev : ArrayPointer) (index : CLogic.Expr) (u : Nat) (bound : u<512)
    (table : KeygenMkgm3RevMemory.Rev s rev) (value : scalar s index (u64 (2*u))) :
    Pointer s "REV10".toList index (element rev (2*u)) := by
  have capacity : rev.index+2*u≤rev.count := by
    have allocated := read_allocated _ _ _ (table.2.2 u bound)
    exact Nat.le_of_lt allocated.2.2.1
  refine .add _ _ rev _ (u64 (2*u)) table.1 value ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer (2*u) (by omega)]; omega
  · rw [KeygenNttLoopSupport.u64_toNat (2*u) (by omega)]
    exact .within rev (2*u) capacity

theorem destination (s : State) (name : String) (dst : ArrayPointer) (u : Nat) (bound : u<512)
    (binding : s.arrays name.toList=some dst) (allocated : Allocated s.heap (element dst (lastIndex u))) :
    Pointer s name.toList (.literal .u64 (lastIndex u)) (element dst (lastIndex u)) := by
  have range := (KeygenMkgm3Table.last_range u bound).2
  refine .add _ _ dst _ (u64 (lastIndex u)) binding (.literal .uint64 (lastIndex u)) ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer (lastIndex u) (by omega)]; omega
  · rw [KeygenNttLoopSupport.u64_toNat (lastIndex u) (by omega)]
    exact .within dst (lastIndex u) (Nat.le_of_lt allocated.2.2.1)

end FT1536.Source3.GeneratorRowIndex179
