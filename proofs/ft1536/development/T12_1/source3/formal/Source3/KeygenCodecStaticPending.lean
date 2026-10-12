import Source3.KeygenCodecStaticProfile
import Source3.KeygenCodecStaticUnaryAppend

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenCodecStaticPending
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

abbrev IV := C99IntegerReference.Value

def Cell (n : Nat) (l : Locals) : Prop :=
  l.scalars "acc_len".toList=some (.int32,some (.int32 (BitVec.ofNat 32 n)))

theorem addition (p : Nat) (bound : p<8) :
    C99IntegerReference.ArithmeticExec .plus (.int32 (BitVec.ofNat 32 p)) (.int32 1)
      (.int32 (BitVec.ofNat 32 (p+1))) := by
  apply (C99IntegerReference.arithmetic_iff _ _ _ _).mpr
  change (true=true → C99IntegerReference.fits .int32
    ((C99IntegerReference.convert .int32 (C99IntegerReference.Value.int32 (BitVec.ofNat 32 p)).integer).integer+
     (C99IntegerReference.convert .int32 (C99IntegerReference.Value.int32 1).integer).integer)) ∧
    C99IntegerReference.Value.int32 (BitVec.ofNat 32 (p+1))=
      C99IntegerReference.convert .int32
        ((C99IntegerReference.convert .int32 (C99IntegerReference.Value.int32 (BitVec.ofNat 32 p)).integer).integer+
         (C99IntegerReference.convert .int32 (C99IntegerReference.Value.int32 1).integer).integer)
  rw [KeygenCodecStaticCountdown.self_convert,KeygenCodecStaticCountdown.self_convert]
  change (true=true → C99IntegerReference.fits .int32 ((BitVec.ofNat 32 p).toInt+1)) ∧
    C99IntegerReference.Value.int32 (BitVec.ofNat 32 (p+1))=.int32 (BitVec.ofInt 32 ((BitVec.ofNat 32 p).toInt+1))
  rw [KeygenCodecNoneCursor.signed_nat32 p (by omega)]
  constructor
  · intro _
    change -2147483648≤(p : Int)+1 ∧ (p : Int)+1<2147483648
    omega
  · rw [show (p : Int)+1=((p+1 : Nat) : Int) by omega,BitVec.ofInt_natCast]

theorem test_eval (args : Args) (s : State) (l : Locals) (value : Value) (p : Nat)
    (bound : p<8) (cell : Cell p s.locals)
    (source : Eval args s.heap s.buf KeygenCodecStaticBinding.guard081 s.locals value l) :
    truth value=decide (p=7) ∧ Cell (p+1) l := by
  cases source with
  | binary op a b before middle last x y z first second binaryOperation =>
    cases first with
    | preInc name before middle old next updated =>
      cases updated with
      | scalar name delta before ty v z declared operation =>
        have equal : ty=.int32 ∧ v=.int32 (BitVec.ofNat 32 p) := by
          simpa only [Cell,Option.some.injEq,Prod.mk.injEq,Option.some.injEq] using declared.symm.trans cell
        obtain ⟨rfl,rfl⟩ := equal
        have same := C99IntegerReference.arithmetic_deterministic _ _ _ _ _ operation (addition p bound)
        subst z
        obtain ⟨hy,ht⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 8 (.int32 8) _ l y (by decide +kernel) second
        subst y
        subst l
        simp only [KeygenCodecStaticCountdown.self_convert] at binaryOperation
        cases binaryOperation with
        | eq x y z compared =>
          cases compared with
          | step ty ht a b ha hb =>
            subst ty
            subst a
            subst b
            constructor
            · change truth (.integer (.int32 (if decide
                ((C99IntegerReference.convert .int32 (C99IntegerReference.Value.int32 (BitVec.ofNat 32 (p+1))).integer).integer=
                 (C99IntegerReference.convert .int32 (C99IntegerReference.Value.int32 8).integer).integer)
                  then 1 else 0)))=decide (p=7)
              rw [KeygenCodecStaticCountdown.self_convert,KeygenCodecStaticCountdown.self_convert]
              change truth (.integer (.int32 (if decide ((BitVec.ofNat 32 (p+1)).toInt=8) then 1 else 0)))=_
              rw [KeygenCodecNoneCursor.signed_nat32 (p+1) (by omega)]
              by_cases same : p=7
              · subst p; decide +kernel
              · have different : ((p+1 : Nat) : Int)≠8 := by omega
                simp only [different,decide_false,truth,C99IntegerReference.Value.integer]
                simp [same]
            · simp only [Cell,localSet,C99ScalarReference.set,ite_true,
                KeygenCodecStaticCountdown.self_convert]

theorem normal_seq (args : Args) (a b : Stmt) (s t : State)
    (source : Exec args (.seq a b) s t .normal) :
    ∃ m, Exec args a s m .normal ∧ Exec args b m t .normal := by
  cases source with
  | seq args a b s m t flow first second => exact ⟨m,first,second⟩

theorem emit_reset (args : Args) (s t : State)
    (cell : Cell 8 s.locals)
    (source : Exec args KeygenCodecStaticBinding.node080 s t .normal) : Cell 0 t.locals := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨m,first,rest⟩ := normal_seq args KeygenCodecStaticBinding.node073 KeygenCodecStaticBinding.node078 s t inside
    obtain ⟨last,second,rest⟩ := normal_seq args KeygenCodecStaticBinding.node074 KeygenCodecStaticBinding.node077 m t rest
    obtain ⟨out,third,rest⟩ := normal_seq args KeygenCodecStaticBinding.node075 KeygenCodecStaticBinding.node076 last t rest
    have held := (KeygenCodecCellFrame.exec_frame "acc_len".toList args _ m last .normal second (by decide +kernel)).trans
      ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s m .normal first (by decide +kernel)).trans cell)
    have written := KeygenCodecStaticProfile.assignment args last out .normal "acc_len".toList .int32 _
      (.number .i32 0) (.int32 0) held (.number _ _ _ (by decide +kernel)) third
    cases rest
    exact written

/-- The actual preincrement, branch and reset derive the next pending
    count. Capacity rejection is excluded here only by the observed normal
    execution index; no successful codec result or length is assumed. -/
theorem counter_step (args : Args) (s t : State) (p : Nat)
    (bound : p<8) (cell : Cell p s.locals)
    (source : Exec args KeygenCodecStaticBinding.node081 s t .normal) : Cell ((p+1)%8) t.locals := by
  cases source with
  | branchTrue args test a b s t flow value locals evaluated yes selected =>
    obtain ⟨test,last⟩ := test_eval args s locals value p bound cell evaluated
    rw [test] at yes
    have same : p=7 := by simpa using yes
    subst p
    exact emit_reset args _ t last selected
  | branchFalse args test a b s t flow value locals evaluated no selected =>
    obtain ⟨test,last⟩ := test_eval args s locals value p bound cell evaluated
    rw [test] at no
    have different : p≠7 := by simpa using no
    have less : p+1<8 := by omega
    cases selected
    simpa only [Nat.mod_eq_of_lt less,withLocals] using last

theorem body_pending (args : Args) (s t : State) (p : Nat)
    (bound : p<8) (cell : Cell p s.locals)
    (source : Exec args KeygenCodecStaticBinding.node086 s t .normal) : Cell ((p+1)%8) t.locals := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨m,shift,rest⟩ := normal_seq args KeygenCodecStaticBinding.node061 KeygenCodecStaticBinding.node084 s t inside
    obtain ⟨last,append,rest⟩ := normal_seq args KeygenCodecStaticBinding.node062 KeygenCodecStaticBinding.node083 m t rest
    obtain ⟨out,counter,rest⟩ := normal_seq args KeygenCodecStaticBinding.node081 KeygenCodecStaticBinding.node082 last t rest
    have held := (KeygenCodecCellFrame.exec_frame "acc_len".toList args _ m last .normal append (by decide +kernel)).trans
      ((KeygenCodecCellFrame.exec_frame "acc_len".toList args _ s m .normal shift (by decide +kernel)).trans cell)
    have next := counter_step args last out p bound held counter
    cases rest
    exact next

/-- Every finite normally completed unary loop preserves pending<8, for
    any number of actual iterations. The false terminal guard is included. -/
theorem loop_pending (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecStaticBinding.node087 s t flow)
    (normal : flow=.normal) (p : Nat) (bound : p<8) (cell : Cell p s.locals) :
    ∃ pending : Nat, pending<8 ∧ Cell pending t.locals := by
  generalize codeEq : KeygenCodecStaticBinding.node087=code at source
  induction source generalizing p with
  | whileDone args test a s value locals evaluated no =>
    cases codeEq
    exact ⟨p,bound,(KeygenCodecCellFrame.eval_frame "acc_len".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans cell⟩
  | whileNext args test a s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    cases codeEq
    have kept := (KeygenCodecCellFrame.eval_frame "acc_len".toList args s.heap s.buf _ s.locals locals value evaluated (by decide +kernel)).trans cell
    exact ih2 normal ((p+1)%8) (Nat.mod_lt _ (by decide +kernel)) (body_pending args (withLocals s locals) middle p bound kept iteration) rfl
  | whileReturn => cases normal
  | _ => cases codeEq

end FT1536.Source3.KeygenCodecStaticPending
