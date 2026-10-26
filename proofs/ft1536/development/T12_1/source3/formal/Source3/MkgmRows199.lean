import Source3.MkgmRowPreludeFacts199
import Source3.MkgmTop199

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.MkgmRows199
open C99ArrayReference (State restoreScope)
open C99MemoryReference (ArrayPointer Allocated)
open C99ModularReference (Exec ModCall chainOf)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot)
open KeygenSmallOutput (element)
open MkgmParams198 (Level logn lognWord half count shiftWord)
open MkgmRowLoop198 (Upper)

structure Domain (l : Level) (s : State) (gm igm rev : ArrayPointer) (g ig p p0i : BitVec 32) : Prop where
  gCell : Slot s "g" g
  igCell : Slot s "ig" ig
  pCell : Slot s "p" p
  iCell : Slot s "p0i" p0i
  lognCell : Slot s "logn" (lognWord l)
  kType : ∃ old, s.locals "k".toList=some (.uint32,old)
  uType : ∃ old, s.locals "u".toList=some (.uint64,old)
  gBinding : s.arrays "gm".toList=some gm
  iBinding : s.arrays "igm".toList=some igm
  table : KeygenMkgm3RevMemory.Rev s rev
  gWidth : gm.elementBytes=4
  iWidth : igm.elementBytes=4
  gAllocated : ∀ j<count l, Allocated s.heap (element gm j)
  iAllocated : ∀ j<count l, Allocated s.heap (element igm j)
  gWritable : s.heap.writable gm.block=true
  iWritable : s.heap.writable igm.block=true

def names : List C99ArrayReference.Name := ["x","ix","g2","g4","ig2","ig4","b"].map String.toList

theorem else_shape : KeygenMkgm3Program.elseRow=.scope names
    (chainOf (KeygenMkgm3RowInit.rowPrelude++[KeygenMkgm3Program.lastRowLoop])) := rfl

theorem logn_compare (l : Level) : C99IntegerReference.CompareExec .eq (.uint32 (lognWord l)) (.int32 1)
    (C99ScalarReference.boolean (decide (l.val=0))) := by
  have raw := C99IntegerReference.CompareExec.step .eq (.uint32 (lognWord l)) (.int32 1) .uint32 rfl
    (.uint32 (lognWord l)) (.uint32 1) (C99CountedWords.convert_self (.uint32 (lognWord l))).symm rfl
  change C99IntegerReference.CompareExec .eq (.uint32 (lognWord l)) (.int32 1)
    (C99ScalarReference.boolean (decide ((C99IntegerReference.Value.uint32 (lognWord l)).integer=
      (C99IntegerReference.Value.uint32 1).integer))) at raw
  have one : (C99IntegerReference.Value.uint32 1).integer=(1:Int) := by decide
  rw [MkgmParams198.logn_integer l,one] at raw
  have same : ((logn l:Int)=1)↔l.val=0 := by unfold logn; omega
  simpa only [same] using raw

theorem fixed (l : Level) (s : State) (gm igm rev : ArrayPointer) (g ig p p0i : BitVec 32)
    (h : Domain l s gm igm rev g ig p p0i) :
    MkgmRowFixed198.Fixed l (MkgmRowPrelude199.after l s g ig p p0i) gm igm rev p p0i
      (Gen0RowPrelude189.square g p p0i) (Gen0RowPrelude189.fourth g p p0i)
      (Gen0RowPrelude189.square ig p p0i) (Gen0RowPrelude189.fourth ig p p0i) := by
  let input : MkgmRowPrelude199.Input l s g ig p p0i := ⟨h.gCell,h.igCell,h.pCell,h.iCell,h.lognCell,h.kType⟩
  have pre := MkgmRowPreludeFacts199.source l s g ig p p0i input
  have arrays := MkgmRowPreludeFacts199.arrays l s g ig p p0i input
  have heap := MkgmRowPreludeFacts199.heap l s g ig p p0i input
  refine ⟨MkgmRowPreludeFacts199.p_cell l s g ig p p0i input,
    MkgmRowPreludeFacts199.i_cell l s g ig p p0i input,
    MkgmRowPreludeFacts199.g2_cell l s g ig p p0i,MkgmRowPreludeFacts199.g4_cell l s g ig p p0i,
    MkgmRowPreludeFacts199.ig2_cell l s g ig p p0i,MkgmRowPreludeFacts199.ig4_cell l s g ig p p0i,
    MkgmRowPreludeFacts199.k_cell l s g ig p p0i,MkgmRowPreludeFacts199.b_cell l s g ig p p0i,
    ?_,?_,KeygenMkgm3RevMemory.transported _ _ _ rev (by decide) h.table pre,
    h.gWidth,h.iWidth,?_,?_,?_,?_⟩
  · rw [arrays]; exact h.gBinding
  · rw [arrays]; exact h.iBinding
  · intro j bound; rw [heap]; exact h.gAllocated j bound
  · intro j bound; rw [heap]; exact h.iAllocated j bound
  · rw [heap]; exact h.gWritable
  · rw [heap]; exact h.iWritable

theorem source_else (l : Level) (positive : 0<l.val) (s : State) (gm igm rev : ArrayPointer)
    (g ig p p0i : BitVec 32) (h : Domain l s gm igm rev g ig p p0i) :
    ∃ out, Exec KeygenMkgm3Program.elseRow s ⟨out,.normal⟩ ∧ Upper l out.heap gm igm ∧
      (∃ old, out.locals "k".toList=some (.uint32,old)) ∧
      (∃ old, out.locals "u".toList=some (.uint64,old)) := by
  let input : MkgmRowPrelude199.Input l s g ig p p0i := ⟨h.gCell,h.igCell,h.pCell,h.iCell,h.lognCell,h.kType⟩
  let pre := MkgmRowPrelude199.after l s g ig p p0i
  obtain ⟨old,uType⟩ := h.uType
  have preU : pre.locals "u".toList=some (.uint64,old) :=
    (MkgmRowPreludeFacts199.u_cell l s g ig p p0i input).trans uType
  obtain ⟨out,x,ix,loopRun,outFixed,hx,hi,hu,initialized⟩ := MkgmRowLoop198.full l positive pre gm igm rev p p0i
    (Gen0RowPrelude189.square g p p0i) (Gen0RowPrelude189.fourth g p p0i)
    (Gen0RowPrelude189.square ig p p0i) (Gen0RowPrelude189.fourth ig p p0i) g ig
    (fixed l s gm igm rev g ig p p0i h)
    (MkgmRowPreludeFacts199.x_cell l s g ig p p0i) (MkgmRowPreludeFacts199.ix_cell l s g ig p p0i) old preU
  let restored := restoreScope s out names []
  have inner : Exec (chainOf (KeygenMkgm3RowInit.rowPrelude++[KeygenMkgm3Program.lastRowLoop]))
      s ⟨out,.normal⟩ :=
    ModularSequence178.source ModCall KeygenMkgm3RowInit.rowPrelude s pre
      (MkgmRowPrelude199.source l s g ig p p0i input) [KeygenMkgm3Program.lastRowLoop] _
      (.seqNormal _ _ pre out _ loopRun (.base .skip _ _ (.skip _)))
  have source : Exec KeygenMkgm3Program.elseRow s ⟨restored,.normal⟩ := by
    rw [else_shape]
    exact .scope names _ s ⟨out,.normal⟩ inner
  have keepK : restored.locals "k".toList=out.locals "k".toList := by
    simp [restored,restoreScope,C99ScalarReference.restore,names]
  have keepU : restored.locals "u".toList=out.locals "u".toList := by
    simp [restored,restoreScope,C99ScalarReference.restore,names]
  exact ⟨restored,source,initialized,
    ⟨some (.uint32 (shiftWord l)),keepK.trans outFixed.kCell⟩,
    ⟨some (.uint64 (C99NatWord141.word (half l))),keepU.trans hu⟩⟩

def first (s : State) (gm : ArrayPointer) (g : BitVec 32) : State :=
  {s with heap:=Word32Memory176.write s.heap (element gm 1) g}
def both (s : State) (gm igm : ArrayPointer) (g ig : BitVec 32) : State :=
  {first s gm g with heap:=Word32Memory176.write (first s gm g).heap (element igm 1) ig}

theorem source_one (s : State) (gm igm rev : ArrayPointer) (g ig p p0i : BitVec 32)
    (h : Domain 0 s gm igm rev g ig p p0i) :
    Exec KeygenMkgm3Program.thenOne s ⟨both s gm igm g ig,.normal⟩ ∧
      Upper 0 (both s gm igm g ig).heap gm igm := by
  have gRun : Exec (.store32 "gm".toList (KeygenMkgm3Program.num 1) (KeygenMkgm3Program.cell "g"))
      s ⟨first s gm g,.normal⟩ :=
    .store32 _ _ _ s (first s gm g).heap (element gm 1) (.uint32 g)
      (GeneratorTablePointer181.literal s "gm" gm 1 (by decide) h.gBinding (h.gAllocated 1 (by decide)))
      (ModularAtoms178.cell s "g" g h.gCell)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
        BitVec.setWidth_eq,first] using (Word32Memory176.source s.heap (element gm 1) g
          (h.gAllocated 1 (by decide)) h.gWidth h.gWritable))
  have iRun : Exec (.store32 "igm".toList (KeygenMkgm3Program.num 1) (KeygenMkgm3Program.cell "ig"))
      (first s gm g) ⟨both s gm igm g ig,.normal⟩ :=
    .store32 _ _ _ (first s gm g) (both s gm igm g ig).heap (element igm 1) (.uint32 ig)
      (GeneratorTablePointer181.literal _ "igm" igm 1 (by decide) h.iBinding (h.iAllocated 1 (by decide)))
      (ModularAtoms178.cell _ "ig" ig h.igCell)
      (by simpa only [C99IntegerReference.Value.integer,BitVec.ofInt_natCast,BitVec.ofNat_toNat,
        BitVec.setWidth_eq,both] using (Word32Memory176.source (first s gm g).heap (element igm 1) ig
          (h.iAllocated 1 (by decide)) h.iWidth h.iWritable))
  have run := C99ModularReference.GenExec.scope [] _ s ⟨both s gm igm g ig,.normal⟩
    (.seqNormal _ _ s (first s gm g) _ gRun (.seqNormal _ _ (first s gm g) (both s gm igm g ig) _ iRun
      (.base .skip _ _ (.skip _))))
  refine ⟨?_,?_⟩
  · simpa only [KeygenMkgm3Program.thenOne,chainOf,KeygenPublicForwardCall.restore_empty] using run
  · intro j lower upper
    have same : j=1 := by change 1≤j at lower; change j<2 at upper; omega
    subst j
    exact ⟨Word32Initialized180.transported _ _ _
        (Word32Initialized180.write_preserves (first s gm g).heap (element igm 1) ig)
        (Word32Initialized180.write_initializes s.heap (element gm 1) g),
      Word32Initialized180.write_initializes (first s gm g).heap (element igm 1) ig⟩

theorem source (l : Level) (s : State) (gm igm rev : ArrayPointer) (g ig p p0i : BitVec 32)
    (h : Domain l s gm igm rev g ig p p0i) :
    ∃ out, Exec KeygenMkgm3Program.rowSelect s ⟨out,.normal⟩ ∧ Upper l out.heap gm igm ∧
      (∃ old, out.locals "k".toList=some (.uint32,old)) ∧
      (∃ old, out.locals "u".toList=some (.uint64,old)) := by
  have guard : C99ArrayReference.scalar s KeygenMkgm3Program.lognOne
      (C99ScalarReference.boolean (decide (l.val=0))) :=
    .compare .eq _ _ _ _ _ (.variable _ _ _ h.lognCell) (.literal .int32 1) (logn_compare l)
  by_cases one : l.val=0
  · have equal : l=0 := Fin.ext one
    subst l
    obtain ⟨run,initialized⟩ := source_one s gm igm rev g ig p p0i h
    have yes : C99ArrayReference.scalar s KeygenMkgm3Program.lognOne (.int32 1) := by
      simpa [C99ScalarReference.boolean] using guard
    exact ⟨both s gm igm g ig,.branchTrue _ _ _ s _ (.int32 1) yes (by decide) run,
      initialized,h.kType,h.uType⟩
  · obtain ⟨out,run,initialized,kType,uType⟩ := source_else l (by omega) s gm igm rev g ig p p0i h
    have no : C99ArrayReference.scalar s KeygenMkgm3Program.lognOne (.int32 0) := by
      simpa [one,C99ScalarReference.boolean] using guard
    exact ⟨out,.branchFalse _ _ _ s _ (.int32 0) no rfl run,initialized,kType,uType⟩

end FT1536.Source3.MkgmRows199
