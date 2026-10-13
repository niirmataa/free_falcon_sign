import ProducerControlCheck020E8
import ProducerControlSweep020E8
import ProducerControlTerminal020E8
import ProducerControlPush020E8
import ProducerMetaSource020E6

set_option maxRecDepth 8192
namespace FT1536.S05.ProducerControlNonact020E8
open WordRAM020 ProducerExpr020E6 ProducerCoreCircuit020E6 ProducerMetaWords020E8

theorem raw (d : BoundaryPayload020E5.Data) (ha : d.core.phase≠CoreState020E5.Phase.act) (j : Fin 16) :
    eval (ProducerReference020E7.env d) (nextMeta j.val)=
      words (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j.val := by
  cases hp : d.core.phase with
  | check => exact ProducerControlCheck020E8.control d hp j
  | clear => exact ProducerControlSweep020E8.clear d hp j
  | scan => exact ProducerControlSweep020E8.scan d hp j
  | act => exact False.elim (ha hp)
  | push => exact ProducerControlPush020E8.control d hp j
  | done => exact ProducerControlTerminal020E8.done d hp j
  | bad => exact ProducerControlTerminal020E8.bad d hp j

/-- Actual resident-bank reader followed by the concrete circuit: every
    control word matches the old step outside act. Data writes are separate. -/
theorem source (d : BoundaryPayload020E5.Data) (fresh : Bool)
    (ha : d.core.phase≠CoreState020E5.Phase.act) (j : Fin 16) :
    eval (ProducerMetaSource020E6.env d fresh) (nextMeta j.val)=
      (CoreEncoding020E5.metaCodec 877 28941 1106642201817 ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl).encode
        (CoreControl020E5.next d.parser.arena (ProducerSlotLayout020E7.input d) d.core) j :=
  (ProducerReference020E7.scalar d fresh _).trans ((raw d ha j).trans (meta_codec _ _ _ _ j).symm)

end FT1536.S05.ProducerControlNonact020E8
