import Source3.NttBinaryFrame183
import Source3.NttFirstControl182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttVControl183
open C99ArrayReference (State bindPointer bindValue)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open NttFirstFixed182 (Fixed)

def put (s : State) (i : Nat) := bindValue s "v".toList .uint64 (u64 i)
def withFirst (s : State) (a : ArrayPointer) (l i : Nat) := bindPointer (put s (i+1)) "r1".toList (element a (l+1))
def after (s : State) (a : ArrayPointer) (l r i : Nat) := bindPointer (withFirst s a l i) "r2".toList (element a (r+1))

theorem source (s : State) (a : ArrayPointer) (l r i : Nat) (ib : i<1536) (lb : l<1536) (rb : r<1536)
    (counter : USlot s "v" i) (stride : USlot s "stride" 1) (capacity : a.index+1536≤a.count)
    (first : s.arrays "r1".toList=some (element a l)) (second : s.arrays "r2".toList=some (element a r)) :
    Exec (KeygenNttForwardPrograms.step "v") s ⟨after s a l r i,.normal⟩ := by
  have base := C99LoopScalar141.increment (fun _ => none) s "v".toList i (by omega) counter
  rw [FftLocalCells140.put_bind] at base
  have inc : Exec (KeygenNttForwardPrograms.update "v" .add (KeygenNttForwardPrograms.num 1)) s ⟨put s (i+1),.normal⟩ := by
    cases base with
    | base _ _ _ run => exact .base _ _ _ run
  have r1 : Exec (KeygenNttForwardPrograms.bind "r1" "r1" (.var "stride".toList)) (put s (i+1)) ⟨withFirst s a l i,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _ (NttFirstControl182.address (put s (i+1)) "r1" a l first stride (by omega)))
  have r2 : Exec (KeygenNttForwardPrograms.bind "r2" "r2" (.var "stride".toList)) (withFirst s a l i) ⟨after s a l r i,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _ (NttFirstControl182.address (withFirst s a l i) "r2" a r second stride (by omega)))
  exact .seqNormal _ _ s (put s (i+1)) _ inc (.seqNormal _ _ (put s (i+1)) (withFirst s a l i) _ r1 r2)

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (l r i : Nat) (h : Fixed s a gm p p0i w) :
    Fixed (after s a l r i) a gm p p0i w :=
  ⟨h.pCell,h.iCell,h.wCell,h.nCell,h.hnCell,h.stride,h.aBinding,h.gmBinding,h.width,h.capacity,h.allocated,h.writable,h.initialized⟩

theorem counter (s : State) (a : ArrayPointer) (l r i : Nat) (bound : i<1536) : USlot (after s a l r i) "v" (i+1) :=
  KeygenMkgm3RowInit.set64_slot s "v" (i+1) (by omega)

theorem first_pointer (s : State) (a : ArrayPointer) (l r i : Nat) :
    (after s a l r i).arrays "r1".toList=some (element a (l+1)) := rfl

theorem second_pointer (s : State) (a : ArrayPointer) (l r i : Nat) :
    (after s a l r i).arrays "r2".toList=some (element a (r+1)) := rfl

theorem initial (s : State) (old : Option C99IntegerReference.Value)
    (declared : s.locals "v".toList=some (.uint64,old)) :
    Exec KeygenNttForwardPrograms.vInit s ⟨put s 0,.normal⟩ :=
  .assign _ _ _ .uint64 old (.int32 0) declared (.scalar _ _ (.literal .int32 0))

theorem initial_fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (h : Fixed s a gm p p0i w) :
    Fixed (put s 0) a gm p p0i w :=
  ⟨h.pCell,h.iCell,h.wCell,h.nCell,h.hnCell,h.stride,h.aBinding,h.gmBinding,h.width,h.capacity,h.allocated,h.writable,h.initialized⟩

end FT1536.Source3.NttVControl183
