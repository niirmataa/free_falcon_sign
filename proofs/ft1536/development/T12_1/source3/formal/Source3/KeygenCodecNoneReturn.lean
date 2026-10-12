import Source3.KeygenCodecNoneWhole

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecNoneReturn
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecNoneCursor
open KeygenCodecNoneWhole

def result (args : Args) : BitVec 64 :=
  if args.out=none then 3072 else if args.capacity.toNat<3072 then 0 else 3072

theorem ret_len (args : Args) (s t : State) (flow : Flow) (cell : Len s.locals)
    (source : Exec args (.ret (.variable "len".toList)) s t flow) : flow=.returned 3072 := by
  cases source with
  | ret args s e value locals evaluated =>
    have same := KeygenCodecControl.return_len args s.heap s.buf s.locals locals value cell evaluated
    subst value
    rfl

theorem return_tail (args : Args) (s t : State) (flow : Flow) (cell : Len s.locals)
    (source : Exec args KeygenCodecNoneBinding.node035 s t flow) : flow=.returned 3072 := by
  cases source with
  | seq args a b s middle t flow first second => cases first
  | seqReturn args a b s t ret first => exact ret_len args s t (.returned ret) cell first

theorem writes_return (args : Args) (s t : State) (flow : Flow) (cell : Len s.locals)
    (source : Exec args KeygenCodecNoneBinding.node037 s t flow) : flow=.returned 3072 := by
  obtain ⟨buffer,binding,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node021 KeygenCodecNoneBinding.node036 s t flow source (by rfl)
  obtain ⟨loopEnd,loopExec,returnExec⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node032 KeygenCodecNoneBinding.node035 buffer t flow rest (by decide +kernel)
  have bufferLen : Len buffer.locals :=
    (KeygenCodecCellFrame.exec_frame "len".toList args _ s buffer .normal binding (by decide +kernel)).trans cell
  have loopLen : Len loopEnd.locals :=
    (KeygenCodecCellFrame.exec_frame "len".toList args _ buffer loopEnd .normal loopExec (by decide +kernel)).trans bufferLen
  exact return_tail args loopEnd t flow loopLen returnExec

theorem capacity_flow (args : Args) (s t : State) (flow : Flow) (ready : Ready args s)
    (source : Exec args KeygenCodecNoneBinding.node020 s t flow) :
    t=s ∧ flow=(if args.capacity.toNat<3072 then .returned 0 else .normal) := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    obtain ⟨testValue,last⟩ := capacity_test args s locals value ready evaluated
    have short : args.capacity.toNat<3072 := by rw [testValue] at yes; simpa only [decide_eq_true_eq] using yes
    subst locals
    obtain ⟨same,returned⟩ := KeygenCodecGuardedWrite.reject_state args s t flow selected
    exact ⟨same,by simpa only [short,ite_true] using returned⟩
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    obtain ⟨testValue,last⟩ := capacity_test args s locals value ready evaluated
    have enough : ¬args.capacity.toNat<3072 := by rw [testValue] at no; simpa only [decide_eq_false_iff_not] using no
    subst locals
    cases selected
    exact ⟨rfl,by simp only [enough,ite_false]⟩

theorem after_null_return (args : Args) (s t : State) (flow : Flow) (ready : Ready args s)
    (source : Exec args KeygenCodecNoneBinding.node038 s t flow) :
    flow=.returned (if args.capacity.toNat<3072 then 0 else 3072) := by
  cases source with
  | seq args a b s middle t flow first second =>
    obtain ⟨same,capFlow⟩ := capacity_flow args s middle .normal ready first
    subst middle
    have enough : ¬args.capacity.toNat<3072 := by
      by_cases short : args.capacity.toNat<3072
      · simp only [short,ite_true] at capFlow; cases capFlow
      · exact short
    simpa only [enough,ite_false] using writes_return args s t flow ready.length second
  | seqReturn args a b s t ret first =>
    obtain ⟨same,capFlow⟩ := capacity_flow args s t (.returned ret) ready first
    have short : args.capacity.toNat<3072 := by
      by_cases short : args.capacity.toNat<3072
      · exact short
      · simp only [short,ite_false] at capFlow; cases capFlow
    simpa only [short,ite_true] using capFlow

theorem null_test_true (args : Args) (s : State) (l : Locals) (value : Value)
    (ready : Ready args s) (out : args.out=none)
    (source : Eval args s.heap s.buf KeygenCodecNoneBinding.guard015 s.locals value l) :
    truth value=true ∧ l=s.locals := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨hx,hm⟩ := out_eval args s middle x ready.outCell first
    subst x
    subst middle
    obtain ⟨hy,ht⟩ := null_eval args s l y ready.nullCell second
    subst y
    cases operation
    exact ⟨by simp [boolean,truth,C99ScalarReference.boolean,C99IntegerReference.Value.integer,out],ht⟩

theorem query_flow (args : Args) (s t : State) (flow : Flow) (ready : Ready args s)
    (out : args.out=none) (source : Exec args KeygenCodecNoneBinding.node015 s t flow) :
    flow=.returned 3072 := by
  cases source with
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    have nonzero := (null_test_true args s locals value ready out evaluated).1
    rw [nonzero] at no
    cases no
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    have last := (null_test_true args s locals value ready out evaluated).2
    subst locals
    cases selected with
    | scope args a s t flow noBufShadow inside => exact return_tail args s t flow ready.length inside

theorem suffix_return (args : Args) (s t : State) (flow : Flow) (ready : Ready args s)
    (source : Exec args KeygenCodecNoneBinding.node039 s t flow) : flow=.returned (result args) := by
  cases out : args.out with
  | none =>
    cases source with
    | seq args a b s middle t flow first second =>
      have impossible := query_flow args s middle .normal ready out first
      cases impossible
    | seqReturn args a b s t ret first =>
      simpa only [result,out,ite_true] using query_flow args s t (.returned ret) ready out first
  | some dst =>
    cases source with
    | seq args a b s middle t flow first second =>
      obtain ⟨same,_⟩ := null_step args s middle .normal ready dst out first
      subst middle
      simpa only [result,out,Option.some_ne_none,ite_false] using after_null_return args s t flow ready second
    | seqReturn args a b s t ret first =>
      have impossible := (null_step args s t (.returned ret) ready dst out first).2
      cases impossible

/-- Every defined complete NONE execution has the source result:3072 for
    NULL length queries or sufficient capacity, zero for short non-NULL
    buffers. No successful result, returned length or frame is assumed. -/
theorem none_return (args : Args) (before : Memory) (after : State) (flow : Flow)
    (q : args.q=18433) (logn : args.logn=10)
    (source : Exec args KeygenCodecNoneBinding.code (initial args before) after flow) :
    flow=.returned (result args) := by
  obtain ⟨middle,final,first,rest,_⟩ := split_full args before after flow source
  exact suffix_return args middle final flow (prefix_ready args before middle q logn first).1 rest

end FT1536.Source3.KeygenCodecNoneReturn
