import Source3.MkgmRowInit198

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmRowLoop198
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Memory)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open KeygenSmallOutput (element)
open Word32Initialized180 (At)
open MkgmParams198 (Level half count lastIndex)
open MkgmRowFixed198 (Fixed)
open GeneratorRowControl179 (put body increment loop)
open MkgmRowBody198 (nextX nextIX)

def Prefix (l : Level) (s : State) (gm igm : ArrayPointer) (done : Nat) : Prop :=
  ∀ v : Nat, v<done → At s.heap (element gm (lastIndex l v)) ∧ At s.heap (element igm (lastIndex l v))
def Upper (l : Level) (h : Memory) (gm igm : ArrayPointer) : Prop :=
  ∀ j : Nat, half l≤j → j<count l → At h (element gm j) ∧ At h (element igm j)

theorem covered (l : Level) (s : State) (gm igm : ArrayPointer) (written : Prefix l s gm igm (half l)) :
    Upper l s.heap gm igm := by
  intro j lower upper
  have bound : j-half l<half l := by unfold count at upper; omega
  obtain ⟨v,equal⟩ := MkgmParams198.reverse_surjective l ⟨j-half l,bound⟩
  have index : lastIndex l v.val=j := by
    unfold lastIndex
    rw [equal]
    change half l+(j-half l)=j
    omega
  have reads := written v.val v.isLt
  simpa only [index] using reads

theorem guard (l : Level) (s : State) (u : Nat) (counter : USlot s "u" u)
    (base : USlot s "b" (half l)) (bound : u<2^64) :
    C99ArrayReference.scalar s GeneratorRowControl179.condition
      (C99ScalarReference.boolean (decide (u<half l))) :=
  C99LoopScalar141.less s _ _ u (half l) bound (by have h:=MkgmParams198.half_range l; omega)
    (.variable _ _ _ counter) (.variable _ _ _ base)

theorem remaining (l : Level) (n u : Nat) (finish : u+2*n=half l)
    (s : State) (gm igm rev : ArrayPointer) (p p0i g2 g4 ig2 ig4 x ix : BitVec 32)
    (fixed : Fixed l s gm igm rev p p0i g2 g4 ig2 ig4)
    (counter : USlot s "u" u) (hx : Slot s "x" x) (hi : Slot s "ix" ix)
    (written : Prefix l s gm igm u) :
    ∃ (out : State) (x' ix' : BitVec 32), Exec loop s ⟨out,.normal⟩ ∧
      Fixed l out gm igm rev p p0i g2 g4 ig2 ig4 ∧ Slot out "x" x' ∧ Slot out "ix" ix' ∧
      USlot out "u" (half l) ∧ Prefix l out gm igm (half l) := by
  induction n generalizing u s x ix with
  | zero =>
    have same : u=half l := by omega
    subst u
    have falseGuard : C99ArrayReference.scalar s GeneratorRowControl179.condition (.int32 0) := by
      simpa [C99ScalarReference.boolean] using guard l s (half l) counter fixed.bCell
        (by have h:=MkgmParams198.half_range l; omega)
    exact ⟨s,x,ix,.loopFalse _ _ _ s (.int32 0) falseGuard rfl,fixed,hx,hi,counter,written⟩
  | succ n ih =>
    have slot : u+1<half l := by omega
    let middle := MkgmRowBody198.after l s gm igm p p0i g2 g4 ig2 ig4 x ix u
    let next := put middle (u+2)
    have bodyRun := MkgmRowBody198.source l s gm igm rev p p0i g2 g4 ig2 ig4 x ix u slot fixed hx hi counter
    have iteration : Exec body s ⟨middle,.normal⟩ := by
      have scopedRun := C99ModularReference.GenExec.scope [] _ s ⟨middle,.normal⟩ bodyRun
      simpa only [GeneratorRowControl179.body,KeygenPublicForwardCall.restore_empty] using scopedRun
    have middleFixed := MkgmRowFixed198.transported l body s ⟨middle,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4
      fixed (by decide) (by decide) iteration
    have middleU : USlot middle "u" u := (MkgmRowBody198.u_after l s gm igm p p0i g2 g4 ig2 ig4 x ix u).trans counter
    have update : Exec increment middle ⟨next,.normal⟩ :=
      GeneratorRowControl179.advance middle u (by have h:=MkgmParams198.half_range l; omega) middleU
    have nextFixed := MkgmRowFixed198.transported l increment middle ⟨next,.normal⟩ gm igm rev p p0i g2 g4 ig2 ig4
      middleFixed (by decide) (by decide) update
    have nextU : USlot next "u" (u+2) :=
      GeneratorRowControl179.cell middle (u+2) (by have h:=MkgmParams198.half_range l; omega)
    have nextXCell : Slot next "x" (nextX x g2 g4 p p0i) := MkgmRowBody198.x_after l s gm igm p p0i g2 g4 ig2 ig4 x ix u
    have nextIXCell : Slot next "ix" (nextIX ix ig2 ig4 p p0i) := MkgmRowBody198.ix_after l s gm igm p p0i g2 g4 ig2 ig4 x ix u
    have preserves := C99InitializationTrace.steps_preserve _ _ (KeygenMkgm3RevMemory.memory_steps _ _ _ iteration)
    have initialized := MkgmRowInit198.pair l s gm igm p p0i g2 g4 ig2 ig4 x ix u
    have nextPrefix : Prefix l next gm igm (u+2) := by
      intro v bound
      by_cases old : v<u
      · exact ⟨Word32Initialized180.transported _ _ _ preserves (written v old).1,
          Word32Initialized180.transported _ _ _ preserves (written v old).2⟩
      · have same : v=u ∨ v=u+1 := by omega
        rcases same with rfl | rfl
        · exact ⟨initialized.1,initialized.2.1⟩
        · exact initialized.2.2
    obtain ⟨out,x',ix',rest,outFixed,outX,outIX,outU,outPrefix⟩ :=
      ih (u+2) (by omega) next (nextX x g2 g4 p p0i) (nextIX ix ig2 ig4 p p0i)
        nextFixed nextU nextXCell nextIXCell nextPrefix
    have nonzero : (C99ScalarReference.boolean (decide (u<half l))).integer≠0 := by
      simp [show u<half l by omega,C99ScalarReference.boolean,C99IntegerReference.Value.integer]
    exact ⟨out,x',ix',.loopNormal _ _ _ s middle next ⟨out,.normal⟩ _
      (guard l s u counter fixed.bCell (by have h:=MkgmParams198.half_range l; omega)) nonzero
      iteration update rest,outFixed,outX,outIX,outU,outPrefix⟩

theorem half_even (l : Level) (positive : 0<l.val) : 2*(half l/2)=half l := by
  have all : ∀ l : Level, 0<l.val → 2*(half l/2)=half l := by decide +kernel
  exact all l positive

theorem full (l : Level) (positive : 0<l.val) (s : State) (gm igm rev : ArrayPointer)
    (p p0i g2 g4 ig2 ig4 x ix : BitVec 32) (fixed : Fixed l s gm igm rev p p0i g2 g4 ig2 ig4)
    (hx : Slot s "x" x) (hi : Slot s "ix" ix)
    (old : Option C99IntegerReference.Value) (declared : s.locals "u".toList=some (.uint64,old)) :
    ∃ (out : State) (x' ix' : BitVec 32), Exec KeygenMkgm3Program.lastRowLoop s ⟨out,.normal⟩ ∧
      Fixed l out gm igm rev p p0i g2 g4 ig2 ig4 ∧ Slot out "x" x' ∧ Slot out "ix" ix' ∧
      USlot out "u" (half l) ∧ Upper l out.heap gm igm := by
  have initial := GeneratorRowControl179.start s old declared
  have fixed0 := MkgmRowFixed198.transported l GeneratorRowControl179.initial s ⟨put s 0,.normal⟩
    gm igm rev p p0i g2 g4 ig2 ig4 fixed (by decide) (by decide) initial
  obtain ⟨out,x',ix',run,fo,hx',hi',hu,initialized⟩ := remaining l (half l/2) 0
    (by simpa only [Nat.zero_add] using half_even l positive) (put s 0) gm igm rev p p0i g2 g4 ig2 ig4 x ix
    fixed0 (GeneratorRowControl179.cell s 0 (by decide)) hx hi (fun v bound => (by omega))
  exact ⟨out,x',ix',.seqNormal _ _ s (put s 0) _ initial run,fo,hx',hi',hu,covered l out gm igm initialized⟩

end FT1536.Source3.MkgmRowLoop198
