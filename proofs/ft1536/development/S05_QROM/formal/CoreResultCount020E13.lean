import CoreDriverCount020E13
import ProducerCoreExecution020E11

namespace FT1536.S05.CoreResultCount020E13
open ProducerRawCore020E11 CoreCountTypes020E13
attribute [local irreducible] CoreDriverCount020E13.run

/-- Retains the full result and counts of the raw core only. The final readout
    is performed but its elementary work and storage are not priced here. -/
def run (c : Context) (fuel : Nat) (m : Memory) : Report (Option (Option ArrayState020E4.State)) :=
  map (Option.map ProducerRawResult020E11.result) (CoreDriverCount020E13.run c fuel m)

theorem value (c : Context) (fuel : Nat) (m : Memory) :
    (run c fuel m).value=ProducerRawResult020E11.run c fuel m := by
  simp only [run,map,CoreDriverCount020E13.value,ProducerRawResult020E11.run]

theorem valid (c : Context) (fuel : Nat) (m : Memory) : Valid (run c fuel m).counts fuel :=
  CoreDriverCount020E13.valid c fuel m

def execute (c : Context) (m : Memory) := run c ProducerCoreExecution020E11.budget m

theorem execute_value (c : Context) (m : Memory) :
    (execute c m).value=ProducerCoreExecution020E11.execute c m := value c _ m

theorem execute_valid (c : Context) (m : Memory) :
    Valid (execute c m).counts ProducerCoreExecution020E11.budget := valid c _ m

theorem typed_value (d : BoundaryPayload020E5.Data) (fresh : Bool) (fuel : Nat) (q : Core) :
    (run (ofData d fresh) fuel (image q)).value=
      some (CoreState020E5.result (CoreRun020E5.run d.parser.arena (ProducerSlotLayout020E7.input d) fuel q)) :=
  (value _ fuel _).trans (ProducerRawResult020E11.refines d fresh fuel q)

end FT1536.S05.CoreResultCount020E13
