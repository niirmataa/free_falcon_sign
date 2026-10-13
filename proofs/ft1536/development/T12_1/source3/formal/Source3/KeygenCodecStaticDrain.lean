import Source3.KeygenCodecStaticInit
import Source3.KeygenCodecStaticUnaryInvariant

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The first actual byte-drain loop. All count and accumulator conditions
   concern its local input cells. No codec result or length is assumed. -/
namespace FT1536.Source3.KeygenCodecStaticDrain
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference
open KeygenCodecStaticPending (Cell normal_seq)
open KeygenCodecScalarCalculation

theorem signed_arithmetic (op : C99IntegerReference.Arithmetic) (a b : Int)
    (al : -2147483648≤a) (au : a<2147483648)
    (bl : -2147483648≤b) (bu : b<2147483648)
    (lower : -2147483648≤C99IntegerReference.exact op a b)
    (upper : C99IntegerReference.exact op a b<2147483648) :
    C99IntegerReference.ArithmeticExec op (.int32 (BitVec.ofInt 32 a))
      (.int32 (BitVec.ofInt 32 b)) (.int32 (BitVec.ofInt 32 (C99IntegerReference.exact op a b))) := by
  apply (C99IntegerReference.arithmetic_iff _ _ _ _).mpr
  simp only [C99IntegerReference.Value.type,C99IntegerReference.promote,C99IntegerReference.usual,
    ite_true,C99IntegerReference.convert,C99IntegerReference.Value.integer,
    KeygenCodecStaticCountdown.signed_exact a al au,KeygenCodecStaticCountdown.signed_exact b bl bu]
  exact ⟨fun _ => ⟨lower,upper⟩,True.intro⟩

theorem append_count (args : Args) (s t : State) (flow : Flow) (p : Nat)
    (small : p<8) (cell : Cell p s.locals)
    (j : KeygenCodecStaticProfile.Cell "j".toList .int32 (.int32 8) s.locals)
    (source : Exec args KeygenCodecStaticBinding.node041 s t flow) : Cell (p+9) t.locals := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.int32 ∧ old=some (.int32 (BitVec.ofNat 32 p)) := by
      simpa only [Cell,Option.some.injEq,Prod.mk.injEq] using declared.symm.trans cell
    obtain ⟨rfl,rfl⟩ := equal
    obtain ⟨same,last⟩ := KeygenCodecStaticAppend.amount_eval args s.heap s.buf s.locals locals value j evaluated
    subst value
    cases assigned with
    | compound op binary old rhs z operator operation =>
      have same : binary=.add := Option.some.inj operator.symm
      subst binary
      cases operation with
      | add x y z actual =>
        have canonical := signed_arithmetic .plus (p : Int) 9 (by omega) (by omega) (by omega) (by omega)
          (by change -2147483648≤(p : Int)+9; omega) (by change (p : Int)+9<2147483648; omega)
        have same := C99IntegerReference.arithmetic_deterministic _ _ _ _ _ actual canonical
        have sum : (p : Int)+9=((p+9 : Nat) : Int) := by omega
        simp only [C99IntegerReference.exact,sum,BitVec.ofInt_natCast] at same
        simp only [Cell,withLocals,localSet,C99ScalarReference.set,ite_true,same,
          KeygenCodecStaticCountdown.self_convert]

theorem subtract_count (args : Args) (s t : State) (flow : Flow) (p : Nat)
    (lower : 8≤p) (upper : p≤16) (cell : Cell p s.locals)
    (source : Exec args KeygenCodecStaticBinding.node042 s t flow) : Cell (p-8) t.locals := by
  cases source with
  | scalar args s name op rhs ty old value result locals notBuf notOut declared evaluated assigned =>
    have equal : ty=.int32 ∧ old=some (.int32 (BitVec.ofNat 32 p)) := by
      simpa only [Cell,Option.some.injEq,Prod.mk.injEq] using declared.symm.trans cell
    obtain ⟨rfl,rfl⟩ := equal
    obtain ⟨same,last⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 8 (.int32 8) s.locals locals (.integer value) (by decide +kernel) evaluated
    cases same
    cases assigned with
    | compound op binary old rhs z operator operation =>
      have same : binary=.sub := Option.some.inj operator.symm
      subst binary
      cases operation with
      | sub x y z actual =>
        have canonical := signed_arithmetic .minus (p : Int) 8 (by omega) (by omega) (by omega) (by omega)
          (by change -2147483648≤(p : Int)-8; omega) (by change (p : Int)-8<2147483648; omega)
        have same := C99IntegerReference.arithmetic_deterministic _ _ _ _ _ actual canonical
        have difference : (p : Int)-8=((p-8 : Nat) : Int) := by omega
        simp only [C99IntegerReference.exact,difference,BitVec.ofInt_natCast] at same
        simp only [Cell,withLocals,localSet,C99ScalarReference.set,ite_true,same,
          KeygenCodecStaticCountdown.self_convert]

theorem test_eval (args : Args) (s : State) (l : Locals) (value : Value) (p : Nat)
    (upper : p≤16) (cell : Cell p s.locals)
    (source : Eval args s.heap s.buf KeygenCodecStaticBinding.guard060 s.locals value l) :
    truth value=decide (8≤p) ∧ l=s.locals := by
  cases source with
  | binary op a b before middle last x y z first second operation =>
    obtain ⟨same,last⟩ := computes_eval args s.heap s.buf s.locals _ (.int32 (BitVec.ofNat 32 p))
      (.scalar _ _ _ (by unfold Ordinary; decide +kernel) cell) middle x first
    subst x
    subst middle
    obtain ⟨same,last⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 8 (.int32 8) s.locals l y (by decide +kernel) second
    subst y
    cases operation with
    | ge x y z compared =>
      cases compared with
      | step ty ht a b ha hb =>
        subst ty
        subst a
        subst b
        constructor
        · simp only [C99IntegerReference.Value.type,C99IntegerReference.promote,C99IntegerReference.usual,
            ite_true,C99IntegerReference.convert,C99IntegerReference.Value.integer,BitVec.ofInt_toInt,
            BitVec.ofInt_natCast,KeygenCodecNoneCursor.signed_nat32 p (by omega),C99IntegerReference.compare]
          by_cases full : 8≤p
          · have yes : (8 : Int)≤p := by omega
            simp [truth,full,yes,C99IntegerReference.Value.integer]
          · have no : ¬(8 : Int)≤p := by omega
            simp [truth,full,no,C99IntegerReference.Value.integer]
        · exact last

theorem body_count (args : Args) (s t : State) (p : Nat)
    (lower : 8≤p) (upper : p≤16) (cell : Cell p s.locals)
    (source : Exec args KeygenCodecStaticBinding.node059 s t .normal) : Cell (p-8) t.locals := by
  cases source with
  | scope args a s t flow noBufShadow inside =>
    obtain ⟨m,first,rest⟩ := normal_seq args KeygenCodecStaticBinding.node042 KeygenCodecStaticBinding.node057 s t inside
    exact (KeygenCodecCellFrame.exec_frame "acc_len".toList args _ m t .normal rest (by decide +kernel)).trans
      (subtract_count args s m .normal p lower upper cell first)

/-- All actual normal drain iterations and the final false guard derive
    the pending residue. Capacity-return executions are retained separately. -/
theorem drain_pending (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecStaticBinding.node060 s t flow) (normal : flow=.normal)
    (p : Nat) (upper : p≤16) (cell : Cell p s.locals) : Cell (p%8) t.locals := by
  generalize codeEq : KeygenCodecStaticBinding.node060=code at source
  induction source generalizing p with
  | whileDone args test a s value locals evaluated no =>
    cases codeEq
    obtain ⟨test,last⟩ := test_eval args s locals value p upper cell evaluated
    rw [test] at no
    have small : p<8 := by simpa using no
    simpa only [Nat.mod_eq_of_lt small,withLocals,last] using cell
  | whileNext args test a s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    cases codeEq
    obtain ⟨test,last⟩ := test_eval args s locals value p upper cell evaluated
    rw [test] at yes
    have lower : 8≤p := by simpa using yes
    subst locals
    have next := ih2 normal (p-8) (by omega) (body_count args s middle p lower upper cell iteration) rfl
    have residue : (p-8)%8=p%8 := by omega
    simpa only [residue] using next
  | whileReturn => cases normal
  | _ => cases codeEq

/-- The two source pieces discharge the unary-entry pending<8 seam.
    Their common accumulator is preserved through the complete drain. -/
theorem append_and_drain (args : Args) (s m t : State) (p : Nat) (word : BitVec 32)
    (small : p<8) (cell : Cell p s.locals)
    (j : KeygenCodecStaticProfile.Cell "j".toList .int32 (.int32 8) s.locals)
    (acc : KeygenCodecStaticUnaryInvariant.Acc word s.locals)
    (append : Exec args KeygenCodecStaticBinding.node041 s m .normal)
    (drain : Exec args KeygenCodecStaticBinding.node060 m t .normal) :
    Cell ((p+9)%8) t.locals ∧ KeygenCodecStaticUnaryInvariant.Acc word t.locals := by
  exact ⟨drain_pending args m t .normal drain rfl (p+9) (by omega) (append_count args s m .normal p small cell j append),
    (KeygenCodecCellFrame.exec_frame "acc".toList args _ m t .normal drain (by decide +kernel)).trans
      ((KeygenCodecCellFrame.exec_frame "acc".toList args _ s m .normal append (by decide +kernel)).trans acc)⟩

end FT1536.Source3.KeygenCodecStaticDrain
