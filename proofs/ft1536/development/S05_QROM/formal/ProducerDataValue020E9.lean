import ProducerDataFlags020E9

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerDataValue020E9
open WordRAM020 ProducerExpr020E6 ProducerCoreSlots020E6 ProducerCoreCircuit020E6 ProducerReference020E7 ProducerEval020E7
open ProducerDataFlags020E9 ProducerMetaWords020E8
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isPhase

theorem clear (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.clear)
    (h : d.core.cursor.val<877) (j : Fin 2) :
    eval (env d) (dataValue j.val)=BankStorage020E3.valueWords none j := by
  have hv : eval (env d) valueStep=1 := by rw [sweep d (Or.inl hp),ite_eq_left h]
  simp only [dataValue,choose_eval,hv,ProducerPhaseCases020E8.phase d 1 (by decide),hp,CoreEncoding020E5.phaseTag]
  fin_cases j <;> rfl

theorem scan (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.scan)
    (h : d.core.cursor.val<877) (j : Fin 2) :
    eval (env d) (dataValue j.val)=BankStorage020E3.valueWords
      (ArrayValues020E4.entry d.parser.arena d.core.state d.core.values ⟨d.core.cursor.val,h⟩) j := by
  have hv : eval (env d) valueStep=1 := by rw [sweep d (Or.inr hp),ite_eq_left h]
  have hs := ProducerScanDecision020E8.transport (eval (env d)) (eval (env d)) scanPresent scanValue
    (ProducerScanSpec020E8.entry d) (fun _ => rfl) (ProducerScanDecision020E8.correct d).1 (ProducerScanDecision020E8.correct d).2 j
  rw [ProducerScanSpec020E8.entry,dite_eq_left h] at hs
  simp only [dataValue,choose_eval,hv,ProducerPhaseCases020E8.phase d 1 (by decide),hp,CoreEncoding020E5.phaseTag]
  change eval (env d) (if j.val=0 then scanPresent else scanValue)=_
  by_cases hj : j.val=0 <;> simpa only [hj,ite_true,ite_false] using hs

theorem push_one (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.push)
    (v : NodeFrames020E2.Frame 877) (hv : d.core.pending=.one v) (j : Fin 3) :
    eval (env d) (dataValue j.val)=BankStorage020E3.frameWords v j := by
  have ht : eval (env d) pendingTwo=0 := (ProducerFlags020E8.pending_two d).trans (by rw [hv];rfl)
  simp only [dataValue,choose_eval,push_value d hp,no_act d (by simp [hp]),ht]
  change eval (env d) (w (6+j.val))=_
  rw [read_control d (6+j.val) (by have := j.isLt;omega)]
  fin_cases j <;> simp only [words,CoreEncoding020E5.metadata,hv,pending] <;> rfl

theorem push_two (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.push)
    (u v : NodeFrames020E2.Frame 877) (hv : d.core.pending=.two u v) (j : Fin 3) :
    eval (env d) (dataValue j.val)=BankStorage020E3.frameWords v j := by
  have ht : eval (env d) pendingTwo=1 := (ProducerFlags020E8.pending_two d).trans (by rw [hv];rfl)
  simp only [dataValue,choose_eval,push_value d hp,no_act d (by simp [hp]),ht]
  change eval (env d) (w (12+j.val))=_
  rw [read_control d (12+j.val) (by have := j.isLt;omega)]
  fin_cases j <;> simp only [words,CoreEncoding020E5.metadata,hv,pending] <;> rfl

end FT1536.S05.ProducerDataValue020E9
