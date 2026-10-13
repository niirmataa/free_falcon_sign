import Source3.KeygenDecodeNoneEntryControl

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete source prologue partition, with all M0 cells and the actual
   non-rejecting length gate derived from initial arguments/declarations.
   No n/length/result/frame correctness premise is added. -/
namespace FT1536.Source3.KeygenDecodeNonePrologue
open KeygenDecodeSyntax KeygenDecodeValues KeygenDecodeExecution C99MemoryReference
open KeygenDecodeCalculation KeygenDecodeNoneCore KeygenDecodeNoneReady
open KeygenDecodeNoneEntryCalculations KeygenDecodeNoneEntryControl KeygenDecodeWordOps

def afterNU (tail : Stmt) : Stmt := .seq KeygenDecodeNoneBinding.node001
  (.seq KeygenDecodeNoneBinding.node002 (.seq KeygenDecodeNoneBinding.node011
    (.seq KeygenDecodeNoneBinding.node016 (.seq KeygenDecodeNoneBinding.node017
      (.seq KeygenDecodeNoneBinding.node018 (.seq KeygenDecodeNoneBinding.node019 tail))))))
def plug (tail : Stmt) : Stmt := .seq KeygenDecodeNoneBinding.node000 (afterNU tail)
def prefixCode : Stmt := plug .skip

theorem source_partition : KeygenDecodeNoneBinding.node054=plug KeygenDecodeNoneBinding.node046 := rfl

structure Prepared (args : Args) (src dst : ArrayPointer) (s : State) : Prop where
  q : Cell "q" .uint32 (.uint32 18433) s.locals
  hq : Cell "hq" .uint32 (.uint32 9216) s.locals
  tq : Cell "tq" .uint32 (.uint32 27650) s.locals
  count : Cell "n" .uint64 (.uint64 1536) s.locals
  length : Cell "len" .uint64 (.uint64 args.len) s.locals
  counter : s.locals.scalars "u".toList=some (.uint64,none)
  buffer : s.buf=some (some src)
  destination : s.locals.x=some dst

theorem declaration_nu (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenDecodeNoneBinding.node000 s t flow) :
    t.locals.scalars "n".toList=some (.uint64,none) ∧ t.locals.scalars "u".toList=some (.uint64,none) := by
  cases source with
  | declare s objects locals declarations =>
    have same : locals=localSet (localSet s.locals "n".toList .uint64 none) "u".toList .uint64 none := by
      simpa [KeygenDecodeNoneBinding.node000,declareLocals,scalarTy] using declarations.symm
    subst locals
    simp [declared,localSet,C99ScalarReference.set]

theorem declaration_hqtq (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenDecodeNoneBinding.node002 s t flow) :
    t.locals.scalars "hq".toList=some (.uint32,none) ∧ t.locals.scalars "tq".toList=some (.uint32,none) := by
  cases source with
  | declare s objects locals declarations =>
    have same : locals=localSet (localSet s.locals "hq".toList .uint32 none) "tq".toList .uint32 none := by
      simpa [KeygenDecodeNoneBinding.node002,declareLocals,scalarTy] using declarations.symm
    subst locals
    simp [declared,localSet,C99ScalarReference.set]

/-- Extract the complete actual prologue and arbitrary remaining source
    suffix. All initialized M0 loop-entry cells are conclusions. -/
theorem prefix_split (args : Args) (before : Memory) (after : State) (flow : Flow) (suffix : Stmt)
    (src dst : ArrayPointer) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (data : args.data=some src) (destination : args.x=some dst) (enough : 3072≤args.len.toNat)
    (source : Exec args (plug suffix) (initial args before) after flow) :
    ∃ middle, Exec args prefixCode (initial args before) middle .normal ∧
      Prepared args src dst middle ∧ middle.heap=before ∧ Exec args suffix middle after flow := by
  obtain ⟨s1,e0,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node000 (afterNU suffix) _ after flow source (by rfl)
  obtain ⟨s2,e1,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node001 _ s1 after flow rest (by rfl)
  obtain ⟨s3,e2,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node002 _ s2 after flow rest (by rfl)
  obtain ⟨s4,e3,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node011 _ s3 after flow rest (by decide +kernel)
  have q3 : Cell "q" .uint32 (.uint32 18433) s3.locals := by
    have frame := (KeygenDecodeCellFrame.exec_frame "q".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans
      ((KeygenDecodeCellFrame.exec_frame "q".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans
        (KeygenDecodeCellFrame.exec_frame "q".toList args _ _ s1 .normal e0 (by decide +kernel)))
    simpa [Cell,initial,initialLocals,qM0] using frame
  have logn3 : Cell "logn" .uint32 (.uint32 10) s3.locals := by
    have frame := (KeygenDecodeCellFrame.exec_frame "logn".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans
      ((KeygenDecodeCellFrame.exec_frame "logn".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans
        (KeygenDecodeCellFrame.exec_frame "logn".toList args _ _ s1 .normal e0 (by decide +kernel)))
    simpa [Cell,initial,initialLocals,lognM0] using frame
  have n3 := (KeygenDecodeCellFrame.exec_frame "n".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans
    ((KeygenDecodeCellFrame.exec_frame "n".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans
      (declaration_nu args _ s1 .normal e0).1)
  have same4 := (q_branch_source args s3 s4 .normal q3 logn3 n3 e3).1
  have n4 : Cell "n" .uint64 (.uint64 1536) s4.locals := by
    rw [same4]
    simp only [Cell,nAfter,withLocals,localSet,C99ScalarReference.set,ite_true]
  have q4 : Cell "q" .uint32 (.uint32 18433) s4.locals :=
    (KeygenDecodeCellFrame.exec_frame "q".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans q3
  have len4 : Cell "len" .uint64 (.uint64 args.len) s4.locals := by
    have frame := (KeygenDecodeCellFrame.exec_frame "len".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans
      ((KeygenDecodeCellFrame.exec_frame "len".toList args _ s2 s3 .normal e2 (by decide +kernel)).trans
        ((KeygenDecodeCellFrame.exec_frame "len".toList args _ s1 s2 .normal e1 (by decide +kernel)).trans
          (KeygenDecodeCellFrame.exec_frame "len".toList args _ _ s1 .normal e0 (by decide +kernel))))
    simpa [Cell,initial,initialLocals] using frame
  obtain ⟨gateEnd,gate,rest⟩ := KeygenDecodeControl.seq_split_given args KeygenDecodeNoneBinding.node016 _ s4 after flow rest
    (fun next result actual => (length_gate_source args s4 next result enough len4 n4 actual).2)
  have sameGate := (length_gate_source args s4 gateEnd .normal enough len4 n4 gate).1
  subst gateEnd
  obtain ⟨s5,e4,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node017 _ s4 after flow rest (by rfl)
  obtain ⟨s6,e5,rest⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node018 _ s5 after flow rest (by rfl)
  obtain ⟨middle,e6,remaining⟩ := KeygenDecodeControl.seq_split args KeygenDecodeNoneBinding.node019 suffix s6 after flow rest (by rfl)
  have hq4 := (KeygenDecodeCellFrame.exec_frame "hq".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans
    (declaration_hqtq args s2 s3 .normal e2).1
  have tq4 := (KeygenDecodeCellFrame.exec_frame "tq".toList args _ s3 s4 .normal e3 (by decide +kernel)).trans
    (declaration_hqtq args s2 s3 .normal e2).2
  have same5 := (assign_set args s4 s5 .normal "hq".toList .uint32 none hqRhs (.uint32 9216) hq4
    (hq_calculation args s4 q4) e4).1
  have hq5 : Cell "hq" .uint32 (.uint32 9216) s5.locals := by
    rw [same5]
    simp only [Cell,withLocals,localSet,C99ScalarReference.set,ite_true,self32]
  have q5 : Cell "q" .uint32 (.uint32 18433) s5.locals :=
    (KeygenDecodeCellFrame.exec_frame "q".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans q4
  have tq5 := (KeygenDecodeCellFrame.exec_frame "tq".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans tq4
  have same6 := (assign_set args s5 s6 .normal "tq".toList .uint32 none tqRhs (.uint32 27650) tq5
    (tq_calculation args s5 hq5 q5) e5).1
  have tq6 : Cell "tq" .uint32 (.uint32 27650) s6.locals := by
    rw [same6]
    simp only [Cell,withLocals,localSet,C99ScalarReference.set,ite_true,self32]
  have buffer : middle.buf=some (some src) := by
    cases e6 with
    | bind => exact congrArg some data
    | scalar s name op rhs ty old value result locals notBuf notData declared evaluated assigned => exact (notBuf rfl).elim
  have trailing : Exec args (afterNU .skip) s1 middle .normal :=
    .seq args _ _ s1 s2 middle .normal e1
      (.seq args _ _ s2 s3 middle .normal e2
        (.seq args _ _ s3 s4 middle .normal e3
          (.seq args _ _ s4 s4 middle .normal gate
            (.seq args _ _ s4 s5 middle .normal e4
              (.seq args _ _ s5 s6 middle .normal e5
                (.seq args _ _ s6 middle middle .normal e6 (.skip args middle)))))))
  have prefixRun : Exec args prefixCode (initial args before) middle .normal :=
    .seq args _ _ _ s1 middle .normal e0 trailing
  have finalQ : Cell "q" .uint32 (.uint32 18433) middle.locals := by
    have frame := KeygenDecodeCellFrame.exec_frame "q".toList args _ _ middle .normal prefixRun (by decide +kernel)
    simpa [Cell,initial,initialLocals,qM0] using frame
  have finalLen : Cell "len" .uint64 (.uint64 args.len) middle.locals := by
    have frame := KeygenDecodeCellFrame.exec_frame "len".toList args _ _ middle .normal prefixRun (by decide +kernel)
    simpa [Cell,initial,initialLocals] using frame
  have finalN : Cell "n" .uint64 (.uint64 1536) middle.locals :=
    (KeygenDecodeCellFrame.exec_frame "n".toList args _ s6 middle .normal e6 (by decide +kernel)).trans
      ((KeygenDecodeCellFrame.exec_frame "n".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans
        ((KeygenDecodeCellFrame.exec_frame "n".toList args _ s4 s5 .normal e4 (by decide +kernel)).trans n4))
  have finalHQ : Cell "hq" .uint32 (.uint32 9216) middle.locals :=
    (KeygenDecodeCellFrame.exec_frame "hq".toList args _ s6 middle .normal e6 (by decide +kernel)).trans
      ((KeygenDecodeCellFrame.exec_frame "hq".toList args _ s5 s6 .normal e5 (by decide +kernel)).trans hq5)
  have finalTQ : Cell "tq" .uint32 (.uint32 27650) middle.locals :=
    (KeygenDecodeCellFrame.exec_frame "tq".toList args _ s6 middle .normal e6 (by decide +kernel)).trans tq6
  have counter := (KeygenDecodeCellFrame.exec_frame "u".toList args _ s1 middle .normal trailing (by decide +kernel)).trans
    (declaration_nu args _ s1 .normal e0).2
  have ptr := (KeygenDecodePointerFrame.exec_frame args _ _ middle .normal prefixRun (by decide +kernel)).trans destination
  have heap := KeygenDecodeStateFrame.heap_frame args _ _ middle .normal prefixRun (by decide +kernel)
  exact ⟨middle,prefixRun,⟨finalQ,finalHQ,finalTQ,finalN,finalLen,counter,buffer,ptr⟩,heap,remaining⟩

theorem prefix_source (args : Args) (before : Memory) (after : State) (flow : Flow)
    (src dst : ArrayPointer) (qM0 : args.q=18433) (lognM0 : args.logn=10)
    (data : args.data=some src) (destination : args.x=some dst) (enough : 3072≤args.len.toNat)
    (source : Exec args prefixCode (initial args before) after flow) :
    flow=.normal ∧ Prepared args src dst after ∧ after.heap=before := by
  obtain ⟨middle,prefixRun,prepared,heap,rest⟩ := prefix_split args before after flow .skip src dst qM0 lognM0 data destination enough source
  cases rest
  exact ⟨rfl,prepared,heap⟩

end FT1536.Source3.KeygenDecodeNonePrologue
