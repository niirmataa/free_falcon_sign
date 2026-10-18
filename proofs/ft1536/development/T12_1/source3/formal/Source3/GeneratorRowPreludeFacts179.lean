import Source3.GeneratorRowPrelude179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorRowPreludeFacts179
open C99ArrayReference (State)
open C99ModularReference (Exec chainOf)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open GeneratorRowPrelude179

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before source"

theorem source (s : State) (g ig p p0i : BitVec 32) (h : Input s g ig p p0i) :
    Exec (chainOf KeygenMkgm3RowInit.rowPrelude) s ⟨after s g ig p p0i,.normal⟩ :=
  ModularSequence178.complete _ _ _ _ (GeneratorRowPrelude179.source s g ig p p0i h)

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before heap"

theorem heap (s : State) (g ig p p0i : BitVec 32) (h : Input s g ig p p0i) :
    (after s g ig p p0i).heap=s.heap :=
  KeygenMkgm3Atoms.pure_heap _ _ _ (by decide) (source s g ig p p0i h)

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before arrays"

theorem arrays (s : State) (g ig p p0i : BitVec 32) (h : Input s g ig p p0i) :
    (after s g ig p p0i).arrays=s.arrays :=
  (KeygenMkgm3Control.frame _ _ _ (by decide) (source s g ig p p0i h)).2.1

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before p_cell"

theorem p_cell (s : State) (g ig p p0i : BitVec 32) (h : Input s g ig p p0i) : Slot (after s g ig p p0i) "p" p :=
  ((KeygenMkgm3Control.frame _ _ _ (by decide) (source s g ig p p0i h)).2.2 _ (by decide)).trans h.pCell

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before i_cell"

theorem i_cell (s : State) (g ig p p0i : BitVec 32) (h : Input s g ig p p0i) : Slot (after s g ig p p0i) "p0i" p0i :=
  ((KeygenMkgm3Control.frame _ _ _ (by decide) (source s g ig p p0i h)).2.2 _ (by decide)).trans h.iCell

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before u_cell"

theorem u_cell (s : State) (g ig p p0i : BitVec 32) (h : Input s g ig p p0i) :
    (after s g ig p p0i).locals "u".toList=s.locals "u".toList :=
  (KeygenMkgm3Control.frame _ _ _ (by decide) (source s g ig p p0i h)).2.2 _ (by decide)

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before x_cell"

theorem x_cell (s : State) (g ig p p0i : BitVec 32) : Slot (after s g ig p p0i) "x" g := by
  change Slot (withX s g) "x" g
  exact ModularAtoms178.slot (declared s) "x" g

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before ix_cell"

theorem ix_cell (s : State) (g ig p p0i : BitVec 32) : Slot (after s g ig p p0i) "ix" ig := by
  change Slot (withIX s g ig) "ix" ig
  exact ModularAtoms178.slot (withX s g) "ix" ig

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before g2_cell"

theorem g2_cell (s : State) (g ig p p0i : BitVec 32) : Slot (after s g ig p p0i) "g2" (square g p p0i) := by
  change Slot (withG2 s g ig p p0i) "g2" (square g p p0i)
  exact ModularAtoms178.slot (withIX s g ig) "g2" _

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before g4_cell"

theorem g4_cell (s : State) (g ig p p0i : BitVec 32) : Slot (after s g ig p p0i) "g4" (fourth g p p0i) := by
  change Slot (withG4 s g ig p p0i) "g4" (fourth g p p0i)
  exact ModularAtoms178.slot (withG2 s g ig p p0i) "g4" _

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before ig2_cell"

theorem after_locals (s : State) (g ig p p0i : BitVec 32) (name : C99ArrayReference.Name)
    (notB : name≠"b".toList) (notK : name≠"k".toList) :
    (after s g ig p p0i).locals name=(withIG4 s g ig p p0i).locals name := by
  simp only [after,withK,ModularAtoms178.set,C99ArrayReference.bindValue,C99ScalarReference.set,notB,notK,ite_false]

theorem ig2_cell (s : State) (g ig p p0i : BitVec 32) : Slot (after s g ig p p0i) "ig2" (square ig p p0i) :=
  (after_locals s g ig p p0i "ig2".toList (by decide) (by decide)).trans
    ((ModularAtoms178.outside (withIG2 s g ig p p0i) "ig4" "ig2" (fourth ig p p0i) (by decide)).trans
      (ModularAtoms178.slot (withG4 s g ig p p0i) "ig2" _))

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before ig4_cell"

theorem ig4_cell (s : State) (g ig p p0i : BitVec 32) : Slot (after s g ig p p0i) "ig4" (fourth ig p p0i) :=
  (after_locals s g ig p p0i "ig4".toList (by decide) (by decide)).trans
    (ModularAtoms178.slot (withIG2 s g ig p p0i) "ig4" _)

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before k_cell"

theorem k_cell (s : State) (g ig p p0i : BitVec 32) : Slot (after s g ig p p0i) "k" 1 := by
  have keep : (after s g ig p p0i).locals "k".toList=(withK s g ig p p0i).locals "k".toList := by
    simp only [after,C99ArrayReference.bindValue,C99ScalarReference.set,
      show "k".toList≠"b".toList from by decide,ite_false]
  exact keep.trans (ModularAtoms178.slot (withIG4 s g ig p p0i) "k" 1)

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "before b_cell"

theorem b_cell (s : State) (g ig p p0i : BitVec 32) : USlot (after s g ig p p0i) "b" 512 :=
  KeygenMkgm3RowInit.set64_slot (withK s g ig p p0i) "b" 512 (by decide)

#eval IO.FS.writeFile "../ROW_PRELUDE179_PROGRESS.txt" "complete"

end FT1536.Source3.GeneratorRowPreludeFacts179
