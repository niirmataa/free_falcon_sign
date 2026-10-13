import Source3.KeygenCodecNonePairBytes
import Source3.KeygenCodecNoneLoop
import Source3.KeygenDecodeNonePairs

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete NONE output-loop byte history on the original physical words.
   Actual reads, pointer advancement and writes are coupled in one fold. -/
namespace FT1536.Source3.KeygenCodecNoneHistory
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecNoneCursor KeygenCodecStaticMaterial KeygenCodecByteHistory
open KeygenCodecStaticHistory (positions)
open KeygenCodecNoneLoop (loopCode)
open KeygenDecodeNonePairs (wire)

theorem pair_preserved (dst ptr : ArrayPointer) (input : BitVec 16) (n : Nat) (a b : Memory)
    (away : ptr.block≠dst.block)
    (trace : Trace a b [(byteOff dst n,KeygenDecodeNoneScalar.high input),
      (byteOff dst (n+1),KeygenDecodeNoneScalar.low input)]) : Preserved ptr.block a b := by
  refine ⟨trace_sizes _ _ _ trace,?_⟩
  intro offset
  apply outside _ _ _ trace ptr.block offset
  intro write member
  have first : write=(byteOff dst n,KeygenDecodeNoneScalar.high input) ∨
      write=(byteOff dst (n+1),KeygenDecodeNoneScalar.low input) := by simpa using member
  rcases first with rfl | rfl <;> exact Or.inl away

theorem loop_history (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args stmt s t flow) : stmt=loopCode →
    ∀ n : Nat, n≤3072 → n%2=0 → ∀ dst ptr : ArrayPointer, 3072≤args.capacity.toNat →
      Cursor n s.locals → Len s.locals → s.buf=some (some dst) →
      s.locals.x=some ptr → ptr.block≠dst.block → ∀ inputs : List (BitVec 16),
      Words s.heap ptr inputs → n+2*inputs.length=3072 →
      flow=.normal ∧ Cursor 3072 t.locals ∧
      Trace s.heap t.heap (positions (some dst) n (wire inputs)) := by
  induction source with
  | whileDone args condition body s value locals evaluated no =>
    intro shape n bound even dst ptr capacity cursor length buffer pointer separate inputs words count
    cases shape
    obtain ⟨testValue,last⟩ := test_eval args s locals value n bound cursor length evaluated
    have done : n=3072 := by
      rw [testValue] at no
      have notLess : ¬n<3072 := by simpa only [decide_eq_false_iff_not] using no
      omega
    have empty : inputs=[] := by
      cases inputs with
      | nil => rfl
      | cons input rest => simp only [List.length_cons] at count; omega
    subst inputs; subst n; subst locals
    exact ⟨rfl,cursor,.nil _⟩
  | whileNext args condition body s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    intro shape n bound even dst ptr capacity cursor length buffer pointer separate inputs words count
    cases shape
    obtain ⟨testValue,last⟩ := test_eval args s locals value n bound cursor length evaluated
    have less : n<3072 := by rw [testValue] at yes; simpa only [decide_eq_true_eq] using yes
    subst locals
    obtain ⟨bodyEnd,bodyExec,updateExec⟩ := KeygenCodecControl.seq_split args KeygenCodecNoneBinding.node031 KeygenCodecNoneBinding.loop032Update s middle .normal iteration (by decide +kernel)
    obtain ⟨actual,next,input,actualPtr,advance,load,finalPtr,trace⟩ :=
      KeygenCodecNonePairBytes.pair_bytes args s bodyEnd .normal n dst (by omega) cursor buffer bodyExec
    have samePtr := Option.some.inj (actualPtr.symm.trans pointer)
    subst actual
    cases words with
    | nil ptr => simp only [List.length_nil] at count; omega
    | cons ptr next' input' inputs' original nextStep tail =>
      have sameWord := load_unique _ _ _ _ load original
      subst input'
      have sameNext := add_unique _ _ _ advance nextStep
      subst next'
      have kept := pair_preserved dst ptr input n s.heap bodyEnd.heap separate trace
      have nextBlock : next.block=ptr.block := by cases advance; rfl
      have tailWords := words_preserved ptr.block s.heap bodyEnd.heap kept next nextBlock inputs' tail
      have updateHeap := KeygenCodecStateFrame.heap_frame args _ bodyEnd middle .normal updateExec (by decide +kernel)
      have middleWords : Words middle.heap next inputs' := by rw [updateHeap]; exact tailWords
      have bodyCursor : Cursor n bodyEnd.locals :=
        (KeygenCodecCellFrame.exec_frame "u".toList args _ s bodyEnd .normal bodyExec (by decide +kernel)).trans cursor
      have nextBound : n+2≤3072 := by omega
      have nextCursor := update_cursor args bodyEnd middle .normal n nextBound bodyCursor updateExec
      have nextLength : Len middle.locals :=
        (KeygenCodecCellFrame.exec_frame "len".toList args _ s middle .normal iteration (by decide +kernel)).trans length
      have nextBuffer := (KeygenCodecStateFrame.buf_frame args _ s middle .normal iteration (by decide +kernel)).trans buffer
      have nextPtr := (KeygenCodecPointerFrame.exec_frame args _ bodyEnd middle .normal updateExec (by decide +kernel)).trans finalPtr
      obtain ⟨normal,finalCursor,later⟩ := ih2 rfl (n+2) nextBound (by omega) dst next capacity nextCursor nextLength nextBuffer nextPtr
        (by rw [nextBlock]; exact separate) inputs' middleWords (by simp only [List.length_cons] at count; omega)
      have first : Trace s.heap middle.heap [(byteOff dst n,KeygenDecodeNoneScalar.high input),
          (byteOff dst (n+1),KeygenDecodeNoneScalar.low input)] := by rw [updateHeap]; exact trace
      refine ⟨normal,finalCursor,?_⟩
      have joined := append _ _ _ _ _ first later
      simpa only [wire,positions,KeygenCodecStaticHistory.single,List.cons_append,List.nil_append,
        Option.toList_some,List.map_cons,List.map_nil,
        show n+1+1=n+2 by omega] using joined
  | whileReturn args condition body s t ret value locals evaluated yes iteration ih =>
    intro shape n bound even dst ptr capacity cursor length buffer pointer separate inputs words count
    cases shape
    have normal := KeygenCodecControl.normal_flow args _ _ t (.returned ret) iteration (by decide +kernel)
    cases normal
  | skip | declare | bind | scalar | store | increment | evaluate | seq | seqReturn | scope | branchTrue | branchFalse | forLoop | switchNone | switchStatic | switchOther | ret | call =>
    intro shape
    cases shape

end FT1536.Source3.KeygenCodecNoneHistory
