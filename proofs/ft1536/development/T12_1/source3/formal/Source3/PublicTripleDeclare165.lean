import Source3.PublicTripleProducts165

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicTripleDeclare165
open C99ArrayReference (State)
open KeygenPublicExec (Exec)
open PublicTripleShape165 (names firstNames productNames declarations declaration0 declaration1)
open PublicU32Locals165 (Env Has Ready)

def first (s : State) : State :=
  {s with locals := C99DeclarationCells.declareCells .uint32 (firstNames.map String.toList) s.locals}
def after (s : State) : State :=
  {first s with locals := C99DeclarationCells.declareCells .uint32 (productNames.map String.toList) (first s).locals}

theorem source (s : State) : Exec KeygenPublicSource.program [] declarations s ⟨after s,.normal⟩ :=
  PublicGenerateRow159.chain_step _ _ s (first s) ⟨after s,.normal⟩
    (.scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32
      (firstNames.map String.toList) s.locals))
    (PublicGenerateRow159.chain_step _ _ (first s) (after s) ⟨after s,.normal⟩
      (.scalar _ _ _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32
        (productNames.map String.toList) (first s).locals)) (.skip (after s)))

theorem declared (s : State) : Env (after s) names := by
  intro name member
  rcases List.mem_append.mp member with left | right
  · simp [firstNames] at left
    rcases left with rfl | rfl | rfl | rfl | rfl <;> exact ⟨none,rfl⟩
  · simp [productNames] at right
    rcases right with rfl | rfl | rfl | rfl | rfl | rfl <;> exact ⟨none,rfl⟩

theorem ready_w (s : State) (initialized : Has s "w") : Ready (after s) ["w"] := by
  intro name member
  have equal : name="w" := List.mem_singleton.mp member
  subst name
  exact initialized

end FT1536.Source3.PublicTripleDeclare165
