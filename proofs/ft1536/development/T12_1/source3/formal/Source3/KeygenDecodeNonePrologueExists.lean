import Source3.KeygenDecodeNonePrologue

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Honest finite execution of every declaration, q branch, length gate,
   hq/tq assignment and data binding of the actual NONE prologue. -/
namespace FT1536.Source3.KeygenDecodeNonePrologueExists
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeNoneCore KeygenDecodeNoneReady
open KeygenDecodeNoneEntryCalculations KeygenDecodeNoneEntryControl KeygenDecodeNonePrologue KeygenDecodeWordOps

def freshNU (s : State) : State :=
  ⟨s.heap,localSet (localSet s.locals "n".toList .uint64 none) "u".toList .uint64 none,s.buf⟩
def freshBuf (s : State) : State := ⟨s.heap,s.locals,none⟩
def freshHQ (s : State) : State :=
  ⟨s.heap,localSet (localSet s.locals "hq".toList .uint32 none) "tq".toList .uint32 none,s.buf⟩
def setHQ (s : State) : State := withLocals s (localSet s.locals "hq".toList .uint32 (some (.uint32 9216)))
def setTQ (s : State) : State := withLocals s (localSet s.locals "tq".toList .uint32 (some (.uint32 27650)))

theorem prefix_exists (args : Args) (before : Memory) (src dst : ArrayPointer)
    (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (data : args.data=some src) (destination : args.x=some dst) (enough : 3072≤args.len.toNat) :
    ∃ after, Exec args prefixCode (initial args before) after .normal ∧
      Prepared args src dst after ∧ after.heap=before := by
  let s0 := initial args before
  let s1 := freshNU s0
  let s2 := freshBuf s1
  let s3 := freshHQ s2
  let s4 := nAfter s3
  let s5 := setHQ s4
  let s6 := setTQ s5
  let last : State := ⟨s6.heap,s6.locals,some args.data⟩
  have e0 : Exec args KeygenDecodeNoneBinding.node000 s0 s1 .normal :=
    .declare args s0 [⟨"n".toList,.size,none⟩,⟨"u".toList,.size,none⟩]
      (localSet (localSet s0.locals "n".toList .uint64 none) "u".toList .uint64 none) rfl
  have e1 : Exec args KeygenDecodeNoneBinding.node001 s1 s2 .normal :=
    .declare args s1 [⟨"buf".toList,.pointer (.readonly .byte),none⟩] s1.locals rfl
  have e2 : Exec args KeygenDecodeNoneBinding.node002 s2 s3 .normal :=
    .declare args s2 [⟨"hq".toList,.u32,none⟩,⟨"tq".toList,.u32,none⟩]
      (localSet (localSet s2.locals "hq".toList .uint32 none) "tq".toList .uint32 none) rfl
  have q3 : Cell "q" .uint32 (.uint32 18433) s3.locals := by
    have frame := (KeygenDecodeCellFrame.exec_frame "q".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans
      ((KeygenDecodeCellFrame.exec_frame "q".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans
        (KeygenDecodeCellFrame.exec_frame "q".toList args _ s0 s1 .normal e0 (by decide +kernel)))
    simpa [Cell,s0,initial,initialLocals,qM0] using frame
  have logn3 : Cell "logn" .uint32 (.uint32 10) s3.locals := by
    have frame := (KeygenDecodeCellFrame.exec_frame "logn".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans
      ((KeygenDecodeCellFrame.exec_frame "logn".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans
        (KeygenDecodeCellFrame.exec_frame "logn".toList args _ s0 s1 .normal e0 (by decide +kernel)))
    simpa [Cell,s0,initial,initialLocals,lognM0] using frame
  have n3 := (KeygenDecodeCellFrame.exec_frame "n".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans
    ((KeygenDecodeCellFrame.exec_frame "n".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans
      (declaration_nu args s0 s1 .normal e0).1)
  have e3 : Exec args KeygenDecodeNoneBinding.node011 s3 s4 .normal := q_branch_exists args s3 q3 logn3 n3
  have n4 : Cell "n" .uint64 (.uint64 1536) s4.locals := by
    simp only [Cell,s4,nAfter,withLocals,localSet,C99ScalarReference.set,ite_true]
  have q4 : Cell "q" .uint32 (.uint32 18433) s4.locals :=
    (KeygenDecodeCellFrame.exec_frame "q".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans q3
  have len4 : Cell "len" .uint64 (.uint64 args.len) s4.locals := by
    have frame := (KeygenDecodeCellFrame.exec_frame "len".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans
      ((KeygenDecodeCellFrame.exec_frame "len".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans
        ((KeygenDecodeCellFrame.exec_frame "len".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans
          (KeygenDecodeCellFrame.exec_frame "len".toList args _ s0 s1 .normal e0 (by decide +kernel))))
    simpa [Cell,s0,initial,initialLocals] using frame
  have gate : Exec args KeygenDecodeNoneBinding.node016 s4 s4 .normal := length_gate_exists args s4 enough len4 n4
  have hq4 := (KeygenDecodeCellFrame.exec_frame "hq".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans
    (declaration_hqtq args s2 s3 .normal e2).1
  have tq4 := (KeygenDecodeCellFrame.exec_frame "tq".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans
    (declaration_hqtq args s2 s3 .normal e2).2
  have e4 : Exec args KeygenDecodeNoneBinding.node017 s4 s5 .normal := by
    have actual := assign_exists args s4 "hq".toList .uint32 none hqRhs (.uint32 9216)
      (by decide +kernel) (by decide +kernel) hq4 (hq_calculation args s4 q4)
    simpa only [self32,setHQ,s5,KeygenDecodeNoneBinding.node017,hqRhs] using actual
  have hq5 : Cell "hq" .uint32 (.uint32 9216) s5.locals := by
    simp only [Cell,s5,setHQ,withLocals,localSet,C99ScalarReference.set,ite_true]
  have q5 : Cell "q" .uint32 (.uint32 18433) s5.locals :=
    (KeygenDecodeCellFrame.exec_frame "q".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans q4
  have tq5 := (KeygenDecodeCellFrame.exec_frame "tq".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans tq4
  have e5 : Exec args KeygenDecodeNoneBinding.node018 s5 s6 .normal := by
    have actual := assign_exists args s5 "tq".toList .uint32 none tqRhs (.uint32 27650)
      (by decide +kernel) (by decide +kernel) tq5 (tq_calculation args s5 hq5 q5)
    simpa only [self32,setTQ,s6,KeygenDecodeNoneBinding.node018,tqRhs] using actual
  have e6 : Exec args KeygenDecodeNoneBinding.node019 s6 last .normal := .bind args s6
  have full : Exec args prefixCode s0 last .normal :=
    .seq args _ _ s0 s1 last .normal e0
      (.seq args _ _ s1 s2 last .normal e1
        (.seq args _ _ s2 s3 last .normal e2
          (.seq args _ _ s3 s4 last .normal e3
            (.seq args _ _ s4 s4 last .normal gate
              (.seq args _ _ s4 s5 last .normal e4
                (.seq args _ _ s5 s6 last .normal e5
                  (.seq args _ _ s6 last last .normal e6 (.skip args last))))))))
  have actual := prefix_source args before last .normal src dst qM0 lognM0 data destination enough full
  exact ⟨last,full,actual.2⟩

end FT1536.Source3.KeygenDecodeNonePrologueExists
