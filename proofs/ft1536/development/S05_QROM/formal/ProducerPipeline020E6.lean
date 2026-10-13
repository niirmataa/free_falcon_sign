import ProducerWindow020E6
import ProducerCoreSlots020E6
import ProducerComposition020E6
import ProducerCoreSource020E6

namespace FT1536.S05.ProducerPipeline020E6
open WordRAM020 ArrayBank020E4 ProducerExpr020E6

def window (d : BoundaryPayload020E5.Data) (fresh : Bool) : Bank Word 96 :=
  load (fun j => eval (ProducerCoreView020E6.sources d fresh) (ProducerWindow020E6.cells j))

def windowSources (w : Bank Word 96) : ProducerMachine020E6.Sources (fun _ : Fin 1 => 96) := fun _ => w

def words (d : BoundaryPayload020E5.Data) (fresh : Bool) : Bank Word 96 :=
  load (fun j => eval (windowSources (window d fresh)) (ProducerCoreSlots020E6.cells j))

/-- The generated producer actually executes the two installed bytecodes.
    The first output bank becomes the borrowed read-only source of the second. -/
def run (d : BoundaryPayload020E5.Data) (fresh : Bool) : Bank Word 96 :=
  ProducerComposition020E6.run (ProducerCoreView020E6.sources d fresh)
    ProducerWindow020E6.cells ProducerWindow020E6.workspace
    ProducerCoreSlots020E6.cells ProducerCoreSlots020E6.workspace

theorem run_words (d : BoundaryPayload020E5.Data) (fresh : Bool) : run d fresh=words d fresh :=
  ProducerComposition020E6.correct (ProducerCoreView020E6.sources d fresh)
    ProducerWindow020E6.cells ProducerWindow020E6.workspace
    ProducerCoreSlots020E6.cells ProducerCoreSlots020E6.workspace

theorem window_cell (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 96) :
    eval (windowSources (window d fresh)) (ProducerCoreCircuit020E6.w j.val)=
      eval (ProducerCoreView020E6.sources d fresh) (ProducerWindow020E6.cells j) := by
  change readWord (windowSources (window d fresh)) 0 (word j.val)=_
  exact (ProducerWordLaws020E6.load_nat (windowSources (window d fresh)) (0 : Fin 1) (by decide +kernel) j).trans
    (congrFun (read_load _) j)

theorem window_control (d : BoundaryPayload020E5.Data) (fresh : Bool) (j : Fin 16) :
    eval (windowSources (window d fresh)) (ProducerCoreCircuit020E6.w j.val)=
      (CoreEncoding020E5.metaCodec 877 28941 1106642201817 ProducerCoreRead020E6.hc ProducerCoreRead020E6.hf ProducerCoreRead020E6.hl).encode
        (CoreEncoding020E5.metadata d.core) j := by
  have hi : j.val<96 := lt_trans j.isLt (by decide)
  have h := window_cell d fresh ⟨j.val,hi⟩
  simp only [ProducerWindow020E6.cells,ite_eq_left j.isLt] at h
  exact h.trans (ProducerCoreSource020E6.control_eval d fresh j)

end FT1536.S05.ProducerPipeline020E6
