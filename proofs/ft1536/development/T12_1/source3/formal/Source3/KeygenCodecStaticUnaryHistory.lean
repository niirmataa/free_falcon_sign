import Source3.KeygenCodecStaticDrainHistory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticUnaryHistory
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticWriteStep (Cursor)
open KeygenCodecStaticEmit (Ready)
open KeygenCodecStaticHistory
open KeygenCodecStaticDrainHistory (ready_frame)

def bytes : Nat → Nat → BitVec 32 → List (BitVec 8)
  | 0,_,_ => []
  | count+1,p,word =>
      let next := (word <<< 1)+(if count=0 then 1 else 0)
      (if p=7 then [KeygenCodecStaticByte.byte next] else [])++bytes count ((p+1)%8) next

def BodyResult (args : Args) (s t : State) (n p : Nat) (word : BitVec 32) (flow : Flow) : Prop :=
  (flow=.normal ∧ Ready args t ∧ Cursor (BitVec.ofNat 64 (n+(if p=7 then 1 else 0))) t ∧
    KeygenCodecByteHistory.Trace s.heap t.heap
      (positions args.out n (if p=7 then [KeygenCodecStaticByte.byte word] else []))) ∨
  (flow=.returned 0 ∧ p=7 ∧ args.out≠none ∧ args.capacity.toNat≤n ∧
    Ready args t ∧ Cursor (BitVec.ofNat 64 n) t ∧ t.heap=s.heap)

theorem emit_reset_history (args : Args) (s t : State) (flow : Flow) (n : Nat) (word : BitVec 32)
    (bound : n+1<2^64) (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 n) s)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (source : Exec args KeygenCodecStaticBinding.node080 s t flow) : BodyResult args s t n 7 word flow := by
  cases source with
  | scope args a s inner flow noBufShadow inside =>
    change BodyResult args s inner n 7 word flow
    cases inside with
    | seq args a b s middle inner flow first second =>
      rcases KeygenCodecStaticEmit.optional_result args s middle .normal _ _ word ready cursor
        (KeygenCodecStaticByte.cast_calculation s.locals word acc) first with
          ⟨_,locals,buf,trace,_⟩ | ⟨_,rejected⟩
      · have nextReady : Ready args middle := by
          refine ⟨buf.trans ready.buffer,?_,?_,?_⟩
          · rw [locals]; exact ready.bufCell
          · rw [locals]; exact ready.nullCell
          · unfold KeygenCodecStaticWriteStep.Capacity; rw [locals]; exact ready.capacity
        have nextCursor : Cursor (BitVec.ofNat 64 n) middle := by unfold Cursor; rw [locals]; exact cursor
        obtain ⟨last,increment,reset⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node074
          KeygenCodecStaticBinding.node077 middle inner flow second rfl
        obtain ⟨_,lastCursor,heap,_⟩ := KeygenCodecStaticCursor.increment_cursor args middle last .normal n bound nextCursor increment
        have normal := KeygenCodecControl.normal_flow args _ last inner flow reset (by decide +kernel)
        have lastReady := KeygenCodecStaticAdvance.ready_increment args middle last .normal nextReady increment
        have finalReady := ready_frame args _ last inner flow lastReady reset (by decide +kernel)
          (by decide +kernel) (by decide +kernel) (by decide +kernel)
        have finalCursor := (KeygenCodecCellFrame.exec_frame "u".toList args _ last inner flow reset (by decide +kernel)).trans lastCursor
        have finalHeap := (KeygenCodecStateFrame.heap_frame args _ last inner flow reset (by decide +kernel)).trans heap
        refine Or.inl ⟨normal,finalReady,by simpa only [ite_true,Cursor] using finalCursor,?_⟩
        simp only [ite_true,positions,List.append_nil]
        rw [finalHeap,←emit_single _ n word (by omega)]
        exact trace
      · cases rejected.1
    | seqReturn args a b s inner value first =>
      rcases KeygenCodecStaticEmit.optional_result args s inner (.returned value) _ _ word ready cursor
        (KeygenCodecStaticByte.cast_calculation s.locals word acc) first with
          ⟨normal,_⟩ | ⟨nonnull,returned,capacity,same⟩
      · cases normal
      · subst inner
        exact Or.inr ⟨returned,rfl,nonnull,by simpa only [BitVec.toNat_ofNat,Nat.mod_eq_of_lt (show n<2^64 by omega)] using capacity,
          ready,cursor,rfl⟩

theorem counter_history (args : Args) (s t : State) (flow : Flow) (n p : Nat) (word : BitVec 32)
    (bound : n+1<2^64) (small : p<8) (ready : Ready args s)
    (cursor : Cursor (BitVec.ofNat 64 n) s)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (source : Exec args KeygenCodecStaticBinding.node081 s t flow) : BodyResult args s t n p word flow := by
  have evaluatedReady (l : Locals) (value : Value)
      (evaluated : Eval args s.heap s.buf KeygenCodecStaticBinding.guard081 s.locals value l) :
      Ready args (withLocals s l) := by
    refine ⟨ready.buffer,?_,?_,?_⟩
    · exact (KeygenCodecCellFrame.eval_frame "buf".toList args s.heap s.buf _ s.locals l value evaluated (by decide +kernel)).trans ready.bufCell
    · exact (KeygenCodecCellFrame.eval_frame "NULL".toList args s.heap s.buf _ s.locals l value evaluated (by decide +kernel)).trans ready.nullCell
    · exact (KeygenCodecCellFrame.eval_frame "max_out_len".toList args s.heap s.buf _ s.locals l value evaluated (by decide +kernel)).trans ready.capacity
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    have test := (KeygenCodecStaticPending.test_eval args s locals value p small count evaluated).1
    rw [test] at yes
    have full : p=7 := by simpa using yes
    subst p
    have keptCursor := (KeygenCodecCellFrame.eval_frame "u".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans cursor
    have keptAcc := (KeygenCodecCellFrame.eval_frame "acc".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans acc
    exact emit_reset_history args (withLocals s locals) t flow n word bound (evaluatedReady locals value evaluated) keptCursor keptAcc selected
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    have test := (KeygenCodecStaticPending.test_eval args s locals value p small count evaluated).1
    rw [test] at no
    have notFull : p≠7 := by simpa using no
    have keptCursor := (KeygenCodecCellFrame.eval_frame "u".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans cursor
    cases selected
    exact Or.inl ⟨rfl,evaluatedReady locals value evaluated,by simpa only [notFull,ite_false,Nat.add_zero,Cursor,withLocals] using keptCursor,
      by simpa only [notFull,ite_false,positions,withLocals] using (KeygenCodecByteHistory.Trace.nil s.heap)⟩

theorem before_skip (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (source : Exec args (.seq stmt .skip) s t flow) : Exec args stmt s t flow := by
  cases source with
  | seq args a b s middle t flow first second => cases second; exact first
  | seqReturn args a b s t value first => exact first

theorem body_history (args : Args) (s t : State) (flow : Flow) (n p : Nat) (word : BitVec 32) (counter : Int)
    (bound : n+1<2^64) (small : p<8) (lower : -1≤counter) (upper : counter≤127)
    (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 n) s)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (ne : KeygenCodecStaticCountdown.Cell counter s.locals)
    (source : Exec args KeygenCodecStaticBinding.node086 s t flow) :
    BodyResult args s t n p (KeygenCodecStaticUnaryInvariant.appended word counter) flow := by
  cases source with
  | scope args a s inner flow noBufShadow inside =>
    change BodyResult args s inner n p (KeygenCodecStaticUnaryInvariant.appended word counter) flow
    obtain ⟨middle,shift,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node061 KeygenCodecStaticBinding.node084 s inner flow inside rfl
    obtain ⟨last,append,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node062 KeygenCodecStaticBinding.node083 middle inner flow rest rfl
    have counterSource := before_skip args _ last inner flow rest
    have shifted := KeygenCodecStaticUnaryAppend.shift_step args s middle .normal word acc shift
    have keptNe := (KeygenCodecCellFrame.exec_frame "ne".toList args _ s middle .normal shift (by decide +kernel)).trans ne
    have appended := KeygenCodecStaticUnaryAppend.bit_step args middle last .normal (word <<< 1) counter lower upper shifted keptNe append
    have readyMiddle := ready_frame args _ s middle .normal ready shift (by decide +kernel) (by decide +kernel) (by decide +kernel) (by decide +kernel)
    have readyLast := ready_frame args _ middle last .normal readyMiddle append (by decide +kernel) (by decide +kernel) (by decide +kernel) (by decide +kernel)
    have countLast := (KeygenCodecCellFrame.exec_frame "acc_len".toList args _ middle last .normal append (by decide +kernel)).trans
      ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s middle .normal shift (by decide +kernel)).trans count)
    have cursorLast := (KeygenCodecCellFrame.exec_frame "u".toList args _ middle last .normal append (by decide +kernel)).trans
      ((KeygenCodecCellFrame.exec_frame "u".toList args _ s middle .normal shift (by decide +kernel)).trans cursor)
    have heap := (KeygenCodecStateFrame.heap_frame args _ middle last .normal append (by decide +kernel)).trans
      (KeygenCodecStateFrame.heap_frame args _ s middle .normal shift (by decide +kernel))
    have result := counter_history args last inner flow n p _ bound small readyLast cursorLast countLast appended counterSource
    unfold BodyResult at result ⊢
    simpa only [heap,KeygenCodecStaticUnaryInvariant.appended] using result

theorem bytes_step (counter : Int) (nonnegative : 0≤counter) (p : Nat) (word : BitVec 32) :
    bytes (counter+1).toNat p word=
      (if p=7 then [KeygenCodecStaticByte.byte (KeygenCodecStaticUnaryInvariant.appended word (counter-1))] else [])++
      bytes counter.toNat ((p+1)%8) (KeygenCodecStaticUnaryInvariant.appended word (counter-1)) := by
  cases counter with
  | ofNat m =>
    change bytes (m+1) p word=
      (if p=7 then [KeygenCodecStaticByte.byte (KeygenCodecStaticUnaryInvariant.appended word ((m : Int)-1))] else [])++
      bytes m ((p+1)%8) (KeygenCodecStaticUnaryInvariant.appended word ((m : Int)-1))
    have same : ((m : Int)-1=(-1 : Int)) ↔ m=0 := by omega
    simp only [bytes,KeygenCodecStaticUnaryInvariant.appended,KeygenCodecStaticUnaryBit.bit,same]
  | negSucc m => omega

theorem trace_empty (a b : Memory) (trace : KeygenCodecByteHistory.Trace a b []) : b=a := by
  cases trace
  rfl

theorem loop_history (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecStaticBinding.node087 s t flow)
    (u p : Nat) (counter : Int) (bound : u+(counter+1).toNat<2^64)
    (small : p<8) (lower : -1≤counter) (upper : counter≤128)
    (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 u) s)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (word : BitVec 32) (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (ne : KeygenCodecStaticCountdown.Cell counter s.locals) :
    Progress args s t u (bytes (counter+1).toNat p word) flow := by
  generalize codeEq : KeygenCodecStaticBinding.node087=code at source
  induction source generalizing u p counter word with
  | whileDone args test a s value locals evaluated no =>
    cases codeEq
    have test := (KeygenCodecStaticCountdown.guard_eval args s locals value counter lower upper ne evaluated).1
    rw [test] at no
    have negative : ¬0≤counter := by simpa using no
    have terminal : counter=(-1 : Int) := by omega
    subst counter
    have nextReady : Ready args (withLocals s locals) := by
      refine ⟨ready.buffer,?_,?_,?_⟩
      · exact (KeygenCodecCellFrame.eval_frame "buf".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans ready.bufCell
      · exact (KeygenCodecCellFrame.eval_frame "NULL".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans ready.nullCell
      · exact (KeygenCodecCellFrame.eval_frame "max_out_len".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans ready.capacity
    have nextCursor := (KeygenCodecCellFrame.eval_frame "u".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans cursor
    exact ⟨0,Nat.le_refl 0,nextReady,by simpa only [Nat.add_zero,Cursor,withLocals] using nextCursor,.nil _,Or.inl ⟨rfl,rfl⟩⟩
  | whileNext args test a s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    cases codeEq
    obtain ⟨test,last⟩ := KeygenCodecStaticCountdown.guard_eval args s locals value counter lower upper ne evaluated
    rw [test] at yes
    have positive : 0≤counter := by simpa using yes
    have entryReady : Ready args (withLocals s locals) := by
      refine ⟨ready.buffer,?_,?_,?_⟩
      · exact (KeygenCodecCellFrame.eval_frame "buf".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans ready.bufCell
      · exact (KeygenCodecCellFrame.eval_frame "NULL".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans ready.nullCell
      · exact (KeygenCodecCellFrame.eval_frame "max_out_len".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans ready.capacity
    have entryCursor := (KeygenCodecCellFrame.eval_frame "u".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans cursor
    have entryCount := (KeygenCodecCellFrame.eval_frame "acc_len".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans count
    have entryAcc := (KeygenCodecCellFrame.eval_frame "acc".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans acc
    rcases body_history args (withLocals s locals) middle .normal u p word (counter-1)
      (by omega) small (by omega) (by omega) entryReady entryCursor entryCount entryAcc last iteration with
        ⟨_,nextReady,nextCursor,trace⟩ | rejected
    · obtain ⟨nextAcc,nextCount⟩ := KeygenCodecStaticUnaryInvariant.body_state args (withLocals s locals) middle p word (counter-1)
        small (by omega) (by omega) entryAcc entryCount last iteration
      have nextNe := KeygenCodecStaticCountdown.body_frame args (withLocals s locals) middle .normal (counter-1) last iteration
      have next := ih2 (u+(if p=7 then 1 else 0)) ((p+1)%8) (counter-1) (by split <;> omega)
        (Nat.mod_lt _ (by decide +kernel)) (by omega) (by omega) nextReady nextCursor nextCount
        (KeygenCodecStaticUnaryInvariant.appended word (counter-1)) nextAcc nextNe rfl
      rw [bytes_step counter positive]
      have steps : counter-1+1=counter := by omega
      rw [steps] at next
      by_cases full : p=7
      · simp only [full,ite_true] at trace next ⊢
        apply cons_progress args s middle t u _ _ flow
        · simpa only [positions,List.append_nil,withLocals] using trace
        · exact next
      · simp only [full,ite_false,Nat.add_zero,List.nil_append] at trace next ⊢
        have heap : middle.heap=s.heap := trace_empty _ _ trace
        unfold Progress at next ⊢
        simpa only [heap] using next
    · cases rejected.1
  | whileReturn args test a s t ret value locals evaluated yes iteration ih =>
    cases codeEq
    obtain ⟨test,last⟩ := KeygenCodecStaticCountdown.guard_eval args s locals value counter lower upper ne evaluated
    rw [test] at yes
    have positive : 0≤counter := by simpa using yes
    have entryReady : Ready args (withLocals s locals) := by
      refine ⟨ready.buffer,?_,?_,?_⟩
      · exact (KeygenCodecCellFrame.eval_frame "buf".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans ready.bufCell
      · exact (KeygenCodecCellFrame.eval_frame "NULL".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans ready.nullCell
      · exact (KeygenCodecCellFrame.eval_frame "max_out_len".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans ready.capacity
    have entryCursor := (KeygenCodecCellFrame.eval_frame "u".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans cursor
    have entryCount := (KeygenCodecCellFrame.eval_frame "acc_len".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans count
    have entryAcc := (KeygenCodecCellFrame.eval_frame "acc".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans acc
    rcases body_history args (withLocals s locals) t (.returned ret) u p word (counter-1)
      (by omega) small (by omega) (by omega) entryReady entryCursor entryCount entryAcc last iteration with
        ⟨normal,_⟩ | ⟨returned,full,nonnull,capacity,lastReady,lastCursor,heap⟩
    · cases normal
    · rw [bytes_step counter positive]
      simp only [full,ite_true,List.singleton_append]
      refine ⟨0,by simp only [List.length_cons]; omega,lastReady,?_,?_,?_⟩
      · simpa only [Nat.add_zero] using lastCursor
      · change KeygenCodecByteHistory.Trace s.heap t.heap []; rw [heap]; exact .nil _
      · exact Or.inr ⟨returned,nonnull,by simp only [List.length_cons]; omega,by simpa only [Nat.add_zero] using capacity⟩
  | _ => cases codeEq

end FT1536.Source3.KeygenCodecStaticUnaryHistory
