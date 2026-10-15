import Source3.KeygenSearchExtended133
import Source3.KeygenAttemptSlots

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.KeygenSearchPreservation133
open C99ArrayReference (State Name)
open C99ProcedureReference (Result)
open KeygenSearchContext (Context)
open KeygenAttemptSlots (Slots searchOnly procedure trans restore)

theorem search (ctx : KeygenSearchContext.Context) (code : KeygenSearchExec.Stmt) (before : State) (out : Result)
    (source : KeygenSearchExtended133.Exec ctx code before out) (checked : searchOnly code=true) : Slots before out.state := by
  induction source with
  | procedure code before out source => exact procedure _ _ _ _ source checked
  | pointer => cases checked
  | small args before after source => cases source; exact ⟨rfl,rfl⟩
  | seqNormal a b before middle out head tail ih1 ih2 =>
    exact trans _ _ _ (ih1 (Bool.and_eq_true_iff.mp checked).1) (ih2 (Bool.and_eq_true_iff.mp checked).2)
  | seqExit a b before out head exit ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | scope locals pointers body before out inner ih => exact restore _ _ _ _ (ih checked)
  | branchTrue _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | branchFalse _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).2
  | loopNormal condition body increment before middle next out v guard nonzero iteration update rest ih1 ih2 ih3 =>
    exact trans _ _ _ (ih1 (Bool.and_eq_true_iff.mp checked).1)
      (trans _ _ _ (ih2 (Bool.and_eq_true_iff.mp checked).2) (ih3 checked))
  | loopReturn _ _ _ _ _ _ _ _ _ _ ih => exact ih (Bool.and_eq_true_iff.mp checked).1
  | logn | assign | store32 | store64 | move | loopFalse => exact ⟨rfl,rfl⟩

open KeygenMemoryStability
open KeygenHelperStability (compose)
open KeygenSearchStability (small_to_fp)

theorem stable (ctx : Context) (code : KeygenSearchExec.Stmt) (before : State) (out : Result)
    (source : KeygenSearchExtended133.Exec ctx code before out) : Stable before.heap out.state.heap := by
  induction source
  case procedure code before out source => exact procedure _ _ _ _ source
  case store32 dst index e before after p v address value write => exact store32 _ _ _ _ write
  case store64 dst index e before after p v address value write => exact store64 _ _ _ _ write
  case move dst src count before after p q word destination source length copy => exact move _ _ _ _ _ copy
  case small args before after source => exact small_to_fp _ _ _ source
  all_goals first | exact refl _ | assumption | solve_by_elim [compose]
end FT1536.Source3.KeygenSearchPreservation133
