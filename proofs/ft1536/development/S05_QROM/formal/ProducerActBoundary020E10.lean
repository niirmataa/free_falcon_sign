import ProducerWholeStep020E10

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerActBoundary020E10
open WordRAM020 ArrayBank020E4 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerReference020E7
open ProducerReferenceData020E8 ProducerActSource020E10

theorem rejected_no_data (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.act)
    (hr : result d=none) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=0 :=
  ProducerDataSlots020E9.inactive d fresh j f
    (ProducerActStoreFields020E10.flag_zero d hp (ProducerActStoreFields020E10.rejected d hp hr) j.val)

theorem fault_no_data (d : BoundaryPayload020E5.Data) (fresh : Bool) (hp : d.core.phase=.act)
    (p : FixedAction020E5.Pending 877) (hr : result d=some (p,.fault)) (j : Fin 3) (f : Fin 3) :
    read (ProducerStored020E6.run d fresh) (finProdFinEquiv (dataSlot j,f))=0 :=
  ProducerDataSlots020E9.inactive d fresh j f
    (ProducerActStoreFields020E10.flag_zero d hp (ProducerActStoreFields020E10.accepted d hp p .fault hr) j.val)

/-- Rejection changes the phase to bad while preserving the previous fault bit. -/
theorem rejected_control (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act) (hr : result d=none) :
    eval (env d) (nextMeta 0)=word 6 ∧ eval (env d) (nextMeta 15)=WordCodec020E5.boolWord d.core.state.fault := by
  constructor
  · apply (ProducerControlAct020E10.correct d hp 0).trans
    rw [ProducerActOutcome020E10.control_eq d hp,hr];rfl
  · apply (ProducerControlAct020E10.correct d hp 15).trans
    rw [ProducerActOutcome020E10.control_eq d hp,hr];rfl

/-- An accepted fault changes the phase to push and sets the fault bit. -/
theorem fault_control (d : BoundaryPayload020E5.Data) (hp : d.core.phase=.act)
    (p : FixedAction020E5.Pending 877) (hr : result d=some (p,.fault)) :
    eval (env d) (nextMeta 0)=word 4 ∧ eval (env d) (nextMeta 15)=1 := by
  constructor
  · apply (ProducerControlAct020E10.correct d hp 0).trans
    rw [ProducerActOutcome020E10.control_eq d hp,hr];rfl
  · apply (ProducerControlAct020E10.correct d hp 15).trans
    rw [ProducerActOutcome020E10.control_eq d hp,hr];rfl

end FT1536.S05.ProducerActBoundary020E10
