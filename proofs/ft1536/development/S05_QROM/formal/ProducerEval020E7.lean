import ProducerBoolLaws020E6
import ProducerClamp020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerEval020E7
open WordRAM020 ProducerScalar020E6 ProducerExpr020E6 WordCodec020E5
variable {r : Nat} {extent : Fin r → Nat} (s : ProducerMachine020E6.Sources extent)

@[simp] theorem literal (n : Nat) : eval s (lit n)=word n := rfl
@[simp] theorem choose_eval (c a b : E r) :
    eval s (choose c a b)=if eval s c=0 then eval s b else eval s a := rfl
@[simp] theorem add_eval (a b : E r) : eval s (add a b)=op .add (eval s a) (eval s b) := rfl
@[simp] theorem mul_eval (a b : E r) : eval s (mul a b)=op .mul (eval s a) (eval s b) := rfl
@[simp] theorem lt_eval (a b : E r) : eval s (lt a b)=op .lt (eval s a) (eval s b) := rfl
@[simp] theorem eq_eval (a b : E r) : eval s (eq a b)=op .eq (eval s a) (eval s b) := rfl
@[simp] theorem load_eval (i : Fin r) (a : E r) : eval s (.load i a)=readWord s i (eval s a) := rfl
@[simp] theorem cell_eval (i : Fin r) (n : Nat) : eval s (cell i n)=readWord s i (word n) := rfl
@[simp] theorem and_eval (a b : E r) : eval s (and a b)=if eval s a=0 then 0 else eval s b := rfl
@[simp] theorem or_eval (a b : E r) : eval s (or a b)=if eval s a=0 then eval s b else 1 := rfl
@[simp] theorem not_eval (a : E r) : eval s (not a)=op .eq (eval s a) 0 := rfl
@[simp] theorem clamp_eval (a : E r) : eval s (natClamp a)=word (eval s a).toInt.toNat := by
  exact ProducerClamp020E6.clamp _

theorem pred_nat (a : E r) (n : Nat) (hn : n<2^511) (h : eval s a=word n) :
    eval s (pred a)=word (n-1 : Nat) := by
  simp only [pred,choose_eval,eq_eval,literal,h,ProducerWordLaws020E6.eq_nat (a:=n) (b:=0) hn (by norm_num)]
  by_cases hz : n=0
  · subst n;rfl
  · simp only [hz,ite_false,ite_true]
    simp only [sub,ProducerExpr020E6.eval,h,lit]
    change op .sub (word n) (word 1)=word (n-1 : Nat)
    have ho : (word 1).toInt=1 := rfl
    simp only [op,InputLayout020.nat_word_exact n hn,ho]
    congr 1
    omega

end FT1536.S05.ProducerEval020E7
