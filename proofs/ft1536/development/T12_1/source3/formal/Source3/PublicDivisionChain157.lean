import Source3.PublicDivisionExpr157

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicDivisionChain157
open C99ArrayReference (State)
open C99ModularReference (GenExec Stmt)
open KeygenPublicDivisionWords (Instruction Ready allowed target statement update run chain names)
open PublicDivisionExpr157 (Known readable checked initializedAfter)
open KeygenPublicSquare (Slot converted_word)

theorem step (s : State) (env : String → BitVec 32) (initialized : List String) (instruction : Instruction)
    (ready : Ready s env) (known : Known s env initialized) (legal : allowed instruction=true)
    (present : readable initialized instruction=true) :
    ∃ after, GenExec KeygenPublicScalar.Square (statement instruction) s ⟨after,.normal⟩ ∧
      Ready after (update env instruction) ∧ Known after (update env instruction) (target instruction::initialized) := by
  have targetAllowed : target instruction∈names := by
    cases instruction with
    | mul n a b => exact List.contains_iff_mem.mp ((Bool.and_eq_true_iff.mp (Bool.and_eq_true_iff.mp legal).1).1)
    | square n a => exact List.contains_iff_mem.mp (Bool.and_eq_true_iff.mp legal).1
  have declared : ∃ old, s.locals (target instruction).toList=some (.uint32,old) := by
    rcases ready (target instruction) targetAllowed with uninitialized | initialized
    · exact ⟨none,uninitialized⟩
    · exact ⟨some (.uint32 (env (target instruction))),initialized⟩
  obtain ⟨old,cell⟩ := declared
  let after := C99ArrayReference.bindValue s (target instruction).toList .uint32 (.uint32 (KeygenPublicDivisionWords.result env instruction))
  have executed : GenExec KeygenPublicScalar.Square (statement instruction) s ⟨after,.normal⟩ :=
    .assign _ _ s .uint32 old _ cell (PublicDivisionExpr157.source s env initialized instruction known present)
  refine ⟨after,executed,(KeygenPublicDivisionWords.step_ready s env instruction ⟨after,.normal⟩ ready legal executed).2,?_⟩
  intro n member
  by_cases same : n=target instruction
  · subst n
    simp [Slot,after,C99ArrayReference.bindValue,C99ScalarReference.set,update,converted_word]
  · have oldMember : n∈initialized := (List.mem_cons.mp member).resolve_left same
    have bound := known n oldMember
    simpa only [Slot,after,C99ArrayReference.bindValue,C99ScalarReference.set,update,
      ite_eq_right same,show n.toList≠(target instruction).toList from fun h => same (String.toList_injective h),ite_false] using bound

/-- Checked operand initialization supplies the original source assignment chain. -/
theorem source (instructions : List Instruction) (s : State) (env : String → BitVec 32) (initialized : List String)
    (ready : Ready s env) (known : Known s env initialized)
    (legal : instructions.all allowed=true) (present : checked instructions initialized=true) :
    ∃ after, Ready after (run instructions env) ∧ Known after (run instructions env) (initializedAfter instructions initialized) ∧
      ∀ (finish : Stmt) (out : C99ProcedureReference.Result), GenExec KeygenPublicScalar.Square finish after out →
        GenExec KeygenPublicScalar.Square (chain instructions finish) s out := by
  induction instructions generalizing s env initialized with
  | nil => exact ⟨s,ready,known,fun _ _ source => source⟩
  | cons instruction rest ih =>
    obtain ⟨middle,first,middleReady,middleKnown⟩ := step s env initialized instruction ready known
      (Bool.and_eq_true_iff.mp legal).1 (Bool.and_eq_true_iff.mp present).1
    obtain ⟨after,lastReady,lastKnown,tail⟩ := ih middle (update env instruction) (target instruction::initialized)
      middleReady middleKnown (Bool.and_eq_true_iff.mp legal).2 (Bool.and_eq_true_iff.mp present).2
    exact ⟨after,lastReady,lastKnown,fun finish out last => .seqNormal _ _ _ _ _ first (tail finish out last)⟩

end FT1536.Source3.PublicDivisionChain157
