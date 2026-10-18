import Source3.TopProductBody186

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.TopProductControl186
open C99ArrayReference (State bindValue)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)
open TopProductFixed186 (Fixed)

def withU (s : State) (j : Nat) := bindValue s "u".toList .uint64 (u64 (3*j+3))
def after (s : State) (j : Nat) := bindValue (withU s j) "v".toList .uint64 (u64 (j+1))

theorem source (s : State) (j : Nat) (bound : j<512) (uc : USlot s "u" (3*j)) (vc : USlot s "v" j) :
    Exec TopProductProgram186.stepCode s ⟨after s j,.normal⟩ := by
  have u : Exec (.base (.scalar (.update "u".toList .add (TopProductProgram186.num 3)))) s ⟨withU s j,.normal⟩ :=
    .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint64 (some (u64 (3*j))) (u64 (3*j+3)) uc
      (.arithmetic .plus _ _ _ _ _ (.variable _ _ _ uc) (.literal .int32 3) (NttTripleControl184.add_three (3*j) (by omega)))))
  have base := C99LoopScalar141.increment (fun _ => none) (withU s j) "v".toList j (by omega) vc
  rw [FftLocalCells140.put_bind] at base
  have v : Exec (.base (.scalar (.update "v".toList .add (TopProductProgram186.num 1)))) (withU s j) ⟨after s j,.normal⟩ := by
    cases base with
    | base _ _ _ run => exact .base _ _ _ run
  exact .seqNormal _ _ s (withU s j) _ u v

theorem fixed (s : State) (p p0i r3 : BitVec 32) (j : Nat) (f : Fixed s p p0i r3) : Fixed (after s j) p p0i r3 :=
  ⟨f.pCell,f.iCell,f.rCell,f.outCell,f.nCell,f.fdBinding,f.gdBinding,f.fsBinding,f.gsBinding,f.fdAllocated,f.gdAllocated,f.writable,f.fReads,f.gReads⟩

theorem u_cell (s : State) (j : Nat) (bound : j<512) : USlot (after s j) "u" (3*(j+1)) := by
  change USlot (withU s j) "u" (3*(j+1))
  rw [Nat.mul_add,Nat.mul_one]
  exact KeygenMkgm3RowInit.set64_slot s "u" (3*j+3) (by omega)

theorem v_cell (s : State) (j : Nat) (bound : j<512) : USlot (after s j) "v" (j+1) :=
  KeygenMkgm3RowInit.set64_slot (withU s j) "v" (j+1) (by omega)

def initial (s : State) := bindValue (bindValue s "u".toList .uint64 (u64 0)) "v".toList .uint64 (u64 0)

theorem init (s : State) (oldU oldV : Option C99IntegerReference.Value)
    (du : s.locals "u".toList=some (.uint64,oldU)) (dv : s.locals "v".toList=some (.uint64,oldV)) :
    Exec TopProductProgram186.initCode s ⟨initial s,.normal⟩ :=
  .seqNormal _ _ s (bindValue s "u".toList .uint64 (u64 0)) _
    (.assign _ _ _ .uint64 oldU (.int32 0) du (.scalar _ _ (.literal .int32 0)))
    (.assign _ _ _ .uint64 oldV (.int32 0) dv (.scalar _ _ (.literal .int32 0)))

theorem initial_fixed (s : State) (p p0i r3 : BitVec 32) (f : Fixed s p p0i r3) : Fixed (initial s) p p0i r3 :=
  ⟨f.pCell,f.iCell,f.rCell,f.outCell,f.nCell,f.fdBinding,f.gdBinding,f.fsBinding,f.gsBinding,f.fdAllocated,f.gdAllocated,f.writable,f.fReads,f.gReads⟩

end FT1536.Source3.TopProductControl186
