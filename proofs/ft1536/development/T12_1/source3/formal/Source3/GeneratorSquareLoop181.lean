import Source3.GeneratorSquareInitialized181
import Source3.GeneratorSquareControl181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GeneratorSquareLoop181
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenSmallOutput (element)
open GeneratorCubeFixed180 (Fixed)
open GeneratorSquareDomains181 (From)
open GeneratorSquareControl181 (loop)
open GeneratorRowControl179 (put)

theorem source (n : Nat) (bound : n < 256) (s : State) (gm igm : ArrayPointer) (p p0i : BitVec 32)
    (fixed : Fixed s gm igm p p0i) (counter : USlot s "u" n) (initialized : From s.heap gm igm (n+1)) :
    ∃ out, Exec loop s ⟨out,.normal⟩ ∧ Fixed out gm igm p p0i ∧ USlot out "u" 0 ∧ From out.heap gm igm 1 := by
  induction n generalizing s with
  | zero =>
    exact ⟨s,.loopFalse _ _ _ s (.int32 0) (GeneratorSquareControl181.guard s 0 (by decide) counter) rfl,
      fixed,counter,initialized⟩
  | succ n ih =>
    obtain ⟨y,gRead⟩ := Word32Initialized180.load s.heap (element gm (2*(n+1)))
      (fixed.gAllocated _ (by omega)) fixed.gWidth (initialized _ (by omega) (by omega)).1
    let first := GeneratorSquareBody181.gWritten s gm p p0i y (n+1)
    have firstData : From first.heap gm igm (n+1+1) :=
      GeneratorSquareDomains181.from_transport _ _ gm igm _
        (GeneratorSquareInitialized181.first_preserves s gm p p0i y (n+1)) initialized
    obtain ⟨z,iRead⟩ := Word32Initialized180.load first.heap (element igm (2*(n+1)))
      (fixed.iAllocated _ (by omega)) fixed.iWidth (firstData _ (by omega) (by omega)).2
    let middle := GeneratorSquareBody181.after s gm igm p p0i y z (n+1)
    let next := put middle n
    have iteration := GeneratorSquareBody181.source s gm igm p p0i y z (n+1) (by omega) bound fixed counter gRead iRead
    have middleFixed := GeneratorSquareDomains181.transported KeygenMkgm3Program.squareBody s ⟨middle,.normal⟩
      gm igm p p0i fixed (by decide) (by decide) iteration
    have middleU : USlot middle "u" (n+1) :=
      ((KeygenMkgm3Control.frame _ _ _ (by decide) iteration).2.2 "u".toList (by decide)).trans counter
    have update : Exec (KeygenMkgm3Program.dec "u") middle ⟨next,.normal⟩ := by
      simpa only [Nat.add_sub_cancel] using GeneratorSquareControl181.decrement middle (n+1) (by omega) bound middleU
    have nextFixed := GeneratorSquareDomains181.transported (KeygenMkgm3Program.dec "u") middle ⟨next,.normal⟩
      gm igm p p0i middleFixed (by decide) (by decide) update
    have nextData : From next.heap gm igm (n+1) := GeneratorSquareInitialized181.grows s gm igm p p0i y z (n+1) initialized
    obtain ⟨out,rest,outFixed,outU,outData⟩ := ih (by omega) next nextFixed
      (GeneratorRowControl179.cell middle n (by omega)) nextData
    refine ⟨out,?_,outFixed,outU,outData⟩
    have nonzero : (C99ScalarReference.boolean (decide (0<n+1))).integer≠0 := by
      simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (GeneratorSquareControl181.guard s (n+1) bound counter) nonzero iteration update rest

theorem full (s : State) (gm igm : ArrayPointer) (p p0i : BitVec 32) (fixed : Fixed s gm igm p p0i)
    (initialized : From s.heap gm igm 256) (old : Option C99IntegerReference.Value)
    (declared : s.locals "u".toList=some (.uint64,old)) :
    ∃ out, Exec KeygenMkgm3Program.squareLoop s ⟨out,.normal⟩ ∧ Fixed out gm igm p p0i ∧
      USlot out "u" 0 ∧ From out.heap gm igm 1 := by
  have initial := GeneratorSquareControl181.start s old declared fixed.kCell
  have fixed0 := GeneratorSquareDomains181.transported GeneratorSquareControl181.initial s ⟨put s 255,.normal⟩
    gm igm p p0i fixed (by decide) (by decide) initial
  obtain ⟨out,run,fo,hu,initialized'⟩ := source 255 (by decide) (put s 255) gm igm p p0i fixed0
    (GeneratorRowControl179.cell s 255 (by decide)) initialized
  exact ⟨out,.seqNormal _ _ s (put s 255) ⟨out,.normal⟩ initial run,fo,hu,initialized'⟩

end FT1536.Source3.GeneratorSquareLoop181
