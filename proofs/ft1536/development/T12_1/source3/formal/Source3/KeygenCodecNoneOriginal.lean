import Source3.KeygenCodecNoneHistory
import Source3.KeygenCodecNoneReturn

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Whole pinned NONE encoder to exact ordered bytes of the SAME original
   physical int16 array. Source return and byte history are conclusions. -/
namespace FT1536.Source3.KeygenCodecNoneOriginal
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecNoneCursor KeygenCodecStaticMaterial KeygenCodecByteHistory
open KeygenCodecStaticHistory (positions)
open KeygenCodecNoneWhole
open KeygenDecodeNonePairs (wire)

theorem for_history (args : Args) (s t : State) (flow : Flow) (dst ptr : ArrayPointer)
    (capacity : 3072≤args.capacity.toNat) (length : Len s.locals)
    (cursor : s.locals.scalars "u".toList=some (.uint64,none))
    (buffer : s.buf=some (some dst)) (pointer : s.locals.x=some ptr)
    (separate : ptr.block≠dst.block) (inputs : List (BitVec 16)) (count : inputs.length=1536)
    (words : Words s.heap ptr inputs)
    (source : Exec args KeygenCodecNoneBinding.node032 s t flow) :
    Trace s.heap t.heap (positions (some dst) 0 (wire inputs)) := by
  cases source with
  | forLoop args initial condition increment loopBody s t flow expanded =>
    obtain ⟨middle,initialExec,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.loop032Init KeygenCodecNoneLoop.loopCode s t flow expanded (by rfl)
    have startCursor := initialize_cursor args s middle .normal cursor initialExec
    have midLength : Len middle.locals :=
      (KeygenCodecCellFrame.exec_frame "len".toList args _ s middle .normal initialExec (by decide +kernel)).trans length
    have midBuffer := (KeygenCodecStateFrame.buf_frame args _ s middle .normal initialExec (by decide +kernel)).trans buffer
    have midPointer := (KeygenCodecPointerFrame.exec_frame args _ s middle .normal initialExec (by decide +kernel)).trans pointer
    have heap := KeygenCodecStateFrame.heap_frame args _ s middle .normal initialExec (by decide +kernel)
    have midWords : Words middle.heap ptr inputs := by rw [heap]; exact words
    obtain ⟨_,_,trace⟩ := KeygenCodecNoneHistory.loop_history args _ middle t flow rest rfl 0
      (by decide +kernel) (by decide +kernel) dst ptr capacity startCursor midLength midBuffer midPointer
      separate inputs midWords (by rw [count])
    simpa only [heap] using trace

theorem writes_history (args : Args) (s t : State) (flow : Flow) (dst ptr : ArrayPointer)
    (ready : Ready args s) (out : args.out=some dst) (capacity : 3072≤args.capacity.toNat)
    (pointer : s.locals.x=some ptr) (separate : ptr.block≠dst.block)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (words : Words s.heap ptr inputs)
    (source : Exec args KeygenCodecNoneBinding.node037 s t flow) :
    Trace s.heap t.heap (positions (some dst) 0 (wire inputs)) := by
  obtain ⟨buffer,binding,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node021 KeygenCodecNoneBinding.node036 s t flow source (by rfl)
  have heap := KeygenCodecStateFrame.heap_frame args _ s buffer .normal binding (by decide +kernel)
  have held : buffer.buf=some (some dst) := by
    cases binding with
    | bind => exact congrArg some out
    | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned => exact (notBuf rfl).elim
  have length : Len buffer.locals :=
    (KeygenCodecCellFrame.exec_frame "len".toList args _ s buffer .normal binding (by decide +kernel)).trans ready.length
  have cursor := (KeygenCodecCellFrame.exec_frame "u".toList args _ s buffer .normal binding (by decide +kernel)).trans ready.cursor
  have bufPtr := (KeygenCodecPointerFrame.exec_frame args _ s buffer .normal binding (by decide +kernel)).trans pointer
  have bufWords : Words buffer.heap ptr inputs := by rw [heap]; exact words
  obtain ⟨loopEnd,loopExec,returnExec⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node032 KeygenCodecNoneBinding.node035 buffer t flow rest (by decide +kernel)
  have trace := for_history args buffer loopEnd .normal dst ptr capacity length cursor held bufPtr separate inputs count bufWords loopExec
  have returnHeap := KeygenCodecStateFrame.heap_frame args _ loopEnd t flow returnExec (by decide +kernel)
  simpa only [returnHeap,heap] using trace

theorem suffix_history (args : Args) (s t : State) (flow : Flow) (dst ptr : ArrayPointer)
    (ready : Ready args s) (out : args.out=some dst) (capacity : 3072≤args.capacity.toNat)
    (pointer : s.locals.x=some ptr) (separate : ptr.block≠dst.block)
    (inputs : List (BitVec 16)) (count : inputs.length=1536) (words : Words s.heap ptr inputs)
    (source : Exec args KeygenCodecNoneBinding.node039 s t flow) :
    Trace s.heap t.heap (positions (some dst) 0 (wire inputs)) := by
  have afterNull (execution : Exec args KeygenCodecNoneBinding.node038 s t flow) :
      Trace s.heap t.heap (positions (some dst) 0 (wire inputs)) := by
    cases execution with
    | seq args a b s middle t flow first second =>
      have same := (capacity_step args s middle .normal ready first).1
      subst middle
      exact writes_history args s t flow dst ptr ready out capacity pointer separate inputs count words second
    | seqReturn args a b s t ret first =>
      have impossible := (KeygenCodecNoneReturn.capacity_flow args s t (.returned ret) ready first).2
      simp only [show ¬args.capacity.toNat<3072 by omega,ite_false] at impossible
      cases impossible
  cases source with
  | seq args a b s middle t flow first second =>
    have same := (null_step args s middle .normal ready dst out first).1
    subst middle
    exact afterNull second
  | seqReturn args a b s t ret first =>
    have impossible := (null_step args s t (.returned ret) ready dst out first).2
    cases impossible

/-- Whole source encoder on the original physical inputs, without an
    encoded-byte, desired return, output-length or frame premise. -/
theorem source_bytes (args : Args) (before : Memory) (after : State) (flow : Flow)
    (dst ptr : ArrayPointer) (q : args.q=18433) (logn : args.logn=10)
    (out : args.out=some dst) (capacity : 3072≤args.capacity.toNat) (input : args.x=some ptr)
    (separate : ptr.block≠dst.block) (inputs : List (BitVec 16)) (count : inputs.length=1536)
    (words : Words before ptr inputs)
    (source : Exec args KeygenCodecNoneBinding.code (initial args before) after flow) :
    flow=.returned 3072 ∧ Trace before after.heap (positions (some dst) 0 (wire inputs)) := by
  have returned := KeygenCodecNoneReturn.none_return args before after flow q logn source
  have result : KeygenCodecNoneReturn.result args=3072 := by
    simp only [KeygenCodecNoneReturn.result,out,Option.some_ne_none,ite_false,
      show ¬args.capacity.toNat<3072 by omega]
  rw [result] at returned
  obtain ⟨middle,final,first,rest,sameHeap⟩ := split_full args before after flow source
  obtain ⟨ready,heap⟩ := prefix_ready args before middle q logn first
  have pointer : middle.locals.x=some ptr :=
    (KeygenCodecPointerFrame.exec_frame args _ _ middle .normal first (by decide +kernel)).trans input
  have midWords : Words middle.heap ptr inputs := by rw [heap]; exact words
  have trace := suffix_history args middle final flow dst ptr ready out capacity pointer separate inputs count midWords rest
  exact ⟨returned,by simpa only [←sameHeap,heap] using trace⟩

end FT1536.Source3.KeygenCodecNoneOriginal
