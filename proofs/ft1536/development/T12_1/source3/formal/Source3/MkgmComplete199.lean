import Source3.MkgmScalar199
import Source3.MkgmRows199
import Source3.MkgmSplice199

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmComplete199
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer Allocated Load32)
open C99ModularReference (Exec ModCall chainOf)
open KeygenModpR2Exec (Slot)
open KeygenMkgm3Program
open KeygenSmallOutput (element)
open MkgmParams198 (Level lognWord half count)
open MkgmSquare199 (Fixed From)
open MkgmScalar199 (rWord r2Word gWord igWord Ready)
open Word32Initialized180 (At)

structure Input (l : Level) (s : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32) : Prop where
  scalarInput : MkgmScalar199.Input l s g p p0i
  fixed : Fixed l s gm igm p p0i
  table : KeygenMkgm3RevMemory.Rev s rev

theorem fixed_after (l : Level) (code : C99ModularReference.Stmt) (s out : State)
    (gm igm : ArrayPointer) (p p0i : BitVec 32) (h : Fixed l s gm igm p p0i)
    (supported : KeygenMkgm3Control.supported code=true)
    (noP : "p".toList∉KeygenMkgm3Control.writes code)
    (noI : "p0i".toList∉KeygenMkgm3Control.writes code)
    (run : Exec code s ⟨out,.normal⟩) : Fixed l out gm igm p p0i := by
  have frame := KeygenMkgm3Control.frame _ _ _ supported run
  have stable := KeygenMemoryStability.modular _ _ _ run
  have size : out.heap.size=s.heap.size := stable.size
  refine ⟨(frame.2.2 _ noP).trans h.pCell,(frame.2.2 _ noI).trans h.iCell,
    ?_,?_,h.gWidth,h.iWidth,?_,?_,?_,?_⟩
  · rw [frame.2.1]; exact h.gBinding
  · rw [frame.2.1]; exact h.iBinding
  · intro j bound; simpa only [Allocated,size] using h.gAllocated j bound
  · intro j bound; simpa only [Allocated,size] using h.iAllocated j bound
  · rw [stable.writable]; exact h.gWritable
  · rw [stable.writable]; exact h.iWritable

theorem row_domain (l : Level) (s out : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32)
    (h : Input l s gm igm rev g p p0i) (ready : Ready l out g p p0i)
    (run : Exec MkgmScalar199.code s ⟨out,.normal⟩) :
    MkgmRows199.Domain l out gm igm rev (gWord l g p p0i) (igWord l g p p0i) p p0i := by
  have fixed := fixed_after l _ s out gm igm p p0i h.fixed (by decide) (by decide) (by decide) run
  exact ⟨ready.gCell,ready.igCell,ready.pCell,ready.iCell,ready.lognCell,
    ⟨some (.uint32 (MkgmControl199.word 12)),ready.kCell⟩,⟨none,ready.uDeclared⟩,
    fixed.gBinding,fixed.iBinding,
    KeygenMkgm3RevMemory.transported _ _ _ rev (by decide) h.table run,
    fixed.gWidth,fixed.iWidth,fixed.gAllocated,fixed.iAllocated,fixed.gWritable,fixed.iWritable⟩

structure Prepared (l : Level) (s : State) (gm igm : ArrayPointer) (p p0i : BitVec 32) : Prop where
  fixed : Fixed l s gm igm p p0i
  initialized : From l s.heap gm igm (half l)
  kCell : Slot s "k" (MkgmControl199.word l.val)
  uType : ∃ old, s.locals "u".toList=some (.uint64,old)
  rCell : Slot s "R" (rWord p)
  r2Cell : Slot s "R2" (r2Word p p0i)
  wDeclared : s.locals "w".toList=some (.uint32,none)

def prepareSteps := [rowSelect,kFromLogn,ifFull]

theorem prepare_source (l : Level) (s : State) (gm igm rev : ArrayPointer) (g ig p p0i : BitVec 32)
    (domain : MkgmRows199.Domain l s gm igm rev g ig p p0i)
    (fixed : Fixed l s gm igm p p0i)
    (rCell : Slot s "R" (rWord p)) (r2Cell : Slot s "R2" (r2Word p p0i))
    (fullCell : Slot s "full" 0) (wDeclared : s.locals "w".toList=some (.uint32,none)) :
    ∃ out, Exec (chainOf prepareSteps) s ⟨out,.normal⟩ ∧ Prepared l out gm igm p p0i := by
  obtain ⟨rows,rowsRun,upper,kType,uType⟩ := MkgmRows199.source l s gm igm rev g ig p p0i domain
  have frame := KeygenMkgm3Control.frame _ _ _ (by decide) rowsRun
  have rowsFixed := fixed_after l _ s rows gm igm p p0i fixed (by decide) (by decide) (by decide) rowsRun
  obtain ⟨old,kDeclared⟩ := kType
  let out := ModularAtoms178.set rows "k" (MkgmControl199.word l.val)
  have kRun : Exec kFromLogn rows ⟨out,.normal⟩ :=
    ModularAtoms178.assign rows "k" old _ _ kDeclared
      (.scalar _ _ (.arithmetic .minus _ _ _ _ _
        (.variable _ _ _ ((frame.2.2 _ (by decide)).trans domain.lognCell))
        (.literal .int32 1) (MkgmControl199.lower_power l)))
  have full : Slot out "full" 0 := (ModularAtoms178.outside rows "k" "full" _ (by decide)).trans
    ((frame.2.2 _ (by decide)).trans fullCell)
  have skipRun : Exec ifFull out ⟨out,.normal⟩ :=
    .branchFalse _ _ _ out _ (.uint32 0) (.variable _ _ _ full) rfl (.base .skip _ _ (.skip _))
  have run : Exec (chainOf prepareSteps) s ⟨out,.normal⟩ :=
    .seqNormal _ _ s rows _ rowsRun (.seqNormal _ _ rows out _ kRun
      (.seqNormal _ _ out out _ skipRun (.base .skip _ _ (.skip _))))
  have allFrame := KeygenMkgm3Control.frame _ _ _ (by decide) run
  refine ⟨out,run,?_,⟩
  exact ⟨fixed_after l _ rows out gm igm p p0i rowsFixed (by decide) (by decide) (by decide) kRun,
    upper,ModularAtoms178.slot rows "k" _,
    ⟨uType.choose,(ModularAtoms178.outside rows "k" "u" _ (by decide)).trans uType.choose_spec⟩,
    (allFrame.2.2 _ (by decide)).trans rCell,(allFrame.2.2 _ (by decide)).trans r2Cell,
    (allFrame.2.2 _ (by decide)).trans wDeclared⟩

theorem top_initialized (l : Level) (s : State) (gm igm : ArrayPointer) (w p p0i r r2 : BitVec 32)
    (old : From l s.heap gm igm 1) :
    ∀ j<count l, At (MkgmTop199.after s gm igm w p p0i r r2).heap (element gm j) ∧
      At (MkgmTop199.after s gm igm w p p0i r r2).heap (element igm j) := by
  intro j bound
  by_cases zero : j=0
  · subst j
    exact ⟨Word32Initialized180.transported _ _ _
      (Word32Initialized180.write_preserves _ _ _)
      (Word32Initialized180.write_initializes s.heap (element gm 0) w),
      Word32Initialized180.write_initializes _ (element igm 0) _⟩
  · have prior := old j (by omega) bound
    have first := Word32Initialized180.write_preserves s.heap (element gm 0) w
    have second := Word32Initialized180.write_preserves (MkgmTop199.withW s gm w).heap (element igm 0)
      (MkgmTop199.inverseWord w p p0i r r2)
    exact ⟨Word32Initialized180.transported _ _ _ second
      (Word32Initialized180.transported _ _ _ first prior.1),
      Word32Initialized180.transported _ _ _ second
        (Word32Initialized180.transported _ _ _ first prior.2)⟩

def finishSteps := squareLoop::topElements

theorem finish_source (l : Level) (s : State) (gm igm : ArrayPointer) (p p0i : BitVec 32)
    (h : Prepared l s gm igm p p0i) :
    ∃ out, Exec (chainOf finishSteps) s ⟨out,.normal⟩ ∧ Fixed l out gm igm p p0i ∧
      ∀ j<count l, At out.heap (element gm j) ∧ At out.heap (element igm j) := by
  obtain ⟨old,uDeclared⟩ := h.uType
  obtain ⟨squared,squareRun,squareFixed,hu,initialized⟩ := MkgmSquareLoop199.full l s gm igm p p0i
    h.fixed h.initialized old uDeclared h.kCell
  have frame := KeygenMkgm3Control.frame _ _ _ (by decide) squareRun
  have bound : 1<count l := by have a:=MkgmParams198.half_range l; unfold count; omega
  obtain ⟨w,read⟩ := Word32Initialized180.load squared.heap (element gm 1)
    (squareFixed.gAllocated 1 bound) squareFixed.gWidth (initialized 1 (by decide) bound).1
  have topRun := MkgmTop199.source l squared gm igm w p p0i (rWord p) (r2Word p p0i) squareFixed
    ((frame.2.2 _ (by decide)).trans h.rCell) ((frame.2.2 _ (by decide)).trans h.r2Cell)
    none ((frame.2.2 _ (by decide)).trans h.wDeclared) read
  let out := MkgmTop199.after squared gm igm w p p0i (rWord p) (r2Word p p0i)
  exact ⟨out,.seqNormal _ _ s squared _ squareRun topRun,
    fixed_after l _ squared out gm igm p p0i squareFixed (by decide) (by decide) (by decide) topRun,
    top_initialized l squared gm igm w p p0i (rWord p) (r2Word p p0i) initialized⟩

theorem source (l : Level) (s : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32)
    (h : Input l s gm igm rev g p p0i) :
    ∃ out, Exec KeygenMkgm3Program.code s ⟨out,.normal⟩ ∧ Fixed l out gm igm p p0i ∧
      ∀ j<count l, At out.heap (element gm j) ∧ At out.heap (element igm j) := by
  obtain ⟨scalar,scalarRun,ready,heapEq,arraysEq⟩ := MkgmScalar199.source l s g p p0i h.scalarInput
  have domain := row_domain l s scalar gm igm rev g p p0i h ready scalarRun
  have scalarFixed := fixed_after l _ s scalar gm igm p p0i h.fixed (by decide) (by decide) (by decide) scalarRun
  obtain ⟨prepared,prepareRun,preparedFacts⟩ := prepare_source l scalar gm igm rev
    (gWord l g p p0i) (igWord l g p p0i) p p0i domain scalarFixed
    ready.rCell ready.r2Cell ready.fullCell ready.wDeclared
  obtain ⟨out,finishRun,outFixed,initialized⟩ := finish_source l prepared gm igm p p0i preparedFacts
  have tail := MkgmSplice199.append ModCall prepareSteps finishSteps scalar prepared ⟨out,.normal⟩ prepareRun finishRun
  have whole := MkgmSplice199.append ModCall (declarations++MkgmScalar199.scalarSteps)
    (prepareSteps++finishSteps) s scalar ⟨out,.normal⟩ scalarRun tail
  refine ⟨out,?_,outFixed,initialized⟩
  simpa only [KeygenMkgm3Program.code,MkgmScalar199.scalarSteps,prepareSteps,finishSteps,
    List.append_assoc,List.cons_append,List.nil_append] using whole

theorem readable (l : Level) (s : State) (gm igm rev : ArrayPointer) (g p p0i : BitVec 32)
    (h : Input l s gm igm rev g p p0i) :
    ∃ out, Exec KeygenMkgm3Program.code s ⟨out,.normal⟩ ∧
      ∀ j<count l, (∃ w, Load32 out.heap (element gm j) w) ∧ (∃ w, Load32 out.heap (element igm j) w) := by
  obtain ⟨out,run,fixed,initialized⟩ := source l s gm igm rev g p p0i h
  exact ⟨out,run,fun j bound =>
    ⟨Word32Initialized180.load out.heap (element gm j) (fixed.gAllocated j bound) fixed.gWidth (initialized j bound).1,
      Word32Initialized180.load out.heap (element igm j) (fixed.iAllocated j bound) fixed.iWidth (initialized j bound).2⟩⟩

end FT1536.Source3.MkgmComplete199
