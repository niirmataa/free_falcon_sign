import ProducerRawCore020E11
import CoreRun020E5

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerRawDriver020E11
open WordRAM020 ArrayBank020E4 ProducerRawCore020E11

def phase (m : Memory) : Word := read m (ProducerCoreRead020E6.metaPtr 0)
def terminal (m : Memory) : Bool := decide (phase m=word 5 ∨ phase m=word 6)

/-- The only mutable state threaded between iterations is raw memory.
    Outer none is a malformed-command failure, distinct from old Core.result. -/
def run (c : Context) : Nat → Memory → Option Memory
  | 0,m => some m
  | fuel+1,m => if terminal m then some m else (ProducerRawCore020E11.step c m).bind (run c fuel)

theorem phase_image (q : Core) : phase (image q)=word (CoreEncoding020E5.phaseTag q.phase).val :=
  (ProducerCoreRead020E6.meta_read q 0).trans (by rfl)

theorem terminal_image (q : Core) : terminal (image q)=decide (CoreState020E5.terminal q) := by
  rw [terminal,phase_image]
  cases hp : q.phase <;> simp only [CoreState020E5.terminal,hp] <;> rfl

theorem refines (d : BoundaryPayload020E5.Data) (fresh : Bool) (fuel : Nat) (q : Core) :
    run (ofData d fresh) fuel (image q)=
      some (image (CoreRun020E5.run d.parser.arena (ProducerSlotLayout020E7.input d) fuel q)) := by
  induction fuel generalizing q with
  | zero => rfl
  | succ fuel ih =>
    simp only [run,terminal_image,CoreRun020E5.run]
    by_cases ht : CoreState020E5.terminal q
    · simp only [ht,decide_true,ite_true]
    · simp only [ht,decide_false,Bool.false_eq_true,ite_false,ProducerRawCore020E11.step_image,Option.bind_some]
      exact ih (CoreStep020E5.step d.parser.arena (ProducerSlotLayout020E7.input d) q)

theorem stop (c : Context) (fuel : Nat) (m : Memory) (ht : terminal m=true) : run c fuel m=some m := by
  cases fuel with
  | zero => rfl
  | succ fuel => simp only [run,ht,ite_true]

theorem malformed_next (c : Context) (fuel : Nat) (m : Memory) (ht : terminal m=false)
    (he : ProducerRawCore020E11.step c m=none) : run c (fuel+1) m=none := by
  simp only [run,ht,Bool.false_eq_true,ite_false,he,Option.bind_none]

end FT1536.S05.ProducerRawDriver020E11
