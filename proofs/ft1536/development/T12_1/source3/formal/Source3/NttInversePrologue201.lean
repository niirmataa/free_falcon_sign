import Source3.NttSize201
import Source3.KeygenMkgm3RowInit

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInversePrologue201
open C99ArrayReference (State Name bindValue)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot u64)
open MkgmParams198 (Level lognWord count half)
open NttInversePrologue192 (afterSize afterMixed names wordNames)

def withN (l : Level) (s : State) : State := bindValue (afterMixed s) "n".toList .uint64 (u64 (count l))
def ready (l : Level) (s : State) : State := bindValue (withN l s) "hn".toList .uint64 (u64 (half l))

theorem bind_keep (s : State) (target : Name) (ty : C99IntegerReference.Ty)
    (v : C99IntegerReference.Value) (other : Name) (different : other≠target) :
    (bindValue s target ty v).locals other=s.locals other := by
  simp only [bindValue,C99ScalarReference.set,different,ite_false]

theorem n_cell (l : Level) (s : State) : USlot (withN l s) "n" (count l) :=
  KeygenMkgm3RowInit.set64_slot _ _ _ (by have h:=MkgmParams198.half_range l; unfold count; omega)

theorem ready_n (l : Level) (s : State) : USlot (ready l s) "n" (count l) :=
  (bind_keep (withN l s) "hn".toList .uint64 (u64 (half l)) "n".toList
    (by decide)).trans (n_cell l s)

theorem ready_hn (l : Level) (s : State) : USlot (ready l s) "hn" (half l) :=
  KeygenMkgm3RowInit.set64_slot _ _ _ (by have h:=MkgmParams198.half_range l; omega)

theorem guard_run (l : Level) (s : State) (logn : Slot s "logn" (lognWord l)) (full : Slot s "full" 0) :
    Exec NttInversePrograms192.guardPart (afterMixed s) ⟨ready l s,.normal⟩ := by
  have lognAfter : Slot (afterMixed s) "logn" (lognWord l) :=
    (NttInversePrologue192.mixed_locals_outside s "logn".toList (by simp [names,wordNames])).trans logn
  have fullAfter : Slot (afterMixed s) "full" 0 := NttInversePrologue192.full_ready s full
  have early : Exec NttInversePrograms192.earlyExit (afterMixed s) ⟨afterMixed s,.normal⟩ :=
    .branchFalse _ _ _ _ _ (.int32 0)
      (.compare .eq _ _ _ _ _ (.variable _ _ _ lognAfter) (.literal .int32 0) (NttSize201.logn_zero l)) rfl
      (.base .skip _ _ (.skip _))
  have n : Exec NttInversePrograms192.nAssign (afterMixed s) ⟨withN l s,.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 (count l)) rfl (.scalar _ _ (NttSize201.mkn l _ lognAfter fullAfter))
  have hn : Exec NttInversePrograms192.hnAssign (withN l s) ⟨ready l s,.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 (half l)) rfl (.scalar _ _
      (.shift .right _ _ _ _ _ (.variable _ _ _ (n_cell l s)) (.literal .int32 1) (NttSize201.shift_half l)))
  exact .seqNormal _ _ _ (afterMixed s) _ early
    (.seqNormal _ _ _ (withN l s) _ n (.seqNormal _ _ _ (ready l s) _ hn (.base .skip _ _ (.skip _))))

theorem source (l : Level) (s : State) (logn : Slot s "logn" (lognWord l)) (full : Slot s "full" 0) :
    Exec NttInversePrograms192.prologue s ⟨ready l s,.normal⟩ :=
  .seqNormal _ _ s (afterSize s) _ (NttInversePrologue192.size_run s)
    (.seqNormal _ _ _ (afterMixed s) _ (NttInversePrologue192.mixed_run s)
      (.seqNormal _ _ _ (ready l s) _ (guard_run l s logn full) (.base .skip _ _ (.skip _))))

theorem heap (l : Level) (s : State) : (ready l s).heap=s.heap := rfl

theorem locals_outside (l : Level) (s : State) (name : Name) (absent : name∉names++wordNames) :
    (ready l s).locals name=s.locals name := by
  obtain ⟨nDiff,hnDiff,_,_,_⟩ := NttInversePrologue192.distinct name absent
  exact (bind_keep (withN l s) "hn".toList .uint64 (u64 (half l)) name hnDiff).trans
    ((bind_keep (afterMixed s) "n".toList .uint64 (u64 (count l)) name nDiff).trans
      (NttInversePrologue192.mixed_locals_outside s name absent))

theorem arrays_outside (l : Level) (s : State) (name : Name)
    (first : name≠"r1".toList) (second : name≠"r2".toList) :
    (ready l s).arrays name=s.arrays name := NttInversePrologue192.arrays_outside s name first second

theorem slot_keep (l : Level) (s : State) (name : String) (w : BitVec 32)
    (fresh : name.toList∉names++wordNames) (cell : Slot s name w) : Slot (ready l s) name w :=
  (locals_outside l s name.toList fresh).trans cell

theorem uslot_keep (l : Level) (s : State) (name : String) (n : Nat)
    (fresh : name.toList∉names++wordNames) (cell : USlot s name n) : USlot (ready l s) name n :=
  (locals_outside l s name.toList fresh).trans cell

theorem u_declared (l : Level) (s : State) : (ready l s).locals "u".toList=some (.uint64,none) := rfl
theorem r_declared (l : Level) (s : State) : (ready l s).locals "r".toList=some (.uint64,none) := rfl
theorem m_declared (l : Level) (s : State) : (ready l s).locals "m".toList=some (.uint64,none) := rfl
theorem t_declared (l : Level) (s : State) : (ready l s).locals "t".toList=some (.uint64,none) := rfl
theorem w_declared (l : Level) (s : State) : (ready l s).locals "w".toList=some (.uint32,none) := rfl
theorem ni_declared (l : Level) (s : State) : (ready l s).locals "ni".toList=some (.uint32,none) := rfl
theorem R_declared (l : Level) (s : State) : (ready l s).locals "R".toList=some (.uint32,none) := rfl

end FT1536.Source3.NttInversePrologue201
