import OutputSlice020D
import MachineAtoms020D
import ScalarExpr020D
import Interleaved020D
import BitValue020A

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.EmitStep020D
open WordRAM020 PairProgram020 ReadSemantics020A WordArithmetic020
open MachineAtoms020D ScalarExpr020D BitValue020A

def body : Code := seqs [.atom (.emit (r 28) (mod (r 30) (lit 2))),
  set 30 (div (r 30) (lit 2)),inc 28,set 4 (sub (r 4) (lit 1))]
def result (s : State) (b : Fin outputSize) (a n : Nat) : State :=
  put (put (put {s with out := Function.update s.out b (decide (a%2=1))}
    30 (word ((a/2:Nat):Int))) 28 (word ((b.val+1:Nat):Int))) 4 (word (n:Int))

theorem exec_emit (i : Input) (s : State) (a v : Expr) :
    exec i (.atom (.emit a v)) s=(match address outputSize (eval s a) with
      | none => fail s | some k => {s with out := Function.update s.out k (eval s v != 0)}) := rfl

attribute [local irreducible] exec loopState

theorem low_bit (a : Nat) : (word ((a%2:Nat):Int) != 0)=decide (a%2=1) := by
  rcases Interleaved020D.parity a with he|he <;> rw [he] <;> decide

theorem body_correct (i : Input) (s : State) (b : Fin outputSize) (a n : Nat)
    (ha : a<2^384) (hn : n<384) (h28 : s.reg 28=word (b.val:Int))
    (h30 : s.reg 30=word (a:Int)) (h4 : s.reg 4=word ((n+1:Nat):Int)) :
    exec i body s=result s b a n := by
  have hb := b.isLt
  have fa : Fits (a:Int) := nat_fits (lt_trans ha (by norm_num))
  have f2 : Fits (2:Int) := small_nat 2 (by decide)
  have emod : eval s (mod (r 30) (lit 2))=word ((a%2:Nat):Int) := by
    change op .mod (s.reg 30) (word 2)=_
    rw [h30,mod_word (a:Int) (2:Int) fa f2]
    rfl
  let q0 : State := {s with out := Function.update s.out b (decide (a%2=1))}
  have writeBit : exec i (.atom (.emit (r 28) (mod (r 30) (lit 2)))) s=q0 := by
    rw [exec_emit]
    change (match address outputSize (s.reg 28) with
      | none => fail s | some k => {s with out := Function.update s.out k (eval s (mod (r 30) (lit 2)) != 0)})=q0
    rw [h28,address_exact outputSize b.val b.isLt (by unfold outputSize at hb;norm_num;omega),emod,low_bit]
  have ediv : eval q0 (div (r 30) (lit 2))=word ((a/2:Nat):Int) := by
    change op .div (s.reg 30) (word 2)=_
    rw [h30,div_word (a:Int) (2:Int) fa f2]
    rfl
  let q1 := put q0 30 (word ((a/2:Nat):Int))
  have q128 : q1.reg 28=word (b.val:Int) := (put_other q0 30 28 _ (by decide)).trans h28
  have ei : eval q1 (add (r 28) (lit 1))=word ((b.val+1:Nat):Int) :=
    inc_eval q1 28 b.val (by unfold outputSize at hb;omega) q128
  let q2 := put q1 28 (word ((b.val+1:Nat):Int))
  have q24 : q2.reg 4=word ((n+1:Nat):Int) := by
    exact (put_other q1 28 4 _ (by decide)).trans ((put_other q0 30 4 _ (by decide)).trans h4)
  have es : eval q2 (sub (r 4) (lit 1))=word (n:Int) := by
    change op .sub (q2.reg 4) (word 1)=_
    rw [q24,sub_word ((n+1:Nat):Int) (1:Int) (small_nat (n+1) (by omega)) (show Fits (1:Int) from small_nat 1 (by decide))]
    apply congrArg word
    push_cast
    ring
  simp only [body,exec_seqs_cons,exec_seqs_nil,writeBit,exec_set,ediv,inc]
  change put (put q1 28 (eval q1 (add (r 28) (lit 1)))) 4
    (eval (put q1 28 (eval q1 (add (r 28) (lit 1)))) (sub (r 4) (lit 1)))=_
  rw [ei]
  change put q2 4 (eval q2 (sub (r 4) (lit 1)))=_
  rw [es]
  rfl

theorem result_remaining (s : State) (b : Fin outputSize) (a n : Nat) :
    (result s b a n).reg 4=word (n:Int) := put_same _ _ _
theorem result_value (s : State) (b : Fin outputSize) (a n : Nat) :
    (result s b a n).reg 30=word ((a/2:Nat):Int) := by
  unfold result;rw [put_other _ 4 30 _ (by decide),put_other _ 28 30 _ (by decide),put_same]
theorem result_cursor (s : State) (b : Fin outputSize) (a n : Nat) :
    (result s b a n).reg 28=word ((b.val+1:Nat):Int) := by
  unfold result;rw [put_other _ 4 28 _ (by decide),put_same]
theorem result_frame (s : State) (b : Fin outputSize) (a n : Nat) :
    (result s b a n).ram=s.ram ∧ (result s b a n).fault=s.fault := ⟨rfl,rfl⟩
theorem result_other (s : State) (b : Fin outputSize) (a n : Nat) (rr : Reg)
    (h4 : rr≠4) (h28 : rr≠28) (h30 : rr≠30) : (result s b a n).reg rr=s.reg rr := by
  unfold result
  rw [put_other _ 4 rr _ h4,put_other _ 28 rr _ h28,put_other _ 30 rr _ h30]

end FT1536.S05.EmitStep020D
