import ProducerWindowSource020E7
import ProducerMetaSource020E6

set_option maxRecDepth 8192
set_option exponentiation.threshold 512
namespace FT1536.S05.ProducerReference020E7
open WordRAM020 ArrayBank020E4 ProducerExpr020E6

/-- Proof-only view of the complete reference snapshot. The executable code
    continues to load the resident source banks proved equal in E7. -/
def env (d : BoundaryPayload020E5.Data) : ProducerMachine020E6.Sources (fun _ : Fin 1 => 96) :=
  fun _ => load (ProducerSnapshot020E6.fields d)

theorem scalar (d : BoundaryPayload020E5.Data) (fresh : Bool) (e : Expr 1) :
    eval (ProducerMetaSource020E6.env d fresh) e=eval (env d) e := by
  unfold ProducerMetaSource020E6.env
  rw [ProducerWindowSource020E7.window]
  rfl

theorem word_read (d : BoundaryPayload020E5.Data) (k : Nat) (hk : k<96) :
    eval (env d) (ProducerCoreCircuit020E6.w k)=ProducerSnapshot020E6.fields d ⟨k,hk⟩ := by
  change readWord (env d) 0 (word k)=_
  exact (ProducerWordLaws020E6.load_nat (env d) (0 : Fin 1) (by norm_num) ⟨k,hk⟩).trans
    (congrFun (read_load _) ⟨k,hk⟩)

/-- The concrete installed two-stage code, now expressed over the proved
    source snapshot. This does not assert CoreStep equivalence. -/
theorem stored_output (d : BoundaryPayload020E5.Data) (fresh : Bool) :
    ProducerStored020E6.run d fresh=load (fun j => eval (env d) (ProducerCoreSlots020E6.cells j)) := by
  rw [ProducerStored020E6.run_words]
  unfold ProducerPipeline020E6.words
  rw [ProducerWindowSource020E7.window]
  rfl

theorem fresh_irrelevant (d : BoundaryPayload020E5.Data) (a b : Bool) :
    ProducerStored020E6.run d a=ProducerStored020E6.run d b := by
  rw [stored_output,stored_output]

end FT1536.S05.ProducerReference020E7
