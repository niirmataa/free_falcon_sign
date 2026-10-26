import Source3.RxSection210
import Source3.NttSize201

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttForwardPrologue211
open C99ArrayReference (State Name)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open C99NatWord141 (word)
open MkgmParams198 (Level count half lognWord)

def mixed (s : State) := KeygenNttForwardExec.afterPointers (KeygenNttForwardExec.afterWord (KeygenNttForwardExec.afterLocals s))
 def withN (l : Level) (s : State) := set64 (mixed s) "n" (word (count l))
 def ready (l : Level) (s : State) := set64 (withN l s) "hn" (word (half l))
 def names : List Name := KeygenNttForwardExec.names6++["w".toList]

theorem mixed_locals (s : State) (name : Name) (absent : name∉names) : (mixed s).locals name=s.locals name := by
  have no6 : name∉KeygenNttForwardExec.names6 := fun member => absent (List.mem_append_left _ member)
  have noW : name∉["w".toList] := fun member => absent (List.mem_append_right _ member)
  have nw : name≠"w".toList := by simpa only [List.mem_singleton] using noW
  change (C99DeclarationStatements.effect .u32 ["w".toList]
    (C99DeclarationStatements.effect .u64 KeygenNttForwardExec.names6 s)).locals name=s.locals name
  exact (ZintSubWord194.effect_one_other .u32 "w".toList name _ nw).trans
    (SelectedStepAddPrime195.effect_locals .u64 KeygenNttForwardExec.names6 s name no6)

theorem locals (l : Level) (s : State) (name : Name) (absent : name∉names) : (ready l s).locals name=s.locals name := by
  have nn : name≠"n".toList := fun eq => absent (by rw [eq]; decide)
  have nh : name≠"hn".toList := fun eq => absent (by rw [eq]; decide)
  exact (SelectedStepAddPrime195.locals_keep (withN l s) "hn".toList .uint64 (.uint64 (word (half l))) name nh).trans
    ((SelectedStepAddPrime195.locals_keep (mixed s) "n".toList .uint64 (.uint64 (word (count l))) name nn).trans (mixed_locals s name absent))

theorem arrays (l : Level) (s : State) (name : Name) (nr1 : name≠"r1".toList) (nr2 : name≠"r2".toList) :
    (ready l s).arrays name=s.arrays name := by
  change (if name="r2".toList then none else if name="r1".toList then none else s.arrays name)=s.arrays name
  simp only [nr1,nr2,ite_false]

theorem nCell (l : Level) (s : State) : Cell (ready l s) "n".toList (count l) :=
  (CrtState205.keep64 (withN l s) "hn" "n" (word (half l)) (by decide)).trans (CrtState205.cell64 _ _ _)

theorem hnCell (l : Level) (s : State) : Cell (ready l s) "hn".toList (half l) := CrtState205.cell64 _ _ _

theorem free (l : Level) (s : State) : (ready l s).locals "w".toList=some (.uint32,none) ∧
    (ready l s).locals "u".toList=some (.uint64,none) ∧ (ready l s).locals "m".toList=some (.uint64,none) ∧
    (ready l s).locals "t".toList=some (.uint64,none) := ⟨rfl,rfl,rfl,rfl⟩

theorem source (l : Level) (s : State) (logn : Slot s "logn" (lognWord l)) (full : Slot s "full" 0) :
    Exec KeygenNttForwardPrograms.prologue s ⟨ready l s,.normal⟩ := by
  have lognM : Slot (mixed s) "logn" (lognWord l) := (mixed_locals s "logn".toList (by decide)).trans logn
  have fullM : Slot (mixed s) "full" 0 := (mixed_locals s "full".toList (by decide)).trans full
  have early : Exec KeygenNttForwardPrograms.earlyExit (mixed s) ⟨mixed s,.normal⟩ :=
    .branchFalse _ _ _ _ _ (.int32 0) (.compare .eq _ _ _ _ _ (.variable _ _ _ lognM) (.literal .int32 0) (NttSize201.logn_zero l))
      (by decide) (.base _ _ _ (.skip _))
  have n : Exec KeygenNttForwardPrograms.nAssign (mixed s) ⟨withN l s,.normal⟩ :=
    .assign _ _ _ .uint64 none (.uint64 (word (count l))) rfl (.scalar _ _ (NttSize201.mkn l (mixed s) lognM fullM))
  have nCurrent : Cell (withN l s) "n".toList (count l) := CrtState205.cell64 _ _ _
  have hn : Exec KeygenNttForwardPrograms.hnAssign (withN l s) ⟨ready l s,.normal⟩ :=
    .assign _ _ _ .uint64 none (.uint64 (word (half l))) rfl (.scalar _ _
      (.shift .right _ _ _ _ _ (.variable _ _ _ nCurrent) (.literal .int32 1) (NttSize201.shift_half l)))
  exact .seqNormal _ _ _ _ _ (StepNttPrologue195.locals_run s)
    (.seqNormal _ _ _ _ _ (StepNttPrologue195.word_run _) (.seqNormal _ _ _ _ _ (StepNttPrologue195.pointers_run _)
      (.seqNormal _ _ _ _ _ early (.seqNormal _ _ _ _ _ n (.seqNormal _ _ _ _ _ hn (.base _ _ _ (.skip _)))))))

end FT1536.Source3.NttForwardPrologue211
