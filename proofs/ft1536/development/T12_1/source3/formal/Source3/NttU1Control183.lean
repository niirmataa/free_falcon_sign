import Source3.NttU1Body183

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttU1Control183
open C99ArrayReference (State bindValue)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)
open NttFirstFixed182 (Fixed)

def withU (s : State) (j : Nat) := bindValue s "u1".toList .uint64 (u64 (j+1))
def after (s : State) (j l t : Nat) := bindValue (withU s j) "v1".toList .uint64 (u64 (l+t))

theorem source (s : State) (j l t : Nat) (jb : j<1024) (lb : l≤1536) (tb : t≤768)
    (jc : USlot s "u1" j) (lc : USlot s "v1" l) (tc : USlot s "t" t) :
    Exec KeygenNttForwardPrograms.u1Step s ⟨after s j l t,.normal⟩ := by
  have base := C99LoopScalar141.increment (fun _ => none) s "u1".toList j (by omega) jc
  rw [FftLocalCells140.put_bind] at base
  have inc : Exec (KeygenNttForwardPrograms.update "u1" .add (KeygenNttForwardPrograms.num 1)) s ⟨withU s j,.normal⟩ := by
    cases base with
    | base _ _ _ run => exact .base _ _ _ run
  have advance : Exec (KeygenNttForwardPrograms.update "v1" .add (KeygenNttForwardPrograms.var "t"))
      (withU s j) ⟨after s j l t,.normal⟩ :=
    .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 l)) (u64 (l+t)) lc
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ lc) (.variable _ _ _ tc) (C99NatWord141.add l t (by omega) (by omega)))))
  exact .seqNormal _ _ s (withU s j) _ inc advance

theorem fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (j l t : Nat) (h : Fixed s a gm p p0i w) :
    Fixed (after s j l t) a gm p p0i w :=
  ⟨h.pCell,h.iCell,h.wCell,h.nCell,h.hnCell,h.stride,h.aBinding,h.gmBinding,h.width,h.capacity,h.allocated,h.writable,h.initialized⟩

theorem counter (s : State) (j l t : Nat) (bound : j<1024) : USlot (after s j l t) "u1" (j+1) :=
  KeygenMkgm3RowInit.set64_slot s "u1" (j+1) (by omega)

theorem position (s : State) (j l t : Nat) (bound : l+t<2^64) : USlot (after s j l t) "v1" (l+t) :=
  KeygenMkgm3RowInit.set64_slot (withU s j) "v1" (l+t) bound

def initial (s : State) := bindValue (bindValue s "u1".toList .uint64 (u64 0)) "v1".toList .uint64 (u64 0)

theorem init (s : State) (oldU oldV : Option C99IntegerReference.Value)
    (du : s.locals "u1".toList=some (.uint64,oldU)) (dv : s.locals "v1".toList=some (.uint64,oldV)) :
    Exec KeygenNttForwardPrograms.u1Init s ⟨initial s,.normal⟩ :=
  .seqNormal _ _ s (bindValue s "u1".toList .uint64 (u64 0)) _
    (.assign _ _ _ .uint64 oldU (.int32 0) du (.scalar _ _ (.literal .int32 0)))
    (.assign _ _ _ .uint64 oldV (.int32 0) dv (.scalar _ _ (.literal .int32 0)))

theorem initial_fixed (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32) (h : Fixed s a gm p p0i w) :
    Fixed (initial s) a gm p p0i w :=
  ⟨h.pCell,h.iCell,h.wCell,h.nCell,h.hnCell,h.stride,h.aBinding,h.gmBinding,h.width,h.capacity,h.allocated,h.writable,h.initialized⟩

end FT1536.Source3.NttU1Control183
