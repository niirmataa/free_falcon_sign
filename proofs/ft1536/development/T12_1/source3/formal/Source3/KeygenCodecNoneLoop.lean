import Source3.KeygenCodecNonePair

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecNoneLoop
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecNoneCursor
open KeygenCodecGuardedWrite (Window)
open KeygenCodecStaticWindow (window_refl window_trans)

def loopCode : Stmt := .whileLoop test (.seq KeygenCodecNoneBinding.node031 KeygenCodecNoneBinding.loop032Update)

theorem while_fold (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) : stmt=loopCode →
    ∀ n : Nat, n≤3072 → n%2=0 → ∀ dst : ArrayPointer, 3072≤args.capacity.toNat →
      Cursor n s.locals → Len s.locals → s.buf=some (some dst) →
      flow=.normal ∧ Cursor 3072 t.locals ∧ Window dst args.capacity.toNat s.heap t.heap := by
  induction source with
  | whileDone args condition a s value locals evaluated no =>
    intro shape n bound even dst capacity cursor length buffer
    cases shape
    obtain ⟨testValue,last⟩ := test_eval args s locals value n bound cursor length evaluated
    have done : n=3072 := by
      rw [testValue] at no
      have notLess : ¬n<3072 := by simpa only [decide_eq_false_iff_not] using no
      omega
    subst n
    subst locals
    exact ⟨rfl,cursor,window_refl dst _ _⟩
  | whileNext args condition a s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    intro shape n bound even dst capacity cursor length buffer
    cases shape
    obtain ⟨testValue,last⟩ := test_eval args s locals value n bound cursor length evaluated
    have less : n<3072 := by rw [testValue] at yes; simpa only [decide_eq_true_eq] using yes
    have nextBound : n+2≤3072 := by omega
    subst locals
    obtain ⟨bodyEnd,bodyExec,updateExec⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node031 KeygenCodecNoneBinding.loop032Update s middle .normal iteration (by decide +kernel)
    have bodyWindow := KeygenCodecNonePair.pair_body args s bodyEnd .normal n dst less even capacity cursor buffer bodyExec
    have bodyCursor : Cursor n bodyEnd.locals :=
      (KeygenCodecCellFrame.exec_frame "u".toList args _ s bodyEnd .normal bodyExec (by decide +kernel)).trans cursor
    have nextCursor := update_cursor args bodyEnd middle .normal n nextBound bodyCursor updateExec
    have nextLength : Len middle.locals :=
      (KeygenCodecCellFrame.exec_frame "len".toList args _ s middle .normal iteration (by decide +kernel)).trans length
    have nextBuffer := (KeygenCodecStateFrame.buf_frame args _ s middle .normal iteration (by decide +kernel)).trans buffer
    have nextEven : (n+2)%2=0 := by omega
    obtain ⟨normal,finalCursor,window⟩ := ih2 rfl (n+2) nextBound nextEven dst capacity nextCursor nextLength nextBuffer
    have updateHeap := KeygenCodecStateFrame.heap_frame args _ bodyEnd middle .normal updateExec (by decide +kernel)
    have firstWindow : Window dst args.capacity.toNat s.heap middle.heap := by simpa only [updateHeap] using bodyWindow
    exact ⟨normal,finalCursor,window_trans dst _ _ _ _ firstWindow window⟩
  | whileReturn args condition a s t ret value locals evaluated yes iteration ih =>
    intro shape n bound even dst capacity cursor length buffer
    cases shape
    have normal := KeygenCodecControl.normal_flow args _ _ t (.returned ret) iteration (by decide +kernel)
    cases normal
  | skip | declare | bind | scalar | store | increment | evaluate | seq | seqReturn | scope | branchTrue | branchFalse | forLoop | switchNone | switchStatic | switchOther | ret | call =>
    intro shape
    cases shape

theorem loop_window (args : Args) (s t : State) (flow : Flow) (dst : ArrayPointer)
    (capacity : 3072≤args.capacity.toNat) (length : Len s.locals)
    (declaredCursor : s.locals.scalars "u".toList=some (.uint64,none))
    (buffer : s.buf=some (some dst))
    (source : Exec args KeygenCodecNoneBinding.node032 s t flow) :
    flow=.normal ∧ Cursor 3072 t.locals ∧ Window dst args.capacity.toNat s.heap t.heap := by
  cases source with
  | forLoop args initial condition increment loopBody s t flow expanded =>
    obtain ⟨middle,initialExec,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.loop032Init loopCode s t flow expanded (by rfl)
    have cursor := initialize_cursor args s middle .normal declaredCursor initialExec
    have midLength : Len middle.locals :=
      (KeygenCodecCellFrame.exec_frame "len".toList args _ s middle .normal initialExec (by decide +kernel)).trans length
    have midBuffer := (KeygenCodecStateFrame.buf_frame args _ s middle .normal initialExec (by decide +kernel)).trans buffer
    have initHeap := KeygenCodecStateFrame.heap_frame args _ s middle .normal initialExec (by decide +kernel)
    obtain ⟨normal,last,window⟩ := while_fold args _ middle t flow rest rfl 0 (by decide +kernel) (by decide +kernel) dst capacity cursor midLength midBuffer
    exact ⟨normal,last,by simpa only [initHeap] using window⟩

end FT1536.Source3.KeygenCodecNoneLoop
