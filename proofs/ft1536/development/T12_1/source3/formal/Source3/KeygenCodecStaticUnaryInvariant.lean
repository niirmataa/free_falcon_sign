import Source3.KeygenCodecStaticPending

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Complete accumulator/countdown/pending fold for the actual unary loop.
   The initial cells are local entry seams; the coefficient prefix must
   still derive them. No codec return, length or memory frame is assumed. -/
namespace FT1536.Source3.KeygenCodecStaticUnaryInvariant
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticPending (normal_seq)

def Acc (word : BitVec 32) (l : Locals) : Prop :=
  l.scalars "acc".toList=some (.uint32,some (.uint32 word))
def appended (word : BitVec 32) (counter : Int) : BitVec 32 :=
  (word <<< 1)+KeygenCodecStaticUnaryBit.bit counter

def finish : Nat → Nat → BitVec 32 → Nat × BitVec 32
  | 0,pending,word => (pending,word)
  | count+1,pending,word =>
      finish count ((pending+1)%8) ((word <<< 1)+(if count=0 then 1 else 0))

theorem body_state (args : Args) (s t : State) (pending : Nat) (word : BitVec 32) (n : Int)
    (small : pending<8) (lower : -1≤n) (upper : n≤127)
    (acc : Acc word s.locals) (count : KeygenCodecStaticPending.Cell pending s.locals)
    (counter : KeygenCodecStaticCountdown.Cell n s.locals)
    (source : Exec args KeygenCodecStaticBinding.node086 s t .normal) :
    Acc (appended word n) t.locals ∧ KeygenCodecStaticPending.Cell ((pending+1)%8) t.locals := by
  constructor
  · cases source with
    | scope args a s t flow noBufShadow inside =>
      obtain ⟨m,shift,rest⟩ := normal_seq args KeygenCodecStaticBinding.node061 KeygenCodecStaticBinding.node084 s t inside
      obtain ⟨last,append,rest⟩ := normal_seq args KeygenCodecStaticBinding.node062 KeygenCodecStaticBinding.node083 m t rest
      have kept := (KeygenCodecCellFrame.exec_frame "ne".toList args _ s m .normal shift (by decide +kernel)).trans counter
      have shifted := KeygenCodecStaticUnaryAppend.shift_step args s m .normal word acc shift
      have value := KeygenCodecStaticUnaryAppend.bit_step args m last .normal (word <<< 1) n lower upper shifted kept append
      exact (KeygenCodecCellFrame.exec_frame "acc".toList args _ last t .normal rest (by decide +kernel)).trans value
  · exact KeygenCodecStaticPending.body_pending args s t pending small count source

theorem finish_step (n : Int) (nonnegative : 0≤n) (pending : Nat) (word : BitVec 32) :
    finish (n+1).toNat pending word=finish n.toNat ((pending+1)%8) (appended word (n-1)) := by
  cases n with
  | ofNat m =>
    change finish (m+1) pending word=finish m ((pending+1)%8) (appended word ((m : Int)-1))
    simp only [finish,appended,KeygenCodecStaticUnaryBit.bit]
    have same : ((m : Int)-1=(-1 : Int)) ↔ m=0 := by omega
    simp only [same]
  | negSucc m => omega

/-- The raw source loop derives its whole word/pending result. count is
    the source-derived number of bits: zeros followed by the final one. -/
theorem loop_state (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecStaticBinding.node087 s t flow)
    (normal : flow=.normal) (n : Int) (lower : -1≤n) (upper : n≤128)
    (pending : Nat) (small : pending<8) (word : BitVec 32)
    (counter : KeygenCodecStaticCountdown.Cell n s.locals)
    (count : KeygenCodecStaticPending.Cell pending s.locals) (acc : Acc word s.locals) :
    KeygenCodecStaticPending.Cell (finish (n+1).toNat pending word).1 t.locals ∧
      Acc (finish (n+1).toNat pending word).2 t.locals := by
  generalize codeEq : KeygenCodecStaticBinding.node087=code at source
  induction source generalizing n pending word with
  | whileDone args test a s value locals evaluated no =>
    cases codeEq
    have test := (KeygenCodecStaticCountdown.guard_eval args s locals value n lower upper counter evaluated).1
    rw [test] at no
    have negative : ¬0≤n := by simpa using no
    have same : n=(-1 : Int) := by omega
    subst n
    exact ⟨(KeygenCodecCellFrame.eval_frame "acc_len".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans count,
      (KeygenCodecCellFrame.eval_frame "acc".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans acc⟩
  | whileNext args test a s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    cases codeEq
    obtain ⟨test,last⟩ := KeygenCodecStaticCountdown.guard_eval args s locals value n lower upper counter evaluated
    rw [test] at yes
    have positive : 0≤n := by simpa using yes
    have keptCount := (KeygenCodecCellFrame.eval_frame "acc_len".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans count
    have keptAcc := (KeygenCodecCellFrame.eval_frame "acc".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans acc
    obtain ⟨nextAcc,nextCount⟩ := body_state args (withLocals s locals) middle pending word (n-1) small (by omega) (by omega) keptAcc keptCount last iteration
    have nextCounter := KeygenCodecStaticCountdown.body_frame args (withLocals s locals) middle .normal (n-1) last iteration
    have next := ih2 normal (n-1) (by omega) (by omega) ((pending+1)%8) (Nat.mod_lt _ (by decide +kernel))
      (appended word (n-1)) nextCounter nextCount nextAcc rfl
    rw [finish_step n positive pending word]
    simpa only [show n-1+1=n by omega] using next
  | whileReturn => cases normal
  | _ => cases codeEq

theorem finish_pending (count pending : Nat) (word : BitVec 32) (small : pending<8) :
    (finish count pending word).1=(pending+count)%8 := by
  induction count generalizing pending word with
  | zero => simp only [finish,Nat.add_zero,Nat.mod_eq_of_lt small]
  | succ count ih =>
    rw [finish,ih _ _ (Nat.mod_lt _ (by decide +kernel))]
    omega

/-- Simultaneous conclusions about the same actual normal execution. -/
theorem unary_invariant (args : Args) (s t : State)
    (source : Exec args KeygenCodecStaticBinding.node087 s t .normal)
    (n : Int) (lower : -1≤n) (upper : n≤128) (pending : Nat) (small : pending<8) (word : BitVec 32)
    (counter : KeygenCodecStaticCountdown.Cell n s.locals)
    (count : KeygenCodecStaticPending.Cell pending s.locals) (acc : Acc word s.locals) :
    KeygenCodecStaticCountdown.Cell (-2) t.locals ∧
      KeygenCodecStaticPending.Cell ((pending+(n+1).toNat)%8) t.locals ∧
      Acc (finish (n+1).toNat pending word).2 t.locals := by
  obtain ⟨lastCount,lastAcc⟩ := loop_state args s t .normal source rfl n lower upper pending small word counter count acc
  rw [finish_pending _ pending word small] at lastCount
  exact ⟨KeygenCodecStaticCountdown.normal_exit args s t .normal source rfl n lower upper counter,lastCount,lastAcc⟩


/-- Mathematical low suffix after each emitted byte has been removed. -/
def finishLow : Nat → Nat → Nat → Nat
  | 0,_,suffix => suffix
  | count+1,pending,suffix =>
      finishLow count ((pending+1)%8)
        (if pending=7 then 0 else suffix*2+(if count=0 then 1 else 0))

theorem low_step (pending : Nat) (word newBit : BitVec 32)
    (small : pending<8) (bitSmall : newBit.toNat<2) :
    KeygenCodecStaticSuffix.low ((word <<< 1)+newBit) ((pending+1)%8)=
      if pending=7 then 0 else KeygenCodecStaticSuffix.low word pending*2+newBit.toNat := by
  by_cases full : pending=7
  · subst pending
    simp only [Nat.reduceAdd,Nat.reduceMod,KeygenCodecStaticSuffix.low,Nat.pow_zero,Nat.mod_one,ite_true]
  · have less : pending+1<8 := by omega
    simp only [Nat.mod_eq_of_lt less,full,ite_false]
    exact KeygenCodecStaticUnaryAppend.low_append word newBit pending (by omega) bitSmall

theorem finish_low (count pending : Nat) (word : BitVec 32) (small : pending<8) :
    KeygenCodecStaticSuffix.low (finish count pending word).2 (finish count pending word).1=
      finishLow count pending (KeygenCodecStaticSuffix.low word pending) := by
  induction count generalizing pending word with
  | zero => rfl
  | succ count ih =>
    rw [finish,finishLow,ih _ _ (Nat.mod_lt _ (by decide +kernel)),low_step pending word _ small (by
      by_cases last : count=0 <;> simp only [last,ite_true,ite_false] <;> decide +kernel)]
    have bitNat : (if count=0 then (1 : BitVec 32) else 0).toNat=(if count=0 then 1 else 0) := by
      split <;> rfl
    rw [bitNat]

/-- Low suffix, pending count and ne=-2, all derived from ONE complete
    actual unary execution. No bound on the whole accumulator is required. -/
theorem unary_low_suffix (args : Args) (s t : State)
    (source : Exec args KeygenCodecStaticBinding.node087 s t .normal)
    (n : Int) (lower : -1≤n) (upper : n≤128) (pending : Nat) (small : pending<8) (word : BitVec 32)
    (counter : KeygenCodecStaticCountdown.Cell n s.locals)
    (count : KeygenCodecStaticPending.Cell pending s.locals) (acc : Acc word s.locals) :
    ∃ finalWord : BitVec 32, KeygenCodecStaticCountdown.Cell (-2) t.locals ∧
      KeygenCodecStaticPending.Cell ((pending+(n+1).toNat)%8) t.locals ∧ Acc finalWord t.locals ∧
      KeygenCodecStaticSuffix.low finalWord ((pending+(n+1).toNat)%8)=
        finishLow (n+1).toNat pending (KeygenCodecStaticSuffix.low word pending) := by
  obtain ⟨terminal,lastCount,lastAcc⟩ := unary_invariant args s t source n lower upper pending small word counter count acc
  refine ⟨_,terminal,lastCount,lastAcc,?_⟩
  rw [←finish_pending (n+1).toNat pending word small]
  exact finish_low _ pending word small

end FT1536.Source3.KeygenCodecStaticUnaryInvariant
