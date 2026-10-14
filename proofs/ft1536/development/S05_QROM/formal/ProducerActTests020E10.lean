import ProducerActHelpers020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActTests020E10
open WordRAM020 ProducerExpr020E6 ProducerScalar020E6 ProducerEval020E7

theorem eq_zero {r : Nat} {extent : Fin r → Nat} (s : ProducerMachine020E6.Sources extent) (e : Expr r) :
    eval s (ProducerScalar020E6.eq e (lit 0))=if eval s e=0 then (1 : Word) else 0 := by
  change op .eq (eval s e) 0=_
  by_cases h : eval s e=0 <;> simp only [op,h,ite_true,ite_false] <;> rfl

theorem ne_zero {r : Nat} {extent : Fin r → Nat} (s : ProducerMachine020E6.Sources extent) (e : Expr r) :
    eval s (not (ProducerScalar020E6.eq e (lit 0)))=if eval s e=0 then (0 : Word) else 1 := by
  rw [not_eval,eq_zero]
  split <;> rfl

end FT1536.S05.ProducerActTests020E10
