import Source3.C99DeclareOutside140
import Source3.FftLocalCells140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.C99Declared147
open C99ArrayReference (State Name)

theorem member (ty : C99IntegerReference.Ty) (names : List Name) (before : C99ScalarReference.Env)
    (name : Name) (found : name∈names) : (C99DeclarationCells.declareCells ty names before) name=some (ty,none) := by
  induction names generalizing before with
  | nil => cases found
  | cons first rest ih =>
    change (C99DeclarationCells.declareCells ty rest (C99ScalarReference.set before first (ty,none))) name=_
    by_cases tail : name∈rest
    · exact ih _ tail
    · have same : name=first := (List.mem_cons.mp found).resolve_right tail
      rw [C99DeclareOutside140.source ty rest _ name tail]
      simp only [C99ScalarReference.set,same,ite_true]

def Declared (s : State) (names : List Name) : Prop :=
  ∀ name∈names, ∃ old, s.locals name=some (.uint64,old)

theorem put (s : State) (names : List Name) (target : Name) (value : BitVec 64)
    (declared : Declared s names) : Declared (FftLocalCells140.put s target value) names := by
  intro name member
  by_cases same : name=target
  · subst name
    exact ⟨some (.uint64 value),FftLocalCells140.cell_at s target value⟩
  · obtain ⟨old,cell⟩ := declared name member
    exact ⟨old,(FftLocalCells140.outside s target name value same).trans cell⟩

end FT1536.Source3.C99Declared147
