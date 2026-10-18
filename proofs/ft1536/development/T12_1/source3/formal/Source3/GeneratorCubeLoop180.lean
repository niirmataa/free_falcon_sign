import Source3.GeneratorCubeInitialized180
import Source3.GeneratorCubeControl180

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorCubeLoop180
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open GeneratorCubeFixed180 (Fixed)
open GeneratorCubeControl180 (loop)
open GeneratorRowControl179 (put)
open GeneratorCubeInitialized180 (Lower)

theorem source (n j : Nat) (count : j+n=512) (lo : 256≤j) (s : State) (gm igm : ArrayPointer)
    (p p0i : BitVec 32) (fixed : Fixed s gm igm p p0i) (counter : USlot s "u" j)
    (initialized : Lower s.heap gm igm j) :
    ∃ out, Exec loop s ⟨out,.normal⟩ ∧ Fixed out gm igm p p0i ∧ USlot out "u" 512 ∧ Lower out.heap gm igm 512 := by
  induction n generalizing j s with
  | zero =>
    have equal : j=512 := by omega
    subst j
    exact ⟨s,.loopFalse _ _ _ s (.int32 0)
      (GeneratorCubeControl180.guard s 512 (by decide) counter fixed.kCell) rfl,fixed,counter,initialized⟩
  | succ n ih =>
    have hi : j<512 := by omega
    obtain ⟨y,gRead⟩ := Word32Initialized180.load s.heap (KeygenSmallOutput.element gm (2*j))
      (fixed.gAllocated (2*j) (by omega)) fixed.gWidth (fixed.gUpper (2*j) (by omega) (by omega))
    obtain ⟨z,iRead⟩ := Word32Initialized180.load s.heap (KeygenSmallOutput.element igm (2*j))
      (fixed.iAllocated (2*j) (by omega)) fixed.iWidth (fixed.iUpper (2*j) (by omega) (by omega))
    let middle := GeneratorCubeBody180.after s gm igm p p0i y z j
    let next := put middle (j+1)
    have iteration := GeneratorCubeBody180.source s gm igm p p0i y z j lo hi fixed counter gRead iRead
    have middleFixed := GeneratorCubeFixed180.transported KeygenMkgm3Program.cubeBody s ⟨middle,.normal⟩ gm igm p p0i
      fixed (by decide) (by decide) iteration
    have middleU : USlot middle "u" j :=
      ((KeygenMkgm3Control.frame _ _ _ (by decide) iteration).2.2 "u".toList (by decide)).trans counter
    have update := GeneratorCubeControl180.advance middle j (by omega) middleU
    have nextFixed := GeneratorCubeFixed180.transported (KeygenMkgm3Program.inc "u") middle ⟨next,.normal⟩ gm igm p p0i
      middleFixed (by decide) (by decide) update
    have nextInit : Lower next.heap gm igm (j+1) := GeneratorCubeInitialized180.grows s gm igm p p0i y z j initialized
    obtain ⟨out,rest,outFixed,outU,outInit⟩ := ih (j+1) (by omega) (by omega) next nextFixed
      (GeneratorRowControl179.cell middle (j+1) (by omega)) nextInit
    refine ⟨out,?_,outFixed,outU,outInit⟩
    have nonzero : (C99ScalarReference.boolean (decide (j<512))).integer≠0 := by
      simp [hi,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (GeneratorCubeControl180.guard s j (by omega) counter fixed.kCell) nonzero iteration update rest

theorem full (s : State) (gm igm : ArrayPointer) (p p0i : BitVec 32) (fixed : Fixed s gm igm p p0i)
    (old : Option C99IntegerReference.Value) (declared : s.locals "u".toList=some (.uint64,old)) :
    ∃ out, Exec KeygenMkgm3Program.cubeLoop s ⟨out,.normal⟩ ∧ Fixed out gm igm p p0i ∧
      USlot out "u" 512 ∧ Lower out.heap gm igm 512 := by
  have initial := GeneratorCubeControl180.start s old declared fixed.kCell
  have fixed0 := GeneratorCubeFixed180.transported GeneratorCubeControl180.initial s ⟨put s 256,.normal⟩
    gm igm p p0i fixed (by decide) (by decide) initial
  obtain ⟨out,run,fo,hu,initialized⟩ := source 256 256 rfl (by decide) (put s 256) gm igm p p0i fixed0
    (GeneratorRowControl179.cell s 256 (by decide)) (by intro i lo hi; omega)
  exact ⟨out,.seqNormal _ _ s (put s 256) ⟨out,.normal⟩ initial run,fo,hu,initialized⟩

end FT1536.Source3.GeneratorCubeLoop180
