import Source3.GsMapLoop155
import Source3.GsInvNormSetup154

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsMapSetup155
open C99ArrayReference (State Name)
open C99ProcedureReference (Exec)
open C99LoopScalar141 (Cell)
open FftLocalCells140 (put)

def adjointInitial (s : State) := put (GsInvNormSetup154.halfSized s) "u".toList 768

theorem adjoint_initialization (s : State) : Exec KeygenSearchFft.program GsMapShape155.adjointInitial
    (GsInvNormSetup154.halfSized s) ⟨adjointInitial s,.normal⟩ := by
  have declared : (GsInvNormSetup154.halfSized s).locals "u".toList=some (.uint64,none) :=
    (FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (GsInvNormSetup154.declared_cell s _ (by decide)))
  have hnCell := FftLocalCells140.cell_at (GsInvNormSetup154.sized s) "hn".toList 768
  rw [adjointInitial,FftLocalCells140.put_bind]
  exact .base _ _ _ (.scalar _ _ _ (.assign _ _ _ .uint64 none (.uint64 768) declared
    (.variable "hn".toList .uint64 (.uint64 768) hnCell)))

theorem adjoint_n (s : State) : Cell (adjointInitial s) "n".toList 1536 :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at (GsInvNormSetup154.declared s) "n".toList 1536))
theorem adjoint_u (s : State) : Cell (adjointInitial s) "u".toList 768 := FftLocalCells140.cell_at (GsInvNormSetup154.halfSized s) "u".toList 768

def scaleNames : List Name := ["n".toList,"u".toList]
def scaleDeclared (s : State) := C99DeclarationStatements.effect .u64 scaleNames s
def scaleSized (s : State) := put (scaleDeclared s) "n".toList 1536
def scaleInitial (s : State) := put (scaleSized s) "u".toList 0

theorem scale_cell (s : State) (key : Name) (member : key∈scaleNames) : (scaleDeclared s).locals key=some (.uint64,none) :=
  C99Declared147.member .uint64 scaleNames s.locals key member
theorem scale_outside (s : State) (key : Name) (absent : key∉scaleNames) : (scaleDeclared s).locals key=s.locals key :=
  C99DeclareOutside140.source .uint64 scaleNames s.locals key absent
theorem scale_declaration (s : State) : Exec (fun _ => none) GsMapShape155.scaleDeclaration s ⟨scaleDeclared s,.normal⟩ :=
  .base _ _ _ (C99DeclarationStatements.source_exists _ .u64 scaleNames s)

theorem scale_size (s : State) (full : s.locals "full".toList=some (.uint32,some (.uint32 1)))
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))) :
    Exec (fun _ => none) FftShape138.size (scaleDeclared s) ⟨scaleSized s,.normal⟩ := by
  rw [FftDimension150.size_shape]
  exact .base _ _ _ (FftLocalCells140.assign _ (scaleDeclared s) "n".toList _ none 1536
    (scale_cell s _ (by decide)) (.scalar _ _ (FftDimension150.source (scaleDeclared s)
      ((scale_outside s _ (by decide)).trans full) ((scale_outside s _ (by decide)).trans logn))))

theorem scale_initialization (s : State) : Exec (fun _ => none) FftShape138.firstInitial (scaleSized s) ⟨scaleInitial s,.normal⟩ :=
  C99OuterScalar144.clear _ (scaleSized s) "u".toList none
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (scale_cell s _ (by decide)))
theorem scale_n (s : State) : Cell (scaleInitial s) "n".toList 1536 :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at (scaleDeclared s) "n".toList 1536)
theorem scale_u (s : State) : Cell (scaleInitial s) "u".toList 0 := FftLocalCells140.cell_at (scaleSized s) "u".toList 0
theorem scale_x (s : State) (word : BitVec 64) (cell : s.locals "x".toList=some (.uint64,some (.uint64 word))) :
    (scaleInitial s).locals "x".toList=some (.uint64,some (.uint64 word)) :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans ((scale_outside s _ (by decide)).trans cell))

end FT1536.Source3.GsMapSetup155
