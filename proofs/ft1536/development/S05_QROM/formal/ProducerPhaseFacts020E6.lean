import ProducerMetaSource020E6
import ProducerBoolLaws020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerPhaseFacts020E6
open WordRAM020 ProducerExpr020E6 ProducerScalar020E6 ProducerCoreCircuit020E6 ProducerMetaSource020E6

attribute [local irreducible] ProducerCoreCircuit020E6.w

theorem phase_eq (d : BoundaryPayload020E5.Data) (fresh : Bool) (p : Fin 7) :
    eval (env d fresh) (isPhase p.val)=WordCodec020E5.boolWord (decide ((CoreEncoding020E5.phaseTag d.core.phase).val=p.val)) := by
  simp only [isPhase,ProducerScalar020E6.eq,lit,ProducerExpr020E6.eval,ProducerMetaSource020E6.phase]
  rw [ProducerWordLaws020E6.eq_nat (lt_trans (CoreEncoding020E5.phaseTag d.core.phase).isLt (by norm_num)) (lt_trans p.isLt (by norm_num))]
  by_cases h : (CoreEncoding020E5.phaseTag d.core.phase).val=p.val
  · simp only [h,ite_true,decide_true];rfl
  · simp only [h,ite_false,decide_false];rfl

theorem phase_check (d : BoundaryPayload020E5.Data) (fresh : Bool) (h : d.core.phase=CoreState020E5.Phase.check) :
    eval (env d fresh) (isPhase 0)=1 ∧ eval (env d fresh) (isPhase 1)=0 ∧
      eval (env d fresh) (isPhase 2)=0 ∧ eval (env d fresh) (isPhase 3)=0 ∧ eval (env d fresh) (isPhase 4)=0 := by
  have h0 := phase_eq d fresh 0
  have h1 := phase_eq d fresh 1
  have h2 := phase_eq d fresh 2
  have h3 := phase_eq d fresh 3
  have h4 := phase_eq d fresh 4
  rw [h] at h0 h1 h2 h3 h4
  exact ⟨h0,h1,h2,h3,h4⟩

end FT1536.S05.ProducerPhaseFacts020E6
