import Source3.GeneratorRowBody179
import Source3.GeneratorRowControl179

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorRowLoop179
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open GeneratorRowFixed179 (Fixed)
open GeneratorRowControl179 (put loop body increment)

theorem source (n j : Nat) (count : j+n=256) (s : State) (gm igm rev : ArrayPointer)
    (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (fixed : Fixed s gm igm rev p p0i g2 g4 ig2 ig4)
    (counter : USlot s "u" (2*j)) (hx : Slot s "x" x) (hi : Slot s "ix" ix) :
    ∃ out x' ix', Exec loop s ⟨out,.normal⟩ ∧ Fixed out gm igm rev p p0i g2 g4 ig2 ig4 ∧
      Slot out "x" x' ∧ Slot out "ix" ix' ∧ USlot out "u" 512 := by
  induction n generalizing j s x ix with
  | zero =>
    have equal : j=256 := by omega
    subst j
    exact ⟨s,x,ix,.loopFalse _ _ _ s (.int32 0)
      (GeneratorRowControl179.guard s 512 (by decide) counter fixed.bCell) rfl,fixed,hx,hi,counter⟩
  | succ n ih =>
    have bound : 2*j+1<512 := by omega
    let middle := GeneratorRowBody179.after s gm igm p p0i g2 g4 ig2 ig4 x ix (2*j)
    let next := put middle (2*j+2)
    have core := GeneratorRowBody179.source s gm igm rev p p0i g2 g4 ig2 ig4 x ix (2*j) bound fixed hx hi counter
    have iteration : Exec body s ⟨middle,.normal⟩ := by
      have run := C99ModularReference.GenExec.scope [] _ s ⟨middle,.normal⟩ core
      simpa only [body,KeygenPublicForwardCall.restore_empty] using run
    have middleFixed := GeneratorRowFixed179.transported body s ⟨middle,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4
      fixed (by decide) (by decide) iteration
    have middleU : USlot middle "u" (2*j) :=
      (GeneratorRowBody179.u_after s gm igm p p0i g2 g4 ig2 ig4 x ix (2*j)).trans counter
    have update := GeneratorRowControl179.advance middle (2*j) (by omega) middleU
    have nextFixed := GeneratorRowFixed179.transported increment middle ⟨next,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4
      middleFixed (by decide) (by decide) update
    have nextU : USlot next "u" (2*(j+1)) := by
      have equal : 2*(j+1)=2*j+2 := by omega
      rw [equal]
      exact GeneratorRowControl179.cell middle (2*j+2) (by omega)
    have nextX : Slot next "x" (GeneratorRowBody179.nextX x g2 g4 p p0i) :=
      GeneratorRowBody179.x_after s gm igm p p0i g2 g4 ig2 ig4 x ix (2*j)
    have nextIX : Slot next "ix" (GeneratorRowBody179.nextIX ix ig2 ig4 p p0i) :=
      GeneratorRowBody179.ix_after s gm igm p p0i g2 g4 ig2 ig4 x ix (2*j)
    obtain ⟨out,x',ix',rest,outFixed,outX,outIX,outU⟩ := ih (j+1) (by omega) next
      (GeneratorRowBody179.nextX x g2 g4 p p0i) (GeneratorRowBody179.nextIX ix ig2 ig4 p p0i)
      nextFixed nextU nextX nextIX
    refine ⟨out,x',ix',?_,outFixed,outX,outIX,outU⟩
    have nonzero : (C99ScalarReference.boolean (decide (2*j<512))).integer≠0 := by
      simp [show 2*j<512 by omega,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (GeneratorRowControl179.guard s (2*j) (by omega) counter fixed.bCell) nonzero iteration update rest

theorem full (s : State) (gm igm rev : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32)
    (fixed : Fixed s gm igm rev p p0i g2 g4 ig2 ig4) (hx : Slot s "x" x) (hi : Slot s "ix" ix)
    (old : Option C99IntegerReference.Value) (declared : s.locals "u".toList=some (.uint64,old)) :
    ∃ out x' ix', Exec KeygenMkgm3Program.lastRowLoop s ⟨out,.normal⟩ ∧
      Fixed out gm igm rev p p0i g2 g4 ig2 ig4 ∧ Slot out "x" x' ∧ Slot out "ix" ix' ∧ USlot out "u" 512 := by
  have initial := GeneratorRowControl179.start s old declared
  have fixed0 := GeneratorRowFixed179.transported GeneratorRowControl179.initial s ⟨put s 0,.normal⟩
    gm igm rev p p0i g2 g4 ig2 ig4 fixed (by decide) (by decide) initial
  obtain ⟨out,x',ix',run,fo,hx',hi',hu⟩ := source 256 0 rfl (put s 0) gm igm rev p p0i g2 g4 ig2 ig4 x ix
    fixed0 (GeneratorRowControl179.cell s 0 (by decide)) hx hi
  exact ⟨out,x',ix',.seqNormal _ _ s (put s 0) ⟨out,.normal⟩ initial run,fo,hx',hi',hu⟩

end FT1536.Source3.GeneratorRowLoop179
