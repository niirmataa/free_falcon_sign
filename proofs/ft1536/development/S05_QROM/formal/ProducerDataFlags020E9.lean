import ProducerOutputSlots020E8
import ProducerScanDecision020E8

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerDataFlags020E9
open WordRAM020 ProducerExpr020E6 ProducerCoreSlots020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isPhase

theorem no_act (d : BoundaryPayload020E5.Data) (ha : d.core.phase≠CoreState020E5.Phase.act) : eval (env d) actStore=0 := by
  simp only [actStore,and_eval,ProducerPhaseCases020E8.phase d 3 (by decide)]
  cases hp : d.core.phase <;> first | exact (ha hp).elim | rfl

theorem no_push (d : BoundaryPayload020E5.Data) (ha : d.core.phase≠CoreState020E5.Phase.push) : eval (env d) pushStore=0 := by
  simp only [pushStore,and_eval,ProducerPhaseCases020E8.phase d 4 (by decide)]
  cases hp : d.core.phase <;> first | exact (ha hp).elim | rfl

theorem sweep (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.clear ∨ d.core.phase=.scan) :
    eval (env d) valueStep=if d.core.cursor.val<877 then (1 : Word) else 0 := by
  simp only [valueStep,and_eval,or_eval,ProducerPhaseCases020E8.phase d 1 (by decide),
    ProducerPhaseCases020E8.phase d 2 (by decide)]
  rcases hp with hp|hp <;> rw [hp]
  all_goals exact ProducerFlags020E8.cursor_test d

theorem push_value (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.push) : eval (env d) valueStep=0 := by
  simp only [valueStep,and_eval,or_eval,ProducerPhaseCases020E8.phase d 1 (by decide),
    ProducerPhaseCases020E8.phase d 2 (by decide),hp,CoreEncoding020E5.phaseTag]
  rfl

theorem push_flag (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.push) :
    eval (env d) pushStore=if ProducerFlags020E8.present d.core.pending=0 then 0
      else if d.core.frames.sp.val<28941 then (1 : Word) else 0 := by
  simp only [pushStore,and_eval,ProducerPhaseCases020E8.phase d 4 (by decide),hp,
    ProducerFlags020E8.pending_present,ProducerFlags020E8.room,CoreEncoding020E5.phaseTag]
  rfl

theorem sweep_present (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.clear ∨ d.core.phase=.scan) (j : Nat) :
    eval (env d) (dataPresent j)=if d.core.cursor.val<877 ∧ j<2 then (1 : Word) else 0 := by
  have ha : d.core.phase≠CoreState020E5.Phase.act := by rcases hp with h|h <;> simp [h]
  have hb : d.core.phase≠CoreState020E5.Phase.push := by rcases hp with h|h <;> simp [h]
  simp only [dataPresent,or_eval,and_eval,sweep d hp,no_act d ha,no_push d hb]
  by_cases h : d.core.cursor.val<877 <;> by_cases hj : j<2 <;> simp [h,hj,ProducerWordLaws020E6.word_one,ProducerWordLaws020E6.word_zero]

theorem push_present (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.push) (j : Nat) :
    eval (env d) (dataPresent j)=eval (env d) pushStore := by
  simp only [dataPresent,or_eval,and_eval,push_value d hp,no_act d (by simp [hp])]
  rfl

end FT1536.S05.ProducerDataFlags020E9
