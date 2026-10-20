import Source3.KeygenPublicSource

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

/- Independent of the byte footprint, actual public helper execution also
   preserves allocation metadata and every immutable source-table byte. -/
namespace FT1536.Source3.KeygenPublicStability
open C99ArrayReference (State)
open C99ProcedureReference (Result)
open KeygenPublicExec
open KeygenMemoryStability (Stable)
open KeygenHelperStability (compose)

theorem body (program : Program) (signed : List C99ArrayReference.Name) (code : Stmt)
    (before : State) (out : Result) (source : Exec program signed code before out) : Stable before.heap out.state.heap := by
  induction source
  case store signed name index cast e before heap p v address value write => exact KeygenRootObjects.store16 _ _ _ _ write
  case call signed name args f before entry out lookup binding source returned ih =>
    rw [KeygenPublicWord.bind_heap _ _ _ _ binding] at ih
    exact ih
  case arrayScope signed name count code before out localBlock positive size fresh source ih =>
    refine ⟨?_,?_,?_⟩
    · funext b
      by_cases eq : b=localBlock
      · simp only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,eq,ite_true]
      · simpa only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,localEntry,
          C99ArrayReference.bindPointer,allocated,eq,ite_false] using congrFun ih.size b
    · funext b
      by_cases eq : b=localBlock
      · simp only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,eq,ite_true]
      · simpa only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,localEntry,
          C99ArrayReference.bindPointer,allocated,eq,ite_false] using congrFun ih.writable b
    · intro b offset readonly
      by_cases eq : b=localBlock
      · simp only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,eq,ite_true]
      · have ro : (localEntry before name localBlock count).heap.writable b=false := by
          simpa only [localEntry,C99ArrayReference.bindPointer,allocated,eq,ite_false] using readonly
        simpa only [localExit,C99ArrayReference.restoreScope,KeygenRngSource.disposed,localEntry,
          C99ArrayReference.bindPointer,allocated,eq,ite_false] using ih.readonly b offset ro
  all_goals first | exact KeygenMemoryStability.refl _ | assumption | solve_by_elim [compose]
theorem call (before after : State) (v : C99IntegerReference.Value) (source : KeygenPublicSource.Call before after v) :
    Stable before.heap after.heap := by
  cases source with
  | run entry out v binding source returned =>
    have keep := body _ _ _ _ _ source
    rw [KeygenPublicWord.bind_heap _ _ _ _ binding] at keep
    exact keep

end FT1536.Source3.KeygenPublicStability
