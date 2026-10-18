import Source3.NttFirstFixed182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttFirstControl182
open C99ArrayReference (State bindPointer)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenSmallOutput (element)
open KeygenNttLoopSupport (USlot u64)
open NttFirstFixed182 (Fixed)
open GeneratorRowControl179 (put)

def withU (s : State) (i : Nat) := put s (i+1)
def withFirst (s : State) (a : ArrayPointer) (i : Nat) := bindPointer (withU s i) "r1".toList (element a (i+1))
def after (s : State) (a : ArrayPointer) (i : Nat) := bindPointer (withFirst s a i) "r2".toList (element a (768+i+1))

theorem address (s : State) (name : String) (a : ArrayPointer) (i : Nat)
    (binding : s.arrays name.toList=some (element a i)) (stride : USlot s "stride" 1)
    (capacity : a.index+i+1≤a.count) :
    C99ArrayReference.Pointer s name.toList (.var "stride".toList) (element a (i+1)) := by
  refine .add _ _ (element a i) _ (.uint64 1) binding (.variable _ _ _ stride) (by decide) ?_
  change C99MemoryReference.PointerAdd (element a i) 1 (element a (i+1))
  simpa only [element,Nat.add_assoc] using C99MemoryReference.PointerAdd.within (element a i) 1 capacity

theorem source (s : State) (a : ArrayPointer) (i : Nat) (bound : i < 768)
    (counter : USlot s "u" i) (stride : USlot s "stride" 1) (capacity : a.index+1536≤a.count)
    (first : s.arrays "r1".toList=some (element a i)) (second : s.arrays "r2".toList=some (element a (768+i))) :
    Exec (KeygenNttForwardPrograms.step "u") s ⟨after s a i,.normal⟩ := by
  have base := C99LoopScalar141.increment (fun _ => none) s "u".toList i (by omega) counter
  rw [FftLocalCells140.put_bind] at base
  have increment : Exec (KeygenNttForwardPrograms.update "u" .add (KeygenNttForwardPrograms.num 1)) s ⟨withU s i,.normal⟩ := by
    cases base with
    | base _ _ _ run => exact .base _ _ _ run
  have r1 : Exec (KeygenNttForwardPrograms.bind "r1" "r1" (.var "stride".toList)) (withU s i) ⟨withFirst s a i,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _ (address (withU s i) "r1" a i first stride (by omega)))
  have r2 : Exec (KeygenNttForwardPrograms.bind "r2" "r2" (.var "stride".toList)) (withFirst s a i) ⟨after s a i,.normal⟩ :=
    .base _ _ _ (.bindPtr _ _ _ _ _ (address (withFirst s a i) "r2" a (768+i) second stride (by omega)))
  exact .seqNormal _ _ s (withU s i) _ increment (.seqNormal _ _ (withU s i) (withFirst s a i) _ r1 r2)

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (i : Nat) (h : Fixed s a gm p p0i w) :
    Fixed (after s a i) a gm p p0i w :=
  ⟨h.pCell,h.iCell,h.wCell,h.nCell,h.hnCell,h.stride,h.aBinding,h.gmBinding,h.width,h.capacity,h.allocated,h.writable,h.initialized⟩

theorem counter (s : State) (a : ArrayPointer) (i : Nat) (bound : i < 768) : USlot (after s a i) "u" (i+1) :=
  GeneratorRowControl179.cell s (i+1) (by omega)

theorem first_pointer (s : State) (a : ArrayPointer) (i : Nat) :
    (after s a i).arrays "r1".toList=some (element a (i+1)) := rfl

theorem second_pointer (s : State) (a : ArrayPointer) (i : Nat) :
    (after s a i).arrays "r2".toList=some (element a (768+(i+1))) := by
  change some (element a (768+i+1))=some (element a (768+(i+1)))
  rw [Nat.add_assoc]

end FT1536.Source3.NttFirstControl182
