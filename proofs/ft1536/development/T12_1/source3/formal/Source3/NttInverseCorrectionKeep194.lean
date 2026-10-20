import Source3.NttInverseCorrectionInit192
import Source3.NttInverseCorrectionLoopKeep194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Keep-threaded re-composition of the whole corrective scaling statement
   of the accepted modp_iNTT3_ext corpus (NttInversePrograms192.correction
   at n = 512): the setNi/uInit prefix is heap-free and the scaleLoop is
   the only writer, so the per-cell bystander keep of
   NttInverseCorrectionLoopKeep194 (the shape
   NttInverseMiddleRounds192.source exports) lifts through the whole
   correction statement, together with the writable transport. Values
   stay executed words; no numerical property is assumed. -/
namespace FT1536.Source3.NttInverseCorrectionKeep194
open C99ArrayReference (State Name)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open C99IntegerReference (Value)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open NttInverseCorrection192 (niWord setR setNi)
open NttInverseCorrectionLoop192 (walk scale Image Fixed)
open NttInverseCorrectionSource192 (started started_u started_r1 setNi_outside)

theorem heap_free (s : State) (a : ArrayPointer) (stride : Nat) (p p0i : BitVec 32) :
    (started (setNi s p p0i) a stride).heap=s.heap := rfl

theorem source (s : State) (a : ArrayPointer) (stride : Nat) (p p0i : BitVec 32)
    (fv : Nat → BitVec 32) (old : Option Value)
    (rDeclared : s.locals "R".toList=some (.uint32,none))
    (niDeclared : s.locals "ni".toList=some (.uint32,none))
    (uDeclared : s.locals "u".toList=some (.uint64,old))
    (pc : Slot s "p" p) (ic : Slot s "p0i" p0i) (nCell : USlot s "n" 512)
    (aBinding : s.arrays "a".toList=some a) (capacity : a.index≤a.count)
    (fixed : Fixed (started (setNi s p p0i) a stride) a stride 512 p p0i (niWord p p0i) fv)
    (image : Image (started (setNi s p p0i) a stride) a stride 512 p p0i (niWord p p0i) fv 0) :
    ∃ after, Exec NttInversePrograms192.correction s ⟨after,.normal⟩ ∧
      Fixed after a stride 512 p p0i (niWord p p0i) fv ∧
      Image after a stride 512 p p0i (niWord p p0i) fv 512 ∧
      Cell after "u".toList 512 ∧
      after.arrays "r1".toList=some (walk a 512 stride) ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < 512 → Separate (walk a x stride) q) →
        ∀ z : BitVec 32, Load32 s.heap q z → Load32 after.heap q z) ∧
      after.heap.writable=s.heap.writable := by
  have rRun : Exec NttInversePrograms192.rAssign s ⟨setR s p,.normal⟩ :=
    NttInverseCorrection192.r_run s p pc rDeclared
  have niRun : Exec NttInversePrograms192.niAssign (setR s p) ⟨setNi s p p0i,.normal⟩ :=
    NttInverseCorrection192.ni_run s p p0i pc ic nCell niDeclared
  have uAfter : (setNi s p p0i).locals "u".toList=some (.uint64,old) :=
    (setNi_outside s p p0i "u" (by decide) (by decide)).trans uDeclared
  have aAfter : (setNi s p p0i).arrays "a".toList=some a := aBinding
  have initRun : Exec NttInversePrograms192.cInit (setNi s p p0i)
      ⟨started (setNi s p p0i) a stride,.normal⟩ :=
    NttInverseCorrectionInit192.init_run (setNi s p p0i) a stride old uAfter aAfter capacity
  obtain ⟨after,loopRun,loopFixed,loopCell,loopX,loopImage,_,_,loopKeep,loopWritable⟩ :=
    NttInverseCorrectionLoopKeep194.remaining 512 0 (started (setNi s p p0i) a stride) a stride 512
      p p0i (niWord p p0i) fv fixed (started_u _ _ _) (started_r1 _ _ _) image (by omega)
  have cLoopRun : Exec NttInversePrograms192.cLoop (setNi s p p0i) ⟨after,.normal⟩ :=
    .seqNormal _ _ (setNi s p p0i) (started (setNi s p p0i) a stride) ⟨after,.normal⟩
      initRun loopRun
  refine ⟨after,?_,loopFixed,loopImage,loopCell,loopX,?_,?_⟩
  · exact .seqNormal _ _ s (setR s p) _ rRun
      (.seqNormal _ _ (setR s p) (setNi s p p0i) _ niRun
        (.seqNormal _ _ (setNi s p p0i) after _ cLoopRun (.base _ _ _ (.skip _))))
  · intro q separate z load
    have step : Load32 (started (setNi s p p0i) a stride).heap q z := load
    exact loopKeep q separate z step
  · exact loopWritable.trans rfl

end FT1536.Source3.NttInverseCorrectionKeep194
