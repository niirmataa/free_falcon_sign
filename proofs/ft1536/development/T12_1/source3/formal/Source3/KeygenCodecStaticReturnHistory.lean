import Source3.KeygenCodecStaticPadding
import Source3.KeygenCodecStaticHistory

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticReturnHistory
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticWriteStep (Cursor)
open KeygenCodecStaticEmit (Ready)
open KeygenCodecStaticHistory

def padding (word : BitVec 32) (p : Nat) : List (BitVec 8) :=
  if p=0 then [] else [KeygenCodecStaticByte.byte (word <<< (8-p))]

def Result (args : Args) (s t : State) (n : Nat) (expected : List (BitVec 8)) (flow : Flow) : Prop :=
  ∃ k : Nat, k≤expected.length ∧ Ready args t ∧ Cursor (BitVec.ofNat 64 (n+k)) t ∧
    KeygenCodecByteHistory.Trace s.heap t.heap (positions args.out n (expected.take k)) ∧
    ((flow=.returned (BitVec.ofNat 64 (n+expected.length)) ∧ k=expected.length) ∨
      (flow=.returned 0 ∧ args.out≠none ∧ k<expected.length ∧ args.capacity.toNat≤n+k))

theorem padding_size (word : BitVec 32) (p : Nat) :
    (padding word p).length=(if p=0 then 0 else 1) := by unfold padding; split <;> rfl

theorem padding_positions (out : Option ArrayPointer) (n : Nat) (word : BitVec 32) (p : Nat)
    (small : n<2^64) :
    positions out n (padding word p)=KeygenCodecStaticPadding.paddingWrites out n word p := by
  unfold padding KeygenCodecStaticPadding.paddingWrites
  split
  · rfl
  · simp only [positions,List.append_nil,←emit_single out n (word <<< (8-p)) small]

theorem tail_history (args : Args) (s t : State) (flow : Flow) (n : Nat) (word : BitVec 32) (p : Nat)
    (bound : n+1<2^64) (small : p<8) (ready : Ready args s)
    (cursor : Cursor (BitVec.ofNat 64 n) s)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (source : Exec args KeygenCodecStaticBinding.node123 s t flow) :
    Result args s t n (padding word p) flow := by
  rcases KeygenCodecStaticPadding.tail_result args s t flow n word p bound small ready cursor acc count source with
    ⟨returned,lastReady,lastCursor,trace⟩ | ⟨positive,nonnull,returned,capacity,same⟩
  · refine ⟨(padding word p).length,Nat.le_refl _,lastReady,?_,?_,Or.inl ⟨?_,rfl⟩⟩
    · simpa only [padding_size,KeygenCodecStaticPadding.finalCursor] using lastCursor
    · rw [List.take_length,padding_positions args.out n word p (by omega)]; exact trace
    · simpa only [padding_size,KeygenCodecStaticPadding.finalCursor] using returned
  · subst t
    refine ⟨0,by omega,ready,by simpa only [Nat.add_zero] using cursor,
      .nil _,Or.inr ⟨returned,nonnull,?_,by simpa only [Nat.add_zero] using capacity⟩⟩
    simp only [padding_size,show p≠0 by omega,ite_false]; omega

theorem append_result (args : Args) (s middle t : State) (n : Nat) (xs ys : List (BitVec 8)) (flow : Flow)
    (first : Progress args s middle n xs .normal)
    (tail : Result args middle t (n+xs.length) ys flow) : Result args s t n (xs++ys) flow := by
  obtain ⟨i,_,_,_,firstTrace,ending⟩ := first
  have complete : i=xs.length := by rcases ending with ⟨_,complete⟩ | ⟨bad,_⟩; exact complete; cases bad
  subst i
  rw [List.take_length] at firstTrace
  obtain ⟨k,bound,ready,cursor,trace,last⟩ := tail
  refine ⟨xs.length+k,by simp only [List.length_append]; omega,ready,?_,?_,?_⟩
  · simpa only [Nat.add_assoc] using cursor
  · rw [List.take_append,List.take_of_length_le (show xs.length≤xs.length+k by omega),
      show xs.length+k-xs.length=k by omega,positions_append]
    exact KeygenCodecByteHistory.append _ _ _ _ _ firstTrace trace
  · rcases last with ⟨returned,complete⟩ | ⟨returned,nonnull,short,capacity⟩
    · exact Or.inl ⟨by simpa only [List.length_append,Nat.add_assoc] using returned,
        by simp only [List.length_append]; omega⟩
    · exact Or.inr ⟨returned,nonnull,by simp only [List.length_append]; omega,by omega⟩

theorem rejected_result (args : Args) (s t : State) (n : Nat) (xs ys : List (BitVec 8)) (value : BitVec 64)
    (history : Progress args s t n xs (.returned value)) : Result args s t n (xs++ys) (.returned value) := by
  obtain ⟨k,bound,ready,cursor,trace,ending⟩ := extend_rejection args s t n xs ys value history
  rcases ending with ⟨bad,_⟩ | rejected
  · cases bad
  · exact ⟨k,bound,ready,cursor,trace,Or.inr rejected⟩

end FT1536.Source3.KeygenCodecStaticReturnHistory
