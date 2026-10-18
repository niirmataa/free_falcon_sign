import Source3.Gen0RowFixed189

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.Gen0RowIndex189
open C99ArrayReference (State scalar Pointer)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)

def reverse8 (u : Nat) := KeygenMkgm3Indices.reverse9 (2*u)
def lastIndex (u : Nat) := 256+reverse8 u

theorem reverse_bound (u : Nat) (bound : u<256) : reverse8 u<256 := by
  have all : ∀ i : Fin 256, reverse8 i.val<256 := by decide
  exact all ⟨u,bound⟩

theorem half_range (u : Nat) (bound : u<256) : 256≤lastIndex u ∧ lastIndex u<512 := by
  have h := reverse_bound u bound
  unfold lastIndex
  omega

theorem last_range (u : Nat) (bound : u<256) : 256≤lastIndex u ∧ lastIndex u<1024 :=
  ⟨(half_range u bound).1,Nat.lt_trans (half_range u bound).2 (by decide)⟩

theorem shl_two (u : Nat) (bound : u<2^64) : C99IntegerReference.ShiftExec .left (u64 u) (.uint32 2) (u64 (4*u)) := by
  have raw := C99IntegerReference.ShiftExec.unsignedLeft (u64 u) (.uint32 2) 2 rfl rfl (by change (2:Nat)<64; decide)
  change C99IntegerReference.ShiftExec .left (u64 u) (.uint32 2)
    (C99IntegerReference.convert .uint64 ((u64 u).integer*4)) at raw
  rw [KeygenNttLoopSupport.u64_integer u bound] at raw
  have product : (u:Int)*4=((4*u:Nat):Int) := by omega
  rw [product,KeygenNttLoopSupport.convert_u64_nat] at raw
  exact raw

theorem first (s : State) (u : Nat) (bound : u<256) (counter : USlot s "u" u) (k : Slot s "k" 2) :
    scalar s KeygenMkgm3Program.revIndex (u64 (4*u)) :=
  .shift .left _ _ _ _ _ (.variable _ _ _ counter) (.variable _ _ _ k) (shl_two u (by omega))

theorem next (s : State) (u : Nat) (bound : u+1<256) (counter : USlot s "u" u) (k : Slot s "k" 2) :
    scalar s KeygenMkgm3Program.revIndexNext (u64 (4*(u+1))) :=
  .shift .left _ _ _ _ _
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ counter) (.literal .int32 1) (C99NatWord141.add_one u (by omega)))
    (.variable _ _ _ k) (shl_two (u+1) (by omega))

theorem reverse_word (u : Nat) (bound : u<256) : (BitVec.ofNat 16 (reverse8 u)).toNat=reverse8 u :=
  Nat.mod_eq_of_lt (by have h:=reverse_bound u bound; omega)

theorem destination_index (u : Nat) (bound : u<256) :
    ((u64 256).integer.toNat+(C99NarrowReads.unsignedPromotion (BitVec.ofNat 16 (reverse8 u))).integer.toNat)%2^64=lastIndex u := by
  rw [KeygenNttLoopSupport.u64_toNat 256 (by decide),C99NarrowReads.unsigned_promotion_exact]
  simp only [Int.toNat_natCast,reverse_word u bound]
  exact Nat.mod_eq_of_lt (by have h:=reverse_bound u bound; omega)

theorem rev_read (s : State) (rev : ArrayPointer) (u : Nat) (bound : u<256) (table : KeygenMkgm3RevMemory.Rev s rev) :
    C99NarrowReads.Load16 s.heap (element rev (4*u)) (BitVec.ofNat 16 (reverse8 u)) := by
  have read := table.2.2 (2*u) (by omega)
  have equal : 2*(2*u)=4*u := by omega
  simpa only [equal,reverse8] using read

theorem rev_pointer (s : State) (rev : ArrayPointer) (index : CLogic.Expr) (u : Nat) (bound : u<256)
    (table : KeygenMkgm3RevMemory.Rev s rev) (value : scalar s index (u64 (4*u))) :
    Pointer s "REV10".toList index (element rev (4*u)) := by
  have capacity : rev.index+4*u≤rev.count := Nat.le_of_lt (GeneratorRowIndex179.read_allocated _ _ _ (rev_read s rev u bound table)).2.2.1
  refine .add _ _ rev _ (u64 (4*u)) table.1 value ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer (4*u) (by omega)]; omega
  · rw [KeygenNttLoopSupport.u64_toNat (4*u) (by omega)]
    exact .within rev (4*u) capacity

theorem destination (s : State) (name : String) (dst : ArrayPointer) (u : Nat) (bound : u<256)
    (binding : s.arrays name.toList=some dst) (allocated : Allocated s.heap (element dst (lastIndex u))) :
    Pointer s name.toList (.literal .u64 (lastIndex u)) (element dst (lastIndex u)) := by
  have range := (last_range u bound).2
  refine .add _ _ dst _ (u64 (lastIndex u)) binding (.literal .uint64 (lastIndex u)) ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer (lastIndex u) (by omega)]; omega
  · rw [KeygenNttLoopSupport.u64_toNat (lastIndex u) (by omega)]
    exact .within dst (lastIndex u) (Nat.le_of_lt allocated.2.2.1)

end FT1536.Source3.Gen0RowIndex189
