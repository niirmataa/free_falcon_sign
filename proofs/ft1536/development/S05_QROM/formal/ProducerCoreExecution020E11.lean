import ProducerRawResult020E11

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerCoreExecution020E11
open WordRAM020 ArrayBank020E4 ProducerRawCore020E11

/-- The inherited core-transition budget, not a time or memory bound for the
    producer/consumer implementation. -/
def budget : Nat := 1106642201817*CoreRank020E5.cycle 877+1

def execute (c : Context) (m : Memory) : Option (Option ArrayState020E4.State) :=
  ProducerRawResult020E11.run c budget m

/-- Complete old core execution at the original control limit, including its
    None result. No original transition is called by the raw driver. -/
theorem execute_refines (d : BoundaryPayload020E5.Data) (fresh : Bool)
    (s : ArrayState020E4.State) (st : ArrayFrames020E4.Stack (NodeFrames020E2.Frame 877) 28941)
    (v : ArrayValues020E4.Values 877) :
    execute (ofData d fresh) (image (CoreState020E5.start 1106642201817 s st v))=
      some (ArrayExecute020E4.execute d.parser.arena (ProducerSlotLayout020E7.input d) 1106642201817 st s) := by
  have h := ProducerRawResult020E11.refines d fresh budget (CoreState020E5.start 1106642201817 s st v)
  have he : CoreState020E5.result (CoreRun020E5.run d.parser.arena (ProducerSlotLayout020E7.input d) budget
      (CoreState020E5.start 1106642201817 s st v))=
      ArrayExecute020E4.execute d.parser.arena (ProducerSlotLayout020E7.input d) 1106642201817 st s :=
    CoreRun020E5.execute_refines _ _ 1106642201817 st s v
  exact h.trans (congrArg some he)

theorem halts (d : BoundaryPayload020E5.Data) (fresh : Bool) (fuel : Nat) (q : Core)
    (h : CoreRank020E5.rank q≤fuel) :
    ∃ m,ProducerRawDriver020E11.run (ofData d fresh) fuel (image q)=some m ∧ ProducerRawDriver020E11.terminal m=true := by
  refine ⟨image (CoreRun020E5.run d.parser.arena (ProducerSlotLayout020E7.input d) fuel q),ProducerRawDriver020E11.refines d fresh fuel q,?_⟩
  rw [ProducerRawDriver020E11.terminal_image]
  exact decide_eq_true (CoreRun020E5.halts _ _ fuel q h)

theorem zero_fuel (d : BoundaryPayload020E5.Data) (fresh : Bool) (q : Core) :
    ProducerRawResult020E11.run (ofData d fresh) 0 (image q)=some (CoreState020E5.result q) :=
  ProducerRawResult020E11.refines d fresh 0 q

theorem stopped_done (d : BoundaryPayload020E5.Data) (fresh : Bool) (fuel : Nat) (q : Core) (hp : q.phase=.done) :
    ProducerRawResult020E11.run (ofData d fresh) fuel (image q)=some (some q.state) := by
  have ht : ProducerRawDriver020E11.terminal (image q)=true := by
    rw [ProducerRawDriver020E11.terminal_image]
    simp [CoreState020E5.terminal,hp]
  rw [ProducerRawResult020E11.run,ProducerRawDriver020E11.stop _ fuel _ ht]
  simp only [Option.map_some,ProducerRawResult020E11.result_image,CoreState020E5.result,hp,ite_true]

theorem stopped_bad (d : BoundaryPayload020E5.Data) (fresh : Bool) (fuel : Nat) (q : Core) (hp : q.phase=.bad) :
    ProducerRawResult020E11.run (ofData d fresh) fuel (image q)=some none := by
  have ht : ProducerRawDriver020E11.terminal (image q)=true := by
    rw [ProducerRawDriver020E11.terminal_image]
    simp [CoreState020E5.terminal,hp]
  rw [ProducerRawResult020E11.run,ProducerRawDriver020E11.stop _ fuel _ ht]
  simp only [Option.map_some,ProducerRawResult020E11.result_image,CoreState020E5.result,hp]
  rfl

end FT1536.S05.ProducerCoreExecution020E11
