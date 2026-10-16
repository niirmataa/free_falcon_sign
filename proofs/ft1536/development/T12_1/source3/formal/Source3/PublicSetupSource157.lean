import Source3.PublicCalls157
import Source3.KeygenPublicInputSetup
import Source3.C99DeclareOutside140

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000
set_option Elab.async false

namespace FT1536.Source3.PublicSetupSource157
open C99ArrayReference (State)
open C99IntegerReference (Value)
open KeygenPublicWord (Eval)
open KeygenPublicInputProgram (signed)
open KeygenPublicInputSetup

theorem dimension_source (s : State)
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (ternary : s.locals "ternary".toList=some (.int32,some (.int32 1))) : Eval signed s dimension (.uint64 1536) := by
  have t : Eval signed s (KeygenPublicTableAtoms.var "ternary") (.int32 1) := .scalar _ _ (.variable _ _ _ ternary)
  have l : Eval signed s (KeygenPublicTableAtoms.var "logn") (.uint32 10) := .scalar _ _ (.variable _ _ _ logn)
  have one : Eval signed s (KeygenPublicTableAtoms.literal 1) (.int32 1) := .scalar _ _ (.literal .int32 1)
  have shifted : Eval signed s ternaryShift (.int32 2) :=
    .bin .shl _ _ _ _ _ t one (.signedLeft (.int32 1) (.int32 1) 1 rfl rfl (by decide) (by decide) (by unfold C99IntegerReference.fits; decide))
  have sum : Eval signed s (.bin .add (KeygenPublicTableAtoms.literal 1) ternaryShift) (.int32 3) :=
    .bin .add _ _ _ _ _ one shifted (.step .plus (.int32 1) (.int32 2) .int32 rfl (.int32 1) (.int32 2) rfl rfl (by intro _; unfold C99IntegerReference.fits; decide))
  have left : Eval signed s leftCount (.uint64 3) := .cast .uint64 _ (.int32 3) sum
  have right : Eval signed s rightCount (.uint32 9) :=
    .bin .sub _ _ _ _ _ l t (.step .minus (.uint32 10) (.int32 1) .uint32 rfl (.uint32 10) (.uint32 1) rfl rfl (by intro impossible; cases impossible))
  exact .bin .shl _ _ _ _ _ left right (.unsignedLeft (.uint64 3) (.uint32 9) 9 rfl rfl (by decide))

def declared (s : State) : State :=
  {s with locals := C99DeclarationCells.declareCells .uint32 ["q".toList] s.locals}
def sized (s : State) := C99ArrayReference.bindValue (declared s) "n".toList .uint64 (.uint64 1536)
def after (s : State) := C99ArrayReference.bindValue (sized s) "q".toList .uint32 (.int32 18433)

theorem outside (s : State) (name : C99ArrayReference.Name) (different : name≠"q".toList) :
    (declared s).locals name=s.locals name :=
  C99DeclareOutside140.source .uint32 ["q".toList] s.locals name (fun member => different (List.mem_singleton.mp member))

/-- Actual q declaration, MKN evaluation and selected ternary branch; no dimension or modulus value is assumed. -/
theorem source (s : State) (old : Option Value)
    (nDeclared : s.locals "n".toList=some (.uint64,old))
    (logn : s.locals "logn".toList=some (.uint32,some (.uint32 10)))
    (ternary : s.locals "ternary".toList=some (.int32,some (.int32 1))) :
    KeygenPublicExec.Exec KeygenPublicSource.program signed KeygenPublicInputProgram.setup s ⟨after s,.normal⟩ := by
  have decl : KeygenPublicExec.Exec KeygenPublicSource.program signed declareQ s ⟨declared s,.normal⟩ :=
    .scalar _ s _ (C99DeclarationCells.exists_execution KeygenPublicScalar.Call .uint32 ["q".toList] s.locals)
  have size : KeygenPublicExec.Exec KeygenPublicSource.program signed nSet (declared s) ⟨sized s,.normal⟩ :=
    .assign _ _ _ .uint64 old (.uint64 1536) ((outside s _ (by decide)).trans nDeclared)
      (dimension_source (declared s) ((outside s _ (by decide)).trans logn) ((outside s _ (by decide)).trans ternary))
  have t : (sized s).locals "ternary".toList=some (.int32,some (.int32 1)) := by
    change (declared s).locals "ternary".toList=_
    exact (outside s _ (by decide)).trans ternary
  have qDeclared : (sized s).locals "q".toList=some (.uint32,none) := by rfl
  have q : KeygenPublicExec.Exec KeygenPublicSource.program signed qSet (sized s) ⟨after s,.normal⟩ :=
    .branchTrue _ _ _ _ _ (.int32 1) (.scalar _ _ (.variable _ _ _ t)) (by decide)
      (.assign _ _ _ .uint32 none (.int32 18433) qDeclared (.scalar _ _ (.literal .int32 18433)))
  rw [source_complete]
  exact .seqNormal _ _ _ _ _ decl (.seqNormal _ _ _ _ _ size (.seqNormal _ _ _ _ _ q (.skip _)))

theorem n_cell (s : State) : (after s).locals "n".toList=some (.uint64,some (.uint64 1536)) := by rfl
theorem q_cell (s : State) : (after s).locals "q".toList=some (.uint32,some (.uint32 18433)) := by rfl
theorem heap (s : State) : (after s).heap=s.heap := rfl

end FT1536.Source3.PublicSetupSource157
