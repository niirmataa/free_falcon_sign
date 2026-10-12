import Source3.KeygenCodecNoneLoop

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecNoneWhole
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecNoneCursor
open KeygenCodecGuardedWrite (Window)
open KeygenCodecStaticWindow (window_refl window_trans)

def prefixCode : Stmt := .seq KeygenCodecNoneBinding.node000
  (.seq KeygenCodecNoneBinding.node001 KeygenCodecNoneBinding.node010)

structure Ready (args : Args) (s : State) : Prop where
  length : Len s.locals
  cursor : s.locals.scalars "u".toList=some (.uint64,none)
  capacity : s.locals.scalars "max_out_len".toList=some (.uint64,some (.uint64 args.capacity))
  outCell : s.locals.scalars "out".toList=none
  nullCell : s.locals.scalars "NULL".toList=none

theorem prefix_ready (args : Args) (before : Memory) (after : State)
    (q : args.q=18433) (logn : args.logn=10)
    (source : Exec args prefixCode (initial args before) after .normal) :
    Ready args after ∧ after.heap=before := by
  obtain ⟨declared,first,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node000
    (.seq KeygenCodecNoneBinding.node001 KeygenCodecNoneBinding.node010) _ after .normal source (by rfl)
  obtain ⟨buffer,second,branch⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node001 KeygenCodecNoneBinding.node010 declared after .normal rest (by rfl)
  have qDeclared := KeygenCodecCellFrame.exec_frame "q".toList args _ _ declared .normal first (by decide +kernel)
  have lognDeclared := KeygenCodecCellFrame.exec_frame "logn".toList args _ _ declared .normal first (by decide +kernel)
  have qBuffer := KeygenCodecCellFrame.exec_frame "q".toList args _ declared buffer .normal second (by decide +kernel)
  have lognBuffer := KeygenCodecCellFrame.exec_frame "logn".toList args _ declared buffer .normal second (by decide +kernel)
  have lenBuffer := KeygenCodecCellFrame.exec_frame "len".toList args _ declared buffer .normal second (by decide +kernel)
  have qc : buffer.locals.scalars "q".toList=some (.uint32,some (.uint32 18433)) := by
    simpa [initial,initialLocals,q] using qBuffer.trans qDeclared
  have lc : buffer.locals.scalars "logn".toList=some (.uint32,some (.uint32 10)) := by
    simpa [initial,initialLocals,logn] using lognBuffer.trans lognDeclared
  have length := KeygenCodecNoneResult.branch_length args buffer after .normal qc lc
    (lenBuffer.trans (KeygenCodecNoneResult.declaration_len args _ declared .normal first)) branch
  have cursorDeclared : declared.locals.scalars "u".toList=some (.uint64,none) := by
    cases first with
    | declare args s objects locals declarations =>
      have same : locals=localSet (localSet (initialLocals args) "len".toList .uint64 none) "u".toList .uint64 none := by
        simpa [KeygenCodecNoneBinding.node000,declareLocals,scalarTy,initial] using declarations.symm
      subst locals
      simp [declared,localSet,C99ScalarReference.set]
  have cursorBuffer := KeygenCodecCellFrame.exec_frame "u".toList args _ declared buffer .normal second (by decide +kernel)
  have cursorFinal := KeygenCodecCellFrame.exec_frame "u".toList args _ buffer after .normal branch (by decide +kernel)
  have capFrame := KeygenCodecCellFrame.exec_frame "max_out_len".toList args _ _ after .normal source (by decide +kernel)
  have outFrame := KeygenCodecCellFrame.exec_frame "out".toList args _ _ after .normal source (by decide +kernel)
  have nullFrame := KeygenCodecCellFrame.exec_frame "NULL".toList args _ _ after .normal source (by decide +kernel)
  refine ⟨⟨length,cursorFinal.trans (cursorBuffer.trans cursorDeclared),?_,?_,?_⟩,
    KeygenCodecStateFrame.heap_frame args _ _ after .normal source (by decide +kernel)⟩
  · simpa [initial,initialLocals] using capFrame
  · simpa [initial,initialLocals] using outFrame
  · simpa [initial,initialLocals] using nullFrame

theorem split_full (args : Args) (before : Memory) (after : State) (flow : Flow)
    (source : Exec args KeygenCodecNoneBinding.code (initial args before) after flow) :
    ∃ middle final, Exec args prefixCode (initial args before) middle .normal ∧
      Exec args KeygenCodecNoneBinding.node039 middle final flow ∧ after.heap=final.heap := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨declared,first,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node000 KeygenCodecNoneBinding.node041 _ t flow inside (by rfl)
    obtain ⟨buffer,second,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node001 KeygenCodecNoneBinding.node040 declared t flow rest (by rfl)
    obtain ⟨middle,branch,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node010 KeygenCodecNoneBinding.node039 buffer t flow rest (by decide +kernel)
    exact ⟨middle,t,.seq args _ _ _ declared middle .normal first (.seq args _ _ declared buffer middle .normal second branch),rest,rfl⟩

theorem out_eval (args : Args) (s : State) (l : Locals) (value : Value)
    (empty : s.locals.scalars "out".toList=none)
    (source : Eval args s.heap s.buf (.variable "out".toList) s.locals value l) :
    value=.pointer args.out ∧ l=s.locals := by
  cases source with
  | scalar name l ty v held => rw [empty] at held; cases held
  | out => exact ⟨rfl,rfl⟩

theorem null_eval (args : Args) (s : State) (l : Locals) (value : Value)
    (empty : s.locals.scalars "NULL".toList=none)
    (source : Eval args s.heap s.buf (.variable "NULL".toList) s.locals value l) :
    value=.pointer none ∧ l=s.locals := by
  cases source with
  | scalar name l ty v held => rw [empty] at held; cases held
  | null => exact ⟨rfl,rfl⟩

theorem null_test (args : Args) (s : State) (l : Locals) (value : Value)
    (ready : Ready args s) (dst : ArrayPointer) (out : args.out=some dst)
    (source : Eval args s.heap s.buf KeygenCodecNoneBinding.guard015 s.locals value l) :
    truth value=false ∧ l=s.locals := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨hx,hm⟩ := out_eval args s middle x ready.outCell first
    subst x
    subst middle
    obtain ⟨hy,ht⟩ := null_eval args s l y ready.nullCell second
    subst y
    cases operation
    exact ⟨by simp [boolean,truth,C99ScalarReference.boolean,C99IntegerReference.Value.integer,out],ht⟩

theorem null_step (args : Args) (s t : State) (flow : Flow) (ready : Ready args s)
    (dst : ArrayPointer) (out : args.out=some dst)
    (source : Exec args KeygenCodecNoneBinding.node015 s t flow) : t=s ∧ flow=.normal := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    have zero := (null_test args s locals value ready dst out evaluated).1
    rw [zero] at yes
    cases yes
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    have last := (null_test args s locals value ready dst out evaluated).2
    subst locals
    cases selected
    exact ⟨rfl,rfl⟩

theorem capacity_test (args : Args) (s : State) (l : Locals) (value : Value)
    (ready : Ready args s)
    (source : Eval args s.heap s.buf KeygenCodecNoneBinding.guard020 s.locals value l) :
    truth value=decide (args.capacity.toNat<3072) ∧ l=s.locals := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨hx,hm⟩ := KeygenCodecGuardedWrite.capacity_eval args s.heap s.buf s.locals middle x ready.capacity first
    subst x
    subst middle
    obtain ⟨hy,ht⟩ := len_eval args s.heap s.buf s.locals l y ready.length second
    subst y
    cases operation with
    | lt x y z compared =>
      cases compared
      simp_all [truth,C99IntegerReference.usual,C99IntegerReference.promote,C99IntegerReference.convert,
        C99IntegerReference.Value.type,C99IntegerReference.Value.integer,C99IntegerReference.compare]
      by_cases h : args.capacity.toNat<3072
      · simp [h]
      · simp [h]

theorem capacity_step (args : Args) (s t : State) (flow : Flow) (ready : Ready args s)
    (source : Exec args KeygenCodecNoneBinding.node020 s t flow) :
    t=s ∧ (flow=.normal → 3072≤args.capacity.toNat) := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    have last := (capacity_test args s locals value ready evaluated).2
    subst locals
    obtain ⟨same,returned⟩ := KeygenCodecGuardedWrite.reject_state args s t flow selected
    refine ⟨same,?_⟩
    intro normal
    rw [normal] at returned
    cases returned
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    obtain ⟨testValue,last⟩ := capacity_test args s locals value ready evaluated
    have enough : 3072≤args.capacity.toNat := by rw [testValue] at no; simpa using no
    subst locals
    cases selected
    exact ⟨rfl,fun _ => enough⟩

theorem writes_tail (args : Args) (s t : State) (flow : Flow) (ready : Ready args s)
    (dst : ArrayPointer) (out : args.out=some dst) (capacity : 3072≤args.capacity.toNat)
    (source : Exec args KeygenCodecNoneBinding.node037 s t flow) :
    Window dst args.capacity.toNat s.heap t.heap := by
  obtain ⟨buffer,binding,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node021 KeygenCodecNoneBinding.node036 s t flow source (by rfl)
  have bufferHeap := KeygenCodecStateFrame.heap_frame args _ s buffer .normal binding (by decide +kernel)
  have held : buffer.buf=some (some dst) := by
    cases binding with
    | bind => exact congrArg some out
    | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned => exact (notBuf rfl).elim
  have length : Len buffer.locals :=
    (KeygenCodecCellFrame.exec_frame "len".toList args _ s buffer .normal binding (by decide +kernel)).trans ready.length
  have cursor := (KeygenCodecCellFrame.exec_frame "u".toList args _ s buffer .normal binding (by decide +kernel)).trans ready.cursor
  obtain ⟨loopEnd,loopExec,returnExec⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node032 KeygenCodecNoneBinding.node035 buffer t flow rest (by decide +kernel)
  obtain ⟨normal,finalCursor,window⟩ := KeygenCodecNoneLoop.loop_window args buffer loopEnd .normal dst capacity length cursor held loopExec
  have returnHeap := KeygenCodecStateFrame.heap_frame args _ loopEnd t flow returnExec (by decide +kernel)
  simpa only [returnHeap,bufferHeap] using window

theorem suffix_window (args : Args) (s t : State) (flow : Flow) (ready : Ready args s)
    (dst : ArrayPointer) (out : args.out=some dst)
    (source : Exec args KeygenCodecNoneBinding.node039 s t flow) :
    Window dst args.capacity.toNat s.heap t.heap := by
  have afterNull (source : Exec args KeygenCodecNoneBinding.node038 s t flow) : Window dst args.capacity.toNat s.heap t.heap := by
    cases source with
    | seq args a b s middle t flow first second =>
      obtain ⟨same,capacity⟩ := capacity_step args s middle .normal ready first
      subst middle
      exact writes_tail args s t flow ready dst out (capacity rfl) second
    | seqReturn args a b s t ret first =>
      have heap := KeygenCodecStateFrame.heap_frame args _ s t (.returned ret) first (by decide +kernel)
      rw [heap]
      exact window_refl dst _ _
  cases source with
  | seq args a b s middle t flow first second =>
    obtain ⟨same,_⟩ := null_step args s middle .normal ready dst out first
    subst middle
    exact afterNull second
  | seqReturn args a b s t ret first =>
    obtain ⟨_,normal⟩ := null_step args s t (.returned ret) ready dst out first
    cases normal

/-- Full source NONE window, all finite defined executions and observed
    returns, including capacity rejection. No result/length/frame premise. -/
theorem none_window (args : Args) (before : Memory) (after : State) (flow : Flow)
    (dst : ArrayPointer) (q : args.q=18433) (logn : args.logn=10) (out : args.out=some dst)
    (source : Exec args KeygenCodecNoneBinding.code (initial args before) after flow) :
    Window dst args.capacity.toNat before after.heap := by
  obtain ⟨middle,final,first,rest,sameHeap⟩ := split_full args before after flow source
  obtain ⟨ready,prefixHeap⟩ := prefix_ready args before middle q logn first
  have window := suffix_window args middle final flow ready dst out rest
  simpa only [←sameHeap,prefixHeap] using window

end FT1536.Source3.KeygenCodecNoneWhole
