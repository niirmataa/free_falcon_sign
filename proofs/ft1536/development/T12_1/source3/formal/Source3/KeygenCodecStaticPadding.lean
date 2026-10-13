import Source3.KeygenCodecStaticAdvance

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete actual padding branch and return, including capacity return0.
   Entry cells are local seams; the whole STATIC history must derive them. -/
namespace FT1536.Source3.KeygenCodecStaticPadding
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecScalarCalculation KeygenCodecStaticByte KeygenCodecStaticWriteStep
open KeygenCodecStaticEmit (Ready writes)

def finalCursor (n p : Nat) : Nat := n+(if p=0 then 0 else 1)
def paddingWrites (out : Option ArrayPointer) (n : Nat) (word : BitVec 32) (p : Nat) : List KeygenCodecByteHistory.Write :=
  if p=0 then [] else writes out (BitVec.ofNat 64 n) (word <<< (8-p))

def Completed (args : Args) (s t : State) (n : Nat) (word : BitVec 32) (p : Nat) : Prop :=
  Ready args t ∧ Cursor (BitVec.ofNat 64 (finalCursor n p)) t ∧
  KeygenCodecByteHistory.Trace s.heap t.heap (paddingWrites args.out n word p)

def Rejection (args : Args) (s t : State) (n p : Nat) (flow : Flow) : Prop :=
  0<p ∧ args.out≠none ∧ flow=.returned 0 ∧ args.capacity.toNat≤n ∧ t=s

def BranchResult (args : Args) (s t : State) (n : Nat) (word : BitVec 32) (p : Nat) (flow : Flow) : Prop :=
  (flow=.normal ∧ Completed args s t n word p) ∨ Rejection args s t n p flow

def TailResult (args : Args) (s t : State) (n : Nat) (word : BitVec 32) (p : Nat) (flow : Flow) : Prop :=
  (flow=.returned (BitVec.ofNat 64 (finalCursor n p)) ∧ Completed args s t n word p) ∨
  Rejection args s t n p flow

theorem test_eval (args : Args) (s : State) (l : Locals) (value : Value) (p : Nat)
    (small : p<8) (count : KeygenCodecStaticPending.Cell p s.locals)
    (source : Eval args s.heap s.buf KeygenCodecStaticBinding.guard119 s.locals value l) :
    truth value=decide (0<p) ∧ l=s.locals := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨rfl,rfl⟩ := computes_eval args s.heap s.buf s.locals _ (.int32 (BitVec.ofNat 32 p))
      (.scalar _ _ _ (by unfold Ordinary; decide +kernel) count) middle x first
    obtain ⟨rfl,last⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 0 (.int32 0) s.locals l y (by decide +kernel) second
    cases operation with
    | gt x y z compared =>
      cases compared with
      | step ty ht a b ha hb =>
        subst ty
        subst a
        subst b
        constructor
        · simp only [C99IntegerReference.Value.type,C99IntegerReference.promote,C99IntegerReference.usual,
            ite_true,C99IntegerReference.convert,C99IntegerReference.Value.integer,BitVec.ofInt_toInt,
            KeygenCodecNoneCursor.signed_nat32 p (by omega),C99IntegerReference.compare]
          by_cases positive : 0<p
          · simp [truth,positive,C99IntegerReference.Value.integer,KeygenCodecNoneCursor.signed_nat32 p (by omega)]
          · simp [truth,positive,C99IntegerReference.Value.integer,KeygenCodecNoneCursor.signed_nat32 p (by omega)]
        · exact last

theorem branch_result (args : Args) (s t : State) (flow : Flow) (n : Nat) (word : BitVec 32) (p : Nat)
    (bound : n+1<2^64) (small : p<8) (ready : Ready args s)
    (cursor : Cursor (BitVec.ofNat 64 n) s)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (source : Exec args KeygenCodecStaticBinding.node119 s t flow) : BranchResult args s t n word p flow := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    obtain ⟨test,last⟩ := test_eval args s locals value p small count evaluated
    rw [test] at yes
    have positive : 0<p := by simpa using yes
    have nonzero : p≠0 := by omega
    subst locals
    cases selected with
    | scope args a s inner flow noBufShadow inside =>
      change BranchResult args s inner n word p flow
      rcases KeygenCodecStaticAdvance.source_result args s inner flow _ n (word <<< (8-p)) bound ready cursor
        (KeygenCodecStaticStores.padding_calculation s.locals word p (by omega) acc count) inside with
          ⟨normal,nextReady,nextCursor,trace,_⟩ | ⟨nonnull,rejected⟩
      · exact Or.inl ⟨normal,nextReady,by simpa only [finalCursor,nonzero,ite_false] using nextCursor,
          by simpa only [paddingWrites,nonzero,ite_false] using trace⟩
      · exact Or.inr ⟨positive,nonnull,rejected.1,
          by simpa only [BitVec.toNat_ofNat,Nat.mod_eq_of_lt (show n<2^64 by omega)] using rejected.2.1,rejected.2.2⟩
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    obtain ⟨test,last⟩ := test_eval args s locals value p small count evaluated
    rw [test] at no
    have zero : p=0 := by simpa using no
    subst p
    subst locals
    cases selected
    exact Or.inl ⟨rfl,ready,by simpa only [finalCursor,ite_true,Nat.add_zero,Cursor,withLocals] using cursor,
      by simpa only [paddingWrites,ite_true,withLocals] using (KeygenCodecByteHistory.Trace.nil s.heap)⟩

theorem tail_result (args : Args) (s t : State) (flow : Flow) (n : Nat) (word : BitVec 32) (p : Nat)
    (bound : n+1<2^64) (small : p<8) (ready : Ready args s)
    (cursor : Cursor (BitVec.ofNat 64 n) s)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (count : KeygenCodecStaticPending.Cell p s.locals)
    (source : Exec args KeygenCodecStaticBinding.node123 s t flow) : TailResult args s t n word p flow := by
  cases source with
  | seq args a b s middle t flow first second =>
    rcases branch_result args s middle .normal n word p bound small ready cursor acc count first with
      ⟨_,completed⟩ | rejected
    · cases second with
      | seq args a b middle last t flow first second => cases first
      | seqReturn args a b middle t value first =>
        obtain ⟨returned,last⟩ := KeygenCodecStaticCursor.return_cursor args middle t (.returned value) _ completed.2.1 first
        subst t
        exact Or.inl ⟨returned,completed⟩
    · cases rejected.2.2.1
  | seqReturn args a b s t value first =>
    rcases branch_result args s t (.returned value) n word p bound small ready cursor acc count first with
      ⟨normal,_⟩ | rejected
    · cases normal
    · exact Or.inr rejected

end FT1536.Source3.KeygenCodecStaticPadding
