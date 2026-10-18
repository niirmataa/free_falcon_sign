import Source3.NttMBody183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttMControl183
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open NttFirstFixed182 (Fixed)

theorem compare (t : Nat) (bound : t<2^64) :
    C99IntegerReference.CompareExec .gt (u64 t) (.uint32 3)
      (C99ScalarReference.boolean (decide (3<t))) := by
  have raw := C99IntegerReference.CompareExec.step .gt (u64 t) (.uint32 3) .uint64 rfl
    (u64 t) (u64 3) (C99CountedWords.convert_self _).symm rfl
  change C99IntegerReference.CompareExec .gt (u64 t) (.uint32 3)
    (C99ScalarReference.boolean (C99IntegerReference.compare .gt (u64 t).integer (u64 3).integer)) at raw
  rw [KeygenNttLoopSupport.u64_integer t bound,KeygenNttLoopSupport.u64_integer 3 (by decide)] at raw
  have same : C99IntegerReference.compare .gt (t:Int) ((3:Nat):Int)=decide (3<t) := by simp [C99IntegerReference.compare]
  rw [same] at raw
  exact raw

theorem guard (s : State) (t : Nat) (bound : t<2^64) (tc : USlot s "t" t) (full : Slot s "full" 1) :
    C99ArrayReference.scalar s KeygenNttForwardPrograms.mGuard (C99ScalarReference.boolean (decide (3<t))) := by
  have shift : C99ArrayReference.scalar s (.bin .shl (.var "full".toList) (.literal .i32 1)) (.uint32 2) :=
    .shift .left _ _ _ _ _ (.variable _ _ _ full) (.literal .int32 1)
      (.unsignedLeft (.uint32 1) (.int32 1) 1 rfl rfl (by decide))
  have rhs : C99ArrayReference.scalar s (.bin .add (.literal .i32 1) (.bin .shl (.var "full".toList) (.literal .i32 1))) (.uint32 3) :=
    .arithmetic .plus _ _ _ _ _ (.literal .int32 1) shift
      (.step .plus (.int32 1) (.uint32 2) .uint32 rfl (.uint32 1) (.uint32 2) rfl rfl
        (by intro impossible; cases impossible))
  exact .compare .gt _ _ _ _ _ (.variable _ _ _ tc) rhs (compare t bound)

def after (s : State) (m : Nat) := bindValue s "m".toList .uint64 (u64 (2*m))

theorem advance (s : State) (m : Nat) (bound : m≤512) (mc : USlot s "m" m) :
    Exec KeygenNttForwardPrograms.mStep s ⟨after s m,.normal⟩ :=
  .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 m)) (u64 (2*m)) mc
    (.shift .left _ _ _ _ _ (.variable _ _ _ mc) (.literal .int32 1)
      (PublicGenerateIndex159.shl_one m (by omega) _ rfl))))

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (m : Nat) (h : Fixed s a gm p p0i w) :
    Fixed (after s m) a gm p p0i w :=
  ⟨h.pCell,h.iCell,h.wCell,h.nCell,h.hnCell,h.stride,h.aBinding,h.gmBinding,h.width,h.capacity,h.allocated,h.writable,h.initialized⟩

theorem counter (s : State) (m : Nat) (bound : m≤512) : USlot (after s m) "m" (2*m) :=
  KeygenMkgm3RowInit.set64_slot s "m" (2*m) (by omega)

def withT (s : State) := bindValue s "t".toList .uint64 (u64 768)
def initial (s : State) := bindValue (withT s) "m".toList .uint64 (u64 2)

theorem t_init (s : State) (old : Option Value) (declared : s.locals "t".toList=some (.uint64,old))
    (hc : USlot s "hn" 768) : Exec KeygenNttForwardPrograms.tFromHalf s ⟨withT s,.normal⟩ :=
  .assign _ _ _ .uint64 old (u64 768) declared (.scalar _ _ (.variable _ _ _ hc))

theorem m_init (s : State) (old : Option Value) (declared : s.locals "m".toList=some (.uint64,old)) :
    Exec KeygenNttForwardPrograms.mInit (withT s) ⟨initial s,.normal⟩ :=
  .assign _ _ _ .uint64 old (.int32 2) declared (.scalar _ _ (.literal .int32 2))

theorem initial_fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (h : Fixed s a gm p p0i w) :
    Fixed (initial s) a gm p p0i w :=
  ⟨h.pCell,h.iCell,h.wCell,h.nCell,h.hnCell,h.stride,h.aBinding,h.gmBinding,h.width,h.capacity,h.allocated,h.writable,h.initialized⟩

end FT1536.Source3.NttMControl183
