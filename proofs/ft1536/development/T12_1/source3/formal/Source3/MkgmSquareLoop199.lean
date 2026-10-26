import Source3.MkgmSquareInit199
import Source3.GeneratorSquareControl181

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmSquareLoop199
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenSmallOutput (element)
open MkgmSquare199 (Fixed)
open MkgmParams198 (Level half count)
open MkgmSquare199 (From)
open GeneratorSquareControl181 (loop)
open GeneratorRowControl179 (put)

theorem source (l : Level) (n : Nat) (bound : n < half l) (s : State) (gm igm : ArrayPointer) (p p0i : BitVec 32)
    (fixed : Fixed l s gm igm p p0i) (counter : USlot s "u" n) (initialized : From l s.heap gm igm (n+1)) :
    ∃ out, Exec loop s ⟨out,.normal⟩ ∧ Fixed l out gm igm p p0i ∧ USlot out "u" 0 ∧ From l out.heap gm igm 1 := by
  have halfBound:=MkgmParams198.half_range l
  have limit : count l=2*half l := rfl
  induction n generalizing s with
  | zero =>
    exact ⟨s,.loopFalse _ _ _ s (.int32 0) (GeneratorSquareControl181.guard s 0 (by decide) counter) rfl,
      fixed,counter,initialized⟩
  | succ n ih =>
    obtain ⟨y,gRead⟩ := Word32Initialized180.load s.heap (element gm (2*(n+1)))
      (fixed.gAllocated _ (by omega)) fixed.gWidth (initialized _ (by omega) (by omega)).1
    let first := MkgmSquareBody199.gWritten s gm p p0i y (n+1)
    have firstData : From l first.heap gm igm (n+1+1) :=
      MkgmSquare199.from_transport l _ _ gm igm _
        (MkgmSquareInit199.first_preserves s gm p p0i y (n+1)) initialized
    obtain ⟨z,iRead⟩ := Word32Initialized180.load first.heap (element igm (2*(n+1)))
      (fixed.iAllocated _ (by omega)) fixed.iWidth (firstData _ (by omega) (by omega)).2
    let middle := MkgmSquareBody199.after s gm igm p p0i y z (n+1)
    let next := put middle n
    have iteration := MkgmSquareBody199.source l s gm igm p p0i y z (n+1) bound fixed counter gRead iRead
    have middleFixed := MkgmSquare199.transported l KeygenMkgm3Program.squareBody s ⟨middle,.normal⟩
      gm igm p p0i fixed (by decide) (by decide) iteration
    have middleU : USlot middle "u" (n+1) :=
      ((KeygenMkgm3Control.frame _ _ _ (by decide) iteration).2.2 "u".toList (by decide)).trans counter
    have update : Exec (KeygenMkgm3Program.dec "u") middle ⟨next,.normal⟩ := by
      simpa only [Nat.add_sub_cancel] using GeneratorSquareControl181.decrement middle (n+1) (by omega) (by omega) middleU
    have nextFixed := MkgmSquare199.transported l (KeygenMkgm3Program.dec "u") middle ⟨next,.normal⟩
      gm igm p p0i middleFixed (by decide) (by decide) update
    have nextData : From l next.heap gm igm (n+1) := MkgmSquareInit199.grows l s gm igm p p0i y z (n+1) initialized
    obtain ⟨out,rest,outFixed,outU,outData⟩ := ih (by omega) next nextFixed
      (GeneratorRowControl179.cell middle n (by omega)) nextData
    refine ⟨out,?_,outFixed,outU,outData⟩
    have nonzero : (C99ScalarReference.boolean (decide (0<n+1))).integer≠0 := by
      simp [C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact .loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (GeneratorSquareControl181.guard s (n+1) (by omega) counter) nonzero iteration update rest

theorem start (l : Level) (s : State) (old : Option C99IntegerReference.Value)
    (declared : s.locals "u".toList=some (.uint64,old))
    (k : KeygenModpR2Exec.Slot s "k" (MkgmControl199.word l.val)) :
    Exec GeneratorSquareControl181.initial s ⟨put s (half l-1),.normal⟩ :=
  .assign _ _ _ .uint64 old (KeygenNttLoopSupport.u64 (half l-1)) declared (.scalar _ _
    (.arithmetic .minus _ _ _ _ _
      (.shift .left _ _ _ _ _ (.cast .uint64 _ (.int32 1) (.literal .int32 1))
        (.variable _ _ _ k) (MkgmControl199.half_shift l))
      (.literal .int32 1) (PublicGenerateIndex159.sub_one (half l)
        (by have h:=MkgmParams198.half_range l; omega) (by have h:=MkgmParams198.half_range l; omega))))

theorem full (l : Level) (s : State) (gm igm : ArrayPointer) (p p0i : BitVec 32)
    (fixed : Fixed l s gm igm p p0i) (initialized : From l s.heap gm igm (half l))
    (old : Option C99IntegerReference.Value) (declared : s.locals "u".toList=some (.uint64,old))
    (k : KeygenModpR2Exec.Slot s "k" (MkgmControl199.word l.val)) :
    ∃ out, Exec KeygenMkgm3Program.squareLoop s ⟨out,.normal⟩ ∧ Fixed l out gm igm p p0i ∧
      USlot out "u" 0 ∧ From l out.heap gm igm 1 := by
  have initial := start l s old declared k
  have fixed0 := MkgmSquare199.transported l GeneratorSquareControl181.initial s ⟨put s (half l-1),.normal⟩
    gm igm p p0i fixed (by decide) (by decide) initial
  have halfBound:=MkgmParams198.half_range l
  obtain ⟨out,run,fo,hu,data⟩ := source l (half l-1) (by omega) (put s (half l-1)) gm igm p p0i fixed0
    (GeneratorRowControl179.cell s (half l-1) (by omega)) (by
      intro j lower upper
      exact initialized j (by omega) upper)
  exact ⟨out,.seqNormal _ _ s (put s (half l-1)) _ initial run,fo,hu,data⟩

end FT1536.Source3.MkgmSquareLoop199
