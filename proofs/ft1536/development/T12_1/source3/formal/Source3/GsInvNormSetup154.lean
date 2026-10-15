import Source3.FftDimension150
import Source3.GsInvNormLoop154
import Source3.C99Declared147
import Source3.C99ScopeFrame147
import Source3.C99OuterScalar144

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.GsInvNormSetup154
open C99ArrayReference (State Name)
open C99LoopScalar141 (Cell)
open FftLocalCells140 (put)

def names : List Name := ["n".toList,"hn".toList,"u".toList]
def declared (s : State) := C99DeclarationStatements.effect .u64 names s
def sized (s : State) := put (declared s) "n".toList 1536
def halfSized (s : State) := put (sized s) "hn".toList 768
def initial (s : State) := put (halfSized s) "u".toList 0

theorem declaration_shape : GsInvNormShape154.declaration=.base (.scalar (.declare .u64 names)) := by rfl
theorem declaration (s : State) : C99ProcedureReference.Exec KeygenSearchFft.program GsInvNormShape154.declaration s ⟨declared s,.normal⟩ :=
  .base _ _ _ (C99DeclarationStatements.source_exists _ .u64 names s)

theorem declared_outside (s : State) (key : Name) (absent : key∉names) : (declared s).locals key=s.locals key :=
  C99DeclareOutside140.source .uint64 names s.locals key absent

theorem declared_cell (s : State) (key : Name) (member : key∈names) : (declared s).locals key=some (.uint64,none) :=
  C99Declared147.member .uint64 names s.locals key member

theorem size (s : State) (full : s.locals "full".toList=some (.uint32,some (.uint32 1)))
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10))) :
    C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.size (declared s) ⟨sized s,.normal⟩ := by
  rw [FftDimension150.size_shape]
  exact .base _ _ _ (FftLocalCells140.assign _ (declared s) "n".toList _ none 1536
    (declared_cell s _ (by decide)) (.scalar _ _ (FftDimension150.source (declared s)
      ((declared_outside s _ (by decide)).trans full) ((declared_outside s _ (by decide)).trans logn))))

theorem half_size (s : State) : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.halfSize (sized s) ⟨halfSized s,.normal⟩ :=
  C99OuterScalar144.assign_half _ (sized s) "hn".toList "n".toList none 1536 (by decide)
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (declared_cell s _ (by decide)))
    (FftLocalCells140.cell_at (declared s) "n".toList 1536)

theorem initialization (s : State) : C99ProcedureReference.Exec KeygenSearchFft.program FftShape138.firstInitial (halfSized s) ⟨initial s,.normal⟩ :=
  C99OuterScalar144.clear _ (halfSized s) "u".toList none
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans
      ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (declared_cell s _ (by decide))))

theorem frame (s : State) : C99ScopeFrame147.Frame names s (initial s) :=
  C99ScopeFrame147.trans names s (declared s) (initial s)
    ⟨fun key absent => declared_outside s key absent,rfl,rfl,rfl⟩
    (C99ScopeFrame147.trans names (declared s) (sized s) (initial s)
      (C99ScopeFrame147.put names (declared s) "n".toList 1536 (by decide))
      (C99ScopeFrame147.trans names (sized s) (halfSized s) (initial s)
        (C99ScopeFrame147.put names (sized s) "hn".toList 768 (by decide))
        (C99ScopeFrame147.put names (halfSized s) "u".toList 0 (by decide))))

theorem n_cell (s : State) : Cell (initial s) "n".toList 1536 :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans
    ((FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at (declared s) "n".toList 1536))
theorem hn_cell (s : State) : Cell (initial s) "hn".toList 768 :=
  (FftLocalCells140.outside _ _ _ _ (by decide)).trans (FftLocalCells140.cell_at (sized s) "hn".toList 768)
theorem u_cell (s : State) : Cell (initial s) "u".toList 0 := FftLocalCells140.cell_at (halfSized s) "u".toList 0

theorem remaining_declared (s : State) (key : Name) (member : key∈names)
    (notN : key≠"n".toList) (notHn : key≠"hn".toList) (notU : key≠"u".toList) :
    (initial s).locals key=some (.uint64,none) :=
  (FftLocalCells140.outside _ _ _ _ notU).trans
    ((FftLocalCells140.outside _ _ _ _ notHn).trans
      ((FftLocalCells140.outside _ _ _ _ notN).trans (declared_cell s key member)))

end FT1536.Source3.GsInvNormSetup154
