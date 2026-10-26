import Source3.NttInverseFinal201
import Source3.NttInverseFinalPassKeep194

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttInverseFinalKeep202
open C99ArrayReference (State Name bindPointer bindValue)
open C99MemoryReference (ArrayPointer Load32)
open Word32Memory176 (Separate)
open C99ModularReference (Exec)
open KeygenNttLoopSupport (USlot)
open KeygenModpR2Exec (Slot)
open C99LoopScalar141 (Cell)
open NttInverseCorrectionLoop192 (walk)
open NttInverseFinalLoop192 (Image Fixed)
open NttInverseFinalPass192 (setW mid started w_run u_run r1_run r2_run started_u started_r1
  started_r2)

theorem heap_free (s : State) (w : BitVec 32) (a : ArrayPointer) (stride hn : Nat) :
    (started s w a stride hn).heap=s.heap := rfl

theorem source (s : State) (a igm : ArrayPointer) (stride hn : Nat) (p p0i w : BitVec 32)
    (fv : Nat → BitVec 32)
    (wDeclared : s.locals "w".toList=some (.uint32,none))
    (uDeclared : s.locals "u".toList=some (.uint64,none))
    (hnCell : USlot s "hn" hn) (strideCell : USlot s "stride" stride)
    (hnBound : hn<2^64) (strideBound : stride<2^64) (wide : hn*stride<2^64)
    (igmBinding : s.arrays "igm".toList=some igm) (igmCapacity : igm.index ≤ igm.count)
    (wRead : Load32 s.heap igm w)
    (aBinding : s.arrays "a".toList=some a) (capacity : a.index≤a.count)
    (aCapacity : a.index+hn*stride≤a.count)
    (fixed : Fixed (started s w a stride hn) a stride hn p p0i w fv)
    (image : Image (started s w a stride hn) a stride hn w p p0i fv 0) :
    ∃ after, Exec NttInversePrograms192.finalPass s ⟨after,.normal⟩ ∧
      Fixed after a stride hn p p0i w fv ∧
      Image after a stride hn w p p0i fv hn ∧
      Cell after "u".toList hn ∧
      after.arrays "r1".toList=some (walk a hn stride) ∧
      after.arrays "r2".toList=some (walk a (hn+hn) stride) ∧
      (∀ q : ArrayPointer, (∀ x : Nat, x < (2*hn) → Separate (walk a x stride) q) →
        ∀ z : BitVec 32, Load32 s.heap q z → Load32 after.heap q z) ∧
      after.heap.writable=s.heap.writable := by
  have wRun : Exec NttInversePrograms192.wAssign s ⟨setW s w,.normal⟩ :=
    w_run s igm w wDeclared igmBinding igmCapacity wRead
  have uAfter : (setW s w).locals "u".toList=some (.uint64,none) :=
    (ModularAtoms178.outside s "w" "u" w (by decide)).trans uDeclared
  have uRun : Exec NttInversePrograms192.uInit (setW s w)
      ⟨bindValue (setW s w) "u".toList .uint64 (.int32 0),.normal⟩ :=
    u_run s w uAfter
  have r1Run : Exec NttInversePrograms192.r1Init
      (bindValue (setW s w) "u".toList .uint64 (.int32 0)) ⟨mid s w a stride,.normal⟩ :=
    r1_run s w a stride aBinding capacity
  have r2Run : Exec NttInversePrograms192.r2Init (mid s w a stride)
      ⟨started s w a stride hn,.normal⟩ :=
    r2_run s w a stride hn hnCell strideCell hnBound strideBound wide aBinding aCapacity
  have initRun : Exec (.seq NttInversePrograms192.uInit
      (.seq NttInversePrograms192.r1Init NttInversePrograms192.r2Init))
      (setW s w) ⟨started s w a stride hn,.normal⟩ :=
    .seqNormal _ _ (setW s w) (bindValue (setW s w) "u".toList .uint64 (.int32 0))
      ⟨started s w a stride hn,.normal⟩ uRun
      (.seqNormal _ _ (bindValue (setW s w) "u".toList .uint64 (.int32 0)) (mid s w a stride)
        ⟨started s w a stride hn,.normal⟩ r1Run r2Run)
  obtain ⟨after,loopRun,loopFixed,loopCell,loopR1,loopR2,loopImage,_,_,loopKeep,loopWritable⟩ :=
    NttInverseFinalLoopKeep194.remaining hn 0 (started s w a stride hn) a stride hn p p0i w fv
      fixed (started_u s w a stride hn) (started_r1 s w a stride hn)
      (started_r2 s w a stride hn) image (by omega)
  have fLoopRun : Exec NttInversePrograms192.fLoop (setW s w) ⟨after,.normal⟩ :=
    .seqNormal _ _ (setW s w) (started s w a stride hn) ⟨after,.normal⟩ initRun loopRun
  refine ⟨after,?_,loopFixed,loopImage,loopCell,loopR1,loopR2,?_,?_⟩
  · exact .seqNormal _ _ s (setW s w) ⟨after,.normal⟩ wRun
      (.seqNormal _ _ (setW s w) after ⟨after,.normal⟩ fLoopRun (.base _ _ _ (.skip _)))
  · intro q separate z load
    have step : Load32 (started s w a stride hn).heap q z := load
    exact loopKeep q (fun x bound => separate x (by omega)) z step
  · exact loopWritable.trans rfl

end FT1536.Source3.NttInverseFinalKeep202
