import Source3.NttForwardMloop211

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttForwardWhole211
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot u64)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open CrtState205 (set64)
open C99NatWord141 (word)
open Word32Memory176 (Separate)
open StepCopyBody190 (elem)
open MkgmParams198 (Level count half lognWord)
open NttForwardMiddle211 (MFixed)
open NttForwardImage211 (Image)

def withT (l : Level) (s : State) := set64 s "t" (word (half l))
 def started (l : Level) (s : State) := set64 (withT l s) "m" (word 2)
 def words (l : Level) (fv gvs : Fin (count l) → BitVec 32) (p pi : BitVec 32) :=
  NttForwardMloop211.walkWords gvs l.val 2 (half l)
    (NttForwardFirst211.firstWords l fv (gvs ⟨1,by have h:=MkgmParams198.half_range l; unfold count; omega⟩) p pi) p pi

theorem half_count (l : Level) : count l/2=half l := by change 2*half l/2=half l; omega

theorem start_fixed (l : Level) (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32) (p pi : BitVec 32)
    (fixed : MFixed (size:=count l) s a gm gvs p pi) : MFixed (size:=count l) (started l s) a gm gvs p pi :=
  NttForwardMiddle211.fixed_map s a gm gvs p pi fixed (started l s)
    (by simp [started,withT,CrtState205.set64,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [started,withT,CrtState205.set64,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [started,withT,CrtState205.set64,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [started,withT,CrtState205.set64,C99ArrayReference.bindValue,C99ScalarReference.set])
    (by simp [started,withT,CrtState205.set64,C99ArrayReference.bindValue,C99ScalarReference.set]) rfl rfl rfl

theorem tail_source (l : Level) (s : State) (a gm : ArrayPointer) {gmn : Nat} (gvs : Fin gmn → BitVec 32) (p pi : BitVec 32)
    (W : Nat → BitVec 32) (wide : count l ≤ gmn) (fixed : MFixed (size:=count l) s a gm gvs p pi)
    (image : Image (size:=count l) s a W) (tFree : s.locals "t".toList=some (.uint64,none))
    (mFree : s.locals "m".toList=some (.uint64,none)) (uc : Cell s "u".toList (half l)) :
    ∃ out, Exec StepNttBody195.tailT s ⟨out,.normal⟩ ∧ MFixed (size:=count l) out a gm gvs p pi ∧
      USlot out "m" (count l) ∧ USlot out "t" 1 ∧ Cell out "u".toList (half l) ∧
      NttWriteFrame182.Frame a (count l) s.heap out.heap ∧
      Image (size:=count l) out a (NttForwardMloop211.walkWords gvs l.val 2 (half l) W p pi) := by
  have hn : USlot s "hn" (half l) := by simpa only [half_count] using fixed.hnSlot
  have trun : Exec KeygenNttForwardPrograms.tFromHalf s ⟨withT l s,.normal⟩ :=
    .assign _ _ _ .uint64 none (u64 (half l)) tFree (.scalar _ _ (.variable _ _ _ hn))
  have mf : (withT l s).locals "m".toList=some (.uint64,none) :=
    (CrtState205.keep64 s "t" "m" (word (half l)) (by decide)).trans mFree
  have mrun : Exec KeygenNttForwardPrograms.mInit (withT l s) ⟨started l s,.normal⟩ :=
    .assign _ _ _ .uint64 none (.int32 2) mf (.scalar _ _ (.literal .int32 2))
  have tc : USlot (started l s) "t" (half l) :=
    (CrtState205.keep64 (withT l s) "m" "t" (word 2) (by decide)).trans (CrtState205.cell64 _ _ _)
  have mc : USlot (started l s) "m" 2 := CrtState205.cell64 _ _ _
  have ustart : Cell (started l s) "u".toList (half l) :=
    (CrtState205.keep64 (withT l s) "m" "u" (word 2) (by decide)).trans
      ((CrtState205.keep64 s "t" "u" (word (half l)) (by decide)).trans uc)
  obtain ⟨out,walk,finalFixed,finalM,finalT,frame,finalImage⟩:=NttForwardMloop211.source l.val 2 (half l)
    (NttForwardMloop211.plan l) (started l s) a gm gvs p pi W wide (start_fixed l s a gm gvs p pi fixed)
    (NttForwardImage211.image_keep image rfl) mc tc
  have finalU : Cell out "u".toList (half l) := KeygenNttControl.keep_u64 walk (by decide) "u" (half l) (by decide) ustart
  have triple:=StepNttMloop195.triple_skip out finalFixed.fullSlot
  have run : Exec StepNttBody195.tailT s ⟨out,.normal⟩ :=
    .seqNormal _ _ _ _ _ trun (.seqNormal _ _ _ _ _ (.seqNormal _ _ _ _ _ mrun walk) triple)
  exact ⟨out,run,finalFixed,finalM,finalT,finalU,frame,finalImage⟩

theorem source (l : Level) (s : State) (a gm : ArrayPointer) (fv gvs : Fin (count l) → BitVec 32) (p pi : BitVec 32)
    (logn : Slot s "logn" (lognWord l)) (full : Slot s "full" 0) (stride : Cell s "stride".toList 1)
    (pc : Slot s "p" p) (ic : Slot s "p0i" pi) (ab : s.arrays "a".toList=some a) (gb : s.arrays "gm".toList=some gm)
    (width : a.elementBytes=4) (capacity : a.index+count l ≤ a.count) (writable : s.heap.writable a.block=true)
    (separate : ∀ i j : Fin (count l), Separate (elem gm i.val) (elem a j.val))
    (gloads : ∀ i : Fin (count l), C99MemoryReference.Load32 s.heap (elem gm i.val) (gvs i))
    (data : ∀ j : Fin (count l), C99MemoryReference.Load32 s.heap (elem a j.val) (fv j)) :
    ∃ out, Exec KeygenNttForwardPrograms.forwardBody s ⟨out,.normal⟩ ∧
      Image (size:=count l) out a (words l fv gvs p pi) ∧ NttWriteFrame182.Frame a (count l) s.heap out.heap ∧
      USlot out "m" (count l) ∧ USlot out "t" 1 ∧ Cell out "u".toList (half l) := by
  obtain ⟨first,firstRun,firstFixed,firstImage,firstU,_,firstFull,mFree,tFree,firstFrame⟩:=
    NttForwardFirst211.source l s a gm fv gvs p pi logn full stride pc ic ab gb width capacity writable separate gloads data
  have fixed : MFixed (size:=count l) first a gm gvs p pi := by
    refine ⟨firstFixed.pSlot,firstFixed.p0iSlot,firstFull,?_,firstFixed.strideCell,firstFixed.aBinding,firstFixed.gmBinding,
      width,capacity,firstFixed.aWritable,?_,?_,firstFixed.gmLoads,?_⟩
    · change Cell first "hn".toList (count l/2)
      rw [half_count]
      exact firstFixed.hnCell
    · intro j bound
      exact ⟨_,firstImage j bound⟩
    · intro i j bound
      exact firstFixed.gmSeparate i ⟨j,bound⟩
    · have range:=MkgmParams198.half_range l
      unfold count
      omega
  obtain ⟨out,tail,_,finalM,finalT,finalU,frame,image⟩:=tail_source l first a gm gvs p pi _ (Nat.le_refl _) fixed
    firstImage tFree mFree firstU
  exact ⟨out,StepNttFirstLoop195.prefix_continue s first ⟨out,.normal⟩ firstRun tail,image,
    NttWriteFrame182.trans a (count l) _ _ _ firstFrame frame,finalM,finalT,finalU⟩

end FT1536.Source3.NttForwardWhole211
