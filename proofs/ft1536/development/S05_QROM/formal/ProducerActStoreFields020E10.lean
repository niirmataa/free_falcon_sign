import ProducerActDecision020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActStoreFields020E10
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerCoreSlots020E6 ProducerReference020E7 ProducerEval020E7
open ProducerActSource020E10
attribute [local irreducible] ProducerCoreCircuit020E6.w ProducerCoreCircuit020E6.isPhase

def storeFlag : MemoryEdit020E5.Edit → Word | .keep | .fault => 0 | _ => 1

theorem no_sweep (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) : eval (env d) valueStep=0 := by
  simp only [valueStep,and_eval,or_eval,ProducerPhaseCases020E8.phase d 1 (by decide),ProducerPhaseCases020E8.phase d 2 (by decide),hp,CoreEncoding020E5.phaseTag]
  rfl

theorem flag_zero (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) (ha : eval (env d) actStore=0) (j : Nat) :
    eval (env d) (dataPresent j)=0 := by
  simp only [dataPresent,and_eval,or_eval,no_sweep d hp,ProducerDataFlags020E9.no_push d (by simp [hp]),ha]
  rfl

theorem flag_one (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) (ha : eval (env d) actStore=1) (j : Nat) :
    eval (env d) (dataPresent j)=if j=0 then (1 : Word) else 0 := by
  simp only [dataPresent,and_eval,or_eval,no_sweep d hp,ProducerDataFlags020E9.no_push d (by simp [hp]),ha]
  by_cases hj : j=0 <;> simp only [hj,ite_true,ite_false,literal] <;> rfl

theorem rejected (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) (hr : result d=none) :
    eval (env d) actStore=0 := by
  have hok : eval (env d) actionOK=0 := (ProducerActDecision020E10.correct d).1.trans (by rw [hr];rfl)
  simp only [actStore,and_eval,ProducerPhaseCases020E8.phase d 3 (by decide),hp,CoreEncoding020E5.phaseTag,hok]
  rfl

theorem accepted (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act)
    (p : FixedAction020E5.Pending 877) (e : MemoryEdit020E5.Edit) (hr : result d=some (p,e)) :
    eval (env d) actStore=storeFlag e := by
  have hok : eval (env d) actionOK=1 := (ProducerActDecision020E10.correct d).1.trans (by rw [hr];rfl)
  have he := ((ProducerActDecision020E10.correct d).2 p e hr).1.1
  simp only [actStore,and_eval,ProducerPhaseCases020E8.phase d 3 (by decide),hp,CoreEncoding020E5.phaseTag,hok,not_eval,lt_eval,literal,he]
  cases e <;> rfl

theorem value (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) (ha : eval (env d) actStore=1) :
    eval (env d) (dataValue 0)=eval (env d) editValue := by
  simp only [dataValue,choose_eval,no_sweep d hp,ha]
  rfl

theorem address (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) (ha : eval (env d) actStore=1) :
    eval (env d) (dataAddress 0)=op .add (eval (env d) editAddress)
      (if op .eq (eval (env d) editTag) (word 2)=0 then
        if op .eq (eval (env d) editTag) (word 3)=0 then word 4640 else word 32 else word 0) := by
  simp only [dataAddress,choose_eval,no_sweep d hp,ha,add_eval,eq_eval,literal]
  rfl

end FT1536.S05.ProducerActStoreFields020E10
