import Source3.KeygenCodecStaticEmit

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticAdvance
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation KeygenCodecStaticByte KeygenCodecStaticWriteStep
open KeygenCodecStaticEmit (Ready writes)

def code (rhs : Expr) : Stmt :=
  .seq (KeygenCodecStaticEmit.optional rhs) (.seq KeygenCodecStaticCursor.increment .skip)

def Completed (args : Args) (s t : State) (n : Nat) (word : BitVec 32) : Prop :=
  Ready args t ∧ Cursor (BitVec.ofNat 64 (n+1)) t ∧
  KeygenCodecByteHistory.Trace s.heap t.heap (writes args.out (BitVec.ofNat 64 n) word) ∧
  (args.out=none ∨ n<args.capacity.toNat)

def Result (args : Args) (s t : State) (n : Nat) (word : BitVec 32) (flow : Flow) : Prop :=
  (flow=.normal ∧ Completed args s t n word) ∨
  (args.out≠none ∧ Rejected args s t (BitVec.ofNat 64 n) flow)

theorem ready_increment (args : Args) (s t : State) (flow : Flow) (ready : Ready args s)
    (source : Exec args KeygenCodecStaticCursor.increment s t flow) : Ready args t := by
  refine ⟨(KeygenCodecStateFrame.buf_frame args _ s t flow source (by decide +kernel)).trans ready.buffer,?_,?_,?_⟩
  · exact (KeygenCodecCellFrame.exec_frame "buf".toList args _ s t flow source (by decide +kernel)).trans ready.bufCell
  · exact (KeygenCodecCellFrame.exec_frame "NULL".toList args _ s t flow source (by decide +kernel)).trans ready.nullCell
  · exact (KeygenCodecCellFrame.exec_frame "max_out_len".toList args _ s t flow source (by decide +kernel)).trans ready.capacity

theorem source_result (args : Args) (s t : State) (flow : Flow) (rhs : Expr)
    (n : Nat) (word : BitVec 32) (bound : n+1<2^64)
    (ready : Ready args s) (cursor : Cursor (BitVec.ofNat 64 n) s)
    (calculation : Computes s.locals rhs (promoted word))
    (source : Exec args (code rhs) s t flow) : Result args s t n word flow := by
  cases source with
  | seq args a b s middle t flow first second =>
    rcases KeygenCodecStaticEmit.optional_result args s middle .normal rhs _ word ready cursor calculation first with
      ⟨_,locals,buf,trace,capacity⟩ | ⟨_,rejected⟩
    · have nextReady : Ready args middle := by
        refine ⟨buf.trans ready.buffer,?_,?_,?_⟩
        · rw [locals]; exact ready.bufCell
        · rw [locals]; exact ready.nullCell
        · unfold Capacity; rw [locals]; exact ready.capacity
      have nextCursor : Cursor (BitVec.ofNat 64 n) middle := by unfold Cursor; rw [locals]; exact cursor
      obtain ⟨last,increment,rest⟩ := KeygenCodecControl.seq_split args KeygenCodecStaticCursor.increment .skip middle t flow second rfl
      obtain ⟨_,lastCursor,heap,_⟩ := KeygenCodecStaticCursor.increment_cursor args middle last .normal n bound nextCursor increment
      have lastReady := ready_increment args middle last .normal nextReady increment
      cases rest
      refine Or.inl ⟨rfl,lastReady,lastCursor,?_,?_⟩
      · rw [heap]; exact trace
      · simpa only [BitVec.toNat_ofNat,Nat.mod_eq_of_lt (show n<2^64 by omega)] using capacity
    · cases rejected.1
  | seqReturn args a b s t value first =>
    rcases KeygenCodecStaticEmit.optional_result args s t (.returned value) rhs _ word ready cursor calculation first with
      ⟨normal,_⟩ | rejected
    · cases normal
    · exact Or.inr rejected

theorem source_sites :
    KeygenCodecStaticBinding.node057=code (.cast .byte (.binary .shr (.variable "acc".toList) (.variable "acc_len".toList))) ∧
    KeygenCodecStaticBinding.node117=code (.cast .byte (.binary .shl (.variable "acc".toList)
      (.binary .sub (.number .i32 8) (.variable "acc_len".toList)))) := ⟨rfl,rfl⟩

end FT1536.Source3.KeygenCodecStaticAdvance
