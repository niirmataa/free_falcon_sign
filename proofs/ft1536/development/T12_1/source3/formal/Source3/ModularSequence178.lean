import Source3.SelectedGeneratorEntry178

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.ModularSequence178
open C99ModularReference (Stmt GenExec CallRelation chainOf)
open C99ArrayReference (State)

inductive Run (calls : CallRelation) : List Stmt → State → State → Prop where
  | nil (s : State) : Run calls [] s s
  | cons (code : Stmt) (rest : List Stmt) (before middle after : State)
      (head : GenExec calls code before ⟨middle,.normal⟩) (tail : Run calls rest middle after) :
      Run calls (code::rest) before after

theorem source (calls : CallRelation) (steps : List Stmt) (before after : State)
    (run : Run calls steps before after) (tail : List Stmt) (out : C99ProcedureReference.Result)
    (rest : GenExec calls (chainOf tail) after out) :
    GenExec calls (chainOf (steps++tail)) before out := by
  induction run with
  | nil => exact rest
  | cons code codes before middle after head _ ih =>
    exact .seqNormal _ _ before middle out head (ih rest)

theorem complete (calls : CallRelation) (steps : List Stmt) (before after : State)
    (run : Run calls steps before after) : GenExec calls (chainOf steps) before ⟨after,.normal⟩ := by
  have h := source calls steps before after run [] ⟨after,.normal⟩ (.base .skip after after (.skip after))
  simpa only [List.append_nil] using h

end FT1536.Source3.ModularSequence178
