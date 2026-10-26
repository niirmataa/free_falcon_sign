import Source3.CrtEntry208
import Source3.ZintNormWalkBranch208

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.CrtBody208
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open C99LoopScalar141 (Cell)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open SelectedTopInit178 (p)
open SelectedStepAddPrime195 (p1)
open CrtEntry208 (Input before)
open ZintNormWalkFlat208 (Data)
open KeygenZintCall (Exec)

def modulus : Nat → BitVec 32 := ZintNormTwo207.pair (ZintMulWord205.low p p1) (ZintMulWord205.carry p p1)
 def words (W : Nat → BitVec 32) := ZintNormWalkFlat208.words 2 (CrtCoLoop256206.imageWords W p) modulus

theorem source (s : State) (root tmp : ArrayPointer) (W : Nat → BitVec 32) (input : Input s root tmp)
    (data : Data s root 512 W) :
    ∃ out, Exec (KeygenZintCall.calleeBody .rebuildCrt) s ⟨out,.normal⟩ ∧ Data out root 512 (words W) ∧
      Load32 out.heap tmp (ZintMulWord205.low p p1) ∧
      Load32 out.heap (ZintAddMulWord205.next tmp) (ZintMulWord205.carry p p1) ∧ Cell out "u".toList 256 ∧
      out.arrays "x".toList=some (ZintNormWalkIncrement208.row root 2 256) ∧
      (∀ name : Name, name≠"u".toList → out.locals name=s.locals name) ∧
      (∀ name : Name, name≠"x".toList → out.arrays name=s.arrays name) ∧
      (∀ q old, (∀ i, i < 512 → Separate (elem root i) q) → Separate tmp q →
        Separate (ZintAddMulWord205.next tmp) q → Load32 s.heap q old → Load32 out.heap q old) := by
  have ready:=CrtEntry208.round_input s root tmp input
  have lenBefore : Cell (before s tmp) "xlen".toList 2 :=
    (CrtEntry208.locals s tmp "xlen".toList (by decide)).trans input.lenCell
  obtain ⟨co,coRun,coData,lo,hi,coU,_,coLocals,coArrays,coKeep⟩:=
    CrtCoLoop256206.source (before s tmp) root tmp W p ready lenBefore (CrtEntry208.data_after s root tmp W input data)
  have stable:=KeygenMemoryStability.zint _ _ _ coRun
  have hl (name : Name) (nu : name≠"u".toList) : co.locals name=s.locals name :=
    (coLocals name nu).trans (CrtEntry208.locals s tmp name nu)
  have ha (name : Name) (nx : name≠"x".toList) : co.arrays name=s.arrays name :=
    (coArrays name nx).trans (CrtEntry208.arrays s tmp name nx)
  have normFixed : ZintNormWalkFixed208.Fixed co root tmp 256 2 modulus := by
    refine ⟨by decide,by decide,by decide,input.width,input.capacity,?_,?_,?_,?_,?_,?_,?_,?_⟩
    · rw [stable.writable]
      exact input.writable
    · exact (ha "tmp".toList (by decide)).trans input.tmpBinding
    · exact (hl "num".toList (by decide)).trans input.numCell
    · exact (hl "xlen".toList (by decide)).trans input.lenCell
    · exact (hl "xstride".toList (by decide)).trans input.strideCell
    · have h:=input.tmpCapacity; omega
    · intro j bound
      have index : j=0 ∨ j=1 := by omega
      rcases index with h|h <;> subst j
      · exact lo
      · exact hi
    · intro i j k ib jb kb
      exact input.apart (i*2+j) k (ZintNormWalkFlat208.index_bound 256 2 i j ib jb) kb
  have xx : co.arrays "xx".toList=some root := (ha "xx".toList (by decide)).trans input.xxBinding
  have sign : co.locals "normalize_signed".toList=some (.int32,some (.int32 1)) :=
    (hl "normalize_signed".toList (by decide)).trans input.signCell
  obtain ⟨out,normRun,outFixed,outU,outX,outData,outLocals,outArrays,normKeep⟩:=
    ZintNormWalkBranch208.source co root tmp 256 2 (CrtCoLoop256206.imageWords W p) modulus (C99NatWord141.word 2)
      normFixed coU xx sign coData
  obtain ⟨declU,declX,store,head⟩:=CrtEntry208.prefix_source s root tmp input
  have core : Exec MakeFgCrtShape194.crtCore (ZintRebuildCrt194.d4 s tmp p) ⟨co,.normal⟩ := by
    rw [ZintRebuildCrt194.core_split]
    exact .seqNormal _ _ _ _ _ head coRun
  have whole : Exec (KeygenZintCall.calleeBody .rebuildCrt) s ⟨out,.normal⟩ := by
    change Exec MakeFgCrtShape194.crtBody s ⟨out,.normal⟩
    rw [MakeFgCrtShape194.crt_split1,MakeFgCrtShape194.crt_split2,MakeFgCrtShape194.crt_split3,MakeFgCrtShape194.crt_split4]
    exact .seqNormal _ _ _ _ _ declU (.seqNormal _ _ _ _ _ declX (.seqNormal _ _ _ _ _ store (.seqNormal _ _ _ _ _ core normRun)))
  refine ⟨out,whole,outData,outFixed.pRead 0 (by decide),outFixed.pRead 1 (by decide),outU,outX,?_,?_,?_⟩
  · intro name different
    exact (outLocals name different).trans (hl name different)
  · intro name different
    exact (outArrays name different).trans (ha name different)
  · intro q old rootApart tmpApart highApart read
    have beforeRead : Load32 (before s tmp).heap q old := Word32Memory176.outside _ _ _ _ _ tmpApart read
    have coApart : ∀ i : Fin 256, Separate (CrtWalkIncrement206.cell root i.val) q ∧ Separate (CrtWalkFixed206.high root i.val) q := by
      intro i
      have bound:=i.isLt
      refine ⟨rootApart (2*i.val) (by omega),?_⟩
      rw [CrtWalkFixed206.high_eq]
      exact rootApart (2*i.val+1) (by omega)
    exact normKeep q old rootApart (coKeep q old coApart tmpApart highApart beforeRead)

end FT1536.Source3.CrtBody208
