import ProducerExactCount020E13
import CoreCountTypes020E13
import ProducerRawDriver020E11

namespace FT1536.S05.CoreStepCount020E13
open ProducerRawCore020E11 CoreCountTypes020E13
attribute [local irreducible] ProducerPairCount020E13.run ConsumerCount020E13.consume

def run (c : Context) (m : Memory) : Report (Option Memory) :=
  let p := ProducerPairCount020E13.run (sources c m) ProducerStored020E6.windowCode ProducerStored020E6.slotCode
  let r := ConsumerCount020E13.consume (capacity:=32) m p.1
  ⟨r.value,⟨p.2,r.steps,r.scans,r.writes,1,0⟩⟩

theorem value (c : Context) (m : Memory) : (run c m).value=ProducerRawCore020E11.step c m := by
  simp only [run,ConsumerCount020E13.consume_value,ProducerPairCount020E13.value]
  rfl

theorem counts (c : Context) (m : Memory) :
    (run c m).counts.cycles=14733 ∧ (run c m).counts.slots=32 ∧
    (run c m).counts.scans≤32 ∧ (run c m).counts.writes≤(run c m).counts.scans ∧
    (run c m).counts.rounds=1 ∧ (run c m).counts.tests=0 := by
  have hp := ProducerExactCount020E13.core_cycles (sources c m)
  have hr := ConsumerCount020E13.consume_bound (capacity:=32) m
    (ProducerPairCount020E13.run (sources c m) ProducerStored020E6.windowCode ProducerStored020E6.slotCode).1
  exact ⟨hp,hr.1,hr.2.1,hr.2.2,rfl,rfl⟩

end FT1536.S05.CoreStepCount020E13
