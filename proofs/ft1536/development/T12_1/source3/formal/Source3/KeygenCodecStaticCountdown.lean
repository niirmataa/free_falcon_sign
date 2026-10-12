import Source3.KeygenCodecStaticTerminal

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- The actual postdecrement guard, for every reachable unary counter.
   Its body does not write ne. Capacity rejection remains an admitted flow. -/
namespace FT1536.Source3.KeygenCodecStaticCountdown
open KeygenCodecSyntax KeygenCodecValues KeygenCodecExecution C99MemoryReference

def Cell (n : Int) (l : Locals) : Prop :=
  l.scalars "ne".toList=some (.int32,some (.int32 (BitVec.ofInt 32 n)))

theorem signed_exact (n : Int) (lower : -2147483648≤n) (upper : n<2147483648) :
    (BitVec.ofInt 32 n).toInt=n :=
  BitVec.toInt_ofInt_eq_self (w := 32) (n := n) (by decide +kernel) lower upper

theorem self_convert (a : BitVec 32) :
    C99IntegerReference.convert .int32 (C99IntegerReference.Value.int32 a).integer=.int32 a := by
  change C99IntegerReference.Value.int32 (BitVec.ofInt 32 a.toInt)=_
  rw [BitVec.ofInt_toInt]

theorem decrement (n : Int) (lower : -1≤n) (upper : n≤128) :
    C99IntegerReference.ArithmeticExec .plus (.int32 (BitVec.ofInt 32 n))
      (.int32 (-1)) (.int32 (BitVec.ofInt 32 (n-1))) := by
  apply (C99IntegerReference.arithmetic_iff _ _ _ _).mpr
  have ni := signed_exact n (by omega) (by omega)
  simp only [C99IntegerReference.Value.type,C99IntegerReference.promote,C99IntegerReference.usual,
    ite_true,C99IntegerReference.exact,C99IntegerReference.convert,
    C99IntegerReference.Value.integer,BitVec.ofInt_toInt,ni]
  constructor
  · intro _
    change -2147483648≤n+(-1 : Int) ∧ n+(-1 : Int)<2147483648
    omega
  · congr 2

theorem guard_eval (args : Args) (s : State) (l : Locals) (value : Value) (n : Int)
    (lower : -1≤n) (upper : n≤128) (cell : Cell n s.locals)
    (source : Eval args s.heap s.buf KeygenCodecStaticBinding.guard087 s.locals value l) :
    truth value=decide (0≤n) ∧ Cell (n-1) l := by
  cases source with
  | binary op a b before middle last x y z first second binaryOperation =>
    cases first with
    | postDec name before middle old next updated =>
      cases updated with
      | scalar name delta before ty v z bound operation =>
        have equal : ty=.int32 ∧ v=.int32 (BitVec.ofInt 32 n) := by
          simpa only [Cell,Option.some.injEq,Prod.mk.injEq,Option.some.injEq] using bound.symm.trans cell
        obtain ⟨rfl,rfl⟩ := equal
        have same := C99IntegerReference.arithmetic_deterministic _ _ _ _ _ operation (decrement n lower upper)
        subst z
        obtain ⟨hy,ht⟩ := KeygenCodecNoneLength.number_eval args s.heap s.buf .i32 0 (.int32 0) _ l y (by decide +kernel) second
        subst y
        subst l
        cases binaryOperation with
        | ge x y z compared =>
          cases compared with
          | step ty ht a b ha hb =>
            subst ty
            subst a
            subst b
            have ni := signed_exact n (by omega) (by omega)
            constructor
            · simp only [C99IntegerReference.Value.type,C99IntegerReference.promote,C99IntegerReference.usual,
              ite_true,C99IntegerReference.convert,C99IntegerReference.Value.integer,BitVec.ofInt_toInt,ni,C99IntegerReference.compare]
              by_cases positive : 0≤n <;> simp [positive,truth,C99IntegerReference.Value.integer]
            · simp only [Cell,localSet,C99ScalarReference.set,ite_true,
              C99IntegerReference.Value.integer,signed_exact (n-1) (by omega) (by omega),C99IntegerReference.convert]

theorem body_frame (args : Args) (s t : State) (flow : Flow) (n : Int)
    (cell : Cell n s.locals)
    (source : Exec args KeygenCodecStaticBinding.node086 s t flow) : Cell n t.locals :=
  (KeygenCodecCellFrame.exec_frame "ne".toList args _ s t flow source (by decide +kernel)).trans cell

/-- Every normally completed actual unary loop exits with ne=-2, deriving
    the old ne=-1 at its final guard instead of assuming that terminal fact. -/
theorem normal_exit (args : Args) (s t : State) (flow : Flow)
    (source : Exec args KeygenCodecStaticBinding.node087 s t flow)
    (normal : flow=.normal) (n : Int) (lower : -1≤n) (upper : n≤128) (cell : Cell n s.locals) :
    Cell (-2) t.locals := by
  generalize codeEq : KeygenCodecStaticBinding.node087=code at source
  induction source generalizing n with
  | whileDone args test a s value locals evaluated no =>
    cases codeEq
    obtain ⟨guard,last⟩ := guard_eval args s locals value n lower upper cell evaluated
    rw [guard] at no
    have negative : ¬0≤n := by simpa using no
    have same : n=(-1 : Int) := by omega
    simpa only [same,withLocals,Int.reduceSub] using last
  | whileNext args test a s middle t flow value locals evaluated yes iteration rest ih1 ih2 =>
    cases codeEq
    obtain ⟨guard,last⟩ := guard_eval args s locals value n lower upper cell evaluated
    rw [guard] at yes
    have positive : 0≤n := by simpa using yes
    exact ih2 normal (n-1) (by omega) (by omega) (body_frame args _ middle .normal (n-1) last iteration) rfl
  | whileReturn => cases normal
  | _ => cases codeEq

end FT1536.Source3.KeygenCodecStaticCountdown
