import Source3.NttTriplePass184
import Source3.NttMLoop183
import Source3.NttFirstSetup182
import Source3.NttGlue182

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.NttWholeSource185
open C99ArrayReference (State)
open C99MemoryReference (ArrayPointer)
open C99ModularReference (Exec)
open KeygenModpR2Exec (Slot)
open KeygenNttLoopSupport (USlot u64)
open KeygenNttForwardPrograms
open NttFirstFixed182 (Fixed)

theorem source (s : State) (a gm : ArrayPointer) (p p0i w : BitVec 32)
    (input : NttFirstSetup182.Input s a gm p p0i w) (sep : NttMiddleTable183.Separate a gm)
    (reads : NttMiddleTable183.Reads s.heap gm) :
    ∃ out wNew, Exec forwardBody s ⟨out,.normal⟩ ∧ Fixed out a gm p p0i wNew ∧
      USlot out "u" 1536 ∧ USlot out "r" 1024 ∧ NttWriteFrame182.Frame a 1536 s.heap out.heap := by
  let ready := KeygenNttForwardExec.ready s
  let prepared := NttFirstSetup182.after s w
  have prologueRun := NttPrologue182.source s input.logn input.full
  have twiddleRun := NttFirstSetup182.source s a gm p p0i w input
  obtain ⟨first,firstLoopRun,firstFixed,firstU,firstR1,firstR2,firstFrame⟩ :=
    NttFirstLoop182.full prepared a gm p p0i w (NttFirstSetup182.fixed s a gm p p0i w input)
      none (NttFirstSetup182.u_declared s w)
  have firstRun : Exec firstPass ready ⟨first,.normal⟩ :=
    .seqNormal _ _ ready prepared _ twiddleRun
      (.seqNormal _ _ prepared first _ firstLoopRun (.base .skip first first (.skip first)))
  have firstLogn := KeygenNttControl.keep_u32 firstRun (by decide) "logn" 10 (by decide) input.logn
  have firstFull := KeygenNttControl.keep_u32 firstRun (by decide) "full" 1 (by decide) input.full
  have firstM : first.locals "m".toList=some (.uint64,none) :=
    ((KeygenNttControl.frame _ _ _ (by decide) firstRun).2.1 "m".toList (by decide)).trans rfl
  have firstT : first.locals "t".toList=some (.uint64,none) :=
    ((KeygenNttControl.frame _ _ _ (by decide) firstRun).2.1 "t".toList (by decide)).trans rfl
  have firstR : first.locals "r".toList=some (.uint64,none) :=
    ((KeygenNttControl.frame _ _ _ (by decide) firstRun).2.1 "r".toList (by decide)).trans rfl
  have firstReads := NttMiddleTable183.transport s.heap first.heap a gm sep firstFrame reads
  obtain ⟨middle,middleRun,middleFixed,middleM,middleT,middleFrame⟩ :=
    NttMLoop183.full first a gm p p0i w firstFixed sep firstReads firstFull none none firstT firstM
  have middleLogn := KeygenNttControl.keep_u32 middleRun (by decide) "logn" 10 (by decide) firstLogn
  have middleFull := KeygenNttControl.keep_u32 middleRun (by decide) "full" 1 (by decide) firstFull
  have middleU := KeygenNttControl.keep_u64 middleRun (by decide) "u" 768 (by decide) firstU
  have middleR : middle.locals "r".toList=some (.uint64,none) :=
    ((KeygenNttControl.frame _ _ _ (by decide) middleRun).2.1 "r".toList (by decide)).trans firstR
  have middleReads := NttMiddleTable183.transport first.heap middle.heap a gm sep middleFrame firstReads
  obtain ⟨out,wNew,tripleRun,outFixed,outU,outR,tripleFrame⟩ :=
    NttTriplePass184.full middle a gm p p0i w middleFixed sep middleReads middleLogn middleFull
      (some (u64 768)) none middleU middleR
  have body : Exec forwardBody s ⟨out,.normal⟩ :=
    NttGlue182.source prologue s ready prologueRun _ ⟨out,.normal⟩
      (NttGlue182.source firstPass ready first firstRun _ ⟨out,.normal⟩
        (NttGlue182.source intermediatePass first middle middleRun triplePass ⟨out,.normal⟩ tripleRun))
  exact ⟨out,wNew,body,outFixed,outU,outR,NttWriteFrame182.trans a 1536 _ _ _ firstFrame
    (NttWriteFrame182.trans a 1536 _ _ _ middleFrame tripleFrame)⟩

end FT1536.Source3.NttWholeSource185
