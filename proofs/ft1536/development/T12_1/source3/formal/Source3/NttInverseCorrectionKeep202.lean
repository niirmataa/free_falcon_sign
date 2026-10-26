import Source3.NttInverseCorrectionInit201
import Source3.NttInverseCorrectionKeep194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseCorrectionKeep202
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open NttInverseCorrection192 (setR)
open NttInverseCorrection201 (niWord setNi)
open MkgmParams198 (Level)
open NttInverseSchedule201 (size)
open NttInverseCorrectionLoop192 (walk scale Image Fixed)
open NttInverseCorrectionSource192 (started started_u started_r1)
open NttInverseCorrectionSource201 (setNi_outside)

theorem heap_free (l : Level) (s : State) (a : ArrayPointer) (stride : Nat) (p p0i : BitVec 32) :
    (started (setNi l s p p0i) a stride).heap=s.heap := rfl

theorem source (l : Level) (s : State) (a : ArrayPointer) (stride : Nat) (p p0i : BitVec 32)
    (fv : Nat → BitVec 32) (old : Option Value)
    (rDeclared : s.locals "R".toList=some (.uint32,none))
    (niDeclared : s.locals "ni".toList=some (.uint32,none))
    (uDeclared : s.locals "u".toList=some (.uint64,old))
    (pc : Slot s "p" p) (ic : Slot s "p0i" p0i) (nCell : USlot s "n" (size l))
    (aBinding : s.arrays "a".toList=some a) (capacity : a.index≤a.count)
    (fixed : Fixed (started (setNi l s p p0i) a stride) a stride (size l) p p0i (niWord l p p0i) fv)
    (image : Image (started (setNi l s p p0i) a stride) a stride (size l) p p0i (niWord l p p0i) fv 0) :
    ∃ after, Exec NttInversePrograms192.correction s ⟨after,.normal⟩ ∧
      Fixed after a stride (size l) p p0i (niWord l p p0i) fv ∧
      Image after a stride (size l) p p0i (niWord l p p0i) fv (size l) ∧
      Cell after "u".toList (size l) ∧
      after.arrays "r1".toList=some (walk a (size l) stride) ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < (size l) → Separate (walk a x stride) q) →
        ∀ z : BitVec 32, Load32 s.heap q z → Load32 after.heap q z) ∧
      after.heap.writable=s.heap.writable := by
  have rRun : Exec NttInversePrograms192.rAssign s ⟨setR s p,.normal⟩ :=
    NttInverseCorrection192.r_run s p pc rDeclared
  have niRun : Exec NttInversePrograms192.niAssign (setR s p) ⟨setNi l s p p0i,.normal⟩ :=
    NttInverseCorrection201.ni_run l s p p0i pc ic nCell niDeclared
  have uAfter : (setNi l s p p0i).locals "u".toList=some (.uint64,old) :=
    (setNi_outside l s p p0i "u" (by decide) (by decide)).trans uDeclared
  have aAfter : (setNi l s p p0i).arrays "a".toList=some a := aBinding
  have initRun : Exec NttInversePrograms192.cInit (setNi l s p p0i)
      ⟨started (setNi l s p p0i) a stride,.normal⟩ :=
    NttInverseCorrectionInit192.init_run (setNi l s p p0i) a stride old uAfter aAfter capacity
  obtain ⟨after,loopRun,loopFixed,loopCell,loopX,loopImage,_,_,loopKeep,loopWritable⟩ :=
    NttInverseCorrectionLoopKeep194.remaining (size l) 0 (started (setNi l s p p0i) a stride) a stride (size l)
      p p0i (niWord l p p0i) fv fixed (started_u _ _ _) (started_r1 _ _ _) image (by omega)
  have cLoopRun : Exec NttInversePrograms192.cLoop (setNi l s p p0i) ⟨after,.normal⟩ :=
    .seqNormal _ _ (setNi l s p p0i) (started (setNi l s p p0i) a stride) ⟨after,.normal⟩
      initRun loopRun
  refine ⟨after,?_,loopFixed,loopImage,loopCell,loopX,?_,?_⟩
  · exact .seqNormal _ _ s (setR s p) _ rRun
      (.seqNormal _ _ (setR s p) (setNi l s p p0i) _ niRun
        (.seqNormal _ _ (setNi l s p p0i) after _ cLoopRun (.base _ _ _ (.skip _))))
  · intro q separate z load
    have step : Load32 (started (setNi l s p p0i) a stride).heap q z := load
    exact loopKeep q separate z step
  · exact loopWritable.trans rfl

end FT1536.Source3.NttInverseCorrectionKeep202
