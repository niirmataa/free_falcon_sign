import Source3.MkgmRowPrelude199

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmRowPreludeFacts199
open C99ArrayReference (State)
open C99ModularReference (Exec chainOf)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open MkgmParams198 (Level shiftWord half)
open Gen0RowPrelude189 (square fourth declaredWords declared withX withIX withG2 withG4 withIG2 withIG4)
open MkgmRowPrelude199

theorem source (l : Level) (s : State) (g ig p p0i : BitVec 32) (h : Input l s g ig p p0i) :
    Exec (chainOf KeygenMkgm3RowInit.rowPrelude) s ⟨after l s g ig p p0i,.normal⟩ :=
  ModularSequence178.complete _ _ _ _ (MkgmRowPrelude199.source l s g ig p p0i h)

theorem heap (l : Level) (s : State) (g ig p p0i : BitVec 32) (h : Input l s g ig p p0i) :
    (after l s g ig p p0i).heap=s.heap :=
  KeygenMkgm3Atoms.pure_heap _ _ _ (by decide) (source l s g ig p p0i h)

theorem arrays (l : Level) (s : State) (g ig p p0i : BitVec 32) (h : Input l s g ig p p0i) :
    (after l s g ig p p0i).arrays=s.arrays :=
  (KeygenMkgm3Control.frame _ _ _ (by decide) (source l s g ig p p0i h)).2.1

theorem p_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) (h : Input l s g ig p p0i) : Slot (after l s g ig p p0i) "p" p :=
  ((KeygenMkgm3Control.frame _ _ _ (by decide) (source l s g ig p p0i h)).2.2 _ (by decide)).trans h.pCell

theorem i_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) (h : Input l s g ig p p0i) : Slot (after l s g ig p p0i) "p0i" p0i :=
  ((KeygenMkgm3Control.frame _ _ _ (by decide) (source l s g ig p p0i h)).2.2 _ (by decide)).trans h.iCell

theorem u_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) (h : Input l s g ig p p0i) :
    (after l s g ig p p0i).locals "u".toList=s.locals "u".toList :=
  (KeygenMkgm3Control.frame _ _ _ (by decide) (source l s g ig p p0i h)).2.2 _ (by decide)

theorem x_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) : Slot (after l s g ig p p0i) "x" g := by
  change Slot (withX s g) "x" g
  exact ModularAtoms178.slot (declared s) "x" g

theorem ix_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) : Slot (after l s g ig p p0i) "ix" ig := by
  change Slot (withIX s g ig) "ix" ig
  exact ModularAtoms178.slot (withX s g) "ix" ig

theorem g2_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) : Slot (after l s g ig p p0i) "g2" (square g p p0i) := by
  change Slot (withG2 s g ig p p0i) "g2" (square g p p0i)
  exact ModularAtoms178.slot (withIX s g ig) "g2" _

theorem g4_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) : Slot (after l s g ig p p0i) "g4" (fourth g p p0i) := by
  change Slot (withG4 s g ig p p0i) "g4" (fourth g p p0i)
  exact ModularAtoms178.slot (withG2 s g ig p p0i) "g4" _

theorem after_locals (l : Level) (s : State) (g ig p p0i : BitVec 32) (name : C99ArrayReference.Name)
    (notB : name≠"b".toList) (notK : name≠"k".toList) :
    (after l s g ig p p0i).locals name=(withIG4 s g ig p p0i).locals name := by
  simp only [after,KeygenMkgm3RowInit.set64,withK,ModularAtoms178.set,C99ArrayReference.bindValue,C99ScalarReference.set,notB,notK,ite_false]

theorem ig2_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) : Slot (after l s g ig p p0i) "ig2" (square ig p p0i) :=
  (after_locals l s g ig p p0i "ig2".toList (by decide) (by decide)).trans
    ((ModularAtoms178.outside (withIG2 s g ig p p0i) "ig4" "ig2" (fourth ig p p0i) (by decide)).trans
      (ModularAtoms178.slot (withG4 s g ig p p0i) "ig2" _))

theorem ig4_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) : Slot (after l s g ig p p0i) "ig4" (fourth ig p p0i) :=
  (after_locals l s g ig p p0i "ig4".toList (by decide) (by decide)).trans
    (ModularAtoms178.slot (withIG2 s g ig p p0i) "ig4" _)

theorem k_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) : Slot (after l s g ig p p0i) "k" (shiftWord l) := by
  have keep : (after l s g ig p p0i).locals "k".toList=(withK l s g ig p p0i).locals "k".toList := by
    simp only [after,KeygenMkgm3RowInit.set64,C99ArrayReference.bindValue,C99ScalarReference.set,
      show "k".toList≠"b".toList from by decide,ite_false]
  exact keep.trans (ModularAtoms178.slot (withIG4 s g ig p p0i) "k" (shiftWord l))

theorem b_cell (l : Level) (s : State) (g ig p p0i : BitVec 32) : USlot (after l s g ig p p0i) "b" (half l) :=
  KeygenMkgm3RowInit.set64_slot (withK l s g ig p p0i) "b" (half l) (by have h:=MkgmParams198.half_range l; omega)

end FT1536.Source3.MkgmRowPreludeFacts199
