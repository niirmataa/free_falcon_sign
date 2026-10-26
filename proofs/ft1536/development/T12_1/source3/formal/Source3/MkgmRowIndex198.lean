import Source3.MkgmParams198

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmRowIndex198
open C99ArrayReference (State scalar Pointer)
open C99MemoryReference (ArrayPointer Allocated)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open MkgmParams198

theorem shifted (l : Level) (u : Nat) (bound : u<2^64) :
    C99IntegerReference.ShiftExec .left (u64 u) (.uint32 (shiftWord l)) (u64 (scale l*u)) := by
  have raw := C99IntegerReference.ShiftExec.unsignedLeft (u64 u) (.uint32 (shiftWord l)) (shift l)
    rfl (shift_integer l) (by have h:=shift_range l; change shift l<64; omega)
  change C99IntegerReference.ShiftExec .left (u64 u) (.uint32 (shiftWord l))
    (C99IntegerReference.convert .uint64 ((u64 u).integer*2^shift l)) at raw
  rw [KeygenNttLoopSupport.u64_integer u bound] at raw
  have product : (u:Int)*2^shift l=((scale l*u:Nat):Int) := by
    simp only [scale,Nat.cast_mul,Nat.cast_pow,Nat.cast_ofNat]
    exact mul_comm _ _
  rw [product,KeygenNttLoopSupport.convert_u64_nat] at raw
  exact raw

theorem first (l : Level) (s : State) (u : Nat) (bound : u<half l)
    (counter : USlot s "u" u) (k : Slot s "k" (shiftWord l)) :
    scalar s KeygenMkgm3Program.revIndex (u64 (scale l*u)) :=
  .shift .left _ _ _ _ _ (.variable _ _ _ counter) (.variable _ _ _ k)
    (shifted l u (by have h:=half_range l; omega))

theorem next (l : Level) (s : State) (u : Nat) (bound : u+1<half l)
    (counter : USlot s "u" u) (k : Slot s "k" (shiftWord l)) :
    scalar s KeygenMkgm3Program.revIndexNext (u64 (scale l*(u+1))) :=
  .shift .left _ _ _ _ _
    (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ counter) (.literal .int32 1)
      (C99NatWord141.add_one u (by have h:=half_range l; omega)))
    (.variable _ _ _ k) (shifted l (u+1) (by have h:=half_range l; omega))

theorem reverse_word (l : Level) (u : Nat) (bound : u<half l) :
    (BitVec.ofNat 16 (reverse l u)).toNat=reverse l u :=
  Nat.mod_eq_of_lt (by have a:=reverse_range l u bound; have b:=half_range l; omega)

theorem destination_index (l : Level) (u : Nat) (bound : u<half l) :
    ((u64 (half l)).integer.toNat+
      (C99NarrowReads.unsignedPromotion (BitVec.ofNat 16 (reverse l u))).integer.toNat)%2^64=lastIndex l u := by
  have size:=half_range l
  rw [KeygenNttLoopSupport.u64_toNat (half l) (by omega),C99NarrowReads.unsigned_promotion_exact]
  simp only [Int.toNat_natCast,reverse_word l u bound]
  exact Nat.mod_eq_of_lt (by have h:=last_range l u bound; unfold count lastIndex at h; omega)

theorem rev_read (l : Level) (s : State) (rev : ArrayPointer) (u : Nat) (bound : u<half l)
    (table : KeygenMkgm3RevMemory.Rev s rev) :
    C99NarrowReads.Load16 s.heap (element rev (scale l*u)) (BitVec.ofNat 16 (reverse l u)) := by
  have read := table.2.2 (factor l*u) (table_range l u bound)
  have equal : 2*(factor l*u)=scale l*u := by rw [scale_factor,Nat.mul_assoc]
  simpa only [equal,reverse] using read

theorem rev_pointer (l : Level) (s : State) (rev : ArrayPointer) (index : CLogic.Expr)
    (u : Nat) (bound : u<half l) (table : KeygenMkgm3RevMemory.Rev s rev)
    (value : scalar s index (u64 (scale l*u))) : Pointer s "REV10".toList index (element rev (scale l*u)) := by
  have size:=shift_index_range l u bound
  have capacity : rev.index+scale l*u≤rev.count :=
    Nat.le_of_lt (GeneratorRowIndex179.read_allocated _ _ _ (rev_read l s rev u bound table)).2.2.1
  refine .add _ _ rev _ (u64 (scale l*u)) table.1 value ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer (scale l*u) (by omega)]; omega
  · rw [KeygenNttLoopSupport.u64_toNat (scale l*u) (by omega)]
    exact .within rev (scale l*u) capacity

theorem destination (l : Level) (s : State) (name : String) (dst : ArrayPointer) (u : Nat)
    (bound : u<half l) (binding : s.arrays name.toList=some dst)
    (allocated : Allocated s.heap (element dst (lastIndex l u))) :
    Pointer s name.toList (.literal .u64 (lastIndex l u)) (element dst (lastIndex l u)) := by
  have range := last_range l u bound
  have size := half_range l
  have wide : lastIndex l u<2^64 := by unfold count at range; omega
  refine .add _ _ dst _ (u64 (lastIndex l u)) binding (.literal .uint64 (lastIndex l u)) ?_ ?_
  · rw [KeygenNttLoopSupport.u64_integer (lastIndex l u) wide]; omega
  · rw [KeygenNttLoopSupport.u64_toNat (lastIndex l u) wide]
    exact .within dst (lastIndex l u) (Nat.le_of_lt allocated.2.2.1)

end FT1536.Source3.MkgmRowIndex198
