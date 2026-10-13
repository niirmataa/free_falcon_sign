import Source3.KeygenCodecStaticHistory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Expected first-drain bytes and their actual capacity-return prefixes.
   High accumulator bits are unrestricted. No final codec outcome is assumed. -/
namespace FT1536.Source3.KeygenCodecStaticDrainHistory
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticWriteStep (Cursor Capacity)
open KeygenCodecStaticEmit (Ready)
open KeygenCodecStaticHistory

def bytes : Nat → Nat → BitVec 32 → List (BitVec 8)
  | 0,_,_ => []
  | count+1,p,word => KeygenCodecStaticByte.byte (word >>> (p-8))::bytes count (p-8) word

theorem bytes_step (p : Nat) (word : BitVec 32) (lower : 8≤p) :
    bytes (p/8) p word=KeygenCodecStaticByte.byte (word >>> (p-8))::bytes ((p-8)/8) (p-8) word := by
  have same : p/8=(p-8)/8+1 := by omega
  rw [same,bytes]

theorem ready_frame (args : Args) (stmt : Stmt) (s t : State) (flow : Flow)
    (ready : Ready args s) (source : Exec args stmt s t flow)
    (buf : KeygenCodecStateFrame.preserves false stmt=true)
    (bufCell : KeygenCodecCellFrame.statement "buf".toList stmt=true)
    (nullCell : KeygenCodecCellFrame.statement "NULL".toList stmt=true)
    (capacity : KeygenCodecCellFrame.statement "max_out_len".toList stmt=true) : Ready args t :=
  ⟨(KeygenCodecStateFrame.buf_frame args stmt s t flow source buf).trans ready.buffer,
   (KeygenCodecCellFrame.exec_frame "buf".toList args stmt s t flow source bufCell).trans ready.bufCell,
   (KeygenCodecCellFrame.exec_frame "NULL".toList args stmt s t flow source nullCell).trans ready.nullCell,
   (KeygenCodecCellFrame.exec_frame "max_out_len".toList args stmt s t flow source capacity).trans ready.capacity⟩

theorem body_history (args : Args) (s t : State) (flow : Flow) (n p : Nat) (word : BitVec 32)
    (bound : n+1<2^64) (lower : 8≤p) (upper : p≤16)
    (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 n) s)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (source : Exec args KeygenCodecStaticBinding.node059 s t flow) :
    (flow=.normal ∧ KeygenCodecStaticAdvance.Completed args s t n (word >>> (p-8))) ∨
    (flow=.returned 0 ∧ args.out≠none ∧ args.capacity.toNat≤n ∧ Ready args t ∧
      Cursor (BitVec.ofNat 64 n) t ∧ t.heap=s.heap) := by
  cases source with
  | scope args a s inner flow noBufShadow inside =>
    change (flow=.normal ∧ KeygenCodecStaticAdvance.Completed args s inner n (word >>> (p-8))) ∨
      (flow=.returned 0 ∧ args.out≠none ∧ args.capacity.toNat≤n ∧ Ready args inner ∧
        Cursor (BitVec.ofNat 64 n) inner ∧ inner.heap=s.heap)
    obtain ⟨middle,subtract,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticBinding.node042
      KeygenCodecStaticBinding.node057 s inner flow inside rfl
    have nextReady := ready_frame args _ s middle .normal ready subtract (by decide +kernel)
      (by decide +kernel) (by decide +kernel) (by decide +kernel)
    have nextCursor := (KeygenCodecCellFrame.exec_frame "u".toList args _ s middle .normal subtract (by decide +kernel)).trans cursor
    have nextCount := KeygenCodecStaticDrain.subtract_count args s middle .normal p lower upper count subtract
    have nextAcc := (KeygenCodecCellFrame.exec_frame "acc".toList args _ s middle .normal subtract (by decide +kernel)).trans acc
    have heap := KeygenCodecStateFrame.heap_frame args _ s middle .normal subtract (by decide +kernel)
    rcases KeygenCodecStaticAdvance.source_result args middle inner flow _ n (word >>> (p-8)) bound nextReady nextCursor
      (KeygenCodecStaticStores.drain_calculation middle.locals word (p-8) (by omega) nextAcc nextCount) rest with
        ⟨normal,completed⟩ | ⟨nonnull,returned,capacity,same⟩
    · refine Or.inl ⟨normal,completed.1,completed.2.1,?_,completed.2.2.2⟩
      rw [←heap]; exact completed.2.2.1
    · subst inner
      exact Or.inr ⟨returned,nonnull,by simpa only [BitVec.toNat_ofNat,Nat.mod_eq_of_lt (show n<2^64 by omega)] using capacity,
        nextReady,nextCursor,heap⟩

theorem drain_history (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecStaticBinding.node060 s t flow)
    (n p : Nat) (bound : n+p/8<2^64) (upper : p≤16)
    (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 n) s)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (word : BitVec 32) (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals) :
    Progress args s t n (bytes (p/8) p word) flow := by
  generalize codeEq : KeygenCodecStaticBinding.node060=code at source
  induction source generalizing n p with
  | whileDone args test a s value locals evaluated no =>
    cases codeEq
    obtain ⟨test,last⟩ := KeygenCodecStaticDrain.test_eval args s locals value p upper count evaluated
    rw [test] at no
    have small : p<8 := by simpa using no
    subst locals
    have zero : p/8=0 := by omega
    rw [show withLocals s s.locals=s by cases s; rfl]
    simpa only [zero,bytes] using nil_progress args s n ready cursor
  | whileNext args test a s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    cases codeEq
    obtain ⟨test,last⟩ := KeygenCodecStaticDrain.test_eval args s locals value p upper count evaluated
    rw [test] at yes
    have lower : 8≤p := by simpa using yes
    subst locals
    rcases body_history args s middle .normal n p word (by omega) lower upper ready cursor count acc iteration with
      ⟨_,nextReady,nextCursor,trace,_⟩ | rejected
    · have nextCount := KeygenCodecStaticDrain.body_count args s middle p lower upper count iteration
      have nextAcc := (KeygenCodecCellFrame.exec_frame "acc".toList args _ s middle .normal iteration (by decide +kernel)).trans acc
      have next := ih2 (n+1) (p-8) (by omega) (by omega) nextReady nextCursor nextCount nextAcc rfl
      rw [bytes_step p word lower]
      exact cons_progress args s middle t n _ _ flow
        (by rw [←emit_single _ n _ (by omega)]; exact trace) next
    · cases rejected.1
  | whileReturn args test a s t ret value locals evaluated yes iteration ih =>
    cases codeEq
    obtain ⟨test,last⟩ := KeygenCodecStaticDrain.test_eval args s locals value p upper count evaluated
    rw [test] at yes
    have lower : 8≤p := by simpa using yes
    subst locals
    rcases body_history args s t (.returned ret) n p word (by omega) lower upper ready cursor count acc iteration with
      ⟨normal,_⟩ | ⟨returned,nonnull,capacity,lastReady,lastCursor,heap⟩
    · cases normal
    · rw [bytes_step p word lower]
      refine ⟨0,by simp only [List.length_cons]; omega,lastReady,?_,?_,?_⟩
      · simpa only [Nat.add_zero] using lastCursor
      · change KeygenCodecByteHistory.Trace s.heap t.heap []; rw [heap]; exact .nil _
      · exact Or.inr ⟨returned,nonnull,by simp only [List.length_cons]; omega,by simpa only [Nat.add_zero] using capacity⟩
  | _ => cases codeEq

end FT1536.Source3.KeygenCodecStaticDrainHistory
