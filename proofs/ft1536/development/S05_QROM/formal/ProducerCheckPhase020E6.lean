import ProducerPhaseFacts020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerCheckPhase020E6
open WordRAM020 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreCircuit020E6 ProducerMetaSource020E6
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isPhase

theorem eq_zero {regions : Nat} {extent : Fin regions → Nat} (sources : ProducerMachine020E6.Sources extent)
    (e : ProducerExpr020E6.Expr regions) (n : Nat) (hn : n<2^511) (h : eval sources e=word n) :
    eval sources (ProducerScalar020E6.eq e (lit 0))=if n=0 then (1 : Word) else 0 := by
  simp only [ProducerScalar020E6.eq,lit,ProducerExpr020E6.eval,h]
  exact ProducerWordLaws020E6.eq_nat hn (by norm_num)

theorem phase (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=CoreState020E5.Phase.check) :
    eval (env d fresh) nextPhase=if d.core.frames.sp.val=0 then (5 : Word) else if d.core.left.val=0 then 6 else 1 := by
  have hphase := (ProducerPhaseFacts020E6.phase_check d fresh hp).1
  have hs := eq_zero (env d fresh) (w 3) d.core.frames.sp.val
    (lt_trans d.core.frames.sp.isLt (by norm_num)) (ProducerMetaSource020E6.sp d fresh)
  have hl := eq_zero (env d fresh) (w 2) d.core.left.val
    (lt_trans d.core.left.isLt (by norm_num)) (ProducerMetaSource020E6.left d fresh)
  have h10 : (1 : Word)≠0 := by decide +kernel
  simp only [nextPhase,choose,ProducerExpr020E6.eval,hphase,h10,ite_false,hs,hl]
  by_cases hz : d.core.frames.sp.val=0
  · simp only [hz,ite_true,h10,ite_false];rfl
  · simp only [hz,ite_false,ite_true]
    by_cases hleft : d.core.left.val=0
    · simp only [hleft,ite_true,h10,ite_false];rfl
    · simp only [hleft,ite_false,ite_true];rfl

end FT1536.S05.ProducerCheckPhase020E6
