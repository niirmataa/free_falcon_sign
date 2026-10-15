import Source3.KeygenAttemptMaterial
import Source3.KeygenAttemptSlots
import Source3.KeygenPublicStability
import Source3.KeygenAttemptNorm133

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Versioned downstream declarations for the source-bound norm repair.
   Unchanged declarations/types are reused from the frozen source namespace.
   Generated candidates require a fresh kernel build and audit. -/
namespace FT1536.Source3.KeygenAttemptMaterial134
open C99ArrayReference (State Name)
open C99MemoryReference
open C99ProcedureReference (Result)
open C99IntegerReference (Value)
open KeygenSearchContext (Context)
open KeygenAttemptSlots (Slots)


open KeygenAttemptMaterial
theorem through_norm (ctx : Context) (before : State) (out : Result) (source : KeygenAttemptNorm133.Exec ctx before out)
    (f g : ArrayPointer) (fp : KeygenAttemptNorm.Protected ctx before f.block) (gp : KeygenAttemptNorm.Protected ctx before g.block)
    (material : Material before.heap f g) : Material out.state.heap f g := by
  obtain ⟨fv,gv,hf,bf,hg,bg⟩ := material
  exact ⟨fv,gv,KeygenAttemptNorm133.material _ _ _ source f fp fv hf,bf,KeygenAttemptNorm133.material _ _ _ source g gp gv hg,bg⟩

end FT1536.Source3.KeygenAttemptMaterial134
